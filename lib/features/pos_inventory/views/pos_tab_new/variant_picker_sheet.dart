import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../models/product_variant.dart';

/// F2 — POS variant picker. Shown before add-to-cart when a variant-vertical
/// product has real variants, so the shopkeeper sells the exact size/colour/
/// model (its price + stock). Returns the chosen variant, or null if cancelled.
Future<ProductVariant?> showVariantPickerSheet(
  BuildContext context, {
  required List<ProductVariant> variants,
  required String productName,
}) {
  return showModalBottomSheet<ProductVariant>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VariantPickerSheet(
      variants: variants,
      productName: productName,
    ),
  );
}

class _VariantPickerSheet extends StatelessWidget {
  final List<ProductVariant> variants;
  final String productName;
  const _VariantPickerSheet({
    required this.variants,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.posSelectVariant,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          Text(
            productName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: BrandColors.muted),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: variants.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final v = variants[i];
                final outOfStock = v.stock <= 0;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  enabled: !outOfStock,
                  title: Text(
                    v.label.isEmpty ? productName : v.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    outOfStock
                        ? l10n.posOutOfStock
                        : l10n.posVariantStockLine(
                            v.stock.toStringAsFixed(v.stock % 1 == 0 ? 0 : 2),
                          ),
                    style: TextStyle(
                      fontSize: 12,
                      color: outOfStock ? BrandColors.error : BrandColors.muted,
                    ),
                  ),
                  trailing: Text(
                    v.price != null ? '₹${v.price!.toStringAsFixed(0)}' : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: BrandColors.primary,
                    ),
                  ),
                  onTap: outOfStock ? null : () => Navigator.pop(context, v),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
