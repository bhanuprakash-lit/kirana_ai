part of '../add_product_sheet_new.dart';

class _CatalogProduct {
  final int productId;
  final String name;
  final String? brand;
  final String? unit;
  final double? weight;
  final String? barcode;
  final bool isPerishable;
  final bool isLoose;
  final String? imageUrl;
  final int categoryId;
  final String? categoryName;
  final String? parentCategoryName;
  // Most-recent pricing for THIS user's store, joined server-side.
  // Null when the store has no pricing row for this product yet.
  final double? price;
  final double? mrp;

  const _CatalogProduct({
    required this.productId,
    required this.name,
    this.brand,
    this.unit,
    this.weight,
    this.barcode,
    required this.isPerishable,
    required this.isLoose,
    this.imageUrl,
    required this.categoryId,
    this.categoryName,
    this.parentCategoryName,
    this.price,
    this.mrp,
  });

  factory _CatalogProduct.fromJson(Map<String, dynamic> j) => _CatalogProduct(
    productId: j['product_id'] as int,
    name: j['name'] as String,
    brand: j['brand'] as String?,
    unit: j['unit'] as String?,
    weight: (j['weight'] as num?)?.toDouble(),
    barcode: j['barcode'] as String?,
    isPerishable: j['is_perishable'] as bool? ?? false,
    isLoose: j['is_loose'] as bool? ?? false,
    imageUrl: j['image_url'] as String?,
    categoryId: j['category_id'] as int,
    categoryName: j['category_name'] as String?,
    parentCategoryName: j['parent_category_name'] as String?,
    price: (j['price'] as num?)?.toDouble(),
    mrp: (j['mrp'] as num?)?.toDouble(),
  );

  String get subtitle {
    final parts = <String>[];
    if (brand != null) parts.add(brand!);
    if (parentCategoryName != null) parts.add(parentCategoryName!);
    if (categoryName != null && categoryName != parentCategoryName) {
      parts.add(categoryName!);
    }
    return parts.join(' · ');
  }
}
