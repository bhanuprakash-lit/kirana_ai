part of '../add_product_sheet_new.dart';

class _VariantData {
  final weightCtrl = TextEditingController(); // empty = no pack size
  final barcodeCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final mrpCtrl = TextEditingController();
  final costCtrl = TextEditingController();
  final stockCtrl = TextEditingController(text: '0');
  final expiryCtrl = TextEditingController();
  String selectedUnit = 'pcs';

  void dispose() {
    weightCtrl.dispose();
    barcodeCtrl.dispose();
    priceCtrl.dispose();
    mrpCtrl.dispose();
    costCtrl.dispose();
    stockCtrl.dispose();
    expiryCtrl.dispose();
  }
}

