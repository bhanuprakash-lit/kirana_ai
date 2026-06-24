part of '../baskets_screen_new.dart';

class _TierPreview extends StatelessWidget {
  final double grossTotal;
  final BasketTierConfig config;
  const _TierPreview({required this.grossTotal, required this.config});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (grossTotal <= 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: BrandColors.muted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.mktAddItemsForPrice,
                style: const TextStyle(fontSize: 13, color: BrandColors.muted),
              ),
            ),
          ],
        ),
      );
    }
    final tier = config.tierFor(grossTotal);
    final finalPrice = config.priceFor(grossTotal);
    final savings = grossTotal - finalPrice;
    final style = TierStyle.of(tier.name);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: style.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(style.icon, size: 18, color: style.color),
              const SizedBox(width: 8),
              Text(
                l10n.mktTierBasketLabel(tierLabel(l10n, tier.name)),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: style.color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.mktPctOff(tier.discountPct.toStringAsFixed(0)),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: style.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _priceCol(
                l10n.mktItemsTotal,
                '₹${grossTotal.toStringAsFixed(0)}',
                BrandColors.muted,
                false,
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: BrandColors.muted,
              ),
              _priceCol(
                l10n.mktBundlePrice,
                '₹${finalPrice.toStringAsFixed(0)}',
                BrandColors.primary,
                true,
              ),
              const Spacer(),
              if (savings > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.mktSaveAmount(savings.toStringAsFixed(0)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: BrandColors.success,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceCol(String label, String value, Color color, bool bold) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: BrandColors.muted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
