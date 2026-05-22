import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../models/procurement_models.dart';

class ProcurementData {
  final List<Supplier> suppliers;
  final List<PurchaseOrder> purchases;

  const ProcurementData({required this.suppliers, required this.purchases});
}

class ProcurementNotifier extends AsyncNotifier<ProcurementData> {
  @override
  Future<ProcurementData> build() => _fetch();

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
        'order_date': DateTime.now().toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
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
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsReceived(int purchaseId) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp(
        'purchases',
        {'status': 'received'},
        filters: {'purchase_id': purchaseId.toString()},
      );
      await refresh();
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
    } catch (e) {
      rethrow;
    }
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
