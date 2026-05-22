class Recommendation {
  final int skuId;
  final String productName;
  final String categoryName;
  final String type;
  final String priority;
  final double? stockoutProbability;
  final double? reorderQty;
  final double? forecastDemand;
  final double? currentStock;
  final double? daysToStockout;
  final double? currentPrice;
  final double? expectedProfitImpact;
  final String message;

  const Recommendation({
    required this.skuId,
    required this.productName,
    required this.categoryName,
    required this.type,
    required this.priority,
    this.stockoutProbability,
    this.reorderQty,
    this.forecastDemand,
    this.currentStock,
    this.daysToStockout,
    this.currentPrice,
    this.expectedProfitImpact,
    required this.message,
  });

  factory Recommendation.fromJson(Map<String, dynamic> j) => Recommendation(
    skuId: j['sku_id'] as int,
    productName: j['product_name'] as String? ?? '',
    categoryName: j['category_name'] as String? ?? '',
    type: j['recommendation_type'] as String,
    priority: j['priority'] as String? ?? 'medium',
    stockoutProbability: (j['stockout_probability'] as num?)?.toDouble(),
    reorderQty: (j['reorder_qty'] as num?)?.toDouble(),
    forecastDemand: (j['forecast_demand'] as num?)?.toDouble(),
    currentStock: (j['current_stock'] as num?)?.toDouble(),
    daysToStockout: (j['days_to_stockout'] as num?)?.toDouble(),
    currentPrice: (j['current_price'] as num?)?.toDouble(),
    expectedProfitImpact: (j['expected_profit_impact'] as num?)?.toDouble(),
    message: j['message'] as String? ?? '',
  );
}
