import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;

/// One queued consent clip awaiting upload.
class ConsentUploadItem {
  final String filePath; // persistent copy in the consent_pending dir
  final int? orderId;
  final int? customerId;
  final double? agreedTotal;
  final double? agreedUdhaar;
  final String? promisedDate; // ISO yyyy-mm-dd
  final String? language;
  final double? durationSec;
  final int attempts;

  const ConsentUploadItem({
    required this.filePath,
    this.orderId,
    this.customerId,
    this.agreedTotal,
    this.agreedUdhaar,
    this.promisedDate,
    this.language,
    this.durationSec,
    this.attempts = 0,
  });

  Map<String, dynamic> toJson() => {
    'filePath': filePath,
    'orderId': orderId,
    'customerId': customerId,
    'agreedTotal': agreedTotal,
    'agreedUdhaar': agreedUdhaar,
    'promisedDate': promisedDate,
    'language': language,
    'durationSec': durationSec,
    'attempts': attempts,
  };

  factory ConsentUploadItem.fromJson(Map<String, dynamic> j) =>
      ConsentUploadItem(
        filePath: j['filePath'] as String,
        orderId: (j['orderId'] as num?)?.toInt(),
        customerId: (j['customerId'] as num?)?.toInt(),
        agreedTotal: (j['agreedTotal'] as num?)?.toDouble(),
        agreedUdhaar: (j['agreedUdhaar'] as num?)?.toDouble(),
        promisedDate: j['promisedDate'] as String?,
        language: j['language'] as String?,
        durationSec: (j['durationSec'] as num?)?.toDouble(),
        attempts: (j['attempts'] as num?)?.toInt() ?? 0,
      );

  ConsentUploadItem withAttempt() => ConsentUploadItem(
    filePath: filePath,
    orderId: orderId,
    customerId: customerId,
    agreedTotal: agreedTotal,
    agreedUdhaar: agreedUdhaar,
    promisedDate: promisedDate,
    language: language,
    durationSec: durationSec,
    attempts: attempts + 1,
  );
}

/// Persistent, retry-on-poor-connectivity upload queue for udhaar voice-consent
/// clips. Clips are copied into the app documents dir and tracked in a
/// SharedPreferences manifest, so a queued upload survives app restarts and
/// keeps retrying until it lands. The owner is never blocked: [enqueue] returns
/// immediately and [drain] runs in the background (on enqueue and on app start).
class ConsentUploadQueue {
  ConsentUploadQueue(this._client);

  final ApiClient _client;
  static const _prefsKey = 'consent_upload_queue_v1';
  // Drop a clip after this many failed attempts so a permanently-rejected item
  // (e.g. 400) can't wedge the queue forever. Network failures are cheap to keep.
  static const _maxAttempts = 25;

  bool _draining = false;

  Future<Directory> _dir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/consent_pending');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<List<ConsentUploadItem>> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ConsentUploadItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _save(List<ConsentUploadItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  /// Copies [sourcePath] into the persistent queue dir and records the upload,
  /// then kicks off a background drain. Returns once persisted (fast); the
  /// actual network upload happens asynchronously.
  Future<void> enqueue({
    required String sourcePath,
    int? orderId,
    int? customerId,
    double? agreedTotal,
    double? agreedUdhaar,
    String? promisedDate,
    String? language,
    double? durationSec,
  }) async {
    final dir = await _dir();
    final ext = sourcePath.contains('.') ? sourcePath.split('.').last : 'aac';
    final dest =
        '${dir.path}/consent_${DateTime.now().millisecondsSinceEpoch}.$ext';
    try {
      await File(sourcePath).copy(dest);
    } catch (_) {
      return; // nothing to upload if the source vanished
    }

    final items = await _load();
    items.add(
      ConsentUploadItem(
        filePath: dest,
        orderId: orderId,
        customerId: customerId,
        agreedTotal: agreedTotal,
        agreedUdhaar: agreedUdhaar,
        promisedDate: promisedDate,
        language: language,
        durationSec: durationSec,
      ),
    );
    await _save(items);

    unawaited(drain());
  }

  /// Attempts to upload every queued clip oldest-first. Successful uploads are
  /// removed and their files deleted; network failures are kept for the next
  /// drain. Safe to call repeatedly — re-entrancy is guarded.
  Future<void> drain() async {
    if (_draining) return;
    _draining = true;
    try {
      var items = await _load();
      if (items.isEmpty) return;

      final remaining = <ConsentUploadItem>[];
      for (final item in items) {
        final result = await _tryUpload(item);
        switch (result) {
          case _UploadResult.success:
          case _UploadResult.drop:
            await _deleteFile(item.filePath); // uploaded or permanently rejected
          case _UploadResult.retry:
            final bumped = item.withAttempt();
            if (bumped.attempts >= _maxAttempts) {
              await _deleteFile(item.filePath);
            } else {
              remaining.add(bumped);
            }
        }
      }
      await _save(remaining);
    } finally {
      _draining = false;
    }
  }

  Future<_UploadResult> _tryUpload(ConsentUploadItem item) async {
    if (!await File(item.filePath).exists()) return _UploadResult.drop;
    final fields = <String, String>{};
    if (item.orderId != null) fields['order_id'] = '${item.orderId}';
    if (item.customerId != null) fields['customer_id'] = '${item.customerId}';
    if (item.agreedTotal != null) {
      fields['agreed_total'] = '${item.agreedTotal}';
    }
    if (item.agreedUdhaar != null) {
      fields['agreed_udhaar'] = '${item.agreedUdhaar}';
    }
    if (item.promisedDate != null) fields['promised_date'] = item.promisedDate!;
    if (item.language != null) fields['language'] = item.language!;
    if (item.durationSec != null) {
      fields['duration_sec'] = '${item.durationSec}';
    }

    try {
      await _client.postMultipart(
        '/kirana/finance/udhaar/consent',
        filePaths: [item.filePath],
        fileField: 'audio',
        fields: fields,
      );
      return _UploadResult.success;
    } on ApiException catch (e) {
      // 4xx (except 408/429) = the server rejected it; don't retry forever.
      if (e.statusCode >= 400 &&
          e.statusCode < 500 &&
          e.statusCode != 408 &&
          e.statusCode != 429) {
        return _UploadResult.drop;
      }
      return _UploadResult
          .retry; // 5xx / 503 storage-not-configured → retry later
    } catch (_) {
      return _UploadResult.retry; // network/timeout → keep for next drain
    }
  }

  Future<void> _deleteFile(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}

enum _UploadResult { success, retry, drop }

final consentUploadQueueProvider = Provider<ConsentUploadQueue>(
  (ref) => ConsentUploadQueue(ref.read(apiClientProvider)),
);
