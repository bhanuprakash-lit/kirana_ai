import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';

/// product_id → ML flags (fast_moving / reorder_now / dead_stock /
/// stockout_risk / profit_opportunity), from the same ML frame that powers the
/// Intelligence counts — so item tags stay consistent with those numbers.
final inventoryFlagsProvider = FutureProvider<Map<int, List<String>>>((
  ref,
) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final client = ref.read(apiClientProvider);
  try {
    final res = await client.get('/kirana/inventory/flags');
    final raw = (res['flags'] as Map<String, dynamic>?) ?? const {};
    return raw.map(
      (k, v) => MapEntry(int.parse(k), (v as List).cast<String>()),
    );
  } catch (_) {
    return <int, List<String>>{};
  }
});
