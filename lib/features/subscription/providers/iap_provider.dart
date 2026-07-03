import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/services/api_client.dart';
import '../services/iap_service.dart';
import 'subscription_provider.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class IapState {
  final bool isAvailable; // Play Billing available on device
  final bool isProcessing; // purchase in flight
  final String? error;

  const IapState({
    this.isAvailable = true,
    this.isProcessing = false,
    this.error,
  });

  IapState copyWith({
    bool? isAvailable,
    bool? isProcessing,
    String? error,
    bool clearError = false,
  }) {
    return IapState(
      isAvailable: isAvailable ?? this.isAvailable,
      isProcessing: isProcessing ?? this.isProcessing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class IapNotifier extends Notifier<IapState> {
  IapService? _service;
  StreamSubscription<dynamic>? _purchaseSub;
  StreamSubscription<dynamic>? _errorSub;

  @override
  IapState build() {
    _init();
    ref.onDispose(_dispose);
    return const IapState();
  }

  Future<void> _init() async {
    final service = IapService();
    _service = service;
    final available = await service.initialize();

    state = state.copyWith(isAvailable: available);
    if (!available) return;

    _purchaseSub = service.purchases.listen(_onPurchase);
    _errorSub = service.errors.listen(_onError);
  }

  void _dispose() {
    _purchaseSub?.cancel();
    _errorSub?.cancel();
    _service?.dispose();
  }

  // ── Public API ───────────────────────────────────────────────────────────────

  /// Initiates a Play Store purchase for [tier] ('basic' or 'pro').
  Future<void> purchase(String tier) async {
    final service = _service;
    if (service == null || !state.isAvailable) {
      state = state.copyWith(
        error: 'Play Billing not available on this device.',
      );
      return;
    }

    state = state.copyWith(isProcessing: true, clearError: true);

    final storeType = ref.read(subscriptionProvider).value?.storeType;
    final product = await service.queryProduct(tier, storeType);
    if (product == null) {
      state = state.copyWith(
        isProcessing: false,
        error:
            'Product not found in Play Store. Ensure product IDs are configured in Play Console.',
      );
      return;
    }

    try {
      await service.purchase(product);
      // Result arrives asynchronously via purchaseStream — _onPurchase handles it.
    } catch (e) {
      state = state.copyWith(isProcessing: false, error: e.toString());
    }
  }

  Future<void> restorePurchases() async {
    await _service?.restorePurchases();
  }

  void clearError() => state = state.copyWith(clearError: true);

  // ── Internal handlers ────────────────────────────────────────────────────────

  Future<void> _onPurchase(PurchaseDetails purchase) async {
    final tier = tierFromProductId(purchase.productID);
    if (tier == null) return;

    final token = purchase.verificationData.serverVerificationData;

    try {
      final client = ref.read(apiClientProvider);
      await client.post('/kirana/payment/verify-iap', {
        'tier': tier,
        'product_id': purchase.productID,
        'purchase_token': token,
      });
      await ref.read(subscriptionProvider.notifier).refresh();
      state = state.copyWith(isProcessing: false, clearError: true);
    } catch (e) {
      debugPrint('IAP backend verification failed: $e');
      state = state.copyWith(
        isProcessing: false,
        error: 'Payment succeeded but activation failed. Contact support.',
      );
    }
  }

  void _onError(String error) {
    if (error == 'cancelled') {
      state = state.copyWith(isProcessing: false, clearError: true);
      return;
    }
    state = state.copyWith(isProcessing: false, error: error);
  }
}

final iapProvider = NotifierProvider<IapNotifier, IapState>(IapNotifier.new);
