import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Compact banner that makes a bundle's pricing transparent: the original
/// (pre-discount) value, the percentage off, the amount saved, and the net
/// price actually charged. Reused in the cart footer, order-confirm sheet and
/// order details so the shopkeeper always sees what the basket discount did.
///
/// [gross] is the normal-price total of the basket items; [savings] is how much
/// the bundle price undercuts that (null when the bundle was added at regular
/// price — e.g. not all items were in stock).
class BasketSavingsBanner extends StatelessWidget {
  final String name;
  final double? gross;
  final double? savings;

  const BasketSavingsBanner({
    super.key,
    required this.name,
    this.gross,
    this.savings,
  });

  static const _color = Color(0xFF0EA5E9); // sky-blue (matches basket cards)

  String _fmt(double v) => '₹${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final g = gross ?? 0;
    final s = savings ?? 0;
    final hasDiscount = s > 0 && g > 0;
    final net = (g - s).clamp(0.0, g);
    final pct = hasDiscount ? (s / g * 100).round() : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_rounded, size: 14, color: _color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _color,
                  ),
                ),
              ),
              if (hasDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.posBundlePercentOff(pct),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (hasDiscount)
            Row(
              children: [
                // Original (struck through)
                Text(
                  _fmt(g),
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: BrandColors.muted,
                ),
                const SizedBox(width: 6),
                // Net charged
                Text(
                  _fmt(net),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.ink,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.posBundleYouSave(_fmt(s)),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: BrandColors.success,
                  ),
                ),
              ],
            )
          else
            Text(
              l10n.posBundleRegularPrice,
              style: const TextStyle(fontSize: 11, color: BrandColors.muted),
            ),
        ],
      ),
    );
  }
}
