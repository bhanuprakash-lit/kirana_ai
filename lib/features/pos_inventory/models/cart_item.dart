import 'pos_product.dart';

class CartItem {
  final PosProduct product;
  final double quantity;

  /// When set, overrides the product's catalog price for this cart line.
  /// Used by basket/bundle pricing so the line total reflects the deal price
  /// rather than the sum of individual product prices.
  final double? unitPriceOverride;

  /// F2 — the specific variant sold (size/colour/model). Null for grocery /
  /// single-variant products. [variantLabel] is the human label for the line.
  final int? variantId;
  final String? variantLabel;

  const CartItem({
    required this.product,
    required this.quantity,
    this.unitPriceOverride,
    this.variantId,
    this.variantLabel,
  });

  CartItem copyWith({
    double? quantity,
    double? unitPriceOverride,
    bool clearOverride = false,
  }) => CartItem(
    product: product,
    quantity: quantity ?? this.quantity,
    unitPriceOverride: clearOverride
        ? null
        : (unitPriceOverride ?? this.unitPriceOverride),
    variantId: variantId,
    variantLabel: variantLabel,
  );

  /// Stable identity for a cart line: a product can appear once per variant.
  String get lineKey => '${product.productId}:${variantId ?? 0}';

  /// Effective per-unit price charged for this line.
  double get unitPrice => unitPriceOverride ?? product.price;

  double get lineTotal => unitPrice * quantity;

  /// F3 — GST % for this line (0 = no tax).
  double get gstRate => product.gstRate ?? 0;

  /// F3 — GST contained in this line. Retail prices are GST-inclusive, so the
  /// tax is the portion of the line total above the pre-tax (taxable) value.
  double get taxAmount =>
      gstRate > 0 ? lineTotal - (lineTotal / (1 + gstRate / 100)) : 0;
}
