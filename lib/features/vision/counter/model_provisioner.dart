import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart'
    show debugPrint, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

import '../../../core/services/api_client.dart';
import 'counter_model.dart';

/// PAI-15 — fetch the counter model instead of shipping it in the APK.
///
/// The 38 MB `.tflite` used to be a plain Flutter asset, so `unzip` on the APK
/// handed anyone the trained weights. AES-encrypting the asset would not have
/// fixed that — the app must decrypt at runtime with no server involved, so the
/// key ships in the same binary and the attacker just reads it out.
///
/// So the model isn't in the APK at all. It's downloaded once by an
/// authenticated user, checksum-verified, and cached in **app-private**
/// storage. What that actually buys:
///   * an attacker needs a valid account, not just the APK;
///   * every download is attributed server-side and a leaked account can be cut
///     off (see `vision_model_fetch`);
///   * the app download shrinks by ~38 MB.
///
/// **Why the cached file is not encrypted at rest:** the TFLite runtime loads
/// from a file path, so we would have to decrypt to a plaintext temp file on
/// every launch — slow, and the plaintext lands on disk anyway. It would be
/// theatre, and paid for in startup time. App-private storage already keeps it
/// away from other apps on a non-rooted device; a rooted device defeats either
/// approach.
///
/// **The setup runs itself.** Opening the Counter is already the user's
/// decision — asking them to then approve a "38 MB model download" pushes an
/// engineering detail onto a shopkeeper who has no basis to answer it and no
/// alternative if they say no. So the fetch starts on its own, shows honest
/// progress (including the size, so nothing is hidden), retries by itself when
/// the connection drops, and resumes rather than re-spending the same
/// megabytes. The user's only job is to not close the screen.
///
/// **Both platforms download**, from separate blob prefixes, because the two
/// runtimes take different formats (see [CounterModel]). The only difference in
/// this file is the last step: iOS receives a zip, because a CoreML
/// `.mlpackage` is a directory, and unpacks it before handing over the path.
enum ModelPhase {
  /// Looking for a cached copy / asking the server what's current.
  checking,

  /// Transfer in flight — [CounterModelState.progress] is meaningful.
  downloading,

  /// A model is on disk (or bundled) and [CounterModelState.path] can be used.
  ready,

  /// The transfer failed. Any partial bytes are kept for a resume.
  failed,

  /// No model, no bundled fallback, and the server has nothing to offer.
  unavailable,
}

class CounterModelState {
  final ModelPhase phase;

  /// Path handed to the detector once [phase] is [ModelPhase.ready].
  final String? path;

  /// Bytes on disk so far, and the full size from the manifest.
  final int received;
  final int total;

  /// True when a partial download is already on disk, so the next attempt
  /// continues instead of starting over.
  final bool resumable;

  /// True once the model arrived during *this* visit, as opposed to already
  /// being cached. The screen uses it to walk straight into the camera when a
  /// setup finishes, instead of dropping the user back on a landing page they
  /// just waited through.
  final bool justInstalled;

  const CounterModelState({
    required this.phase,
    this.path,
    this.received = 0,
    this.total = 0,
    this.resumable = false,
    this.justInstalled = false,
  });

  /// 0..1, or null when the size isn't known yet (an indeterminate bar is the
  /// honest thing to show then — a fake percentage is worse than none).
  double? get progress =>
      total > 0 ? (received / total).clamp(0.0, 1.0) : null;

  CounterModelState copyWith({
    ModelPhase? phase,
    String? path,
    int? received,
    int? total,
    bool? resumable,
    bool? justInstalled,
  }) => CounterModelState(
    phase: phase ?? this.phase,
    path: path ?? this.path,
    received: received ?? this.received,
    total: total ?? this.total,
    resumable: resumable ?? this.resumable,
    justInstalled: justInstalled ?? this.justInstalled,
  );
}

class CounterModelNotifier extends Notifier<CounterModelState> {
  static const _prefsVersion = 'counter_model_version';

  String get _model => CounterModel.remoteModel;

  /// A connection that has delivered nothing for this long is dead. Note this
  /// is an *idle* timeout, not a total one: a slow connection that keeps
  /// trickling bytes is allowed to take as long as it needs, because a 38 MB
  /// transfer on 3G legitimately runs for minutes.
  static const _idleTimeout = Duration(seconds: 45);

  /// Automatic attempts before we stop and ask the user to intervene. Each one
  /// resumes, so a flaky line makes forward progress across retries instead of
  /// re-downloading from zero.
  static const _maxAttempts = 3;

  late final ApiClient _api = ref.read(apiClientProvider);
  Map<String, dynamic>? _manifest;
  bool _cancelled = false;
  bool _disposed = false;
  int _attempts = 0;

  @override
  CounterModelState build() {
    ref.onDispose(() => _disposed = true);
    unawaited(_check());
    return const CounterModelState(phase: ModelPhase.checking);
  }

  void _emit(CounterModelState s) {
    if (!_disposed) state = s;
  }

  /// Where the installed model lives. A file on Android, a directory on iOS —
  /// [File] is only used here to name the path; use [_installedExists] to test
  /// for it rather than [File.exists], which is false for a directory.
  Future<File> _localFile() async {
    // Support dir, not documents: this is a cache the user never browses, and
    // on iOS documents/ is user-visible and iCloud-backed.
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/models/${CounterModel.installedName}');
  }

  Future<bool> _installedExists(String path) async =>
      CounterModel.downloadIsArchive
      ? Directory(path).exists()
      : File(path).exists();

  String? get _bundled =>
      CounterModel.hasBundledAsset ? CounterModel.tfliteAsset : null;

  CounterModelState _fallback() {
    final asset = _bundled;
    return asset != null
        ? CounterModelState(phase: ModelPhase.ready, path: asset)
        : const CounterModelState(phase: ModelPhase.unavailable);
  }

  /// Decide what the counter can use right now, without transferring anything.
  Future<void> _check() async {
    // A CoreML model bundled into the Runner target would take precedence, and
    // on a build that has one there's nothing to fetch. No build ships one
    // today — the check costs a cheap platform call and means a future bundled
    // model doesn't get downloaded on top of itself.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      var bundled = false;
      try {
        final result = await YOLO.checkModelExists(CounterModel.iosCoreMlName);
        bundled = result['exists'] == true;
      } catch (_) {
        bundled = false;
      }
      if (bundled) {
        _emit(
          const CounterModelState(
            phase: ModelPhase.ready,
            path: CounterModel.iosCoreMlName,
          ),
        );
        return;
      }
    }

    final file = await _localFile();
    final part = File('${file.path}.part');
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_prefsVersion);

    try {
      final res = await _api.get('/kirana/vision/model/$_model/manifest');
      _manifest = (res as Map).cast<String, dynamic>();
    } catch (_) {
      // Offline, or nothing published yet. A cached copy still works, and the
      // bundled asset covers the rest — either way, don't block the user.
      if (await _installedExists(file.path)) {
        _emit(CounterModelState(phase: ModelPhase.ready, path: file.path));
      } else {
        _emit(_fallback());
      }
      return;
    }

    final wanted = _manifest?['version']?.toString();
    if (wanted == null || wanted.isEmpty) {
      _emit(_fallback());
      return;
    }

    // Any usable model on disk wins, even if it's a version behind. The setup
    // screen is a first-run experience: someone who already has a working
    // counter must never be held behind a fresh 38 MB transfer just to open it.
    //
    // The cost is that a published new version isn't picked up by existing
    // installs. That's the right trade while there's one version in the wild,
    // but shipping a model update needs a deliberate mechanism — a background
    // refresh, or a prompt at a moment the user isn't trying to sell something.
    if (await _installedExists(file.path)) {
      _emit(CounterModelState(phase: ModelPhase.ready, path: file.path));
      if (cached != wanted) {
        // Not fatal, but worth seeing in logs when it starts happening.
        assert(() {
          debugPrint(
            'counter model: cached $cached, server has $wanted — keeping cached',
          );
          return true;
        }());
      }
      return;
    }

    // A stale partial from a previous version is worthless — resuming into it
    // would splice two different models together and fail the checksum.
    final partialVersion = prefs.getString('${_prefsVersion}_partial');
    if (await part.exists() && partialVersion != wanted) {
      await part.delete();
    }
    final have = await part.exists() ? await part.length() : 0;

    // Straight into the transfer — no prompt. See the note on [ModelPhase].
    _emit(
      CounterModelState(
        phase: ModelPhase.downloading,
        received: have,
        total: int.tryParse('${_manifest?['size'] ?? 0}') ?? 0,
        resumable: have > 0,
      ),
    );
    _attempts = 0;
    await startDownload();
  }

  /// Manual retry, offered only once the automatic ones are exhausted.
  Future<void> retry() {
    _attempts = 0;
    return _check();
  }

  /// Download (or resume) the weights, verify, and swap them in.
  Future<void> startDownload() async {
    final manifest = _manifest;
    if (manifest == null) return;
    final version = manifest['version'].toString();
    final expected = manifest['sha256']?.toString();
    final total = int.tryParse('${manifest['size'] ?? 0}') ?? 0;

    _cancelled = false;
    final file = await _localFile();
    final part = File('${file.path}.part');
    await file.parent.create(recursive: true);

    var have = await part.exists() ? await part.length() : 0;
    _emit(
      CounterModelState(
        phase: ModelPhase.downloading,
        received: have,
        total: total,
      ),
    );

    IOSink? sink;
    try {
      final res = await _api.getStream(
        '/kirana/vision/model/$_model/download',
        resumeFrom: have,
      );

      if (res.statusCode == 200) {
        // Server ignored the Range (or had nothing to resume) — start clean so
        // we never append fresh bytes onto a stale prefix.
        have = 0;
      } else if (res.statusCode != 206) {
        throw HttpException('HTTP ${res.statusCode}');
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_prefsVersion}_partial', version);

      sink = part.openWrite(
        mode: have > 0 ? FileMode.writeOnlyAppend : FileMode.writeOnly,
      );
      var received = have;

      await for (final chunk in res.stream.timeout(_idleTimeout)) {
        if (_cancelled) break;
        sink.add(chunk);
        received += chunk.length;
        _emit(
          CounterModelState(
            phase: ModelPhase.downloading,
            received: received,
            total: total,
          ),
        );
      }
      await sink.flush();
      await sink.close();
      sink = null;

      if (_cancelled) return;

      if (total > 0 && received < total) {
        throw const HttpException('Transfer ended early');
      }

      // Hash the file off disk rather than a 38 MB buffer in memory — the whole
      // point of streaming was not holding it all at once.
      if (expected != null && expected.isNotEmpty) {
        final digest = await sha256.bind(part.openRead()).first;
        if (digest.toString() != expected) {
          // Corrupt or tampered. Delete it: resuming into a bad prefix would
          // fail forever, so a clean restart is the only way out.
          await part.delete();
          throw const HttpException('Checksum mismatch');
        }
      }

      // Install last, so a download killed halfway can never leave a
      // half-written model that looks valid on the next launch.
      if (CounterModel.downloadIsArchive) {
        await installModelArchive(
          part,
          file.path,
          innerName: CounterModel.installedName,
        );
      } else {
        if (await file.exists()) await file.delete();
        await part.rename(file.path);
      }
      await prefs.setString(_prefsVersion, version);
      await prefs.remove('${_prefsVersion}_partial');
      await _fetchLabels(file.parent.path);

      _emit(
        CounterModelState(
          phase: ModelPhase.ready,
          path: file.path,
          received: total,
          total: total,
          justInstalled: true,
        ),
      );
    } catch (_) {
      try {
        await sink?.close();
      } catch (_) {}
      if (_cancelled || _disposed) return;

      final kept = await part.exists() ? await part.length() : 0;
      _attempts++;

      if (_attempts < _maxAttempts) {
        // Back off briefly and pick up where we stopped. Kept in the
        // downloading phase on purpose: to the user this is one setup that
        // paused, not a failure they need to think about.
        _emit(
          CounterModelState(
            phase: ModelPhase.downloading,
            received: kept,
            total: total,
            resumable: kept > 0,
          ),
        );
        await Future<void>.delayed(Duration(seconds: 2 * _attempts));
        if (_cancelled || _disposed) return;
        return startDownload();
      }

      // Out of automatic attempts. While the asset is still in the build we
      // quietly fall back to it — a working counter beats a correct error
      // message. After the cutover there's nothing to fall back to, so the
      // user gets a real failure and a retry button.
      final asset = _bundled;
      if (asset != null) {
        _emit(CounterModelState(phase: ModelPhase.ready, path: asset));
        return;
      }
      _emit(
        CounterModelState(
          phase: ModelPhase.failed,
          received: kept,
          total: total,
          resumable: kept > 0,
        ),
      );
    }
  }

  /// Labels are small and change with the model — best-effort, never fatal.
  Future<void> _fetchLabels(String dirPath) async {
    try {
      final bytes = await _api.getBytes('/kirana/vision/model/$_model/labels');
      await File(
        '$dirPath/counter_labels.txt',
      ).writeAsString(utf8.decode(bytes), flush: true);
    } catch (_) {}
  }
}

/// Unpack a downloaded `.mlpackage.zip` into place (iOS).
///
/// A CoreML package is a directory, so the last step of the install is an
/// extract rather than a rename. It stays atomic the same way: unpack into a
/// scratch directory, then swap, so a kill mid-extract can't leave a
/// half-populated `.mlpackage` that the next launch mistakes for a good model.
///
/// Top-level rather than a method so the archive handling — including the
/// traversal guard — can be tested without a platform channel in sight.
Future<void> installModelArchive(
  File zip,
  String destPath, {
  required String innerName,
}) async {
  final staging = Directory('$destPath.unpack');
  if (await staging.exists()) await staging.delete(recursive: true);
  await staging.create(recursive: true);

  final archive = ZipDecoder().decodeBytes(await zip.readAsBytes());
  var extracted = 0;
  for (final entry in archive) {
    // The archive is ours, but it arrived over the network: an entry named
    // `../../foo` would otherwise write outside the staging directory.
    final rel = entry.name.replaceAll('\\', '/');
    final segments = rel.split('/');
    if (rel.startsWith('/') ||
        rel.contains(':') ||
        segments.contains('..') ||
        segments.isEmpty) {
      throw const FileSystemException('Unsafe archive entry');
    }
    final out = '${staging.path}/$rel';
    if (entry.isFile) {
      final f = File(out);
      await f.parent.create(recursive: true);
      await f.writeAsBytes(entry.readBytes() ?? const <int>[], flush: true);
      extracted++;
    } else {
      await Directory(out).create(recursive: true);
    }
  }

  // A truncated or corrupt zip decodes to an *empty* archive rather than
  // throwing, and without this the swap below would replace a working model
  // with an empty directory. The checksum should already have rejected such a
  // file; this is the backstop that keeps a bad install from being destructive.
  if (extracted == 0) {
    await staging.delete(recursive: true);
    throw const FileSystemException('Model archive contained no files');
  }

  // The zip has the .mlpackage directory itself as its root, so the model is
  // one level in. Tolerate a flat archive too rather than failing the setup.
  final inner = Directory('${staging.path}/$innerName');
  final source = await inner.exists() ? inner : staging;

  final dest = Directory(destPath);
  if (await dest.exists()) await dest.delete(recursive: true);
  await source.rename(destPath);
  if (await staging.exists()) await staging.delete(recursive: true);
  await zip.delete();
}

final counterModelProvider =
    NotifierProvider<CounterModelNotifier, CounterModelState>(
      CounterModelNotifier.new,
    );
