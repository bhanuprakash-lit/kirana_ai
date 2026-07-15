part of '../pos_tab_new.dart';

class _SearchResults extends StatelessWidget {
  final List<PosProduct> products;
  final bool isLoading;
  final ValueChanged<PosProduct> onAdd;

  /// V2 — product ids that are actually services (linked is_service rows):
  /// they show a "Service" chip instead of a stock count.
  final Set<int> serviceIds;

  const _SearchResults({
    required this.products,
    required this.isLoading,
    required this.onAdd,
    this.serviceIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: BrandColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: ListShimmer(itemCount: 3, itemHeight: 60),
            )
          : products.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No products found',
                style: TextStyle(color: BrandColors.muted),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: products.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
              itemBuilder: (_, i) {
                final p = products[i];
                final isService = serviceIds.contains(p.productId);
                return ListTile(
                  dense: true,
                  leading: isService
                      ? Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: BrandColors.purple.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.design_services_rounded,
                            size: 18,
                            color: BrandColors.purple,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: p.imageUrl != null
                              ? Image.network(
                                  p.imageUrl!,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => _posIconBox(36),
                                )
                              : _posIconBox(36),
                        ),
                  title: Text(
                    p.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    isService
                        ? '${p.priceLabel} · ${AppLocalizations.of(context).posServiceChip}'
                        : '${p.priceLabel} · Stock: ${p.stockLabel}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isService ? BrandColors.purple : BrandColors.muted,
                      fontWeight: isService ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => onAdd(p),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: BrandColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
