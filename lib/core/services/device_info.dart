import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Builds the device-telemetry HTTP headers the backend persists in
/// `user_sessions` (consumed by the admin-panel Sessions page). See the backend
/// `docs/TELEMETRY_SPEC.md`. The IP address is captured server-side, not here.
///
/// Values are read once and cached for the app's lifetime, and clamped to the
/// backend column sizes (brand/os/version 50, model 100). Telemetry is
/// best-effort: any failure yields an empty map and never blocks login.
class DeviceTelemetry {
  static Map<String, String>? _cached;

  static String _clamp(String v, int max) =>
      v.length > max ? v.substring(0, max) : v;

  static Future<Map<String, String>> headers() async {
    if (_cached != null) return _cached!;
    final out = <String, String>{};
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final a = await plugin.androidInfo;
        out['X-Device-Brand'] = _clamp(a.manufacturer, 50);
        out['X-Device-Model'] = _clamp(a.model, 100);
        out['X-OS-Name'] = 'Android';
        out['X-OS-Version'] = _clamp(a.version.release, 50);
      } else if (Platform.isIOS) {
        final i = await plugin.iosInfo;
        out['X-Device-Brand'] = 'Apple';
        out['X-Device-Model'] = _clamp(
          i.utsname.machine,
          100,
        ); // e.g. iPhone15,2
        out['X-OS-Name'] = 'iOS';
        out['X-OS-Version'] = _clamp(i.systemVersion, 50);
      }
    } catch (_) {
      // Best-effort only — never block authentication on telemetry.
    }
    out.removeWhere((_, v) => v.isEmpty);
    _cached = out;
    return out;
  }
}
