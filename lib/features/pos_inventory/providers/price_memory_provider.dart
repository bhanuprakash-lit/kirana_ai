import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import 'inventory_provider.dart';
import 'pos_provider.dart';

/// A product with no active selling price, plus a suggested price.
class MissingPrice {
  final int productId;
  final String productName;
  final String? unit;
  final int stock;
  final double? suggestedPrice;
  final String? suggestionSource; // "your last price" | "MRP" | null
  final double? mrp;

  const MissingPrice({
    required this.productId,
    required this.productName,
    this.unit,
    required this.stock,
    this.suggestedPrice,
    this.suggestionSource,
    this.mrp,
  });

  factory MissingPrice.fromJson(Map<String, dynamic> j) => MissingPrice(
    productId: (j['product_id'] as num).toInt(),
    productName: j['product_name'] as String? ?? 'Item',
    unit: j['unit'] as String?,
    stock: (j['stock'] as num?)?.toInt() ?? 0,
    suggestedPrice: (j['suggested_price'] as num?)?.toDouble(),
    suggestionSource: j['suggestion_source'] as String?,
    mrp: (j['mrp'] as num?)?.toDouble(),
  );
}

class PriceMemoryNotifier extends AsyncNotifier<List<MissingPrice>> {
  @override
  Future<List<MissingPrice>> build() => _fetch();

  Future<List<MissingPrice>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/kirana/inventory/missing-prices');
    final list = (res['products'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(MissingPrice.fromJson).toList();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }

  Future<bool> applyPrice(int productId, double price, {double? mrp}) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/inventory/price', {
        'product_id': productId,
        'price': price,
        'mrp': ?mrp,
      });
      // Price changed — refresh inventory + POS catalog.
      ref.invalidate(inventoryProvider);
      ref.read(posProvider.notifier).reloadProducts();
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final priceMemoryProvider =
    AsyncNotifierProvider<PriceMemoryNotifier, List<MissingPrice>>(
      PriceMemoryNotifier.new,
    );

/// Count of products missing a price (for the inventory-tab banner).
final missingPriceCountProvider = Provider<int>((ref) {
  return ref
      .watch(priceMemoryProvider)
      .maybeWhen(data: (list) => list.length, orElse: () => 0);
});
