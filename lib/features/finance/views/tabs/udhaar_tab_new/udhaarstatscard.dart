part of '../udhaar_tab_new.dart';

class _UdhaarStatsCard extends StatelessWidget {
  final FinanceStats stats;

  const _UdhaarStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MiniStat(
            label: l10n.finTotalPending,
            value: '₹${stats.totalUdhaarPending.toStringAsFixed(0)}',
            color: BrandColors.error,
          ),

          _MiniStat(
            label: l10n.finRecovered,
            value: '₹${stats.totalUdhaarRecovered.toStringAsFixed(0)}',
            color: BrandColors.success,
          ),

          _MiniStat(
            label: l10n.finCustomers,
            value: '${stats.udhaarCustomerCount}',
            color: BrandColors.primary,
          ),
        ],
      ),
    );
  }
}
