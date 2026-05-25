import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../dashboard/providers/overview_provider.dart';
import '../models/inventory_item.dart';
import '../models/pending_inventory_item.dart';
import 'pos_provider.dart';

class InventoryData {
  final List<InventoryItem> items;
  final List<Map<String, dynamic>> categories;
  final List<PendingInventoryItem> pendingItems;

  const InventoryData({
    required this.items,
    required this.categories,
    this.pendingItems = const [],
  });

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

  // ── Refresh — preserves in-flight pending items ───────────────────────────

  Future<void> refresh() async {
    final pendingSnapshot = state.value?.pendingItems ?? const [];
    state = const AsyncLoading();
    try {
      final data = await _fetch();
      state = AsyncData(
        InventoryData(
          items: data.items,
          categories: data.categories,
          pendingItems: pendingSnapshot,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // ── Fetch (pure data, no state mutation) ──────────────────────────────────

  Future<InventoryData> _fetch() async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    final results = await Future.wait([
      client.posGetList('/pos/products?store_id=$storeId&limit=1000'),
      client.posGetList('/pos/categories'),
      client.get('/kirana/stores/$storeId/recommendations'),
      client.get('/kirana/stores/$storeId/snapshot'),
      client.getOltp('pricing', filters: {'store_id': '$storeId'}),
    ]);

    final productsRes = results[0] as List<dynamic>?;
    final categoriesRes = results[1] as List<dynamic>?;
    final recoRes = results[2] as Map<String, dynamic>;
    final snapshotRes = results[3] as Map<String, dynamic>;
    final pricingRes = results[4] as Map<String, dynamic>;

    final categoryNameMap = <int, String>{};
    for (final cat in (categoriesRes ?? []).cast<Map<String, dynamic>>()) {
      final id = (cat['category_id'] as num?)?.toInt();
      final name = cat['name'] as String?;
      if (id != null && name != null) categoryNameMap[id] = name;
    }

    final recoMap = <int, Map<String, dynamic>>{};
    for (final reco
        in ((recoRes['recommendations'] as List<dynamic>?) ?? [])
            .cast<Map<String, dynamic>>()) {
      final id = (reco['sku_id'] as num?)?.toInt();
      if (id != null) recoMap[id] = reco;
    }

    final soldTodayMap = <int, double>{};
    for (final item
        in ((snapshotRes['items'] as List<dynamic>?) ?? [])
            .cast<Map<String, dynamic>>()) {
      final id = (item['sku_id'] as num?)?.toInt();
      if (id != null) {
        soldTodayMap[id] = (item['units_sold'] as num?)?.toDouble() ?? 0.0;
      }
    }

    final pricingMap = <int, Map<String, dynamic>>{};
    for (final row
        in ((pricingRes['rows'] as List<dynamic>?) ?? [])
            .cast<Map<String, dynamic>>()) {
      final id = (row['product_id'] as num?)?.toInt();
      if (id != null) pricingMap[id] = row;
    }

    final items = (productsRes ?? []).cast<Map<String, dynamic>>().map((p) {
      final productId = (p['product_id'] as num?)?.toInt() ?? 0;
      return InventoryItem.fromSources(
        product: p,
        categoryName: categoryNameMap[(p['category_id'] as num?)?.toInt()],
        recommendation: recoMap[productId],
        pricing: pricingMap[productId],
        soldToday: soldTodayMap[productId] ?? 0.0,
        expiryDate: p['expiry_date'] as String?,
      );
    }).toList();

    final categories = (categoriesRes ?? []).cast<Map<String, dynamic>>();

    return InventoryData(items: items, categories: categories);
  }

  // ── Pending-item state helpers ────────────────────────────────────────────

  void _addPending(PendingInventoryItem p) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncData(
      InventoryData(
        items: cur.items,
        categories: cur.categories,
        pendingItems: [...cur.pendingItems, p],
      ),
    );
  }

  void _updatePending(PendingInventoryItem updated) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncData(
      InventoryData(
        items: cur.items,
        categories: cur.categories,
        pendingItems: cur.pendingItems
            .map((p) => p.tempId == updated.tempId ? updated : p)
            .toList(),
      ),
    );
  }

  void _removePending(int tempId) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncData(
      InventoryData(
        items: cur.items,
        categories: cur.categories,
        pendingItems: cur.pendingItems
            .where((p) => p.tempId != tempId)
            .toList(),
      ),
    );
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

  // Optimistic addProduct: adds to the local list instantly, syncs in background.
  // Always returns null (optimistic success) so the UI closes right away.
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
    int? existingProductId,
    String? imageUrl,
  }) async {
    final params = <String, dynamic>{
      'name': name,
      'categoryId': categoryId,
      'sellingPrice': sellingPrice,
      'initialStock': initialStock,
      'brand': brand,
      'unit': unit,
      'weight': weight,
      'barcode': barcode,
      'mrp': mrp,
      'isPerishable': isPerishable,
      'isLoose': isLoose,
      'expiryDate': expiryDate,
      'existingProductId': existingProductId,
      'imageUrl': imageUrl,
    };

    final categoryName = state.value?.categories
        .where((c) => (c['category_id'] as num?)?.toInt() == categoryId)
        .map((c) => c['name'] as String?)
        .firstOrNull;

    final pending = PendingInventoryItem(
      tempId: -DateTime.now().millisecondsSinceEpoch,
      name: name,
      brand: brand,
      categoryName: categoryName,
      price: sellingPrice,
      stockQuantity: initialStock,
      status: PendingStatus.syncing,
      params: params,
    );

    _addPending(pending);
    _syncPendingItem(pending); // fire and forget
    return null; // optimistic success
  }

  // Actual API work — pure, no state changes.
  Future<String?> _executeAddProduct(Map<String, dynamic> p) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    final name = p['name'] as String;
    final categoryId = p['categoryId'] as int;
    final sellingPrice = p['sellingPrice'] as double;
    final initialStock = p['initialStock'] as double;
    final brand = p['brand'] as String?;
    final unit = p['unit'] as String?;
    final weight = p['weight'] as double?;
    final barcode = p['barcode'] as String?;
    final mrp = p['mrp'] as double?;
    final isPerishable = p['isPerishable'] as bool;
    final isLoose = p['isLoose'] as bool;
    final expiryDate = p['expiryDate'] as String?;
    final existingProductId = p['existingProductId'] as int?;
    final imageUrl = p['imageUrl'] as String?;

    try {
      int? productId = existingProductId;
      if (productId == null) {
        try {
          final res = await client.postOltp('product', {
            'name': name,
            'category_id': categoryId,
            'brand': brand,
            'unit': unit,
            'weight': weight,
            'barcode': barcode,
            'is_perishable': isPerishable,
            'is_loose': isLoose,
            if (imageUrl != null) 'image_url': imageUrl,
          });
          productId = (res['row']?['product_id'] as num?)?.toInt();
        } catch (_) {
          if (barcode != null) {
            try {
              final lookup = await client.getOltp(
                'product',
                filters: {'barcode': barcode},
              );
              final rows = (lookup['rows'] as List<dynamic>?) ?? [];
              if (rows.isNotEmpty) {
                productId = (rows.first['product_id'] as num?)?.toInt();
              }
            } catch (_) {}
          }
        }
      }
      if (productId == null) return 'Could not create product.';

      try {
        await client.postOltp('inventory', {
          'store_id': storeId,
          'product_id': productId,
          'quantity': initialStock,
        });
      } catch (_) {
        // already in inventory — continue to pricing
      }

      await client.postOltp('pricing', {
        'store_id': storeId,
        'product_id': productId,
        'selling_price': sellingPrice,
        'mrp': mrp,
        // Backend compares valid_from against datetime.utcnow() — must send UTC.
        // Backdate by 1 minute so clock skew can't make the row "future-dated".
        'valid_from': DateTime.now()
            .toUtc()
            .subtract(const Duration(minutes: 1))
            .toIso8601String(),
      });

      if (isPerishable && expiryDate != null) {
        await client.postOltp('inventory_batch', {
          'store_id': storeId,
          'product_id': productId,
          'batch_no': 'BATCH-${DateTime.now().millisecondsSinceEpoch}',
          'expiry_date': expiryDate,
          'quantity': initialStock,
        });
      }

      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // Syncs one pending item, auto-retries once, then marks failed.
  Future<void> _syncPendingItem(PendingInventoryItem pending) async {
    var err = await _executeAddProduct(pending.params);
    if (err == null) {
      _removePending(pending.tempId);
      await refresh();
      ref.read(posProvider.notifier).reloadProducts();
      ref
          .read(overviewProvider.notifier)
          .refresh(); // update SKU count on overview
      return;
    }
    // Auto-retry after 4 seconds
    await Future.delayed(const Duration(seconds: 4));
    err = await _executeAddProduct(pending.params);
    if (err == null) {
      _removePending(pending.tempId);
      await refresh();
      ref.read(posProvider.notifier).reloadProducts();
      ref
          .read(overviewProvider.notifier)
          .refresh(); // update SKU count on overview
    } else {
      _updatePending(
        pending.copyWith(status: PendingStatus.failed, error: err),
      );
    }
  }

  // Manual retry from UI.
  Future<void> retryPending(int tempId) async {
    final pending = state.value?.pendingItems
        .where((p) => p.tempId == tempId)
        .firstOrNull;
    if (pending == null) return;
    _updatePending(
      pending.copyWith(status: PendingStatus.syncing, clearError: true),
    );
    await _syncPendingItem(pending);
  }

  Future<String?> updateProduct({
    required int productId,
    required String name,
    required int categoryId,
    required double sellingPrice,
    required double stockQuantity,
    String? brand,
    String? unit,
    double? weight,
    String? barcode,
    double? mrp,
    bool isPerishable = false,
    bool isLoose = false,
  }) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      await Future.wait([
        client.patchOltp(
          'product',
          {
            'name': name,
            'category_id': categoryId,
            'brand': brand,
            'unit': unit,
            'weight': weight,
            'barcode': barcode,
            'is_perishable': isPerishable,
            'is_loose': isLoose,
          },
          filters: {'product_id': productId.toString()},
        ),
        client.patchOltp(
          'pricing',
          {
            'selling_price': sellingPrice,
            'mrp': mrp,
            // Also reset valid_from to "now" (UTC, backdated 1 min) so older
            // pricing rows that were written with a future-dated valid_from
            // become active immediately. Without this, edits keep the row
            // future-dated and the POS layer sees price as 0.
            'valid_from': DateTime.now()
                .toUtc()
                .subtract(const Duration(minutes: 1))
                .toIso8601String(),
          },
          filters: {
            'store_id': storeId.toString(),
            'product_id': productId.toString(),
          },
        ),
        client.patchOltp(
          'inventory',
          {'quantity': stockQuantity},
          filters: {
            'store_id': storeId.toString(),
            'product_id': productId.toString(),
          },
        ),
      ]);
      // Refresh in the background — don't block the UI dismiss. If the device
      // is on a flaky network, awaiting refresh() could hang one of the 5
      // parallel calls indefinitely (http has no default timeout), leaving
      // the "Saving..." spinner stuck forever even though the writes succeeded.
      unawaited(refresh());
      unawaited(ref.read(posProvider.notifier).reloadProducts());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> linkBarcode(int productId, String barcode) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.patchOltp(
        'product',
        {'barcode': barcode},
        filters: {'product_id': productId.toString()},
      );
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
      await client.patchOltp(
        'inventory',
        {'quantity': newQuantity},
        filters: {
          'store_id': storeId.toString(),
          'product_id': productId.toString(),
        },
      );
      await refresh();
      ref.read(posProvider.notifier).reloadProducts();
      return true;
    } catch (_) {
      return false;
    }
  }

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
      await client.postOltp('inventory_batch', {
        'store_id': storeId,
        'product_id': productId,
        'batch_no': 'BATCH-${DateTime.now().millisecondsSinceEpoch}',
        'expiry_date': expiryDate,
        'qty_in_stock': quantity,
      });
      await client.patchOltp(
        'inventory',
        {'quantity': currentStock + quantity},
        filters: {
          'store_id': storeId.toString(),
          'product_id': productId.toString(),
        },
      );
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
      InventoryNotifier.new,
    );
