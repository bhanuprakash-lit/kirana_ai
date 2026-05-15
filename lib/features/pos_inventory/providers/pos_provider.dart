import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/auth/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../dashboard/providers/overview_provider.dart';
import '../../profile/providers/customer_provider.dart';
import '../../referral/models/referral_models.dart';
import '../../referral/providers/referral_provider.dart';
import '../models/cart_item.dart';
import '../models/pos_product.dart';

class PosState {
  final List<PosProduct> products;
  final bool isLoadingProducts;
  final List<CartItem> cart;
  final bool isPlacingOrder;
  final String? error;
  final int? selectedCustomerId;
  final String? selectedCustomerName;
  final double? referralDiscountPct;
  final String? referralReferrerName;
  final PendingReferralScan? pendingReferral;

  const PosState({
    this.products = const [],
    this.isLoadingProducts = false,
    this.cart = const [],
    this.isPlacingOrder = false,
    this.error,
    this.selectedCustomerId,
    this.selectedCustomerName,
    this.referralDiscountPct,
    this.referralReferrerName,
    this.pendingReferral,
  });

  PosState copyWith({
    List<PosProduct>? products,
    bool? isLoadingProducts,
    List<CartItem>? cart,
    bool? isPlacingOrder,
    String? error,
    bool clearError = false,
    int? selectedCustomerId,
    String? selectedCustomerName,
    bool clearCustomer = false,
    double? referralDiscountPct,
    String? referralReferrerName,
    PendingReferralScan? pendingReferral,
    bool clearReferral = false,
  }) =>
      PosState(
        products: products ?? this.products,
        isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
        cart: cart ?? this.cart,
        isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
        error: clearError ? null : (error ?? this.error),
        selectedCustomerId: clearCustomer ? null : (selectedCustomerId ?? this.selectedCustomerId),
        selectedCustomerName: clearCustomer ? null : (selectedCustomerName ?? this.selectedCustomerName),
        referralDiscountPct: clearReferral ? null : (referralDiscountPct ?? this.referralDiscountPct),
        referralReferrerName: clearReferral ? null : (referralReferrerName ?? this.referralReferrerName),
        pendingReferral: clearReferral ? null : (pendingReferral ?? this.pendingReferral),
      );

  double get subtotal =>
      cart.fold(0, (sum, item) => sum + item.lineTotal);

  double get discountedSubtotal {
    if (referralDiscountPct == null || referralDiscountPct! <= 0) return subtotal;
    return subtotal * (1 - referralDiscountPct! / 100);
  }

  double get discountAmount => subtotal - discountedSubtotal;

  double get cartItemCount =>
      cart.fold(0, (sum, item) => sum + item.quantity);

  bool get hasToken => true; // checked at runtime
}

class PosNotifier extends Notifier<PosState> {
  @override
  PosState build() {
    Future.microtask(_loadProducts);
    return const PosState();
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(isLoadingProducts: true, clearError: true);
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    final productsFuture = client.posGetList(
        '/pos/products?store_id=$storeId&limit=1000');
    final pricingFuture = client.getOltp('pricing', filters: {'store_id': '$storeId'});

    try {
      final res = await productsFuture;
      final pricingRes = await pricingFuture;

      if (res == null) {
        state = state.copyWith(
          isLoadingProducts: false,
          error: 'POS not connected. Please check your credentials.',
        );
        return;
      }

      final pricingMap = <int, Map<String, dynamic>>{};
      for (final row in ((pricingRes['rows'] as List<dynamic>?) ?? [])
          .cast<Map<String, dynamic>>()) {
        final id = (row['product_id'] as num?)?.toInt();
        if (id != null) pricingMap[id] = row;
      }

      final products = res.cast<Map<String, dynamic>>().map((j) {
        final p = PosProduct.fromJson(j);
        final pricing = pricingMap[p.productId];
        if (pricing != null) {
          final sp = (pricing['selling_price'] ?? pricing['price'] ?? pricing['unit_price'] ?? 0.0) as num;
          final mrp = (pricing['mrp'] ?? p.mrp ?? 0.0) as num;
          return p.copyWith(
            price: sp > 0 ? sp.toDouble() : p.price,
            mrp: mrp > 0 ? mrp.toDouble() : p.mrp,
          );
        }
        return p;
      }).toList();

      state = state.copyWith(products: products, isLoadingProducts: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoadingProducts: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoadingProducts: false, error: 'Error loading POS products: $e');
    }
  }

  Future<void> reloadProducts() => _loadProducts();

  Future<PosProduct?> lookupBarcode(String barcode) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      final res = await client.posGet(
          '/pos/products/barcode/$barcode?store_id=$storeId');
      if (res == null) return null;

      var p = PosProduct.fromJson(res);

      try {
        final pricingRes = await client.getOltp('pricing',
            filters: {'store_id': '$storeId', 'product_id': '${p.productId}'});
        final rows = (pricingRes['rows'] as List<dynamic>?) ?? [];
        if (rows.isNotEmpty) {
          final pricing = rows.first as Map<String, dynamic>;
          final sp = (pricing['selling_price'] ??
                  pricing['price'] ??
                  pricing['unit_price'] ??
                  0.0) as num;
          final mrp = (pricing['mrp'] ?? p.mrp ?? 0.0) as num;

          p = p.copyWith(
            price: sp > 0 ? sp.toDouble() : p.price,
            mrp: mrp > 0 ? mrp.toDouble() : p.mrp,
          );
        }
      } catch (_) {}

      return p;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  void addToCart(PosProduct product, {double qty = 1.0}) {
    final existing = state.cart.indexWhere(
        (i) => i.product.productId == product.productId);
    if (existing >= 0) {
      final updated = List<CartItem>.from(state.cart);
      updated[existing] =
          updated[existing].copyWith(quantity: updated[existing].quantity + qty);
      state = state.copyWith(cart: updated);
    } else {
      state = state.copyWith(
          cart: [...state.cart, CartItem(product: product, quantity: qty)]);
    }
  }

  void removeFromCart(int productId) {
    state = state.copyWith(
        cart: state.cart
            .where((i) => i.product.productId != productId)
            .toList());
  }

  void updateQty(int productId, double qty) {
    if (qty <= 0) {
      removeFromCart(productId);
      return;
    }
    final updated = state.cart
        .map((i) => i.product.productId == productId
            ? i.copyWith(quantity: qty)
            : i)
        .toList();
    state = state.copyWith(cart: updated);
  }

  void clearCart() => state = state.copyWith(cart: const [], clearCustomer: true, clearReferral: true);

  void setCustomer(int id, String name) {
    state = state.copyWith(selectedCustomerId: id, selectedCustomerName: name);
  }

  void clearCustomer() {
    state = state.copyWith(clearCustomer: true);
  }

  Future<int?> createCustomer(String name, String phone) async {
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.postOltp('customer', {
        'name': name,
        'phone': phone,
      });
      final id = res['row']['customer_id'] as int;
      setCustomer(id, name);
      // Invalidate customer list to ensure Profile section is in sync
      ref.invalidate(customerProvider);
      return id;
    } catch (e) {
      state = state.copyWith(error: 'Failed to create customer: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchCustomers(String query) async {
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.getOltp('customer', filters: {'limit': '100'});
      final rows = (res['rows'] as List).cast<Map<String, dynamic>>();
      if (query.isEmpty) return rows;
      return rows.where((r) => 
        (r['name'] as String).toLowerCase().contains(query.toLowerCase()) ||
        (r['phone'] as String).contains(query)
      ).toList();
    } catch (_) {
      return [];
    }
  }

  void setPendingReferral(PendingReferralScan scan) {
    state = state.copyWith(
      pendingReferral: scan,
      referralDiscountPct: scan.discountPct,
      referralReferrerName: scan.referrerName,
    );
  }

  void setReferralDiscount(double pct, String referrerName) {
    state = state.copyWith(
      referralDiscountPct: pct,
      referralReferrerName: referrerName,
    );
  }

  void clearReferralDiscount() {
    state = state.copyWith(clearReferral: true);
  }

  Future<Map<String, dynamic>?> placeOrder({
    String paymentMethod = 'cash',
  }) async {
    if (state.cart.isEmpty) return null;
    state = state.copyWith(isPlacingOrder: true, clearError: true);

    final client = ref.read(apiClientProvider);
    final pending = state.pendingReferral;

    // Resolve customer ID and discount from pending referral (if any)
    int? customerId = state.selectedCustomerId;
    final discountPct = state.referralDiscountPct ?? 0;

    // If a referral QR was scanned, we may already have the new customer's ID
    // (pre-set from the scan sheet). Use it if not already overridden by a manual selection.
    final subtotal = state.subtotal;
    final totalAmount = discountPct > 0
        ? subtotal * (1 - discountPct / 100)
        : subtotal;

    try {
      final body = <String, dynamic>{
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        'customer_id': customerId,
        'items': state.cart
            .map((i) => {
                  'product_id': i.product.productId,
                  'quantity': i.quantity,
                  'selling_price': i.product.price,
                  'unit_price': i.product.price,
                })
            .toList(),
      };
      final order = await client.posPost('/pos/orders', body);
      if (order != null) {
        final orderId = order['order_id'] as int?;

        // Now process the referral with the real order_id (creates customer + referral record)
        if (pending != null) {
          try {
            final scanResult = await processReferralScan(
              tokenHash: pending.tokenHash,
              newCustomerPhone: pending.newCustomerPhone,
              newCustomerName: pending.newCustomerName,
              orderId: orderId,
            );
            if (scanResult.isNewCustomer) {
              ref.invalidate(customerProvider);
            }
          } catch (_) {
            // referral processing failed — order is already placed, so ignore
          }
        }

        clearCart();
        state = state.copyWith(isPlacingOrder: false);
        ref.read(overviewProvider.notifier).refresh();
        final mutable = Map<String, dynamic>.from(order);
        mutable['total_amount'] ??= totalAmount;
        return mutable;
      }
      state = state.copyWith(
          isPlacingOrder: false, error: 'Failed to place order.');
      return null;
    } catch (e) {
      state = state.copyWith(
          isPlacingOrder: false, error: 'Order failed: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllOrders({
    int limit = 50,
    String? status,
    String? paymentMethod,
    int? customerId,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    final params = <String, String>{
      'store_id': '$storeId',
      'limit': '$limit',
    };
    if (status != null) params['status'] = status;
    if (paymentMethod != null) params['payment_method'] = paymentMethod;
    if (customerId != null) params['customer_id'] = '$customerId';
    if (startDate != null) params['start_date'] = startDate.toUtc().toIso8601String();
    if (endDate != null) params['end_date'] = endDate.toUtc().toIso8601String();
    if (minAmount != null) params['min_amount'] = '$minAmount';
    if (maxAmount != null) params['max_amount'] = '$maxAmount';

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    try {
      final res = await client.posGetList('/pos/orders?$query');
      return res?.cast<Map<String, dynamic>>() ?? [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchTodayOrders() async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      final res = await client.posGetList(
          '/pos/orders?store_id=$storeId&limit=200');
      if (res == null) return [];
      
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      
      return res.cast<Map<String, dynamic>>().where((o) {
        String dateStr = o['order_date'] as String? ?? '';
        if (dateStr.isEmpty) return false;
        try {
          if (!dateStr.endsWith('Z')) {
            dateStr += 'Z';
          }
          final orderDate = DateTime.parse(dateStr).toLocal();
          return orderDate.isAfter(todayStart);
        } catch (_) {
          return false;
        }
      }).toList();
    } catch (_) {
      return [];
    }
  }
}

final posProvider = NotifierProvider.autoDispose<PosNotifier, PosState>(PosNotifier.new);
