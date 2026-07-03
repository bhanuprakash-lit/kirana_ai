part of '../pos_tab_new.dart';

class _OrderFooter extends StatelessWidget {
  final double subtotal;
  final double itemCount;
  final double tax; // F3 — GST included in the subtotal (0 = none)
  final String? basketName;
  final double? basketGross;
  final double? basketSavings;
  final bool isPlacing;
  final String? selectedCustomer;
  final VoidCallback onSelectCustomer;
  final VoidCallback onClearCustomer;
  final VoidCallback onOrder;

  const _OrderFooter({
    required this.subtotal,
    required this.itemCount,
    this.tax = 0,
    this.basketName,
    this.basketGross,
    this.basketSavings,
    required this.isPlacing,
    this.selectedCustomer,
    required this.onSelectCustomer,
    required this.onClearCustomer,
    required this.onOrder,
  });

  String _fmt(double v) {
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BrandColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bundle savings banner — shows the original value, % off and net so
          // the shopkeeper sees exactly what the basket discount is doing.
          if (basketName != null) ...[
            BasketSavingsBanner(
              name: basketName!,
              gross: basketGross,
              savings: basketSavings,
            ),
            const SizedBox(height: 8),
          ],
          // Row 1: customer chip (left) + item count & total (right)
          Row(
            children: [
              Expanded(
                child: selectedCustomer != null
                    ? GestureDetector(
                        onTap: onSelectCustomer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.primary.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: BrandColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_rounded,
                                size: 14,
                                color: BrandColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  selectedCustomer!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: BrandColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: onClearCustomer,
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: BrandColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: onSelectCustomer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.surfaceTint,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: BrandColors.border),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add_alt_1_rounded,
                                size: 14,
                                color: BrandColors.muted,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Add Customer',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: BrandColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${itemCount % 1 == 0 ? itemCount.toInt() : itemCount.toStringAsFixed(2)} item${itemCount == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: BrandColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    _fmt(subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: BrandColors.ink,
                    ),
                  ),
                  if (tax > 0)
                    Text(
                      AppLocalizations.of(context).posInclGst(_fmt(tax)),
                      style: const TextStyle(
                        color: BrandColors.muted,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Place Order button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: isPlacing ? null : onOrder,
              child: isPlacing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(
                        context,
                      ).posPlaceOrderAmount(_fmt(subtotal)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
