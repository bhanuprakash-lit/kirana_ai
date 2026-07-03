part of '../baskets_screen_new.dart';

class _SelectedItem {
  final int productId;
  final String productName;
  final double price;
  final TextEditingController qtyCtrl;

  _SelectedItem({
    required this.productId,
    required this.productName,
    required this.price,
    double qty = 1,
  }) : qtyCtrl = TextEditingController(
         text: qty == qty.roundToDouble()
             ? qty.toStringAsFixed(0)
             : qty.toString(),
       );

  double get qty => double.tryParse(qtyCtrl.text) ?? 1.0;
  double get lineTotal => price * qty;

  void dispose() => qtyCtrl.dispose();
}
