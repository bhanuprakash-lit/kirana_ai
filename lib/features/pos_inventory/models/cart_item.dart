import 'pos_product.dart';

class CartItem {
  final PosProduct product;
  final double quantity;

  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({double? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  double get lineTotal => product.price * quantity;
}
