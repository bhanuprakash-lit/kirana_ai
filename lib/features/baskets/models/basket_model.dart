class BasketItem {
  final int? id;
  final int productId;
  final String? productName;
  final double qty;

  const BasketItem({
    this.id,
    required this.productId,
    this.productName,
    this.qty = 1,
  });

  factory BasketItem.fromJson(Map<String, dynamic> j) => BasketItem(
    id: (j['id'] as num?)?.toInt(),
    productId: (j['product_id'] as num).toInt(),
    productName: j['product_name'] as String?,
    qty: (j['qty'] as num?)?.toDouble() ?? 1,
  );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'qty': qty,
  };
}

class Basket {
  final int basketId;
  final String name;
  final String? description;
  final double? price;
  final String? validFrom;
  final String? validTo;
  final bool isActive;
  final List<BasketItem> items;

  const Basket({
    required this.basketId,
    required this.name,
    this.description,
    this.price,
    this.validFrom,
    this.validTo,
    this.isActive = true,
    this.items = const [],
  });

  factory Basket.fromJson(Map<String, dynamic> j) => Basket(
    basketId: (j['basket_id'] as num).toInt(),
    name: j['name'] as String,
    description: j['description'] as String?,
    price: (j['price'] as num?)?.toDouble(),
    validFrom: j['valid_from'] as String?,
    validTo: j['valid_to'] as String?,
    isActive: j['is_active'] as bool? ?? true,
    items: (j['items'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .map(BasketItem.fromJson)
        .toList(),
  );

  bool get isExpired {
    if (validTo == null) return false;
    final dt = DateTime.tryParse(validTo!);
    return dt != null && dt.isBefore(DateTime.now());
  }

  bool get isActive2 {
    if (validFrom != null) {
      final dt = DateTime.tryParse(validFrom!);
      if (dt != null && dt.isAfter(DateTime.now())) return false;
    }
    return isActive && !isExpired;
  }
}
