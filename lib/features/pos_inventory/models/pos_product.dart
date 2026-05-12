class PosProduct {
  final int productId;
  final String name;
  final String? brand;
  final String? unit;
  final double? weight;
  final String? sku;
  final String? barcode;
  final bool isPerishable;
  final bool isLoose;
  final int categoryId;
  final double price;
  final double? mrp;
  final double stockQuantity;

  const PosProduct({
    required this.productId,
    required this.name,
    this.brand,
    this.unit,
    this.weight,
    this.sku,
    this.barcode,
    required this.isPerishable,
    required this.isLoose,
    required this.categoryId,
    required this.price,
    this.mrp,
    required this.stockQuantity,
  });

  factory PosProduct.fromJson(Map<String, dynamic> j) {
    double extract(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final price = extract(j['selling_price'] ?? j['price'] ?? j['unit_price']);
    final mrp = extract(j['mrp']);

    return PosProduct(
      productId: j['product_id'] as int,
      name: j['name'] as String,
      brand: j['brand'] as String?,
      unit: j['unit'] as String?,
      weight: (j['weight'] as num?)?.toDouble(),
      sku: j['sku'] as String?,
      barcode: j['barcode'] as String?,
      isPerishable: j['is_perishable'] as bool? ?? false,
      isLoose: j['is_loose'] as bool? ?? false,
      categoryId: (j['category_id'] as num?)?.toInt() ?? 0,
      price: price,
      mrp: mrp > 0 ? mrp : null,
      stockQuantity: extract(j['stock_quantity']),
    );
  }

  PosProduct copyWith({double? price, double? mrp, double? stockQuantity}) =>
      PosProduct(
        productId: productId,
        name: name,
        brand: brand,
        unit: unit,
        weight: weight,
        sku: sku,
        barcode: barcode,
        isPerishable: isPerishable,
        isLoose: isLoose,
        categoryId: categoryId,
        price: price ?? this.price,
        mrp: mrp ?? this.mrp,
        stockQuantity: stockQuantity ?? this.stockQuantity,
      );

  String get displayName {
    final b = brand != null ? ' · $brand' : '';
    if (isLoose) return '$name$b';
    final size = weightLabel;
    return size != null ? '$name ($size)$b' : '$name$b';
  }

  String? get weightLabel {
    if (weight == null && unit == null) return null;
    final w = weight != null
        ? (weight! % 1 == 0
            ? weight!.toInt().toString()
            : weight!.toStringAsFixed(1))
        : null;
    return [w, unit].whereType<String>().join(' ');
  }

  String get priceLabel {
    final s = price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(1);
    if (isLoose) {
      return '₹$s / ${unit ?? "unit"}';
    }
    return '₹$s / unit';
  }

  String get stockLabel {
    final qty = stockQuantity % 1 == 0 ? stockQuantity.toInt().toString() : stockQuantity.toStringAsFixed(2);
    if (isLoose) {
      return '$qty ${unit ?? "units"}';
    }
    return '$qty units';
  }
}
