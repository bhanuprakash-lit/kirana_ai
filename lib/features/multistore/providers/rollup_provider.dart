import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';

/// Module M2 — multi-store rollup (one row per store + per city/area).
class StoreRow {
  final int storeId;
  final String storeName;
  final String area;
  final int orders;
  final double revenue;
  final double avgBill;

  const StoreRow({
    required this.storeId,
    required this.storeName,
    required this.area,
    required this.orders,
    required this.revenue,
    required this.avgBill,
  });

  factory StoreRow.fromJson(Map<String, dynamic> j) {
    double d(dynamic v) =>
        v == null ? 0 : (v is num ? v.toDouble() : double.tryParse('$v') ?? 0);
    int i(dynamic v) => v == null ? 0 : (v is num ? v.toInt() : 0);
    return StoreRow(
      storeId: i(j['store_id']),
      storeName: (j['store_name'] ?? '').toString(),
      area: (j['area'] ?? '—').toString(),
      orders: i(j['orders']),
      revenue: d(j['revenue']),
      avgBill: d(j['avg_bill']),
    );
  }
}

class AreaRow {
  final String area;
  final int stores;
  final int orders;
  final double revenue;
  const AreaRow({
    required this.area,
    required this.stores,
    required this.orders,
    required this.revenue,
  });

  factory AreaRow.fromJson(Map<String, dynamic> j) {
    double d(dynamic v) =>
        v == null ? 0 : (v is num ? v.toDouble() : double.tryParse('$v') ?? 0);
    int i(dynamic v) => v == null ? 0 : (v is num ? v.toInt() : 0);
    return AreaRow(
      area: (j['area'] ?? '—').toString(),
      stores: i(j['stores']),
      orders: i(j['orders']),
      revenue: d(j['revenue']),
    );
  }
}

class StoreRollup {
  final String? groupName;
  final int storeCount;
  final bool isMultiStore;
  final double totalRevenue;
  final int days;
  final List<StoreRow> byStore;
  final List<AreaRow> byArea;

  const StoreRollup({
    this.groupName,
    required this.storeCount,
    required this.isMultiStore,
    required this.totalRevenue,
    required this.days,
    required this.byStore,
    required this.byArea,
  });

  factory StoreRollup.fromJson(Map<String, dynamic> j) => StoreRollup(
        groupName: j['group_name'] as String?,
        storeCount: (j['store_count'] as num?)?.toInt() ?? 1,
        isMultiStore: j['is_multi_store'] == true,
        totalRevenue: (j['total_revenue'] as num?)?.toDouble() ?? 0,
        days: (j['days'] as num?)?.toInt() ?? 30,
        byStore: ((j['by_store'] as List?) ?? [])
            .whereType<Map>()
            .map((e) => StoreRow.fromJson(e.cast<String, dynamic>()))
            .toList(),
        byArea: ((j['by_area'] as List?) ?? [])
            .whereType<Map>()
            .map((e) => AreaRow.fromJson(e.cast<String, dynamic>()))
            .toList(),
      );

  static const empty = StoreRollup(
    storeCount: 1,
    isMultiStore: false,
    totalRevenue: 0,
    days: 30,
    byStore: [],
    byArea: [],
  );
}

final storeRollupProvider = FutureProvider<StoreRollup>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  try {
    final data = await ref.read(apiClientProvider).get('/kirana/stores/rollup');
    if (data is Map) return StoreRollup.fromJson(data.cast<String, dynamic>());
  } catch (_) {}
  return StoreRollup.empty;
});
