import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';

class UserPrefs {
  final int forecastHorizonDays;
  final double alertStockoutThreshold;
  final double alertMinVelocity;
  final int alertReorderDays;
  final int alertDeadStockDays;
  final bool notifyWhatsapp;
  final bool notifyInApp;
  final int quietHoursStart;
  final int quietHoursEnd;

  const UserPrefs({
    this.forecastHorizonDays = 7,
    this.alertStockoutThreshold = 0.5,
    this.alertMinVelocity = 0.3,
    this.alertReorderDays = 3,
    this.alertDeadStockDays = 21,
    this.notifyWhatsapp = false,
    this.notifyInApp = true,
    this.quietHoursStart = 22,
    this.quietHoursEnd = 7,
  });

  factory UserPrefs.fromJson(Map<String, dynamic> j) => UserPrefs(
        forecastHorizonDays: (j['forecast_horizon_days'] as num?)?.toInt() ?? 7,
        alertStockoutThreshold:
            (j['alert_stockout_threshold'] as num?)?.toDouble() ?? 0.5,
        alertMinVelocity:
            (j['alert_min_velocity'] as num?)?.toDouble() ?? 0.3,
        alertReorderDays:
            (j['alert_reorder_days'] as num?)?.toInt() ?? 3,
        alertDeadStockDays:
            (j['alert_dead_stock_days'] as num?)?.toInt() ?? 21,
        notifyWhatsapp: j['notify_whatsapp'] as bool? ?? false,
        notifyInApp: j['notify_in_app'] as bool? ?? true,
        quietHoursStart: (j['quiet_hours_start'] as num?)?.toInt() ?? 22,
        quietHoursEnd: (j['quiet_hours_end'] as num?)?.toInt() ?? 7,
      );

  Map<String, dynamic> toJson() => {
        'forecast_horizon_days': forecastHorizonDays,
        'alert_stockout_threshold': alertStockoutThreshold,
        'alert_min_velocity': alertMinVelocity,
        'alert_reorder_days': alertReorderDays,
        'alert_dead_stock_days': alertDeadStockDays,
        'notify_whatsapp': notifyWhatsapp,
        'notify_in_app': notifyInApp,
        'quiet_hours_start': quietHoursStart,
        'quiet_hours_end': quietHoursEnd,
      };

  UserPrefs copyWith({
    int? forecastHorizonDays,
    double? alertStockoutThreshold,
    double? alertMinVelocity,
    int? alertReorderDays,
    int? alertDeadStockDays,
    bool? notifyWhatsapp,
    bool? notifyInApp,
    int? quietHoursStart,
    int? quietHoursEnd,
  }) =>
      UserPrefs(
        forecastHorizonDays: forecastHorizonDays ?? this.forecastHorizonDays,
        alertStockoutThreshold:
            alertStockoutThreshold ?? this.alertStockoutThreshold,
        alertMinVelocity: alertMinVelocity ?? this.alertMinVelocity,
        alertReorderDays: alertReorderDays ?? this.alertReorderDays,
        alertDeadStockDays: alertDeadStockDays ?? this.alertDeadStockDays,
        notifyWhatsapp: notifyWhatsapp ?? this.notifyWhatsapp,
        notifyInApp: notifyInApp ?? this.notifyInApp,
        quietHoursStart: quietHoursStart ?? this.quietHoursStart,
        quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      );
}

class ConfigNotifier extends AsyncNotifier<UserPrefs> {
  @override
  Future<UserPrefs> build() => _fetch();

  Future<UserPrefs> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/kirana/preferences');
    return UserPrefs.fromJson(res as Map<String, dynamic>);
  }

  Future<void> save(UserPrefs prefs) async {
    final client = ref.read(apiClientProvider);
    final res = await client.patch('/kirana/preferences', prefs.toJson());
    state = AsyncValue.data(UserPrefs.fromJson(res as Map<String, dynamic>));
  }

  Future<void> resetToDefaults() async {
    await save(const UserPrefs());
  }
}

final configProvider =
    AsyncNotifierProvider<ConfigNotifier, UserPrefs>(ConfigNotifier.new);

// ── POS local preference (default payment method) ─────────────────────────────

class PosPrefsNotifier extends AsyncNotifier<String> {
  static const _key = 'default_payment_method';

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'cash';
  }

  Future<void> setDefaultPaymentMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, method);
    state = AsyncValue.data(method);
  }
}

final posPrefsProvider =
    AsyncNotifierProvider<PosPrefsNotifier, String>(PosPrefsNotifier.new);
