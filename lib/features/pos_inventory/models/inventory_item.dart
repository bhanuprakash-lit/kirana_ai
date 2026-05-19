class InventoryItem {
  final int productId;
  final String name;
  final String? brand;
  final String? unit;
  final double? weight; // e.g. 250 for "250g"
  final String? barcode;
  final int categoryId;
  final String? categoryName;
  final double price;
  final double? mrp;
  final double stockQuantity;
  final bool isPerishable;
  final bool isLoose;
  // From recommendations
  final double? reorderQty;
  final double? daysToStockout;
  final double? prob7Day;
  final String? recommendationType;
  // From snapshot (units sold today)
  final double soldToday;
  // From inventory_batch
  final String? expiryDate;
  final String? imageUrl;

  const InventoryItem({
    required this.productId,
    required this.name,
    this.brand,
    this.unit,
    this.weight,
    this.barcode,
    required this.categoryId,
    this.categoryName,
    required this.price,
    this.mrp,
    required this.stockQuantity,
    required this.isPerishable,
    required this.isLoose,
    this.reorderQty,
    this.daysToStockout,
    this.prob7Day,
    this.recommendationType,
    this.soldToday = 0,
    this.expiryDate,
    this.imageUrl,
  });

  bool get isFastMoving =>
      recommendationType?.toLowerCase().contains('fast') ?? false;

  bool get isDeadStock =>
      recommendationType?.toLowerCase().contains('dead') ?? false;

  bool get isLowStock =>
      stockQuantity <= (reorderQty ?? 10) && stockQuantity > 0;

  bool get isOutOfStock => stockQuantity <= 0;

  String get displayName {
    final b = brand != null ? ' · $brand' : '';
    if (isLoose) return '$name$b';
    final size = weightLabel;
    return size != null ? '$name ($size)$b' : '$name$b';
  }

  /// e.g. "250 g" or "1 kg" — shown in the card subtitle
  String? get weightLabel {
    if (weight == null && unit == null) return null;
    final w = weight != null
        ? (weight! % 1 == 0
              ? weight!.toInt().toString()
              : weight!.toStringAsFixed(1))
        : null;
    return [w, unit].whereType<String>().join(' ');
  }

  String get stockLabel {
    final qty = stockQuantity % 1 == 0
        ? stockQuantity.toInt().toString()
        : stockQuantity.toStringAsFixed(2);
    if (isLoose) {
      return '$qty ${unit ?? "units"}';
    }
    return '$qty units';
  }

  factory InventoryItem.fromSources({
    required Map<String, dynamic> product,
    String? categoryName,
    Map<String, dynamic>? recommendation,
    Map<String, dynamic>? pricing, // from /oltp/pricing — overrides pos price
    double soldToday = 0,
    String? expiryDate,
  }) {
    double? extractPrice(Map<String, dynamic>? map) {
      if (map == null) return null;
      final v =
          (map['selling_price'] ?? map['price'] ?? map['unit_price']) as num?;
      final val = v?.toDouble();
      return (val != null && val > 0) ? val : null;
    }

    double extractNum(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final price =
        extractPrice(pricing) ??
        extractPrice(product) ??
        (product['price'] as num?)?.toDouble() ??
        0.0;
    return InventoryItem(
      productId: product['product_id'] as int,
      name: product['name'] as String,
      brand: product['brand'] as String?,
      unit: product['unit'] as String?,
      weight: (product['weight'] as num?)?.toDouble(),
      barcode: product['barcode'] as String?,
      categoryId: (product['category_id'] as num?)?.toInt() ?? 0,
      categoryName: categoryName,
      price: price,
      mrp:
          (pricing?['mrp'] as num?)?.toDouble() ??
          (product['mrp'] as num?)?.toDouble(),
      stockQuantity: extractNum(product['stock_quantity']),
      isPerishable: product['is_perishable'] as bool? ?? false,
      isLoose: product['is_loose'] as bool? ?? false,
      reorderQty: (recommendation?['reorder_qty'] as num?)?.toDouble(),
      daysToStockout: (recommendation?['days_to_stockout'] as num?)?.toDouble(),
      prob7Day: (recommendation?['prob_stockout_7d'] as num?)?.toDouble(),
      recommendationType: recommendation?['recommendation_type'] as String?,
      soldToday: soldToday,
      expiryDate: expiryDate,
      imageUrl: product['image_url'] as String?,
    );
  }
}
