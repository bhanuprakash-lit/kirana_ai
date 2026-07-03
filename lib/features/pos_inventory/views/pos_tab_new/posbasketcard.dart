part of '../pos_tab_new.dart';

class _PosBasketCard extends StatelessWidget {
  static const _color = Color(
    0xFF0EA5E9,
  ); // sky-blue distinguishes user baskets from AI

  final Basket basket;
  final List<PosProduct> posProducts;
  final VoidCallback onAddToCart;

  const _PosBasketCard({
    required this.basket,
    required this.posProducts,
    required this.onAddToCart,
  });

  int get _inStockCount => basket.items
      .where(
        (i) => posProducts.any(
          (p) => p.productId == i.productId && p.stockQuantity > 0,
        ),
      )
      .length;

  @override
  Widget build(BuildContext context) {
    final inStock = _inStockCount;
    final total = basket.items.length;
    final allReady = inStock == total;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _BasketDetailSheet(
          basket: basket,
          posProducts: posProducts,
          onAddToCart: onAddToCart,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basket.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _color,
                          ),
                        ),
                        if (basket.description != null)
                          Text(
                            basket.description!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: BrandColors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            '${basket.items.length} items in bundle',
                            style: const TextStyle(
                              fontSize: 11,
                              color: BrandColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // In-stock pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: allReady
                          ? Colors.green.withValues(alpha: 0.12)
                          : Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$inStock/$total',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: allReady
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Item chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: basket.items.take(5).map((item) {
                  final matched = posProducts
                      .where((p) => p.productId == item.productId)
                      .firstOrNull;
                  final inStockItem =
                      matched != null && matched.stockQuantity > 0;
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: inStockItem
                            ? _color.withValues(alpha: 0.08)
                            : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: inStockItem
                              ? _color.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            inStockItem
                                ? Icons.check_circle_rounded
                                : Icons.remove_circle_outline_rounded,
                            size: 10,
                            color: inStockItem ? _color : BrandColors.muted,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${item.productName ?? 'Item'} × ${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: inStockItem ? _color : BrandColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (basket.price != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${basket.price!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _color,
                          ),
                        ),
                        const Text(
                          'bundle price',
                          style: TextStyle(
                            fontSize: 11,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: ElevatedButton.icon(
                      onPressed: inStock == 0 ? null : onAddToCart,
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 16,
                      ),
                      label: Text(
                        AppLocalizations.of(context).posCommonAddToCart,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
