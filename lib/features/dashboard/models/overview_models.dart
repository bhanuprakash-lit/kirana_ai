class StoreInfo {
  final int storeId;
  final String storeName;
  final String storeType;
  final int footfall;
  final double budget;
  final double dailyBudget;
  final int skuCount;

  const StoreInfo({
    required this.storeId,
    required this.storeName,
    required this.storeType,
    required this.footfall,
    required this.budget,
    required this.dailyBudget,
    required this.skuCount,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> j) => StoreInfo(
    storeId: j['store_id'] as int,
    storeName: j['store_name'] as String,
    storeType: j['store_type'] as String? ?? '',
    footfall: (j['footfall'] as num?)?.toInt() ?? 0,
    budget: (j['budget'] as num?)?.toDouble() ?? 0,
    dailyBudget: (j['daily_budget'] as num?)?.toDouble() ?? 0,
    skuCount: (j['sku_count'] as num?)?.toInt() ?? 0,
  );
}

class RecommendationSummary {
  final int totalSkus;
  final int reorderCandidates;
  final int highRiskSkus;
  final int fastMovingSkus;
  final int profitOpportunities;
  final int deadStockSkus;
  final int customerInsights;
  final int salesInsights;

  const RecommendationSummary({
    required this.totalSkus,
    required this.reorderCandidates,
    required this.highRiskSkus,
    required this.fastMovingSkus,
    required this.profitOpportunities,
    required this.deadStockSkus,
    required this.customerInsights,
    required this.salesInsights,
  });

  factory RecommendationSummary.fromJson(Map<String, dynamic> j) =>
      RecommendationSummary(
        totalSkus: (j['total_skus'] as num?)?.toInt() ?? 0,
        reorderCandidates: (j['reorder_candidates'] as num?)?.toInt() ?? 0,
        highRiskSkus: (j['high_risk_skus'] as num?)?.toInt() ?? 0,
        fastMovingSkus: (j['fast_moving_skus'] as num?)?.toInt() ?? 0,
        profitOpportunities: (j['profit_opportunities'] as num?)?.toInt() ?? 0,
        deadStockSkus: (j['dead_stock_skus'] as num?)?.toInt() ?? 0,
        customerInsights: (j['customer_insights'] as num?)?.toInt() ?? 0,
        salesInsights: (j['sales_insights'] as num?)?.toInt() ?? 0,
      );
}

class DailySales {
  final double totalSales;
  final int totalOrders;
  final double avgOrderValue;
  final String date;

  const DailySales({
    required this.totalSales,
    required this.totalOrders,
    required this.avgOrderValue,
    required this.date,
  });

  factory DailySales.fromJson(Map<String, dynamic> j) {
    double extract(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return DailySales(
      totalSales: extract(
        j['total_sales'] ?? j['total_revenue'] ?? j['revenue'] ?? 0.0,
      ),
      totalOrders:
          ((j['total_orders'] ?? j['order_count'] ?? j['orders'] ?? 0) as num)
              .toInt(),
      avgOrderValue: extract(j['avg_order_value'] ?? j['aov'] ?? 0.0),
      date: j['date'] as String? ?? '',
    );
  }
}

class OverviewData {
  final StoreInfo store;
  final RecommendationSummary recommendations;
  final DailySales? dailySales;

  const OverviewData({
    required this.store,
    required this.recommendations,
    this.dailySales,
  });
}
