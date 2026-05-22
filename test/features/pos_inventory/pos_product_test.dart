import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/pos_inventory/models/pos_product.dart';

void main() {
  group('PosProduct.fromJson', () {
    test('parses all fields from the canonical payload', () {
      final p = PosProduct.fromJson({
        'product_id': 100,
        'name': 'Aashirvaad Atta',
        'brand': 'Aashirvaad',
        'unit': 'kg',
        'weight': 5.0,
        'sku': 'KAI-100',
        'barcode': '8901030821212',
        'is_perishable': false,
        'is_loose': false,
        'category_id': 3,
        'selling_price': 285.0,
        'mrp': 310.0,
        'stock_quantity': 12,
        'image_url': 'https://example.com/atta.jpg',
      });

      expect(p.productId, 100);
      expect(p.name, 'Aashirvaad Atta');
      expect(p.brand, 'Aashirvaad');
      expect(p.unit, 'kg');
      expect(p.weight, 5.0);
      expect(p.barcode, '8901030821212');
      expect(p.isPerishable, isFalse);
      expect(p.isLoose, isFalse);
      expect(p.categoryId, 3);
      expect(p.price, 285.0);
      expect(p.mrp, 310.0);
      expect(p.stockQuantity, 12.0);
      expect(p.imageUrl, 'https://example.com/atta.jpg');
    });

    test('selling_price wins over price/unit_price', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'X',
        'selling_price': 200,
        'price': 999,
        'unit_price': 888,
        'is_perishable': false,
        'is_loose': false,
        'category_id': 1,
        'stock_quantity': 0,
      });
      expect(p.price, 200.0);
    });

    test('mrp is nulled when zero or missing', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'X',
        'price': 100,
        'mrp': 0,
        'is_perishable': false,
        'is_loose': false,
        'category_id': 1,
        'stock_quantity': 0,
      });
      expect(p.mrp, isNull);
    });

    test('parses string numerics (Postgres NUMERIC -> JSON string)', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'X',
        'price': '49.50',
        'stock_quantity': '10.25',
        'is_perishable': false,
        'is_loose': true,
        'category_id': 1,
      });
      expect(p.price, 49.50);
      expect(p.stockQuantity, 10.25);
    });
  });

  group('PosProduct.copyWith', () {
    PosProduct base() => const PosProduct(
      productId: 1,
      name: 'Atta',
      unit: 'kg',
      weight: 5.0,
      isPerishable: false,
      isLoose: false,
      categoryId: 1,
      price: 285,
      mrp: 310,
      stockQuantity: 12,
    );

    test('only the provided fields change', () {
      final next = base().copyWith(price: 290);
      expect(next.price, 290);
      expect(next.mrp, 310);
      expect(next.stockQuantity, 12);
      expect(next.name, 'Atta');
    });
  });

  group('PosProduct display getters', () {
    test('priceLabel for non-loose item is ₹X / unit', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'Soap',
        'is_perishable': false,
        'is_loose': false,
        'category_id': 1,
        'price': 30,
        'stock_quantity': 5,
      });
      expect(p.priceLabel, '₹30 / unit');
    });

    test('priceLabel for loose item shows the unit', () {
      final p = PosProduct.fromJson({
        'product_id': 2,
        'name': 'Toor Dal',
        'unit': 'kg',
        'is_perishable': false,
        'is_loose': true,
        'category_id': 1,
        'price': 145.5,
        'stock_quantity': 50,
      });
      expect(p.priceLabel, '₹145.5 / kg');
    });

    test('stockLabel for non-loose is "N units"', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'X',
        'is_perishable': false,
        'is_loose': false,
        'category_id': 1,
        'price': 10,
        'stock_quantity': 7,
      });
      expect(p.stockLabel, '7 units');
    });

    test('stockLabel for loose shows fractional units', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'X',
        'unit': 'kg',
        'is_perishable': false,
        'is_loose': true,
        'category_id': 1,
        'price': 100,
        'stock_quantity': 12.5,
      });
      expect(p.stockLabel, '12.50 kg');
    });

    test('weightLabel combines weight + unit when both present', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'X',
        'unit': 'kg',
        'weight': 5.0,
        'is_perishable': false,
        'is_loose': false,
        'category_id': 1,
        'price': 1,
        'stock_quantity': 0,
      });
      expect(p.weightLabel, '5 kg');
    });

    test('displayName for packaged item includes weight and brand', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'Atta',
        'brand': 'Aashirvaad',
        'unit': 'kg',
        'weight': 5.0,
        'is_perishable': false,
        'is_loose': false,
        'category_id': 1,
        'price': 1,
        'stock_quantity': 0,
      });
      expect(p.displayName, 'Atta (5 kg) · Aashirvaad');
    });

    test('displayName for loose item omits weight', () {
      final p = PosProduct.fromJson({
        'product_id': 1,
        'name': 'Toor Dal',
        'unit': 'kg',
        'is_perishable': false,
        'is_loose': true,
        'category_id': 1,
        'price': 1,
        'stock_quantity': 0,
      });
      expect(p.displayName, 'Toor Dal');
    });
  });
}
