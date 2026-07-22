import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../models/loyalty_models.dart';

/// Store loyalty config (cached for the session).
final loyaltyConfigProvider = FutureProvider<LoyaltyConfig>((ref) async {
  try {
    final data = await ref
        .read(apiClientProvider)
        .get('/kirana/loyalty/config');
    if (data is Map) {
      return LoyaltyConfig.fromJson(data.cast<String, dynamic>());
    }
  } catch (_) {}
  return LoyaltyConfig.fallback;
});

/// A customer's points / tier / history.
final customerLoyaltyProvider = FutureProvider.family<CustomerLoyalty, int>((
  ref,
  customerId,
) async {
  final data = await ref
      .read(apiClientProvider)
      .get('/kirana/customers/$customerId/loyalty');
  return CustomerLoyalty.fromJson((data as Map).cast<String, dynamic>());
});

/// Store coupons.
final couponsProvider = FutureProvider<List<Coupon>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
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

  /// PAI-17 — edit an existing coupon. The backend refuses a `code` change
  /// once the coupon has been redeemed (409), so its history stays readable.
  Future<void> updateCoupon(int couponId, Map<String, dynamic> body) async {
    await _c.patch('/kirana/coupons/$couponId', body);
    ref.invalidate(couponsProvider);
  }
}

/// PAI-16 — coupons this bill already qualifies for, best discount first.
/// Keyed on the rounded bill amount so the POS refetches as the cart changes
/// without hammering the endpoint on every paisa.
final applicableCouponsProvider =
    FutureProvider.family<List<ApplicableCoupon>, int>((ref, amountPaise) async {
      ref.watch(storeScopeProvider);
      final amount = amountPaise / 100.0;
      if (amount <= 0) return const [];
      try {
        final data = await ref
            .read(apiClientProvider)
            .get('/kirana/coupons/applicable?amount=$amount');
        final list = (data is Map ? data['coupons'] : null) as List<dynamic>? ?? [];
        return list
            .map((e) => ApplicableCoupon.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
      } catch (_) {
        // An older backend has no such route — the manual code box still works.
        return const [];
      }
    });

/// A coupon the current cart qualifies for, with the ₹ it would take off.
class ApplicableCoupon {
  final int couponId;
  final String code;
  final String discountType;
  final double value;
  final double discount;

  const ApplicableCoupon({
    required this.couponId,
    required this.code,
    required this.discountType,
    required this.value,
    required this.discount,
  });

  factory ApplicableCoupon.fromJson(Map<String, dynamic> j) => ApplicableCoupon(
    couponId: (j['coupon_id'] as num?)?.toInt() ?? 0,
    code: (j['code'] ?? '').toString(),
    discountType: (j['discount_type'] ?? 'flat').toString(),
    value: (j['value'] as num?)?.toDouble() ?? 0,
    discount: (j['discount'] as num?)?.toDouble() ?? 0,
  );
}

final loyaltyActionsProvider = Provider<LoyaltyActions>(LoyaltyActions.new);
