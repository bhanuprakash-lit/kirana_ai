import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_update_flutter/in_app_update_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateService {
  /// iOS App Store ID for Outlet AI — the numeric Apple ID found in the
  /// App Store Connect URL (e.g. 123456789). Until the app is live this stays
  /// as the placeholder and the iOS check is skipped.
  static const String _iosAppStoreId = 'TODO_REPLACE_WITH_YOUR_APP_ID';
  static final InAppUpdateFlutter _plugin = InAppUpdateFlutter();
  static StreamSubscription<InstallStateAndroid>? _installStateSubscription;

  static Future<void> checkForUpdates() async {
    try {
      if (kIsWeb) return;

      if (Platform.isAndroid) {
        await _checkAndroidUpdates();
      } else if (Platform.isIOS) {
        await _checkIosUpdates();
      }
    } catch (e) {
      debugPrint('AppUpdateService failed to check for updates: $e');
    }
  }

  static Future<void> _checkAndroidUpdates() async {
    final updateInfo = await _plugin.checkUpdateAndroid();

    if (updateInfo.installStatus == InstallStatusAndroid.downloaded) {
      await _plugin.completeUpdateAndroid();
      return;
    }

    final hasUpdate =
        updateInfo.updateAvailability ==
            UpdateAvailabilityAndroid.updateAvailable ||
        updateInfo.updateAvailability ==
            UpdateAvailabilityAndroid.developerTriggeredUpdateInProgress;

    if (!hasUpdate) return;

    if (updateInfo.isImmediateUpdateAllowed) {
      await _plugin.startImmediateUpdateAndroid();
      return;
    }

    if (!updateInfo.isFlexibleUpdateAllowed) return;

    _listenForFlexibleUpdateCompletion();
    await _plugin.startFlexibleUpdateAndroid();
  }

  static void _listenForFlexibleUpdateCompletion() {
    _installStateSubscription ??= _plugin.installStateStreamAndroid.listen(
      (state) async {
        if (state.status != InstallStatusAndroid.downloaded) return;

        try {
          await _plugin.completeUpdateAndroid();
        } catch (e) {
          debugPrint('AppUpdateService failed to complete Android update: $e');
        }
      },
      onError: (Object error) {
        debugPrint('AppUpdateService Android install state error: $error');
      },
    );
  }

  static Future<void> _checkIosUpdates() async {
    if (_iosAppStoreId == 'TODO_REPLACE_WITH_YOUR_APP_ID') {
      debugPrint('AppUpdateService: iOS App Store ID not configured.');
      return;
    }

    // The plugin only *presents* the App Store page — it does NOT verify that a
    // newer build actually exists. Without this guard the store overlay would
    // pop up on every launch, even for users already on the latest version, so
    // we compare the installed version against the live App Store version and
    // only prompt when there is genuinely something newer to install.
    if (!await _isIosUpdateAvailable()) return;

    await _plugin.showUpdateForIos(appStoreId: _iosAppStoreId);
  }

  static Future<bool> _isIosUpdateAvailable() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final uri = Uri.parse(
        'https://itunes.apple.com/lookup?id=$_iosAppStoreId',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode != 200) return false;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return false;

      final storeVersion =
          (results.first as Map<String, dynamic>)['version'] as String?;
      if (storeVersion == null || storeVersion.isEmpty) return false;

      return _isVersionNewer(storeVersion, currentVersion);
    } catch (e) {
      debugPrint('AppUpdateService failed to check iOS App Store version: $e');
      return false;
    }
  }

  /// Returns true when [candidate] is a strictly higher dotted version than
  /// [current] (e.g. "1.2.0" > "1.1.9"). Missing or non-numeric segments are
  /// treated as 0 so malformed values fail safe rather than nagging the user.
  static bool _isVersionNewer(String candidate, String current) {
    final a = _versionParts(candidate);
    final b = _versionParts(current);
    final length = a.length > b.length ? a.length : b.length;
    for (var i = 0; i < length; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai != bi) return ai > bi;
    }
    return false;
  }

  static List<int> _versionParts(String version) {
    // Drop any build metadata / suffix (e.g. "1.2.0+5" or "1.2.0-beta").
    final core = version.split(RegExp(r'[+\-]')).first;
    return core.split('.').map((p) => int.tryParse(p.trim()) ?? 0).toList();
  }
}
