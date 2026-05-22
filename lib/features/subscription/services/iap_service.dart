import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Product IDs — must match exactly what's in Play Console ──────────────────
const kIapBasicId = 'kirana_ai_basic_monthly';
const kIapProId = 'kirana_ai_pro_monthly';

const kTierToProductId = <String, String>{
  'basic': kIapBasicId,
  'pro': kIapProId,
};

const kProductIdToTier = <String, String>{
  kIapBasicId: 'basic',
  kIapProId: 'pro',
};

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

  Future<ProductDetails?> queryProduct(String tier) async {
    final id = kTierToProductId[tier];
    if (id == null) return null;

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
          break; // Google will resolve it — no action needed
      }
    }
  }
}
