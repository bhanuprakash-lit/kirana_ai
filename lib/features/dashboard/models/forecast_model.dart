class ForecastHorizon {
  final String label;
  final double predictedUnits;
  final double revenue;
  final double revenueLow;
  final double revenueHigh;

  const ForecastHorizon({
    required this.label,
    required this.predictedUnits,
    required this.revenue,
    required this.revenueLow,
    required this.revenueHigh,
  });

  factory ForecastHorizon.fromJson(Map<String, dynamic> j) => ForecastHorizon(
    label: j['label'] as String? ?? '',
    predictedUnits: (j['predicted_units'] as num?)?.toDouble() ?? 0,
    revenue: (j['revenue'] as num?)?.toDouble() ?? 0,
    revenueLow: (j['revenue_low'] as num?)?.toDouble() ?? 0,
    revenueHigh: (j['revenue_high'] as num?)?.toDouble() ?? 0,
  );
}

class ForecastSummary {
  final int storeId;
  final Map<String, ForecastHorizon> horizons;
  final bool dataStale;

  const ForecastSummary({
    required this.storeId,
    required this.horizons,
    required this.dataStale,
  });

  ForecastHorizon? get tomorrow => horizons['1d'];
  ForecastHorizon? get threeDays => horizons['3d'];
  ForecastHorizon? get sevenDays => horizons['7d'];

  factory ForecastSummary.fromJson(Map<String, dynamic> j) {
    final raw = j['horizons'] as Map<String, dynamic>? ?? {};
    return ForecastSummary(
      storeId: j['store_id'] as int? ?? 0,
      horizons: raw.map(
        (k, v) =>
            MapEntry(k, ForecastHorizon.fromJson(v as Map<String, dynamic>)),
      ),
      dataStale: j['data_stale'] as bool? ?? false,
    );
  }
}

class ForecastItem {
  final int productId;
  final String productName;
  final String categoryName;
  final double avgDailyDemand;
  final double avgPrice;
  final int currentStock;
  final double daysOfSupply;
  final double stockoutRiskPct;
  final bool willOosInWindow;
  final bool isFastMoving;
  final bool needsReorder;
  final double predictedUnits;
  final double predictedUnitsLow;
  final double predictedUnitsHigh;
  final double predictedRevenue;
  final double revenueLow;
  final double revenueHigh;

  const ForecastItem({
    required this.productId,
    required this.productName,
    required this.categoryName,
    required this.avgDailyDemand,
    required this.avgPrice,
    required this.currentStock,
    required this.daysOfSupply,
    required this.stockoutRiskPct,
    required this.willOosInWindow,
    required this.isFastMoving,
    required this.needsReorder,
    required this.predictedUnits,
    required this.predictedUnitsLow,
    required this.predictedUnitsHigh,
    required this.predictedRevenue,
    required this.revenueLow,
    required this.revenueHigh,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> j) => ForecastItem(
    productId: j['product_id'] as int? ?? 0,
    productName: j['product_name'] as String? ?? '',
    categoryName: j['category_name'] as String? ?? '',
    avgDailyDemand: (j['avg_daily_demand'] as num?)?.toDouble() ?? 0,
    avgPrice: (j['avg_price'] as num?)?.toDouble() ?? 0,
    currentStock: (j['current_stock'] as num?)?.toInt() ?? 0,
    daysOfSupply: (j['days_of_supply'] as num?)?.toDouble() ?? 0,
    stockoutRiskPct: (j['stockout_risk_pct'] as num?)?.toDouble() ?? 0,
    willOosInWindow: j['will_oos_in_window'] as bool? ?? false,
    isFastMoving: j['is_fast_moving'] as bool? ?? false,
    needsReorder: j['needs_reorder'] as bool? ?? false,
    predictedUnits: (j['predicted_units'] as num?)?.toDouble() ?? 0,
    predictedUnitsLow: (j['predicted_units_low'] as num?)?.toDouble() ?? 0,
    predictedUnitsHigh: (j['predicted_units_high'] as num?)?.toDouble() ?? 0,
    predictedRevenue: (j['predicted_revenue'] as num?)?.toDouble() ?? 0,
    revenueLow: (j['revenue_low'] as num?)?.toDouble() ?? 0,
    revenueHigh: (j['revenue_high'] as num?)?.toDouble() ?? 0,
  );
}

class ForecastItemsPage {
  final int horizonDays;
  final String horizonLabel;
  final int totalItems;
  final double totalPredictedUnits;
  final double totalPredictedRevenue;
  final int itemsAtOosRisk;
  final List<ForecastItem> items;

  const ForecastItemsPage({
    required this.horizonDays,
    required this.horizonLabel,
    required this.totalItems,
    required this.totalPredictedUnits,
    required this.totalPredictedRevenue,
    required this.itemsAtOosRisk,
    required this.items,
  });

  factory ForecastItemsPage.fromJson(Map<String, dynamic> j) =>
      ForecastItemsPage(
        horizonDays: j['horizon_days'] as int? ?? 1,
        horizonLabel: j['horizon_label'] as String? ?? '',
        totalItems: j['total_items'] as int? ?? 0,
        totalPredictedUnits:
            (j['total_predicted_units'] as num?)?.toDouble() ?? 0,
        totalPredictedRevenue:
            (j['total_predicted_revenue'] as num?)?.toDouble() ?? 0,
        itemsAtOosRisk: j['items_at_oos_risk'] as int? ?? 0,
        items: (j['items'] as List? ?? [])
            .map((e) => ForecastItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
