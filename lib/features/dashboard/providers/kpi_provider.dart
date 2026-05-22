import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';

class KpiCard {
  final String slug;
  final String label;
  final String value;
  final String direction; // up / down / stable
  final double? pctChange;

  const KpiCard({
    required this.slug,
    required this.label,
    required this.value,
    required this.direction,
    this.pctChange,
  });

  static const _slugMeta = {
    'daily-revenue': ('Revenue', '₹', false),
    'gross-profit-margin': ('Margin', '%', false),
    'avg-basket-value': ('Avg Order', '₹', false),
    'stockout-rate': ('Stockout', '%', true), // lower is better
    'dead-stock': ('Dead Stock', '', true),
    'repeat-customer-frequency': ('Loyal Customers', '%', false),
  };

  factory KpiCard.fromJson(String slug, Map<String, dynamic> j) {
    final trend = (j['trend'] as Map<String, dynamic>?) ?? {};
    final current = (trend['current_value'] as num?)?.toDouble();
    final dir = trend['direction'] as String? ?? 'stable';
    final pct = (trend['pct_change'] as num?)?.toDouble();

    final meta = _slugMeta[slug];
    final label = meta?.$1 ?? slug;
    final prefix = meta?.$2 ?? '';

    String fmtVal = '—';
    if (current != null) {
      if (prefix == '₹') {
        fmtVal = current >= 1000
            ? '₹${(current / 1000).toStringAsFixed(1)}K'
            : '₹${current.toStringAsFixed(0)}';
      } else if (prefix == '%') {
        fmtVal = '${current.toStringAsFixed(1)}%';
      } else {
        fmtVal = current.toStringAsFixed(0);
      }
    }

    return KpiCard(
      slug: slug,
      label: label,
      value: fmtVal,
      direction: dir,
      pctChange: pct,
    );
  }
}

final kpiCardsProvider = FutureProvider.autoDispose<List<KpiCard>>((ref) async {
  final client = ref.read(apiClientProvider);
  final prefs = await SharedPreferences.getInstance();
  final storeId = prefs.getInt('store_id') ?? 1;

  const slugs = [
    'daily-revenue',
    'gross-profit-margin',
    'avg-basket-value',
    'stockout-rate',
    'dead-stock',
    'repeat-customer-frequency',
  ];

  final results = await Future.wait(
    slugs.map(
      (s) => client
          .get('/kirana/kpis/$s?store_id=$storeId')
          .catchError((_) => <String, dynamic>{}),
    ),
  );

  return List.generate(
    slugs.length,
    (i) => KpiCard.fromJson(slugs[i], results[i] as Map<String, dynamic>),
  );
});
