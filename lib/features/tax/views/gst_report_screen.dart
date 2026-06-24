import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/gst_provider.dart';

/// F3 — GST summary report (GSTR-style). Pick a month; see taxable sales, CGST,
/// SGST and a per-rate slab breakup the shopkeeper can hand to their accountant.
class GstReportScreen extends ConsumerStatefulWidget {
  const GstReportScreen({super.key});

  @override
  ConsumerState<GstReportScreen> createState() => _GstReportScreenState();
}

class _GstReportScreenState extends ConsumerState<GstReportScreen> {
  late DateTime _month; // first day of the selected month

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month, 1);
  }

  String _d(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String get _rangeKey {
    final from = _month;
    final to = DateTime(_month.year, _month.month + 1, 0); // last day of month
    return '${_d(from)}|${_d(to)}';
  }

  String _monthLabel(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[d.month - 1]} ${d.year}';
  }

  String _money(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(gstSummaryProvider(_rangeKey));
    final now = DateTime.now();
    final atCurrentMonth = _month.year == now.year && _month.month == now.month;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: const Text('GST Report')),
      body: Column(
        children: [
          // ── Month selector ─────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BrandColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () => setState(
                    () => _month = DateTime(_month.year, _month.month - 1, 1),
                  ),
                ),
                Text(
                  _monthLabel(_month),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: atCurrentMonth
                      ? null
                      : () => setState(
                          () => _month = DateTime(
                            _month.year,
                            _month.month + 1,
                            1,
                          ),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: summary.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not load report\n$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: BrandColors.muted),
                  ),
                ),
              ),
              data: (s) => _report(s),
            ),
          ),
        ],
      ),
    );
  }

  Widget _report(GstSummary s) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        // ── Headline cards ───────────────────────────────────────────────
        Row(
          children: [
            _stat('Taxable sales', _money(s.taxableSales)),
            const SizedBox(width: 12),
            _stat('Total GST', _money(s.totalTax)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _stat('CGST', _money(s.cgst)),
            const SizedBox(width: 12),
            _stat('SGST', _money(s.sgst)),
          ],
        ),
        const SizedBox(height: 20),

        // ── Per-rate slab table ─────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'By GST rate',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ),
              const _SlabHeader(),
              if (s.byRate.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No taxable sales this month',
                    style: TextStyle(color: BrandColors.muted),
                  ),
                )
              else
                ...s.byRate.map((r) => _slabRow(r)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Gross sales ${_money(s.grossSales)} · ${s.taxableOrders}/${s.totalOrders} bills carried GST. '
          'GST is inclusive in retail prices; CGST/SGST assume intra-state supply.',
          style: const TextStyle(fontSize: 12, color: BrandColors.muted),
        ),
      ],
    );
  }

  Widget _stat(String label, String value) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: BrandColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _slabRow(GstSlab r) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '${r.rate.toStringAsFixed(r.rate % 1 == 0 ? 0 : 1)}%',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(_money(r.taxable), textAlign: TextAlign.right),
        ),
        Expanded(
          flex: 3,
          child: Text(_money(r.cgst), textAlign: TextAlign.right),
        ),
        Expanded(
          flex: 3,
          child: Text(_money(r.sgst), textAlign: TextAlign.right),
        ),
      ],
    ),
  );
}

class _SlabHeader extends StatelessWidget {
  const _SlabHeader();
  @override
  Widget build(BuildContext context) {
    const st = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: BrandColors.muted,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: BrandColors.surfaceTint,
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Rate', style: st)),
          Expanded(
            flex: 3,
            child: Text('Taxable', style: st, textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 3,
            child: Text('CGST', style: st, textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 3,
            child: Text('SGST', style: st, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
