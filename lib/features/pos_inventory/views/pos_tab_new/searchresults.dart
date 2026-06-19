part of '../pos_tab_new.dart';

class _SearchResults extends StatelessWidget {
  final List<PosProduct> products;
  final bool isLoading;
  final ValueChanged<PosProduct> onAdd;

  const _SearchResults({
    required this.products,
    required this.isLoading,
    required this.onAdd,
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
                return ListTile(
                  dense: true,
                  leading: ClipRRect(
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
                    '${p.priceLabel} · Stock: ${p.stockLabel}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
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

