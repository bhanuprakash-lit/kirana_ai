import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';

/// One GST rate slab in the period report.
class GstSlab {
  final double rate;
  final double taxable;
  final double cgst;
  final double sgst;
  final double totalTax;
  final int lineCount;
  const GstSlab({
    required this.rate,
    required this.taxable,
    required this.cgst,
    required this.sgst,
    required this.totalTax,
    required this.lineCount,
  });
  factory GstSlab.fromJson(Map<String, dynamic> j) => GstSlab(
    rate: (j['rate'] as num?)?.toDouble() ?? 0,
    taxable: (j['taxable'] as num?)?.toDouble() ?? 0,
    cgst: (j['cgst'] as num?)?.toDouble() ?? 0,
    sgst: (j['sgst'] as num?)?.toDouble() ?? 0,
    totalTax: (j['total_tax'] as num?)?.toDouble() ?? 0,
    lineCount: (j['line_count'] as num?)?.toInt() ?? 0,
  );
}

/// Filing-grade GST summary for a period.
class GstSummary {
  final String dateFrom;
  final String dateTo;
  final double grossSales;
  final double taxableSales;
  final double totalTax;
  final double cgst;
  final double sgst;
  final int taxableOrders;
  final int totalOrders;
  final List<GstSlab> byRate;
  const GstSummary({
    required this.dateFrom,
    required this.dateTo,
    required this.grossSales,
    required this.taxableSales,
    required this.totalTax,
    required this.cgst,
    required this.sgst,
    required this.taxableOrders,
    required this.totalOrders,
    required this.byRate,
  });
  factory GstSummary.fromJson(Map<String, dynamic> j) => GstSummary(
    dateFrom: (j['date_from'] ?? '').toString(),
    dateTo: (j['date_to'] ?? '').toString(),
    grossSales: (j['gross_sales'] as num?)?.toDouble() ?? 0,
    taxableSales: (j['taxable_sales'] as num?)?.toDouble() ?? 0,
    totalTax: (j['total_tax'] as num?)?.toDouble() ?? 0,
    cgst: (j['cgst'] as num?)?.toDouble() ?? 0,
    sgst: (j['sgst'] as num?)?.toDouble() ?? 0,
    taxableOrders: (j['taxable_orders'] as num?)?.toInt() ?? 0,
    totalOrders: (j['total_orders'] as num?)?.toInt() ?? 0,
    byRate: ((j['by_rate'] as List<dynamic>?) ?? [])
        .whereType<Map>()
        .map((e) => GstSlab.fromJson(e.cast<String, dynamic>()))
        .toList(),
  );
}

/// GST summary for a period. Family key is "yyyy-mm-dd|yyyy-mm-dd".
final gstSummaryProvider = FutureProvider.family
    .autoDispose<GstSummary, String>((ref, range) async {
      ref.watch(storeScopeProvider); // refetch when the active store changes
      final parts = range.split('|');
      final from = parts[0];
      final to = parts.length > 1 ? parts[1] : parts[0];
      final data = await ref
          .read(apiClientProvider)
          .get('/kirana/tax/gst-summary?date_from=$from&date_to=$to');
      return GstSummary.fromJson((data as Map).cast<String, dynamic>());
    });
