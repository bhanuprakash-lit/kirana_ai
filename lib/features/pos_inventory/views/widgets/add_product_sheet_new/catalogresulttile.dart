part of '../add_product_sheet_new.dart';

class _CatalogResultTile extends StatelessWidget {
  final _CatalogProduct product;
  final VoidCallback onTap;

  const _CatalogResultTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            // Product image / icon
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => _iconFallback(),
                    )
                  : _iconFallback(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.subtitle.isNotEmpty)
                    Text(
                      product.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (product.barcode != null)
                    Text(
                      product.barcode!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: BrandColors.muted,
                        fontFamily: 'monospace',
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.add_circle_rounded,
              color: BrandColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconFallback() => Container(
    width: 48,
    height: 48,
    color: BrandColors.surfaceTint,
    child: const Icon(
      Icons.inventory_2_rounded,
      color: BrandColors.muted,
      size: 22,
    ),
  );
}
