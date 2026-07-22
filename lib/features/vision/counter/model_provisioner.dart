import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
/// Until ops publishes a manifest (`scripts/upload_vision_model.py`), the
/// endpoints 503 and this falls back to the bundled asset — so the backend and
/// the app can be cut over in either order.
class CounterModelProvisioner {
  static const _model = 'counter';
  static const _prefsVersion = 'counter_model_version';
  static const _fileName = 'counter_model.tflite';

  final ApiClient _api;
  CounterModelProvisioner(this._api);

  Future<File> _localFile() async {
    // Support dir, not documents: this is a cache the user never browses, and
    // on iOS documents/ is user-visible and iCloud-backed.
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/models/$_fileName');
  }

  /// Path the detector should load, or null when no model is available yet.
  ///
  /// Returns the bundled asset path while the server has nothing published,
  /// which keeps existing installs working through the cutover.
  Future<String?> resolvePath() async {
    // iOS uses a CoreML model inside the app bundle — a different format the
    // plugin resolves by name, so there's nothing to download there.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CounterModel.iosCoreMlName;
    }

    final file = await _localFile();
    final prefs = await SharedPreferences.getInstance();
    final cachedVersion = prefs.getString(_prefsVersion);

    Map<String, dynamic>? manifest;
    try {
      final res = await _api.get('/kirana/vision/model/$_model/manifest');
      manifest = (res as Map).cast<String, dynamic>();
    } catch (_) {
      // Offline, or the model isn't published yet. A cached copy still works.
      if (await file.exists()) return file.path;
      return _bundledFallback();
    }

    final wanted = manifest['version']?.toString();
    if (wanted == null || wanted.isEmpty) return _bundledFallback();

    if (cachedVersion == wanted && await file.exists()) {
      return file.path;
    }

    try {
      final bytes = await _api.getBytes('/kirana/vision/model/$_model/download');
      final expected = manifest['sha256']?.toString();
      if (expected != null && expected.isNotEmpty) {
        final actual = sha256.convert(bytes).toString();
        if (actual != expected) {
          // A truncated or tampered download must never reach the detector.
          return (await file.exists()) ? file.path : _bundledFallback();
        }
      }
      await file.parent.create(recursive: true);
      // Write to a temp file and rename, so a download killed halfway can't
      // leave a half-written model that looks valid on the next launch.
      final tmp = File('${file.path}.part');
      await tmp.writeAsBytes(bytes, flush: true);
      await tmp.rename(file.path);
      await prefs.setString(_prefsVersion, wanted);
      await _fetchLabels(file.parent.path);
      return file.path;
    } catch (_) {
      if (await file.exists()) return file.path;
      return _bundledFallback();
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

  /// The old bundled asset, while it's still in the build. Returns null once
  /// it's been removed from pubspec assets.
  String? _bundledFallback() => CounterModel.hasBundledAsset
      ? CounterModel.tfliteAsset
      : null;
}

final counterModelProvisionerProvider = Provider<CounterModelProvisioner>(
  (ref) => CounterModelProvisioner(ref.read(apiClientProvider)),
);

/// Resolved model path for the detector — downloads on first use.
final counterModelPathProvider = FutureProvider<String?>(
  (ref) => ref.read(counterModelProvisionerProvider).resolvePath(),
);
