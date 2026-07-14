part of '../pos_tab_new.dart';

class _CartTile extends ConsumerWidget {
  final dynamic item; // CartItem
  final Function(dynamic) onEditLoose;
  const _CartTile({required this.item, required this.onEditLoose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = item.product as PosProduct;

    // Customer-specific pricing: badge the line when its override matches the
    // selected customer's remembered price.
    final posState = ref.watch(posProvider);
    final hasCustomer = posState.selectedCustomerId != null;
    final cp = posState.customerPriceFor(p.productId);
    final override = item.unitPriceOverride as double?;
    final isCustomerPriced =
        override != null && cp != null && (override - cp.price).abs() < 0.01;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: p.imageUrl != null
                ? Image.network(
                    p.imageUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => _posIconBox(40),
                  )
                : _posIconBox(40),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((item.variantLabel as String?)?.isNotEmpty ?? false)
                  Text(
                    item.variantLabel as String,
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (isCustomerPriced)
                  GestureDetector(
                    onTap: hasCustomer
                        ? () => _showSetCustomerPriceSheet(
                            context,
                            ref,
                            p,
                            override,
                          )
                        : () => _showEditLinePriceSheet(context, ref, item),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                cp.isPinned
                                    ? Icons.push_pin_rounded
                                    : Icons.history_rounded,
                                size: 9,
                                color: BrandColors.accent,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '₹${override.toStringAsFixed(1)} · ${cp.isPinned ? 'set' : 'last'}',
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: BrandColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (cp.catalogPrice != null) ...[
                          const SizedBox(width: 5),
                          Text(
                            '₹${cp.catalogPrice!.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: BrandColors.muted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: hasCustomer
                        ? () => _showSetCustomerPriceSheet(
                            context,
                            ref,
                            p,
                            override,
                          )
                        : () => _showEditLinePriceSheet(context, ref, item),
                    child: Row(
                      children: [
                        // A one-time override shows the edited price with the
                        // catalog price struck through beside it.
                        if (override != null) ...[
                          Text(
                            '₹${override.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: BrandColors.accent,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            p.priceLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              color: BrandColors.muted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ] else
                          Text(
                            p.priceLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: BrandColors.muted,
                            ),
                          ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.edit_rounded,
                          size: 10,
                          color: BrandColors.muted.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          if (p.isLoose)
            GestureDetector(
              onTap: () => onEditLoose(item),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: BrandColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  '${item.quantity} ${p.unit ?? ""}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: BrandColors.primary,
                  ),
                ),
              ),
            )
          else
            _QtyControl(
              qty: item.quantity.toInt(),
              onDecrement: () => ref
                  .read(posProvider.notifier)
                  .updateQty(item.lineKey, item.quantity - 1),
              onIncrement: () => ref
                  .read(posProvider.notifier)
                  .updateQty(item.lineKey, item.quantity + 1),
            ),

          const SizedBox(width: 12),
          Text(
            '₹${item.lineTotal.toStringAsFixed(1)}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: BrandColors.primary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
  }
}
