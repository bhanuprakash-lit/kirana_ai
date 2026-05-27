import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../dashboard/providers/overview_provider.dart';
import '../../providers/finance_provider.dart';

class CashflowTab extends ConsumerWidget {
  const CashflowTab({super.key});

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeProvider);
    final overviewAsync = ref.watch(overviewProvider);

    return financeAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CardShimmer(height: 120),
            SizedBox(height: 12),
            CardShimmer(height: 160),
            SizedBox(height: 12),
            CardShimmer(height: 80),
          ],
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: BrandColors.error),
              const SizedBox(height: 16),
              const Text(
                'Failed to load cashflow data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: BrandColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(financeProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (finance) {
        final stats = finance.stats;
        final todaySales =
            overviewAsync.whenOrNull(data: (d) => d.dailySales?.totalSales) ??
            0.0;
        final creditRatio = stats.monthlySalesAmount > 0
            ? (stats.totalUdhaarPending / stats.monthlySalesAmount * 100)
                .clamp(0.0, 100.0)
            : 0.0;
        final ratioColor = creditRatio < 20
            ? BrandColors.success
            : creditRatio < 40
            ? const Color(0xFFD97706)
            : BrandColors.error;

        return RefreshIndicator(
          onRefresh: () => ref.read(financeProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              // ── Income ──────────────────────────────────────────────────
              _SectionHeader(
                icon: Icons.trending_up_rounded,
                label: 'Income',
                color: BrandColors.success,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: "Today's Sales",
                      value: _fmt(todaySales),
                      icon: Icons.today_rounded,
                      color: BrandColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      label: 'Monthly Sales',
                      value: _fmt(stats.monthlySalesAmount),
                      icon: Icons.calendar_month_rounded,
                      color: BrandColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Credit Exposure ─────────────────────────────────────────
              const _SectionHeader(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Credit Exposure (Udhaar)',
                color: Color(0xFFD97706),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'Outstanding',
                      value: _fmt(stats.totalUdhaarPending),
                      icon: Icons.hourglass_bottom_rounded,
                      color: const Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      label: 'Recovered',
                      value: _fmt(stats.totalUdhaarRecovered),
                      icon: Icons.check_circle_outline_rounded,
                      color: BrandColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _MetricCard(
                label: 'Customers with pending dues',
                value: '${stats.udhaarCustomerCount} customers',
                icon: Icons.people_outline_rounded,
                color: BrandColors.error,
                fullWidth: true,
              ),
              const SizedBox(height: 24),

              // ── Credit vs Sales Ratio ───────────────────────────────────
              _SectionHeader(
                icon: Icons.pie_chart_outline_rounded,
                label: 'Credit vs Sales Ratio',
                color: ratioColor,
              ),
              const SizedBox(height: 10),
              _CreditRatioCard(
                ratio: creditRatio,
                color: ratioColor,
                fmt: _fmt,
                pending: stats.totalUdhaarPending,
                monthly: stats.monthlySalesAmount,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Metric card ───────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: fullWidth ? 15 : 18,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Credit ratio card ─────────────────────────────────────────────────────────

class _CreditRatioCard extends StatelessWidget {
  final double ratio;
  final Color color;
  final String Function(double) fmt;
  final double pending;
  final double monthly;

  const _CreditRatioCard({
    required this.ratio,
    required this.color,
    required this.fmt,
    required this.pending,
    required this.monthly,
  });

  @override
  Widget build(BuildContext context) {
    final label = ratio < 20
        ? 'Healthy — credit exposure is low'
        : ratio < 40
        ? 'Moderate — consider collecting dues'
        : 'High — many sales are on credit';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ratio.toStringAsFixed(1)}% on credit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                'of ${fmt(monthly)} monthly',
                style: const TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio / 100,
              minHeight: 10,
              backgroundColor: BrandColors.border.withValues(alpha: 0.4),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: BrandColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
