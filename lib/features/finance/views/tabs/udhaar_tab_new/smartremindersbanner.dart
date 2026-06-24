part of '../udhaar_tab_new.dart';

class _SmartRemindersBanner extends StatelessWidget {
  final int highRisk;
  final VoidCallback onTap;

  const _SmartRemindersBanner({required this.highRisk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final urgent = highRisk > 0;
    final color = urgent ? BrandColors.error : BrandColors.primary;
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.bolt_rounded, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  urgent
                      ? l10n.finHighRiskDues(highRisk)
                      : l10n.finSmartRemindersSubtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
