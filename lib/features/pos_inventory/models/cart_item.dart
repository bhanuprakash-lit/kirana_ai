import 'pos_product.dart';

class CartItem {
  final PosProduct product;
  final double quantity;

  /// When set, overrides the product's catalog price for this cart line.
  /// Used by basket/bundle pricing so the line total reflects the deal price
  /// rather than the sum of individual product prices.
  final double? unitPriceOverride;

  const CartItem({
    required this.product,
    required this.quantity,
    this.unitPriceOverride,
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
  );

  /// Effective per-unit price charged for this line.
  double get unitPrice => unitPriceOverride ?? product.price;

  double get lineTotal => unitPrice * quantity;
}
