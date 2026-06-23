part of '../udhaar_tab_new.dart';

class _ExpandedBody extends StatelessWidget {
  final _CustomerUdhaar group;
  final VoidCallback onRecover;
  final Future<void> Function() onRemind;
  final void Function(UdhaarItem) onOpenHistory;

  const _ExpandedBody({
    required this.group,
    required this.onRecover,
    required this.onRemind,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Summary strip: Taken / Paid / Balance.
          Row(
            children: [
              _SummaryCell(
                label: l10n.finTaken,
                value: '₹${group.totalTaken.toStringAsFixed(0)}',
                color: BrandColors.ink,
              ),
              _SummaryCell(
                label: l10n.finPaid,
                value: '₹${group.totalPaid.toStringAsFixed(0)}',
                color: BrandColors.success,
              ),
              _SummaryCell(
                label: l10n.finBalanceShort,
                value: '₹${group.totalBalance.toStringAsFixed(0)}',
                color: BrandColors.error,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action row.
          Row(
            children: [
              if (group.remindedToday)
                TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: Text(l10n.finRemindedToday),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.muted,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: onRemind,
                  icon: const Icon(Icons.message_rounded, size: 18),
                  label: Text(l10n.finRemind),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.success,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: onRecover,
                icon: const Icon(Icons.payments_rounded, size: 18),
                label: Text(l10n.finRecordPayment),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Per-debt history list.
          ...group.entriesNewestFirst.map(
            (e) => _DebtRow(item: e, onTap: () => onOpenHistory(e), l10n: l10n),
          ),
        ],
      ),
    );
  }
}

