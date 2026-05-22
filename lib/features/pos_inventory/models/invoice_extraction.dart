class InvoiceVendor {
  final String? name;
  final String? gstin;
  final String? address;
  final String? phone;

  const InvoiceVendor({this.name, this.gstin, this.address, this.phone});

  factory InvoiceVendor.fromJson(Map<String, dynamic> j) => InvoiceVendor(
        name: j['vendor_name'] as String?,
        gstin: j['vendor_gstin'] as String?,
        address: j['vendor_address'] as String?,
        phone: j['vendor_phone'] as String?,
      );
}

class InvoiceDetails {
  final String? number;
  final String? date;
  final String? placeOfSupply;

  const InvoiceDetails({this.number, this.date, this.placeOfSupply});

  factory InvoiceDetails.fromJson(Map<String, dynamic> j) => InvoiceDetails(
        number: j['invoice_number'] as String?,
        date: j['invoice_date'] as String?,
        placeOfSupply: j['place_of_supply'] as String?,
      );
}

class InvoiceLineItem {
  final String? name;
  final double? quantity;
  final String? unit;
  final double? pricePerUnit;
  final double? finalAmount;
  final double? cgstRate;
  final double? sgstRate;

  const InvoiceLineItem({
    this.name,
    this.quantity,
    this.unit,
    this.pricePerUnit,
    this.finalAmount,
    this.cgstRate,
    this.sgstRate,
  });

  factory InvoiceLineItem.fromJson(Map<String, dynamic> j) => InvoiceLineItem(
        name: j['item_name'] as String?,
        quantity: (j['quantity'] as num?)?.toDouble(),
        unit: j['unit'] as String?,
        pricePerUnit: (j['price_per_unit'] as num?)?.toDouble(),
        finalAmount: (j['final_amount'] as num?)?.toDouble(),
        cgstRate: (j['cgst_rate'] as num?)?.toDouble(),
        sgstRate: (j['sgst_rate'] as num?)?.toDouble(),
      );

  double get effectiveCostPrice {
    if (quantity != null && quantity! > 0 && finalAmount != null) {
      return finalAmount! / quantity!;
    }
    return pricePerUnit ?? 0.0;
  }
}

class InvoiceTotals {
  final double? subtotal;
  final double? grandTotal;
  final double? cgstTotal;
  final double? sgstTotal;

  const InvoiceTotals({this.subtotal, this.grandTotal, this.cgstTotal, this.sgstTotal});

  factory InvoiceTotals.fromJson(Map<String, dynamic> j) => InvoiceTotals(
        subtotal: (j['subtotal'] as num?)?.toDouble(),
        grandTotal: (j['grand_total'] as num?)?.toDouble(),
        cgstTotal: (j['cgst_total'] as num?)?.toDouble(),
        sgstTotal: (j['sgst_total'] as num?)?.toDouble(),
      );
}

class InvoiceExtraction {
  final InvoiceVendor vendor;
  final InvoiceDetails details;
  final List<InvoiceLineItem> items;
  final InvoiceTotals totals;
  final String validationStatus;
  final double? confidenceScore;

  const InvoiceExtraction({
    required this.vendor,
    required this.details,
    required this.items,
    required this.totals,
    this.validationStatus = 'unknown',
    this.confidenceScore,
  });

  factory InvoiceExtraction.fromJson(Map<String, dynamic> j) {
    final vendor = InvoiceVendor.fromJson(
        (j['vendor'] as Map<String, dynamic>?) ?? {});
    final details = InvoiceDetails.fromJson(
        (j['invoice_details'] as Map<String, dynamic>?) ?? {});
    final items = ((j['items'] as List?) ?? [])
        .cast<Map<String, dynamic>>()
        .map(InvoiceLineItem.fromJson)
        .where((i) => i.name != null && i.name!.trim().isNotEmpty)
        .toList();
    final totals = InvoiceTotals.fromJson(
        (j['totals'] as Map<String, dynamic>?) ?? {});

    return InvoiceExtraction(
      vendor: vendor,
      details: details,
      items: items,
      totals: totals,
      validationStatus: j['validation_status'] as String? ?? 'unknown',
      confidenceScore: (j['confidence_score'] as num?)?.toDouble(),
    );
  }
}
