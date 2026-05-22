import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/dashboard/models/overview_models.dart';

void main() {
  group('StoreInfo.fromJson', () {
    test('parses required fields and defaults the rest', () {
      final store = StoreInfo.fromJson({
        'store_id': 10,
        'store_name': 'Lakshmi Stores',
      });
      expect(store.storeId, 10);
      expect(store.storeName, 'Lakshmi Stores');
      expect(store.storeType, '');
      expect(store.footfall, 0);
      expect(store.budget, 0);
      expect(store.dailyBudget, 0);
      expect(store.skuCount, 0);
    });

    test('parses numeric fields as int/double regardless of incoming type', () {
      final store = StoreInfo.fromJson({
        'store_id': 1,
        'store_name': 'X',
        'footfall': 40,
        'budget': 50000.5,
        'daily_budget': 1666,
        'sku_count': 250,
      });
      expect(store.footfall, 40);
      expect(store.budget, 50000.5);
      expect(store.dailyBudget, 1666.0);
      expect(store.skuCount, 250);
    });
  });

  group('RecommendationSummary.fromJson', () {
    test('defaults all counts to zero when missing', () {
      final s = RecommendationSummary.fromJson({});
      expect(s.totalSkus, 0);
      expect(s.reorderCandidates, 0);
      expect(s.highRiskSkus, 0);
      expect(s.fastMovingSkus, 0);
      expect(s.profitOpportunities, 0);
      expect(s.deadStockSkus, 0);
      expect(s.customerInsights, 0);
      expect(s.salesInsights, 0);
    });

    test('reads counts from a complete payload', () {
      final s = RecommendationSummary.fromJson({
        'total_skus': 200,
        'reorder_candidates': 12,
        'high_risk_skus': 4,
        'fast_moving_skus': 30,
        'profit_opportunities': 8,
        'dead_stock_skus': 5,
        'customer_insights': 2,
        'sales_insights': 3,
      });
      expect(s.totalSkus, 200);
      expect(s.reorderCandidates, 12);
      expect(s.highRiskSkus, 4);
    });
  });

  group('DailySales.fromJson', () {
    test('reads total_sales and total_orders', () {
      final s = DailySales.fromJson({
        'total_sales': 4500.50,
        'total_orders': 23,
        'avg_order_value': 195.67,
        'date': '2026-05-22',
      });
      expect(s.totalSales, 4500.50);
      expect(s.totalOrders, 23);
      expect(s.avgOrderValue, closeTo(195.67, 0.001));
      expect(s.date, '2026-05-22');
    });

    test('falls back to total_revenue / revenue / order_count aliases', () {
      final s = DailySales.fromJson({
        'total_revenue': 1000,
        'order_count': 5,
        'aov': 200,
      });
      expect(s.totalSales, 1000.0);
      expect(s.totalOrders, 5);
      expect(s.avgOrderValue, 200.0);
    });

    test('parses numeric strings (Postgres NUMERIC quirk)', () {
      final s = DailySales.fromJson({
        'total_sales': '1234.50',
        'total_orders': 3,
      });
      expect(s.totalSales, 1234.50);
    });

    test('handles missing fields gracefully', () {
      final s = DailySales.fromJson({});
      expect(s.totalSales, 0.0);
      expect(s.totalOrders, 0);
      expect(s.avgOrderValue, 0.0);
      expect(s.date, '');
    });
  });
}
