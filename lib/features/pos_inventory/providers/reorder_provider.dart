import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';

/// A velocity-based reorder suggestion for a low-stock product.
class ReorderSuggestion {
  final int productId;
  final String productName;
  final String? unit;
  final int stock;
  final double avgDaily;
  final double? daysOfCover;
  final int suggestedQty;
  final int? supplierId;
  final String? supplierName;
  final double costPrice;
  final int leadTimeDays;
  final double reorderCost;

  const ReorderSuggestion({
    required this.productId,
    required this.productName,
    this.unit,
    required this.stock,
    required this.avgDaily,
    this.daysOfCover,
    required this.suggestedQty,
    this.supplierId,
    this.supplierName,
    required this.costPrice,
    required this.leadTimeDays,
    required this.reorderCost,
  });

  factory ReorderSuggestion.fromJson(Map<String, dynamic> j) =>
      ReorderSuggestion(
        productId: (j['product_id'] as num).toInt(),
        productName: j['product_name'] as String? ?? 'Item',
        unit: j['unit'] as String?,
        stock: (j['stock'] as num?)?.toInt() ?? 0,
        avgDaily: (j['avg_daily'] as num?)?.toDouble() ?? 0,
        daysOfCover: (j['days_of_cover'] as num?)?.toDouble(),
        suggestedQty: (j['suggested_qty'] as num?)?.toInt() ?? 0,
        supplierId: (j['supplier_id'] as num?)?.toInt(),
        supplierName: j['supplier_name'] as String?,
        costPrice: (j['cost_price'] as num?)?.toDouble() ?? 0,
        leadTimeDays: (j['lead_time_days'] as num?)?.toInt() ?? 0,
        reorderCost: (j['reorder_cost'] as num?)?.toDouble() ?? 0,
      );
}

class ReorderNotifier extends AsyncNotifier<List<ReorderSuggestion>> {
  @override
  Future<List<ReorderSuggestion>> build() {
    ref.watch(storeScopeProvider); // rebuild when the active store changes
    return _fetch();
  }

  Future<List<ReorderSuggestion>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/kirana/inventory/reorder-suggestions');
    final list = (res['suggestions'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(ReorderSuggestion.fromJson).toList();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }
}

final reorderProvider =
    AsyncNotifierProvider<ReorderNotifier, List<ReorderSuggestion>>(
      ReorderNotifier.new,
    );

/// Count of reorder suggestions for badges (0 while loading/error).
final reorderCountProvider = Provider<int>((ref) {
  return ref
      .watch(reorderProvider)
      .maybeWhen(data: (s) => s.length, orElse: () => 0);
});
