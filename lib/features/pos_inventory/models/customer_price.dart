/// The selected customer's effective personal price for a product — either an
/// explicitly pinned price or, failing that, the price they last paid. Sourced
/// from `/kirana/customers/{id}/price-memory`.
class CustomerPrice {
  final int productId;
  final String productName;
  final String? unit;

  /// The effective customer price to charge (pinned if set, else last-paid).
  final double price;

  /// Where [price] came from: 'pinned' (shopkeeper set it) or 'last_paid'.
  final String source;

  /// The most recent price actually paid (for reference / staleness), if any.
  final double? lastPaidPrice;

  /// ISO date of that last purchase (for "since [date]" hints).
  final String? lastPaidDate;

  /// Current catalog price, if the product has an active price window.
  final double? catalogPrice;

  const CustomerPrice({
    required this.productId,
    required this.productName,
    this.unit,
    required this.price,
    this.source = 'last_paid',
    this.lastPaidPrice,
    this.lastPaidDate,
    this.catalogPrice,
  });

  bool get isPinned => source == 'pinned';

  /// Signed delta vs catalog (negative = customer pays less than catalog).
  double? get delta => catalogPrice == null ? null : price - catalogPrice!;

  factory CustomerPrice.fromJson(Map<String, dynamic> j) => CustomerPrice(
    productId: (j['product_id'] as num).toInt(),
    productName: j['product_name'] as String? ?? '',
    unit: j['unit'] as String?,
    price: (j['price'] as num).toDouble(),
    source: j['source'] as String? ?? 'last_paid',
    lastPaidPrice: (j['last_paid_price'] as num?)?.toDouble(),
    lastPaidDate: j['last_paid_date'] as String?,
    catalogPrice: (j['catalog_price'] as num?)?.toDouble(),
  );
}
