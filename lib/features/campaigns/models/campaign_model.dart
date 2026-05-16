import '../../pos_inventory/models/pos_product.dart';

class CampaignProduct {
  final int productId;
  final String name;
  final double price;
  final double stockQuantity;
  final String? barcode;
  final String? unit;

  const CampaignProduct({
    required this.productId,
    required this.name,
    required this.price,
    required this.stockQuantity,
    this.barcode,
    this.unit,
  });

  factory CampaignProduct.fromJson(Map<String, dynamic> j) => CampaignProduct(
        productId: (j['product_id'] as num).toInt(),
        name: j['name'] as String,
        price: (j['price'] as num? ?? 0).toDouble(),
        stockQuantity: (j['stock_quantity'] as num? ?? 0).toDouble(),
        barcode: j['barcode'] as String?,
        unit: j['unit'] as String?,
      );

  PosProduct toPosProduct() => PosProduct(
        productId: productId,
        name: name,
        price: price,
        stockQuantity: stockQuantity,
        barcode: barcode,
        unit: unit,
        isPerishable: false,
        isLoose: false,
        categoryId: 0,
      );
}

class CampaignItem {
  final String displayName;
  final double quantity;
  final CampaignProduct? product;
  final bool inStock;

  const CampaignItem({
    required this.displayName,
    required this.quantity,
    this.product,
    required this.inStock,
  });

  factory CampaignItem.fromJson(Map<String, dynamic> j) => CampaignItem(
        displayName: j['display_name'] as String,
        quantity: (j['quantity'] as num? ?? 1).toDouble(),
        product: j['product'] != null
            ? CampaignProduct.fromJson(j['product'] as Map<String, dynamic>)
            : null,
        inStock: j['in_stock'] as bool? ?? false,
      );
}

class Campaign {
  final String campaignId;
  final String name;
  final String emoji;
  final String description;
  final String campaignType;
  final List<CampaignItem> items;
  final int availableCount;
  final int totalItems;
  final double totalPrice;
  final double score;

  const Campaign({
    required this.campaignId,
    required this.name,
    required this.emoji,
    required this.description,
    required this.campaignType,
    required this.items,
    required this.availableCount,
    required this.totalItems,
    required this.totalPrice,
    required this.score,
  });

  factory Campaign.fromJson(Map<String, dynamic> j) => Campaign(
        campaignId: j['campaign_id'] as String,
        name: j['name'] as String,
        emoji: j['emoji'] as String? ?? '🛒',
        description: j['description'] as String? ?? '',
        campaignType: j['campaign_type'] as String? ?? 'general',
        items: (j['items'] as List)
            .map((e) => CampaignItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        availableCount: (j['available_count'] as num? ?? 0).toInt(),
        totalItems: (j['total_items'] as num? ?? 0).toInt(),
        totalPrice: (j['total_price'] as num? ?? 0).toDouble(),
        score: (j['score'] as num? ?? 0).toDouble(),
      );

  double get availabilityPct =>
      totalItems == 0 ? 0 : availableCount / totalItems;

  List<CampaignItem> get stockedItems => items.where((i) => i.inStock).toList();
}
