import 'dart:async' show unawaited;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/services/api_client.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/alert_model.dart';
import '../../../shared/providers/alert_provider.dart';
import '../models/subscription_model.dart';

class SubscriptionNotifier extends AsyncNotifier<SubscriptionInfo> {
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  Future<SubscriptionInfo> build() => _fetch();

  Future<SubscriptionInfo> _fetch() async {
    final client = ref.read(apiClientProvider);
    try {
      final res =
          await client.get('/kirana/subscription') as Map<String, dynamic>;
      final hasActive = res['has_active'] as bool? ?? false;
      if (!hasActive) return SubscriptionInfo.none;
      final info = SubscriptionInfo.fromJson(res);
      return info;
    } catch (_) {
      return SubscriptionInfo.none;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  /// Requests a trial for the chosen tier ('basic' or 'pro').
  Future<SubscriptionInfo> requestTrial({String tier = 'basic'}) async {
    final client = ref.read(apiClientProvider);
    try {
      final res =
          await client.post('/kirana/subscription/request-trial', {
                'tier': tier,
              })
              as Map<String, dynamic>;
      final info = SubscriptionInfo.fromJson(res);
      state = AsyncData(info);
      return info;
    } catch (e) {
      rethrow;
    }
  }

  Future<SubscriptionInfo> upgrade(String tier) async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.post('/kirana/subscription/upgrade', {'tier': tier})
            as Map<String, dynamic>;
    final info = SubscriptionInfo.fromJson(res);
    state = AsyncData(info);
    return info;
  }

  Future<void> cancelSubscription() async {
    final client = ref.read(apiClientProvider);
    await client.post('/kirana/subscription/cancel', {});
    state = const AsyncData(SubscriptionInfo.none);
  }

  /// Called after Razorpay payment success — verifies with backend and upgrades.
  Future<SubscriptionInfo> verifyPayment({
    required String tier,
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.post('/kirana/payment/verify', {
              'tier': tier,
              'razorpay_order_id': orderId,
              'razorpay_payment_id': paymentId,
              'razorpay_signature': signature,
            })
            as Map<String, dynamic>;
    final info = SubscriptionInfo.fromJson(res);
    state = AsyncData(info);
    return info;
  }

  /// Check trial expiry and fire in-app alert + FCM push if expiring soon.
  /// Respects quiet hours. Runs at most once per day.
  Future<void> checkTrialAlerts() async {
    final info = state.asData?.value;
    if (info == null || !info.isTrial) return;

    // Use the server-authoritative countdown, not a locally-parsed timestamp.
    final remaining = info.trialRemaining;
    if (remaining == null) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('sub_alert_day') == today) return;

    final quietEnd = prefs.getInt('quiet_hours_end') ?? 7;
    final now = DateTime.now();
    if (now.hour < quietEnd + 1) return;

    final expired = info.serverExpired || remaining.inSeconds <= 0;
    final daysLeft = remaining.inDays;
    // Only nudge within the final week of the trial.
    if (!expired && daysLeft > 7) return;

    final message = expired
        ? _l10n.subTrialExpiredMessage
        : daysLeft <= 1
        ? _l10n.subTrialLastDayMessage
        : _l10n.subTrialDaysLeftMessage(daysLeft);

    final title = expired
        ? _l10n.subTrialExpiredTitle
        : _l10n.subTrialExpiringSoon;

    final priority = (expired || daysLeft <= 3)
        ? AlertPriority.high
        : AlertPriority.medium;

    ref
        .read(alertProvider.notifier)
        .addCustomAlert(
          BusinessAlert(
            id: 'trial_expiry_$today',
            title: title,
            message: message,
            type: AlertType.subscription,
            priority: priority,
            timestamp: now,
            data: const {'action': 'open_subscription'},
          ),
        );

    // Fire-and-forget FCM push
    unawaited(_sendPushNotification(daysLeft, title, message));
    await prefs.setString('sub_alert_day', today);
  }

  Future<void> _sendPushNotification(
    int daysLeft,
    String title,
    String body,
  ) async {
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/kirana/subscription/send-reminder', {
        'days_left': daysLeft,
        'title': title,
        'message': body,
      });
    } catch (_) {}
  }
}

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, SubscriptionInfo>(
      SubscriptionNotifier.new,
    );

final subTierProvider = Provider<SubTier>((ref) {
  final data = ref.watch(subscriptionProvider).asData?.value;
  return data?.tier ?? SubTier.none;
});

final subInfoProvider = Provider<SubscriptionInfo>((ref) {
  return ref.watch(subscriptionProvider).asData?.value ?? SubscriptionInfo.none;
});
