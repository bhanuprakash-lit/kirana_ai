import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/auth/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../dashboard/providers/overview_provider.dart';
import '../../profile/providers/customer_provider.dart';
import '../../referral/models/referral_models.dart';
import '../../referral/providers/referral_provider.dart';
import '../models/cart_item.dart';
import '../models/customer_price.dart';
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

  /// Customer-specific price suggestions for the selected customer (products
  /// whose last-paid price differs from catalog).
  final List<CustomerPrice> customerPrices;

  /// True once the shopkeeper accepted the customer's prices (drives the
  /// per-line badge and makes newly-added items inherit the customer price).
  final bool customerPricesApplied;

  /// True if the shopkeeper dismissed the suggestion banner without applying.
  final bool customerPricesDismissed;

  /// Customer-price edits made in the current cart. These are saved only after
  /// an order is placed; abandoning the cart must not change stored prices.
  final Map<int, double?> pendingCustomerPriceEdits;

  /// Basket attribution for the current cart — set when a full basket bundle
  /// deal is added, so the resulting order records which basket it came from
  /// plus the bundle value and savings. All null for an ordinary cart.
  final int? appliedBasketId;
  final String? appliedBasketName;
  final double? basketGross; // basket value (Σ normal prices)
  final double? basketSavings; // amount saved vs. the bundle price

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
    this.customerPrices = const [],
    this.customerPricesApplied = false,
    this.customerPricesDismissed = false,
    this.pendingCustomerPriceEdits = const {},
    this.appliedBasketId,
    this.appliedBasketName,
    this.basketGross,
    this.basketSavings,
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
    List<CustomerPrice>? customerPrices,
    bool? customerPricesApplied,
    bool? customerPricesDismissed,
    Map<int, double?>? pendingCustomerPriceEdits,
    int? appliedBasketId,
    String? appliedBasketName,
    double? basketGross,
    double? basketSavings,
    bool clearBasket = false,
  }) => PosState(
    products: products ?? this.products,
    isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    cart: cart ?? this.cart,
    isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
    error: clearError ? null : (error ?? this.error),
    selectedCustomerId: clearCustomer
        ? null
        : (selectedCustomerId ?? this.selectedCustomerId),
    selectedCustomerName: clearCustomer
        ? null
        : (selectedCustomerName ?? this.selectedCustomerName),
    referralDiscountPct: clearReferral
        ? null
        : (referralDiscountPct ?? this.referralDiscountPct),
    referralReferrerName: clearReferral
        ? null
        : (referralReferrerName ?? this.referralReferrerName),
    pendingReferral: clearReferral
        ? null
        : (pendingReferral ?? this.pendingReferral),
    // Customer-price state is cleared whenever the customer is cleared.
    customerPrices: clearCustomer
        ? const []
        : (customerPrices ?? this.customerPrices),
    customerPricesApplied: clearCustomer
        ? false
        : (customerPricesApplied ?? this.customerPricesApplied),
    customerPricesDismissed: clearCustomer
        ? false
        : (customerPricesDismissed ?? this.customerPricesDismissed),
    pendingCustomerPriceEdits: clearCustomer
        ? const {}
        : (pendingCustomerPriceEdits ?? this.pendingCustomerPriceEdits),
    appliedBasketId: clearBasket
        ? null
        : (appliedBasketId ?? this.appliedBasketId),
    appliedBasketName: clearBasket
        ? null
        : (appliedBasketName ?? this.appliedBasketName),
    basketGross: clearBasket ? null : (basketGross ?? this.basketGross),
    basketSavings: clearBasket ? null : (basketSavings ?? this.basketSavings),
  );

  double get subtotal => cart.fold(0, (sum, item) => sum + item.lineTotal);

  /// F3 — total GST included in the cart (0 = no taxable items).
  double get cartTax => cart.fold(0.0, (sum, item) => sum + item.taxAmount);

  /// The customer-specific price for [productId], if one was suggested.
  CustomerPrice? customerPriceFor(int productId) {
    for (final cp in customerPrices) {
      if (cp.productId == productId) return cp;
    }
    return null;
  }

  /// How many items *currently in the cart* have a special price for this
  /// customer. The banner offers to reprice the cart, so it must count what's
  /// actually here — not the customer's whole saved price list (which would
  /// claim "4 special prices" even when none of those items are in the cart).
  int get customerPricedCartCount =>
      cart.where((l) => customerPriceFor(l.product.productId) != null).length;

  /// Whether the suggestion banner should be shown. Only when at least one cart
  /// item would actually be repriced.
  bool get showCustomerPriceBanner =>
      customerPricedCartCount > 0 &&
      !customerPricesApplied &&
      !customerPricesDismissed;

  double get discountedSubtotal {
    if (referralDiscountPct == null || referralDiscountPct! <= 0) {
      return subtotal;
    }
    return subtotal * (1 - referralDiscountPct! / 100);
  }

  double get discountAmount => subtotal - discountedSubtotal;

  double get cartItemCount => cart.fold(0, (sum, item) => sum + item.quantity);

  bool get hasToken => true; // checked at runtime
}

class PosNotifier extends Notifier<PosState> {
  int? _storeId;
  Timer? _cartPingTimer;

  @override
  PosState build() {
    ref.onDispose(() => _cartPingTimer?.cancel());
    Future.microtask(_loadProducts);
    return const PosState();
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(isLoadingProducts: true, clearError: true);
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    _storeId = prefs.getInt('store_id') ?? 1;
    final storeId = _storeId!;

    final productsFuture = client.posGetList(
      '/pos/products?store_id=$storeId&limit=1000',
    );
    final pricingFuture = client.getOltp(
      'pricing',
      filters: {'store_id': '$storeId'},
    );

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
      for (final row
          in ((pricingRes['rows'] as List<dynamic>?) ?? [])
              .cast<Map<String, dynamic>>()) {
        final id = (row['product_id'] as num?)?.toInt();
        if (id != null) pricingMap[id] = row;
      }

      final products = res.cast<Map<String, dynamic>>().map((j) {
        final p = PosProduct.fromJson(j);
        final pricing = pricingMap[p.productId];
        if (pricing != null) {
          final sp =
              (pricing['selling_price'] ??
                      pricing['price'] ??
                      pricing['unit_price'] ??
                      0.0)
                  as num;
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
      state = state.copyWith(
        isLoadingProducts: false,
        error: 'Error loading POS products: $e',
      );
    }
  }

  Future<void> reloadProducts() => _loadProducts();

  /// Clears any transient error (e.g. an "Order failed: insufficient stock"
  /// message). Call this when the order sheet is dismissed so the error
  /// doesn't bleed into other surfaces like the empty-cart "POS Offline"
  /// card.
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(clearError: true);
    }
  }

  // Sync local-cache lookup — no network, no async overhead.
  PosProduct? lookupBarcodeLocal(String barcode) {
    for (final p in state.products) {
      if (p.barcode == barcode) return p;
    }
    return null;
  }

  Future<PosProduct?> lookupBarcode(String barcode) async {
    final storeId = _storeId ?? 1;
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.posGet(
        '/pos/products/barcode/$barcode?store_id=$storeId',
      );
      if (res == null) return null;
      return PosProduct.fromJson(res);
    } on ApiException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  // ── Cart ping (abandoned cart intelligence) ────────────────────────────────

  void _schedulePing() {
    _cartPingTimer?.cancel();
    _cartPingTimer = Timer(const Duration(seconds: 3), _doPing);
  }

  Future<void> _doPing({bool converted = false}) async {
    try {
      final client = ref.read(apiClientProvider);
      final items = state.cart
          .map(
            (i) => {
              'product_id': i.product.productId,
              'name': i.product.name,
              'qty': i.quantity,
            },
          )
          .toList();
      await client.post('/kirana/intelligence/cart-ping', {
        'item_count': converted ? 0 : state.cart.length,
        'items': converted ? [] : items,
        'converted': converted,
      });
    } catch (_) {
      // Non-critical — silently ignore
    }
  }

  // ── Cart mutations ─────────────────────────────────────────────────────────

  void addToCart(
    PosProduct product, {
    double qty = 1.0,
    double? unitPriceOverride,
    int? variantId,
    String? variantLabel,
  }) {
    // When the customer's prices are in effect, new items inherit their price
    // unless the caller passed an explicit override (e.g. basket/bundle deal).
    if (unitPriceOverride == null && state.customerPricesApplied) {
      unitPriceOverride = state.customerPriceFor(product.productId)?.price;
    }
    // A product can appear once per variant; grocery uses variantId == null.
    final lineKey = '${product.productId}:${variantId ?? 0}';
    final existing = state.cart.indexWhere((i) => i.lineKey == lineKey);
    if (existing >= 0) {
      final updated = List<CartItem>.from(state.cart);
      updated[existing] = updated[existing].copyWith(
        quantity: updated[existing].quantity + qty,
        unitPriceOverride: unitPriceOverride,
      );
      state = state.copyWith(cart: updated);
    } else {
      state = state.copyWith(
        cart: [
          ...state.cart,
          CartItem(
            product: product,
            quantity: qty,
            unitPriceOverride: unitPriceOverride,
            variantId: variantId,
            variantLabel: variantLabel,
          ),
        ],
      );
    }
    _schedulePing();
  }

  void removeFromCart(String lineKey) {
    state = state.copyWith(
      cart: state.cart.where((i) => i.lineKey != lineKey).toList(),
    );
    _schedulePing();
  }

  void updateQty(String lineKey, double qty) {
    if (qty <= 0) {
      removeFromCart(lineKey);
      return;
    }
    final updated = state.cart
        .map((i) => i.lineKey == lineKey ? i.copyWith(quantity: qty) : i)
        .toList();
    state = state.copyWith(cart: updated);
    _schedulePing();
  }

  void clearCart() {
    state = state.copyWith(
      cart: const [],
      clearCustomer: true,
      clearReferral: true,
      clearBasket: true,
    );
    _cartPingTimer?.cancel();
    _doPing(converted: false);
  }

  /// Tags the current cart as sourced from a basket/combo so the placed order
  /// records the attribution (name + value + optional savings). [id] is the
  /// saved-basket id, or null for an AI campaign (no saved id, no discount).
  /// Cleared with the cart. Resets any prior attribution first so a campaign
  /// (id null) can't inherit a previously-added basket's id.
  void setAppliedBasket({
    int? id,
    required String name,
    double? gross,
    double? savings,
  }) {
    state = state
        .copyWith(clearBasket: true)
        .copyWith(
          appliedBasketId: id,
          appliedBasketName: name,
          basketGross: gross,
          basketSavings: savings,
        );
  }

  void setCustomer(int id, String name) {
    state = state.copyWith(
      selectedCustomerId: id,
      selectedCustomerName: name,
      // Reset any prior customer's price suggestions before loading this one's.
      customerPrices: const [],
      customerPricesApplied: false,
      customerPricesDismissed: false,
    );
    _fetchCustomerPrices(id);
  }

  /// Loads the selected customer's price memory (last-paid vs catalog). Silent
  /// on failure — the feature is purely additive, never blocks a sale.
  Future<void> _fetchCustomerPrices(int customerId) async {
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.get(
        '/kirana/customers/$customerId/price-memory',
      );
      final list = ((res['prices'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()
          .map(CustomerPrice.fromJson)
          .toList();
      // Ignore if the customer changed/cleared while the request was in flight.
      if (state.selectedCustomerId != customerId) {
        return;
      }
      state = state.copyWith(
        customerPrices: _applyPendingCustomerPriceEdits(list),
      );
    } catch (_) {
      // Leave suggestions empty.
    }
  }

  /// Apply the customer's prices to all matching cart lines, and flag so any
  /// items added afterwards inherit the customer price too.
  void applyCustomerPrices() {
    final updated = state.cart.map((line) {
      final cp = state.customerPriceFor(line.product.productId);
      if (cp == null) return line;
      return line.copyWith(unitPriceOverride: cp.price);
    }).toList();
    state = state.copyWith(cart: updated, customerPricesApplied: true);
    _schedulePing();
  }

  void dismissCustomerPrices() {
    state = state.copyWith(customerPricesDismissed: true);
  }

  /// Set a customer-specific price for this cart only.
  ///
  /// The backend write is deferred until an order is placed. If the cart is
  /// abandoned, cleared, or the customer changes, the edit is discarded.
  Future<bool> setCustomerPrice(int productId, double? price) async {
    if (state.selectedCustomerId == null) return false;

    final updated = state.cart
        .map(
          (line) => line.product.productId == productId
              ? line.copyWith(
                  unitPriceOverride: price,
                  clearOverride: price == null,
                )
              : line,
        )
        .toList();
    final pending = Map<int, double?>.from(state.pendingCustomerPriceEdits);
    pending[productId] = price;
    state = state.copyWith(
      cart: updated,
      customerPrices: _applyPendingCustomerPriceEdits(
        state.customerPrices,
        edits: pending,
      ),
      pendingCustomerPriceEdits: pending,
      customerPricesApplied: price != null ? true : state.customerPricesApplied,
    );
    _schedulePing();
    return true;
  }

  List<CustomerPrice> _applyPendingCustomerPriceEdits(
    List<CustomerPrice> prices, {
    Map<int, double?>? edits,
  }) {
    final pending = edits ?? state.pendingCustomerPriceEdits;
    if (pending.isEmpty) return prices;

    final merged = <CustomerPrice>[...prices];
    for (final entry in pending.entries) {
      final productId = entry.key;
      final price = entry.value;
      final index = merged.indexWhere((cp) => cp.productId == productId);
      if (price == null) {
        if (index >= 0) merged.removeAt(index);
        continue;
      }

      final product = state.products
          .where((p) => p.productId == productId)
          .firstOrNull;
      final existing = index >= 0 ? merged[index] : null;
      final customerPrice = CustomerPrice(
        productId: productId,
        productName: existing?.productName ?? product?.displayName ?? '',
        unit: existing?.unit ?? product?.unit,
        price: price,
        source: 'pinned',
        lastPaidPrice: existing?.lastPaidPrice,
        lastPaidDate: existing?.lastPaidDate,
        catalogPrice: existing?.catalogPrice ?? product?.price,
      );
      if (index >= 0) {
        merged[index] = customerPrice;
      } else {
        merged.add(customerPrice);
      }
    }
    return merged;
  }

  Future<void> _persistPendingCustomerPriceEdits(int customerId) async {
    final pending = Map<int, double?>.from(state.pendingCustomerPriceEdits);
    if (pending.isEmpty) return;

    final client = ref.read(apiClientProvider);
    for (final entry in pending.entries) {
      await client.post('/kirana/customers/$customerId/price', {
        'product_id': entry.key,
        'price': entry.value,
      });
    }
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
      final res = await client.getOltp('customer', filters: {'limit': '500'});
      final rows = (res['rows'] as List).cast<Map<String, dynamic>>();
      // Sort alphabetically by name (case-insensitive); unnamed customers last.
      rows.sort((a, b) {
        final an = (a['name'] as String? ?? '').trim().toLowerCase();
        final bn = (b['name'] as String? ?? '').trim().toLowerCase();
        if (an.isEmpty && bn.isEmpty) return 0;
        if (an.isEmpty) return 1;
        if (bn.isEmpty) return -1;
        return an.compareTo(bn);
      });
      if (query.isEmpty) return rows;
      final q = query.toLowerCase();
      return rows.where((r) {
        final name = (r['name'] as String? ?? '').toLowerCase();
        final phone = (r['phone'] as String? ?? '');
        return name.contains(q) || phone.contains(q);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  void setPendingReferral(PendingReferralScan scan) {
    final customerDisplayName = scan.newCustomerName.isNotEmpty
        ? scan.newCustomerName
        : scan.newCustomerPhone;
    state = state.copyWith(
      pendingReferral: scan,
      referralDiscountPct: scan.discountPct,
      referralReferrerName: scan.referrerName,
      selectedCustomerName: customerDisplayName,
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
    double? udhaarAmount, // null = full amount is udhaar (or not applicable)
    int?
    customerId, // overrides the POS-selected customer (e.g. the udhaar customer)
    DateTime? udhaarDueDate, // repayment deadline for udhaar orders
  }) async {
    if (state.cart.isEmpty) return null;
    state = state.copyWith(isPlacingOrder: true, clearError: true);

    final client = ref.read(apiClientProvider);
    final pending = state.pendingReferral;

    // Resolve customer ID and discount from pending referral (if any).
    // An explicit customerId (e.g. the udhaar customer) takes precedence so the
    // backend can attribute the order — and auto-create the single khata row —
    // to the right customer.
    final int? orderCustomerId = customerId ?? state.selectedCustomerId;
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
        'customer_id': orderCustomerId,
        'items': state.cart
            .map(
              (i) => {
                'product_id': i.product.productId,
                'variant_id': ?i.variantId,
                'quantity': i.quantity,
                'selling_price': i.unitPrice,
                'unit_price': i.unitPrice,
              },
            )
            .toList(),
        // Partial-udhaar split — backend persists so order history can show
        // the exact credit/cash breakdown.
        if (udhaarAmount != null && paymentMethod == 'udhaar') ...{
          'udhaar_amount': udhaarAmount,
          'cash_paid': totalAmount - udhaarAmount,
        },
        // Repayment deadline for the auto-created khata (udhaar orders only).
        if (paymentMethod == 'udhaar' && udhaarDueDate != null)
          'due_date':
              '${udhaarDueDate.year.toString().padLeft(4, '0')}-${udhaarDueDate.month.toString().padLeft(2, '0')}-${udhaarDueDate.day.toString().padLeft(2, '0')}',
        // Basket/combo attribution — gated on the name so AI campaigns (which
        // have a null basket_id) are recorded too.
        if (state.appliedBasketName != null) ...{
          'basket_id': state.appliedBasketId,
          'basket_name': state.appliedBasketName,
          'basket_gross': state.basketGross,
          'basket_savings': state.basketSavings,
        },
      };
      final order = await client.posPost('/pos/orders', body);
      if (order != null) {
        final orderId = order['order_id'] as int?;
        final priceMemoryCustomerId = orderCustomerId;

        // Now process the referral with the real order_id (creates customer + referral record)
        if (pending != null) {
          try {
            final scanResult = await processReferralScan(
              tokenHash: pending.tokenHash,
              newCustomerPhone: pending.newCustomerPhone,
              newCustomerName: pending.newCustomerName,
              orderId: orderId,
            );
            // Back-fill customer_id on the order (order was placed before customer existed)
            if (orderId != null) {
              try {
                await client.patchOltp(
                  'orders',
                  {'customer_id': scanResult.newCustomerId},
                  filters: {'order_id': '$orderId'},
                );
              } catch (_) {}
            }
            if (priceMemoryCustomerId == null) {
              try {
                await _persistPendingCustomerPriceEdits(
                  scanResult.newCustomerId,
                );
              } catch (_) {}
            }
            ref.invalidate(customerProvider);
          } catch (_) {
            // referral processing failed — order is already placed, so ignore
          }
        }

        if (priceMemoryCustomerId != null) {
          try {
            await _persistPendingCustomerPriceEdits(priceMemoryCustomerId);
          } catch (_) {
            // The order is already placed; don't fail the sale if price-memory
            // persistence has a transient problem.
          }
        }

        clearCart();
        _doPing(converted: true);
        state = state.copyWith(isPlacingOrder: false);
        ref.read(overviewProvider.notifier).refresh();
        final mutable = Map<String, dynamic>.from(order);
        mutable['total_amount'] ??= totalAmount;
        return mutable;
      }
      state = state.copyWith(
        isPlacingOrder: false,
        error: 'Failed to place order.',
      );
      return null;
    } catch (e) {
      state = state.copyWith(isPlacingOrder: false, error: 'Order failed: $e');
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

    final params = <String, String>{'store_id': '$storeId', 'limit': '$limit'};
    if (status != null) params['status'] = status;
    if (paymentMethod != null) params['payment_method'] = paymentMethod;
    if (customerId != null) params['customer_id'] = '$customerId';
    if (startDate != null) {
      params['start_date'] = startDate.toUtc().toIso8601String();
    }
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
        '/pos/orders?store_id=$storeId&limit=200',
      );
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

final posProvider = NotifierProvider.autoDispose<PosNotifier, PosState>(
  PosNotifier.new,
);

/// Bumped to ask the POS tab to open the continuous scanner (e.g. from the
/// home-screen widget's "New Bill" action). POS tab listens and opens the sheet.
class PosScanRequestNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void request() => state++;
}

final posScanRequestProvider = NotifierProvider<PosScanRequestNotifier, int>(
  PosScanRequestNotifier.new,
);
