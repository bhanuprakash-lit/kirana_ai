import 'dart:async';
import 'package:flutter/foundation.dart';

class AppConfig {
  // ── URL ────────────────────────────────────────────────────────────────────

  static final _urlChanges = StreamController<int>.broadcast();
  static int _revision = 0;
  static String? _remoteUrl;

  static Stream<int> get changes => _urlChanges.stream;

  /// Platform-appropriate fallback used when Remote Config has no value.
  static String get devBaseUrl {
    if (kIsWeb) return 'http://127.0.0.1:9000';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:9000';
    return 'http://127.0.0.1:9000';
  }

  static String get baseUrl {
    final remote = _sanitize(_remoteUrl);
    return remote ?? devBaseUrl;
  }

  static String get apiBaseUrl => baseUrl;

  static void updateFromRemote(String? url) {
    final next = _sanitize(url);
    if (_remoteUrl == next) return;
    _remoteUrl = next;
    _urlChanges.add(++_revision);
  }

  // ── Trial days (from Remote Config) ───────────────────────────────────────

  static int _trialDays = 14;
  static int get trialDays => _trialDays;

  static void updateTrialDays(int days) {
    if (days > 0) _trialDays = days;
  }

  // ── Block state ────────────────────────────────────────────────────────────

  static final _blockChanges = StreamController<void>.broadcast();
  static Stream<void> get blockChanges => _blockChanges.stream;

  static bool _appBlocked = false;
  static String _blockedReason = '';
  static List<int> _blockedStoreIds = [];

  static bool get isAppBlocked => _appBlocked;
  static String get blockedReason => _blockedReason;
  static List<int> get blockedStoreIds => List.unmodifiable(_blockedStoreIds);

  /// Returns true if this store_id is individually blocked.
  static bool isStoreBlocked(int storeId) => _blockedStoreIds.contains(storeId);

  static void updateBlockState({
    required bool appBlocked,
    required String blockedReason,
    required List<int> blockedStoreIds,
  }) {
    _appBlocked = appBlocked;
    _blockedReason = blockedReason;
    _blockedStoreIds = blockedStoreIds;
    _blockChanges.add(null);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String? _sanitize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    final without = trimmed.replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(without);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;
    return without;
  }
}
