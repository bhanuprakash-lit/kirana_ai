part of '../baskets_screen_new.dart';

class _BasketCard extends StatelessWidget {
  final Basket basket;
  final VoidCallback onDelete;
  final VoidCallback onAlert;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onRestore;

  const _BasketCard({
    required this.basket,
    required this.onDelete,
    required this.onAlert,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isExpired = basket.isExpired;
    final isArchived = basket.isArchived;
    final dimmed = isExpired || isArchived;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isArchived ? BrandColors.surfaceTint : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (basket.tier != null) ...[
                            _TierBadge(tier: basket.tier!),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              basket.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: dimmed
                                    ? BrandColors.muted
                                    : BrandColors.ink,
                              ),
                            ),
                          ),
                          if (isArchived) ...[
                            const SizedBox(width: 8),
                            _Pill(
                              text: l10n.mktArchived,
                              color: BrandColors.muted,
                            ),
                          ] else if (isExpired) ...[
                            const SizedBox(width: 8),
                            _Pill(
                              text: l10n.mktExpired,
                              color: BrandColors.error,
                            ),
                          ],
                        ],
                      ),
                      if (basket.description != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          basket.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (basket.price != null) _PriceBlock(basket: basket),
              ],
            ),

            if (basket.savings != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.sell_rounded,
                    size: 13,
                    color: BrandColors.success,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    l10n.mktYouSave(
                      basket.savings!.toStringAsFixed(0),
                      (basket.discountPct ?? 0).toStringAsFixed(0),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.success,
                    ),
                  ),
                ],
              ),
            ],

            if (basket.items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: basket.items
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: BrandColors.surfaceTint,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: BrandColors.border),
                        ),
                        child: Text(
                          '${item.productName ?? l10n.mktItem} × ${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: BrandColors.ink,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],

            if (basket.validFrom != null || basket.validTo != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: BrandColors.muted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    [
                      if (basket.validFrom != null)
                        l10n.mktFromDate(basket.validFrom!),
                      if (basket.validTo != null)
                        l10n.mktToDate(basket.validTo!),
                    ].join('  ·  '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 14),
            if (isArchived)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRestore,
                      icon: const Icon(Icons.unarchive_rounded, size: 16),
                      label: Text(l10n.mktRestore),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _DeleteButton(onDelete: onDelete),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: (isExpired || basket.alertedToday)
                          ? null
                          : onAlert,
                      icon: const Icon(Icons.message_rounded, size: 16),
                      label: Text(
                        basket.alertedToday
                            ? l10n.mktAlertedToday
                            : l10n.mktAlertCustomers,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        side: const BorderSide(color: Color(0xFF25D366)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: l10n.mktEdit,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: BrandColors.surfaceTint,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, size: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (v) {
                      if (v == 'archive') onArchive();
                      if (v == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(Icons.archive_outlined, size: 18),
                            const SizedBox(width: 10),
                            Text(l10n.mktArchive),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: BrandColors.error,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.mktDelete,
                              style: const TextStyle(color: BrandColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
