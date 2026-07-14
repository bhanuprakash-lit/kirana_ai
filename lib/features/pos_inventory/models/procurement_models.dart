import 'package:kirana_ai/core/utils/date_utils.dart';

class Supplier {
  final int supplierId;
  final String name;
  final String? phone;
  final String? gstin;
  final String? paymentTerms;
  final String? category;

  const Supplier({
    required this.supplierId,
    required this.name,
    this.phone,
    this.gstin,
    this.paymentTerms,
    this.category,
  });

  factory Supplier.fromJson(Map<String, dynamic> j) => Supplier(
    supplierId: j['supplier_id'] as int,
    name: j['name'] as String? ?? 'Unknown Supplier',
    phone: j['phone'] as String? ?? j['contact'] as String?,
    gstin: j['gstin'] as String?,
    paymentTerms: j['payment_terms'] as String?,
    category: j['category'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'supplier_id': supplierId,
    'name': name,
    'phone': phone,
    'gstin': gstin,
    'payment_terms': paymentTerms,
    'category': category,
  };
}

/// Per-supplier dues + catalogue rollup for the supplier dashboard.
/// The backend returns these ordered by payment priority (overdue first,
/// then earliest due date, then largest outstanding).
class SupplierOverview {
  final int supplierId;
  final int productCount;
  final double unpaidTotal;
  final int unpaidOrders;
  final double overdueAmount;
  final DateTime? nextDueDate;

  const SupplierOverview({
    required this.supplierId,
    required this.productCount,
    required this.unpaidTotal,
    required this.unpaidOrders,
    required this.overdueAmount,
    this.nextDueDate,
  });

  factory SupplierOverview.fromJson(Map<String, dynamic> j) => SupplierOverview(
    supplierId: (j['supplier_id'] as num).toInt(),
    productCount: (j['product_count'] as num? ?? 0).toInt(),
    unpaidTotal: (j['unpaid_total'] as num? ?? 0).toDouble(),
    unpaidOrders: (j['unpaid_orders'] as num? ?? 0).toInt(),
    overdueAmount: (j['overdue_amount'] as num? ?? 0).toDouble(),
    nextDueDate: j['next_due_date'] != null
        ? parseAsUtc(j['next_due_date'] as String)
        : null,
  );
}

/// A product tagged to a supplier (what they sell us).
class SupplierProduct {
  final int productId;
  final String name;
  final double? costPrice;
  final double stock;

  const SupplierProduct({
    required this.productId,
    required this.name,
    this.costPrice,
    required this.stock,
  });

  factory SupplierProduct.fromJson(Map<String, dynamic> j) => SupplierProduct(
    productId: (j['product_id'] as num).toInt(),
    name: (j['name'] ?? 'Product').toString(),
    costPrice: (j['cost_price'] as num?)?.toDouble(),
    stock: (j['stock'] as num? ?? 0).toDouble(),
  );
}

enum PurchaseStatus { pending, ordered, received, cancelled }

class PurchaseOrder {
  final int purchaseId;
  final int supplierId;
  final String supplierName;
  final DateTime purchaseDate;
  final DateTime? dueDate;
  final double totalAmount;
  final PurchaseStatus status;
  final String paymentStatus;
  final String? notes;
  final List<PurchaseItem> items;

  const PurchaseOrder({
    required this.purchaseId,
    required this.supplierId,
    required this.supplierName,
    required this.purchaseDate,
    this.dueDate,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    this.notes,
    this.items = const [],
  });

  factory PurchaseOrder.fromJson(
    Map<String, dynamic> j, {
    String? supplierName,
  }) => PurchaseOrder(
    purchaseId: j['purchase_id'] as int,
    supplierId: j['supplier_id'] as int,
    supplierName: supplierName ?? 'Supplier #${j['supplier_id']}',
    purchaseDate: parseAsUtc(
      j['order_date'] as String? ?? j['purchase_date'] as String?,
    ),
    dueDate: j['due_date'] != null ? parseAsUtc(j['due_date'] as String) : null,
    totalAmount: (j['total_amount'] as num?)?.toDouble() ?? 0.0,
    status: _parseStatus(j['status'] as String?),
    paymentStatus: j['payment_status'] as String? ?? 'unpaid',
    notes: j['notes'] as String?,
    items: [],
  );

  static PurchaseStatus _parseStatus(String? s) {
    switch (s?.toLowerCase()) {
      case 'ordered':
        return PurchaseStatus.ordered;
      case 'received':
        return PurchaseStatus.received;
      case 'cancelled':
        return PurchaseStatus.cancelled;
      default:
        return PurchaseStatus.pending;
    }
  }
}

class PurchaseItem {
  final int purchaseItemId;
  final int productId;
  final String productName;
  final double quantity;
  final double costPrice;

  const PurchaseItem({
    required this.purchaseItemId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.costPrice,
  });

  factory PurchaseItem.fromJson(
    Map<String, dynamic> j, {
    String? productName,
  }) => PurchaseItem(
    purchaseItemId: j['purchase_item_id'] as int,
    productId: j['product_id'] as int,
    productName:
        j['product_name'] as String? ??
        productName ??
        'Product #${j['product_id']}',
    quantity: (j['quantity'] as num?)?.toDouble() ?? 0.0,
    costPrice: (j['cost_price'] as num?)?.toDouble() ?? 0.0,
  );
}
