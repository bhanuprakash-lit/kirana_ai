part of '../baskets_screen_new.dart';

class _PriceBlock extends StatelessWidget {
  final Basket basket;
  const _PriceBlock({required this.basket});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = basket.savings != null && basket.grossTotal != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasDiscount)
          Text(
            '₹${basket.grossTotal!.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              color: BrandColors.muted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: BrandColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '₹${basket.price!.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: BrandColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
