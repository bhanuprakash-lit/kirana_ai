import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/rollup_provider.dart';

class StoreComparisonScreen extends ConsumerWidget {
  const StoreComparisonScreen({super.key});

  String _money(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(storeRollupProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: const Text('Store Comparison')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (r) {
          if (!r.isMultiStore) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'This report compares multiple outlets.\nAsk support to link your stores into one group.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BrandColors.muted),
                ),
              ),
            );
          }
          final maxRev = r.byStore.isEmpty
              ? 1.0
              : r.byStore.map((s) => s.revenue).reduce((a, b) => a > b ? a : b);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _summary(r),
              const SizedBox(height: 20),
              const _SectionTitle('By store'),
              const SizedBox(height: 8),
              ...r.byStore.asMap().entries.map(
                (e) => _storeBar(e.key, e.value, maxRev),
              ),
              const SizedBox(height: 20),
              const _SectionTitle('By city / area'),
              const SizedBox(height: 8),
              ...r.byArea.map(_areaTile),
            ],
          );
        },
      ),
    );
  }

  Widget _summary(StoreRollup r) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: BrandColors.primary.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: BrandColors.primary.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                r.groupName ?? 'My Stores',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                '${r.storeCount} outlets · last ${r.days} days',
                style: const TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _money(r.totalRevenue),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: BrandColors.primary,
              ),
            ),
            const Text(
              'total revenue',
              style: TextStyle(fontSize: 11, color: BrandColors.muted),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _storeBar(int rank, StoreRow s, double maxRev) {
    final frac = maxRev > 0 ? (s.revenue / maxRev).clamp(0.02, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${rank + 1}. ${s.storeName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                _money(s.revenue),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: BrandColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: frac.toDouble(),
              minHeight: 8,
              backgroundColor: BrandColors.surfaceTint,
              valueColor: const AlwaysStoppedAnimation<Color>(
                BrandColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${s.area} · ${s.orders} orders · avg ${_money(s.avgBill)}',
            style: const TextStyle(fontSize: 11, color: BrandColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _areaTile(AreaRow a) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BrandColors.border),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            a.area,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          '${a.stores} stores · ${a.orders} orders   ',
          style: const TextStyle(fontSize: 11, color: BrandColors.muted),
        ),
        Text(
          _money(a.revenue),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: BrandColors.success,
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 14,
      color: BrandColors.ink,
    ),
  );
}
