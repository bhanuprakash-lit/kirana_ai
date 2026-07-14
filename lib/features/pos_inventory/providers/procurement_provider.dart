import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../models/procurement_models.dart';
import 'inventory_provider.dart';
import 'pos_provider.dart';

class ProcurementData {
  final List<Supplier> suppliers;
  final List<PurchaseOrder> purchases;

  const ProcurementData({required this.suppliers, required this.purchases});
}

/// A pending pre-fill for the New Purchase Order sheet — set when the owner taps
/// "Create purchase order" on a reorder suggestion (procurement) or the ML
/// reorder detail screen, so the sheet opens with the product + qty already in.
class PurchasePrefill {
  final int productId;
  final String productName;
  final int qty;
  final double cost; // 0 if unknown
  final int? supplierId;

  const PurchasePrefill({
    required this.productId,
    required this.productName,
    required this.qty,
    this.cost = 0,
    this.supplierId,
  });
}

/// Holds a one-shot purchase prefill across screens (intelligence → procurement).
class PurchasePrefillNotifier extends Notifier<PurchasePrefill?> {
  @override
  PurchasePrefill? build() => null;

  void set(PurchasePrefill prefill) => state = prefill;
  void clear() => state = null;
}

final purchasePrefillProvider =
    NotifierProvider<PurchasePrefillNotifier, PurchasePrefill?>(
      PurchasePrefillNotifier.new,
    );

class ProcurementNotifier extends AsyncNotifier<ProcurementData> {
  @override
  Future<ProcurementData> build() {
    ref.watch(storeScopeProvider); // rebuild when the active store changes
    return _fetch();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<ProcurementData> _fetch() async {
    final client = ref.read(apiClientProvider);

    final results = await Future.wait([
      client.getOltp('supplier'),
      client.getOltp('purchases'),
    ]);

    final suppliersJson = results[0];
    final purchasesJson = results[1];

    final suppliers = (suppliersJson['rows'] as List)
        .map((j) => Supplier.fromJson(j as Map<String, dynamic>))
        .toList();
    final supplierMap = {for (var s in suppliers) s.supplierId: s.name};

    final purchases = (purchasesJson['rows'] as List).map((j) {
      final sid = j['supplier_id'] as int;
      return PurchaseOrder.fromJson(
        j as Map<String, dynamic>,
        supplierName: supplierMap[sid],
      );
    }).toList();

    return ProcurementData(suppliers: suppliers, purchases: purchases);
  }

  Future<void> updateSupplier({
    required int supplierId,
    required String name,
    String? phone,
    String? category,
  }) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp(
        'supplier',
        {
          'name': name,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (category != null && category.isNotEmpty) 'category': category,
        },
        filters: {'supplier_id': supplierId.toString()},
      );
      await refresh();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createSupplier({
    required String name,
    String? phone,
    String? category,
  }) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      await client.postOltp('supplier', {
        'store_id': storeId,
        'name': name,
        'phone': phone,
        'category': category,
      });
      await refresh();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPurchaseOrder({
    required int supplierId,
    required List<Map<String, dynamic>> items,
    DateTime? dueDate,
    String? notes,
    double?
    totalAmountOverride, // used when total is known externally (e.g. scanned invoice)
  }) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      double totalAmount = totalAmountOverride ?? 0;
      if (totalAmountOverride == null) {
        for (var item in items) {
          totalAmount +=
              (item['quantity'] as num) * (item['cost_price'] as num);
        }
      }

      // 1. Create purchase header
      final res = await client.postOltp('purchases', {
        'store_id': storeId,
        'supplier_id': supplierId,
        // Backend stores timestamps as UTC — must send UTC, not local time.
        'order_date': DateTime.now().toUtc().toIso8601String(),
        'due_date': dueDate?.toUtc().toIso8601String(),
        'total_amount': totalAmount,
        'status': 'ordered',
        'payment_status': 'unpaid',
        'notes': notes,
      });

      final purchaseId = res['row']['purchase_id'] as int;

      // 2. Create purchase items in parallel
      await Future.wait(
        items.map(
          (item) => client.postOltp('purchase_items', {
            'purchase_id': purchaseId,
            'product_id': item['product_id'],
            'quantity': item['quantity'],
            'cost_price': item['cost_price'],
          }),
        ),
      );

      await refresh();
      ref.invalidate(supplierOverviewProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsReceived(int purchaseId) async {
    final client = ref.read(apiClientProvider);
    try {
      // Transactional receive: flips the status AND adds the ordered
      // quantities to inventory (plus movement + supplier-cost records).
      await client.post('/kirana/purchases/$purchaseId/receive', {});
      await refresh();
      // Stock changed — refresh the inventory list and POS product cache.
      ref.invalidate(inventoryProvider);
      ref.invalidate(supplierOverviewProvider);
      ref.read(posProvider.notifier).reloadProducts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsPaid(int purchaseId) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp(
        'purchases',
        {'payment_status': 'paid'},
        filters: {'purchase_id': purchaseId.toString()},
      );
      await refresh();
      ref.invalidate(supplierOverviewProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Tag a product to a supplier (drives the supplier dashboard's
  /// "products they sell us" list).
  Future<void> tagProductToSupplier(
    int supplierId,
    int productId, {
    double? costPrice,
  }) async {
    final client = ref.read(apiClientProvider);
    await client.post('/kirana/suppliers/$supplierId/products', {
      'product_id': productId,
      'cost_price': ?costPrice,
    });
    ref.invalidate(supplierProductsProvider(supplierId));
    ref.invalidate(supplierOverviewProvider);
  }

  Future<void> untagProductFromSupplier(int supplierId, int productId) async {
    final client = ref.read(apiClientProvider);
    await client.delete('/kirana/suppliers/$supplierId/products/$productId');
    ref.invalidate(supplierProductsProvider(supplierId));
    ref.invalidate(supplierOverviewProvider);
  }

  Future<List<PurchaseItem>> fetchPurchaseItems(int purchaseId) async {
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.getOltp(
        'purchase_items',
        filters: {'purchase_id': purchaseId.toString()},
      );

      final items = (res['rows'] as List)
          .map((j) => PurchaseItem.fromJson(j as Map<String, dynamic>))
          .toList();
      return items;
    } catch (e) {
      return [];
    }
  }
}

final procurementProvider =
    AsyncNotifierProvider<ProcurementNotifier, ProcurementData>(
      ProcurementNotifier.new,
    );

// ── Supplier dashboard ────────────────────────────────────────────────────────

/// Per-supplier dues/products rollup, keyed by supplier id. Iteration order
/// preserves the backend's payment-priority ordering (whom to pay first).
final supplierOverviewProvider = FutureProvider<Map<int, SupplierOverview>>((
  ref,
) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final res = await ref.read(apiClientProvider).get('/kirana/suppliers/overview');
  final list = (res is Map ? res['suppliers'] : null) as List<dynamic>? ?? [];
  final map = <int, SupplierOverview>{};
  for (final j in list.whereType<Map>()) {
    final o = SupplierOverview.fromJson(j.cast<String, dynamic>());
    map[o.supplierId] = o;
  }
  return map;
});

/// Products tagged to one supplier.
final supplierProductsProvider = FutureProvider.autoDispose
    .family<List<SupplierProduct>, int>((ref, supplierId) async {
      final res = await ref
          .read(apiClientProvider)
          .get('/kirana/suppliers/$supplierId/products');
      final list = (res is Map ? res['products'] : null) as List<dynamic>? ?? [];
      return list
          .whereType<Map>()
          .map((j) => SupplierProduct.fromJson(j.cast<String, dynamic>()))
          .toList();
    });
