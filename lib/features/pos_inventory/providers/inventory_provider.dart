import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../models/inventory_item.dart';
import 'pos_provider.dart';

class InventoryData {
  final List<InventoryItem> items;
  final List<Map<String, dynamic>> categories;

  const InventoryData({required this.items, required this.categories});

  // Group items by category name for display
  Map<String, List<InventoryItem>> get byCategory {
    final map = <String, List<InventoryItem>>{};
    for (final item in items) {
      final cat = item.categoryName ?? 'Uncategorised';
      map.putIfAbsent(cat, () => []).add(item);
    }
    return map;
  }
}

class InventoryNotifier extends AsyncNotifier<InventoryData> {
  @override
  Future<InventoryData> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<InventoryData> _fetch() async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    // Fire all in parallel
    final productsFuture =
        client.posGetList('/pos/products?store_id=$storeId&limit=1000');
    final categoriesFuture = client.posGetList('/pos/categories');
    final recoFuture =
        client.get('/kirana/stores/$storeId/recommendations');
    final snapshotFuture =
        client.get('/kirana/stores/$storeId/snapshot');
    final pricingFuture =
        client.getOltp('pricing', filters: {'store_id': '$storeId'});

    final productsRes = await productsFuture;
    final categoriesRes = await categoriesFuture;
    final recoRes = await recoFuture;
    final snapshotRes = await snapshotFuture;
    final pricingRes = await pricingFuture;

    final categoryNameMap = <int, String>{};
    for (final cat in (categoriesRes ?? []).cast<Map<String, dynamic>>()) {
      final id = (cat['category_id'] as num?)?.toInt();
      final name = cat['name'] as String?;
      if (id != null && name != null) categoryNameMap[id] = name;
    }

    final recoMap = <int, Map<String, dynamic>>{};
    for (final reco in ((recoRes['recommendations'] as List<dynamic>?) ?? []).cast<Map<String, dynamic>>()) {
      final id = (reco['sku_id'] as num?)?.toInt();
      if (id != null) recoMap[id] = reco;
    }

    final soldTodayMap = <int, double>{};
    for (final item in ((snapshotRes['items'] as List<dynamic>?) ?? []).cast<Map<String, dynamic>>()) {
      final id = (item['sku_id'] as num?)?.toInt();
      if (id != null) {
        soldTodayMap[id] = (item['units_sold'] as num?)?.toDouble() ?? 0.0;
      }
    }

    final pricingMap = <int, Map<String, dynamic>>{};
    for (final row in ((pricingRes['rows'] as List<dynamic>?) ?? [])
        .cast<Map<String, dynamic>>()) {
      final id = (row['product_id'] as num?)?.toInt();
      if (id != null) pricingMap[id] = row;
    }

    final items = (productsRes ?? [])
        .cast<Map<String, dynamic>>()
        .map((p) {
          final productId = (p['product_id'] as num?)?.toInt() ?? 0;
          return InventoryItem.fromSources(
            product: p,
            categoryName: categoryNameMap[(p['category_id'] as num?)?.toInt()],
            recommendation: recoMap[productId],
            pricing: pricingMap[productId],
            soldToday: soldTodayMap[productId] ?? 0.0,
            expiryDate: p['expiry_date'] as String?,
          );
        })
        .toList();

    final categories = (categoriesRes ?? []).cast<Map<String, dynamic>>();

    return InventoryData(items: items, categories: categories);
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<bool> addCategory(String name, {int? parentId}) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.postOltp('category', {
        'name': name,
        'parent_category_id': parentId,
      });
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> addProduct({
    required String name,
    required int categoryId,
    required double sellingPrice,
    required double initialStock,
    String? brand,
    String? unit,
    double? weight,
    String? barcode,
    double? mrp,
    bool isPerishable = false,
    bool isLoose = false,
    String? expiryDate,
  }) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      // 1. Create product in global catalog — or look up if barcode conflicts
      int? productId;
      try {
        final productRes = await client.postOltp('product', {
          'name': name,
          'category_id': categoryId,
          'brand': brand,
          'unit': unit,
          'weight': weight,
          'barcode': barcode,
          'is_perishable': isPerishable,
          'is_loose': isLoose,
        });
        productId = (productRes['row']?['product_id'] as num?)?.toInt();
      } catch (_) {
        if (barcode != null) {
          try {
            final lookup = await client.getOltp(
                'product', filters: {'barcode': barcode});
            final rows = (lookup['rows'] as List<dynamic>?) ?? [];
            if (rows.isNotEmpty) {
              productId =
                  (rows.first['product_id'] as num?)?.toInt();
            }
          } catch (_) {}
        }
      }
      if (productId == null) return 'Failed to create product.';

      // 2. Add to store inventory (ignore conflict if already stocked)
      try {
        await client.postOltp('inventory', {
          'store_id': storeId,
          'product_id': productId,
          'quantity': initialStock,
        });
      } catch (_) {
        // Product may already be in this store's inventory — continue
      }

      // 3. Set pricing
      await client.postOltp('pricing', {
        'store_id': storeId,
        'product_id': productId,
        'selling_price': sellingPrice,
        'mrp': mrp,
        'valid_from': DateTime.now().toIso8601String(),
      });

      // 4. Add batch for perishables
      if (isPerishable && expiryDate != null) {
        await client.postOltp('inventory_batch', {
          'store_id': storeId,
          'product_id': productId,
          'batch_no': 'BATCH-${DateTime.now().millisecondsSinceEpoch}',
          'expiry_date': expiryDate,
          'quantity': initialStock,
        });
      }

      // Refresh both inventory and POS product lists
      await refresh();
      ref.read(posProvider.notifier).reloadProducts();
      return null; // null = success
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> linkBarcode(int productId, String barcode) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp('product', {
        'barcode': barcode,
      }, filters: {
        'product_id': productId.toString(),
      });
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateStock(int productId, double newQuantity) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      await client.patchOltp('inventory', {
        'quantity': newQuantity,
      }, filters: {
        'store_id': storeId.toString(),
        'product_id': productId.toString(),
      });
      await refresh();
      ref.read(posProvider.notifier).reloadProducts();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Receive a new batch for a perishable product:
  /// 1. Creates an inventory_batch record with the expiry date
  /// 2. Increments inventory.quantity by the received amount
  Future<bool> receiveBatch({
    required int productId,
    required double quantity,
    required String expiryDate,
    required double currentStock,
  }) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      // 1. Create batch record
      await client.postOltp('inventory_batch', {
        'store_id': storeId,
        'product_id': productId,
        'batch_no': 'BATCH-${DateTime.now().millisecondsSinceEpoch}',
        'expiry_date': expiryDate,
        'qty_in_stock': quantity,
      });

      // 2. Increment total inventory quantity
      await client.patchOltp('inventory', {
        'quantity': currentStock + quantity,
      }, filters: {
        'store_id': storeId.toString(),
        'product_id': productId.toString(),
      });

      await refresh();
      ref.read(posProvider.notifier).reloadProducts();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final inventoryProvider =
    AsyncNotifierProvider<InventoryNotifier, InventoryData>(
        InventoryNotifier.new);
