part of '../pos_tab_new.dart';

class _BasketDetailSheet extends StatelessWidget {
  static const _color = Color(0xFF0EA5E9);

  final Basket basket;
  final List<PosProduct> posProducts;
  final VoidCallback onAddToCart;

  const _BasketDetailSheet({
    required this.basket,
    required this.posProducts,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basket.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _color,
                          ),
                        ),
                        if (basket.description != null)
                          Text(
                            basket.description!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: BrandColors.muted,
                            ),
                          ),
                        if (basket.validTo != null)
                          Text(
                            'Valid until ${basket.validTo}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: basket.items.length,
                itemBuilder: (_, i) {
                  final item = basket.items[i];
                  final matched = posProducts
                      .where((p) => p.productId == item.productId)
                      .firstOrNull;
                  final inStk = matched != null && matched.stockQuantity > 0;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: inStk
                            ? _color.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        inStk ? Icons.check_rounded : Icons.close_rounded,
                        color: inStk ? _color : BrandColors.muted,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.productName ?? 'Item',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: inStk ? BrandColors.ink : BrandColors.muted,
                      ),
                    ),
                    subtitle: inStk
                        ? Text(
                            'Stock: ${matched.stockQuantity.toStringAsFixed(0)} ${matched.unit ?? 'pcs'}  ·  ₹${matched.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12),
                          )
                        : const Text(
                            'Not in stock',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                    trailing: Text(
                      '× ${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _color,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                children: [
                  if (basket.price != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bundle Price',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${basket.price!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _color,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          basket.items.every(
                            (i) => !posProducts.any(
                              (p) =>
                                  p.productId == i.productId &&
                                  p.stockQuantity > 0,
                            ),
                          )
                          ? null
                          : () {
                              Navigator.pop(context);
                              onAddToCart();
                            },
                      icon: const Icon(Icons.add_shopping_cart_rounded),
                      label: Text(
                        AppLocalizations.of(context).posAddAvailableToCart,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
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
