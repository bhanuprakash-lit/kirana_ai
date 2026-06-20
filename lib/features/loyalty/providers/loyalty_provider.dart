import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../models/loyalty_models.dart';

/// Store loyalty config (cached for the session).
final loyaltyConfigProvider = FutureProvider<LoyaltyConfig>((ref) async {
  try {
    final data = await ref.read(apiClientProvider).get('/kirana/loyalty/config');
    if (data is Map) return LoyaltyConfig.fromJson(data.cast<String, dynamic>());
  } catch (_) {}
  return LoyaltyConfig.fallback;
});

/// A customer's points / tier / history.
final customerLoyaltyProvider =
    FutureProvider.family<CustomerLoyalty, int>((ref, customerId) async {
  final data = await ref
      .read(apiClientProvider)
      .get('/kirana/customers/$customerId/loyalty');
  return CustomerLoyalty.fromJson((data as Map).cast<String, dynamic>());
});

/// Store coupons.
final couponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final data = await ref.read(apiClientProvider).get('/kirana/coupons');
  final list = (data is Map ? data['coupons'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => Coupon.fromJson(e.cast<String, dynamic>()))
      .toList();
});

class LoyaltyActions {
  LoyaltyActions(this.ref);
  final Ref ref;
  ApiClient get _c => ref.read(apiClientProvider);

  Future<void> saveConfig(LoyaltyConfig cfg) async {
    await _c.put('/kirana/loyalty/config', cfg.toJson());
    ref.invalidate(loyaltyConfigProvider);
  }

  Future<Map<String, dynamic>> redeemPoints(
    int customerId,
    double points, {
    int? orderId,
  }) async {
    final res = await _c.post('/kirana/loyalty/redeem', {
      'customer_id': customerId,
      'points': points,
      'order_id': ?orderId,
    });
    ref.invalidate(customerLoyaltyProvider(customerId));
    return (res as Map).cast<String, dynamic>();
  }

  /// Returns {valid, reason, discount, coupon_id}.
  Future<Map<String, dynamic>> validateCoupon(
    String code,
    double orderAmount,
  ) async {
    final res = await _c.post('/kirana/coupons/validate', {
      'code': code,
      'order_amount': orderAmount,
    });
    return (res as Map).cast<String, dynamic>();
  }

  Future<void> createCoupon(Map<String, dynamic> body) async {
    await _c.post('/kirana/coupons', body);
    ref.invalidate(couponsProvider);
  }

  Future<void> toggleCoupon(int couponId, bool isActive) async {
    await _c.patch('/kirana/coupons/$couponId', {'is_active': isActive});
    ref.invalidate(couponsProvider);
  }
}

final loyaltyActionsProvider = Provider<LoyaltyActions>(LoyaltyActions.new);
