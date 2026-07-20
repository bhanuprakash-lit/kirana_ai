import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Product IDs — must match exactly what's in the store console ─────────────
// (Play Console on Android; App Store Connect on iOS — the flat ids below only.)
//
// Pricing is segment-wise (varies by store.store_type — see
// SubscriptionInfo.basicPrice/proPrice). Play Billing has no API to charge a
// different price for the same product, so each priced segment gets its own
// product per tier: `kirana_ai_<tier>_<store_type>`. Segments NOT in
// [kPricedSegments] (kirana, fruits_vegetables, other, and any future
// store_type) reuse the original flat-rate products below.
const kIapBasicId = 'kirana_ai_basic_monthly';
const kIapProId = 'kirana_ai_pro_monthly';

// iOS App Store product ids. App Store Connect ids are immutable and differ
// from the Play Console ids above, so iOS uses its own two flat products.
// 'pro' maps to the App Store "Premium" subscription. These MUST match the
// Product IDs in App Store Connect exactly (Subscriptions → outletai-subscriptions).
const kIosBasicId = 'outletaibasic';
const kIosProId = 'outletaipremium';

/// store_types with their own Play Console product per tier. Keep in sync
/// with the `segment_pricing` seed in the backend (kirana/repositories/base.py).
const kPricedSegments = <String>{
  'supermarket',
  'mini_supermarket',
  'mono_brand',
  'apparel',
  'boutique',
  'salon',
  'fancy_gift',
  'sports_fitness',
  'electronics',
  'footwear',
  'optical',
  'bakery',
  'stationery',
};

/// Resolves the store product id for [tier] ('basic'/'pro') given the
/// store's [storeType]. Unpriced/unknown segments fall back to the default
/// flat-rate product.
///
/// iOS ships ONLY the two flat-rate products for the first App Store release —
/// segment pricing stays Android-only, so we never mint a segment-specific id on
/// iOS (those products don't exist in App Store Connect). See
/// docs/IOS_APP_STORE_REVIEW.md.
String productIdFor(String tier, String? storeType) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return tier == 'pro' ? kIosProId : kIosBasicId;
  }
  if (storeType != null && kPricedSegments.contains(storeType)) {
    return 'kirana_ai_${tier}_$storeType';
  }
  return tier == 'pro' ? kIapProId : kIapBasicId;
}

/// Recovers the tier ('basic'/'pro') from any product id this app can mint,
/// segment-specific or the default flat-rate ones.
String? tierFromProductId(String productId) {
  // iOS App Store ids
  if (productId == kIosBasicId) return 'basic';
  if (productId == kIosProId) return 'pro';
  // Android / segment ids
  if (productId.startsWith('kirana_ai_basic_')) return 'basic';
  if (productId.startsWith('kirana_ai_pro_')) return 'pro';
  return null;
}

// ── IapService ────────────────────────────────────────────────────────────────

class IapService {
  static const _testModeKey = 'payment_test_mode';

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  // Broadcast stream — IapNotifier listens to this.
  final _purchaseCtrl = StreamController<PurchaseDetails>.broadcast();
  final _errorCtrl = StreamController<String>.broadcast();

  Stream<PurchaseDetails> get purchases => _purchaseCtrl.stream;
  Stream<String> get errors => _errorCtrl.stream;

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  Future<bool> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return false;

    _sub = _iap.purchaseStream.listen(
      _onPurchases,
      onError: (e) {
        _errorCtrl.add(e.toString());
      },
    );
    return true;
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _purchaseCtrl.close();
    await _errorCtrl.close();
  }

  // ── Test-mode toggle (persisted in SharedPreferences) ───────────────────────

  static Future<bool> isTestMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Defaults to true so new installs stay in test mode until toggled off.
    return prefs.getBool(_testModeKey) ?? true;
  }

  static Future<void> setTestMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_testModeKey, value);
  }

  // ── Product query ───────────────────────────────────────────────────────────

  Future<ProductDetails?> queryProduct(String tier, [String? storeType]) async {
    final id = productIdFor(tier, storeType);

    final resp = await _iap.queryProductDetails({id});
    if (resp.error != null) {
      debugPrint('IAP queryProduct error: ${resp.error}');
      return null;
    }
    return resp.productDetails.cast<ProductDetails?>().firstWhere(
      (p) => p != null,
      orElse: () => null,
    );
  }

  // ── Purchase ────────────────────────────────────────────────────────────────

  Future<void> purchase(ProductDetails product) async {
    await _iap.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  // ── Stream handler ──────────────────────────────────────────────────────────

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _iap.completePurchase(
            p,
          ); // Acknowledge — required to avoid auto-refund
          _purchaseCtrl.add(p);
        case PurchaseStatus.error:
          _errorCtrl.add(p.error?.message ?? 'Purchase failed');
        case PurchaseStatus.canceled:
          _errorCtrl.add('cancelled');
        case PurchaseStatus.pending:
          break; // The store will resolve it — no action needed
      }
    }
  }
}
