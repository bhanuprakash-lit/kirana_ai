import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';

class KpiCard {
  final String slug;
  final String label;
  final String value;
  final String direction; // up / down / stable
  final double? pctChange;
  // % of billed revenue that has cost data behind it (profit-confidence).
  // Only meaningful for gross-profit-margin; null elsewhere.
  final double? coveragePct;
  // The window (in days) the KPI is computed over, surfaced so the home screen
  // can show "Last 30 days" instead of leaving the period ambiguous.
  final int? periodDays;

  const KpiCard({
    required this.slug,
    required this.label,
    required this.value,
    required this.direction,
    this.pctChange,
    this.coveragePct,
    this.periodDays,
  });

  static const _slugMeta = {
    'daily-revenue': ('Revenue', '₹', false),
    'gross-profit-margin': ('Margin', '%', false),
    'avg-basket-value': ('Avg Bill', '₹', false),
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
      coveragePct: (j['cost_coverage_pct'] as num?)?.toDouble(),
      periodDays: (j['period_days'] as num?)?.toInt(),
    );
  }
}

/// F4 — a KPI the store is allowed to see (vertical pack + admin visibility),
/// resolved server-side so admin show/hide changes reflect live, no app update.
class VisibleKpi {
  final String kpiId;
  final String name;
  final String? slug; // endpoint slug, null for coming-soon
  final String status; // 'ok' | 'data_unavailable'
  final String category;
  final String? missingData;

  const VisibleKpi({
    required this.kpiId,
    required this.name,
    required this.slug,
    required this.status,
    required this.category,
    this.missingData,
  });

  bool get isLive => status == 'ok';

  factory VisibleKpi.fromJson(Map<String, dynamic> j) {
    final ep = j['endpoint'] as String?;
    return VisibleKpi(
      kpiId: j['kpi_id'] as String,
      name: j['name'] as String? ?? j['kpi_id'] as String,
      slug: ep?.split('/').last,
      status: j['status'] as String? ?? 'data_unavailable',
      category: j['category'] as String? ?? 'Operations',
      missingData: j['missing_data'] as String?,
    );
  }
}

/// The KPIs this store should show, per its vertical + admin visibility config.
final visibleKpisProvider = FutureProvider.autoDispose<List<VisibleKpi>>((ref) async {
  final client = ref.read(apiClientProvider);
  final data = await client.get('/kirana/kpis/visible');
  final list = (data is Map ? data['kpis'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => VisibleKpi.fromJson(e.cast<String, dynamic>()))
      .toList();
});

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
