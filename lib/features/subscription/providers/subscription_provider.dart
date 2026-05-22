import 'dart:async' show unawaited;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';
import '../../../shared/models/alert_model.dart';
import '../../../shared/providers/alert_provider.dart';
import '../models/subscription_model.dart';

class SubscriptionNotifier extends AsyncNotifier<SubscriptionInfo> {
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
    if (info == null || !info.isTrial || info.trialEndsAt == null) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString('sub_alert_day') == today) return;

    final quietEnd = prefs.getInt('quiet_hours_end') ?? 7;
    final now = DateTime.now();
    if (now.hour < quietEnd + 1) return;

    final daysLeft = info.trialEndsAt!.difference(now).inDays;
    if (daysLeft > 7) return;

    final message = daysLeft <= 0
        ? 'Your free trial has expired. Upgrade to continue.'
        : daysLeft == 1
        ? 'Last day of your free trial! Upgrade now.'
        : '$daysLeft days left in your trial. Upgrade to Basic or Pro.';

    final priority = daysLeft <= 3 ? AlertPriority.high : AlertPriority.medium;

    ref
        .read(alertProvider.notifier)
        .addCustomAlert(
          BusinessAlert(
            id: 'trial_expiry_$today',
            title: 'Trial Expiring Soon',
            message: message,
            type: AlertType.subscription,
            priority: priority,
            timestamp: now,
            data: const {'action': 'open_subscription'},
          ),
        );

    // Fire-and-forget FCM push
    unawaited(_sendPushNotification(daysLeft, message));
    await prefs.setString('sub_alert_day', today);
  }

  Future<void> _sendPushNotification(int daysLeft, String body) async {
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/kirana/subscription/send-reminder', {
        'days_left': daysLeft,
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
