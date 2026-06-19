part of '../udhaar_tab_new.dart';

class _DebtRow extends StatelessWidget {
  final UdhaarItem item;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _DebtRow({required this.item, required this.onTap, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final settled = item.isRecovered;
    return Opacity(
      opacity: settled ? 0.55 : 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (settled ? BrandColors.success : BrandColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  settled ? Icons.check_rounded : Icons.receipt_long_outlined,
                  size: 17,
                  color: settled ? BrandColors.success : BrandColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${item.originalAmount.toStringAsFixed(0)} · ${_formatUdhaarDate(item.dateTaken)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: BrandColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      settled
                          ? l10n.finSettled
                          : l10n.finBalanceLabel(
                              item.balance.toStringAsFixed(0),
                            ),
                      style: TextStyle(
                        fontSize: 11,
                        color: settled
                            ? BrandColors.success
                            : BrandColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!settled && item.effectiveDueDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.finDueBy(
                          _formatUdhaarDate(item.effectiveDueDate!),
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFD97706),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: BrandColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

