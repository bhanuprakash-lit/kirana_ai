import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'app_config.dart';

class FirebaseBackendConfig {
  static StreamSubscription<RemoteConfigUpdate>? _subscription;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on UnsupportedError catch (error) {
      debugPrint('Firebase config skipped: $error');
      return;
    } catch (error) {
      debugPrint('Firebase initialization failed: $error');
      return;
    }

    // Crashlytics — disable in debug so logs stay clean locally
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );

    // Performance
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(
      !kDebugMode,
    );

    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          // In production use Duration(hours: 1); zero only for dev
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );

      final defaultUrl = AppConfig.devBaseUrl;
      await remoteConfig.setDefaults({
        'backend_dev_url': defaultUrl,
        'app_blocked': false,
        'blocked_reason': '',
        // JSON array of store IDs to block, e.g. "[12, 34]"
        'blocked_store_ids': '[]',
        // Trial period duration in days (configurable per market/campaign)
        'trial_days': 14,
      });

      await remoteConfig.fetchAndActivate();
      _apply(remoteConfig);

      await _subscription?.cancel();
      _subscription = remoteConfig.onConfigUpdated.listen((_) async {
        await remoteConfig.activate();
        _apply(remoteConfig);
      });
    } catch (error) {
      debugPrint('Firebase Remote Config unavailable: $error');
    }
  }

  static void _apply(FirebaseRemoteConfig rc) {
    // ── Backend URL ────────────────────────────────────────────────────────────
    final url = rc.getString('backend_dev_url').trim();
    debugPrint('Remote Config backend_dev_url: $url');
    AppConfig.updateFromRemote(url.isEmpty ? null : url);

    // ── App / store blocking ───────────────────────────────────────────────────
    final appBlocked = rc.getBool('app_blocked');
    final reason = rc.getString('blocked_reason').trim();

    List<int> blockedStoreIds = [];
    try {
      final raw = rc.getString('blocked_store_ids').trim();
      if (raw.isNotEmpty) {
        blockedStoreIds = (jsonDecode(raw) as List<dynamic>)
            .map((e) => e as int)
            .toList();
      }
    } catch (_) {}

    AppConfig.updateBlockState(
      appBlocked: appBlocked,
      blockedReason: reason,
      blockedStoreIds: blockedStoreIds,
    );

    // ── Trial days ─────────────────────────────────────────────────────────────
    final trialDays = rc.getInt('trial_days');
    AppConfig.updateTrialDays(trialDays);
  }
}
