/// Foundation 2 — product variants + dynamic attributes.
///
/// A [ProductVariant] is one sellable variant of a product (size×colour, model,
/// …). Grocery products keep a single *implicit* variant so legacy flows work.
/// [AttributeDef] describes the axes a vertical exposes (from the backend
/// `product_attribute_def` seed), driving the add/edit variant form.
library;

class AttributeDef {
  final String attrCode;
  final String label;
  final String type; // 'text' | 'number' | 'enum'
  final List<String> options; // for type == 'enum'
  final bool isVariantAxis;
  final int sort;

  const AttributeDef({
    required this.attrCode,
    required this.label,
    this.type = 'text',
    this.options = const [],
    this.isVariantAxis = false,
    this.sort = 0,
  });

  bool get isEnum => type == 'enum' && options.isNotEmpty;

  factory AttributeDef.fromJson(Map<String, dynamic> j) {
    final raw = j['options'];
    final opts = raw is List ? raw.map((e) => e.toString()).toList() : const <String>[];
    return AttributeDef(
      attrCode: (j['attr_code'] ?? '').toString(),
      label: (j['label'] ?? j['attr_code'] ?? '').toString(),
      type: (j['type'] ?? 'text').toString(),
      options: opts,
      isVariantAxis: j['is_variant_axis'] == true,
      sort: (j['sort'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductVariant {
  final int variantId;
  final int productId;
  final String? sku;
  final String? barcode;
  final Map<String, String> attributes; // {size: 'M', colour: 'Blue'}
  final double? price;
  final double? mrp;
  final double? cost;
  final double stock;
  final bool isImplicit;
  final bool isActive;

  const ProductVariant({
    required this.variantId,
    required this.productId,
    this.sku,
    this.barcode,
    this.attributes = const {},
    this.price,
    this.mrp,
    this.cost,
    this.stock = 0,
    this.isImplicit = false,
    this.isActive = true,
  });

  /// Human label, e.g. "M · Blue". Empty for the implicit variant.
  String get label => attributes.values.where((v) => v.isNotEmpty).join(' · ');

  static double? _num(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse(v.toString()));

  factory ProductVariant.fromJson(Map<String, dynamic> j) {
    final rawAttrs = j['attributes'];
    final attrs = <String, String>{};
    if (rawAttrs is Map) {
      rawAttrs.forEach((k, v) => attrs[k.toString()] = (v ?? '').toString());
    }
    return ProductVariant(
      variantId: (j['variant_id'] as num).toInt(),
      productId: (j['product_id'] as num).toInt(),
      sku: j['sku']?.toString(),
      barcode: j['barcode']?.toString(),
      attributes: attrs,
      price: _num(j['price']),
      mrp: _num(j['mrp']),
      cost: _num(j['cost']),
      stock: _num(j['stock']) ?? 0,
      isImplicit: j['is_implicit'] == true,
      isActive: j['is_active'] != false,
    );
  }
}
