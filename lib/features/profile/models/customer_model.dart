import 'package:kirana_ai/core/utils/date_utils.dart';

class Customer {
  final int customerId;
  final String name;
  final String phone;
  final String? email;
  final int householdSize;
  final DateTime? createdAt;
  final DateTime? lastOrderDate;

  // Aggregated / computed
  final double totalSpent;
  final int totalOrders;
  final double currentBalance;
  final int orders30d;
  final int orders90d;
  final int? associationId;
  // M1 — loyalty/offers occasion dates
  final DateTime? birthday;
  final DateTime? anniversary;

  Customer({
    required this.customerId,
    required this.name,
    required this.phone,
    this.email,
    this.householdSize = 4,
    this.createdAt,
    this.lastOrderDate,
    this.totalSpent = 0.0,
    this.totalOrders = 0,
    this.currentBalance = 0.0,
    this.orders30d = 0,
    this.orders90d = 0,
    this.associationId,
    this.birthday,
    this.anniversary,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      householdSize: (json['household_size'] as num?)?.toInt() ?? 4,
      createdAt: json['created_at'] != null
          ? parseAsUtc(json['created_at'] as String)
          : null,
      lastOrderDate: json['last_order_date'] != null
          ? DateTime.tryParse(json['last_order_date'] as String)
          : null,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      currentBalance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      orders30d: (json['orders_30d'] as num?)?.toInt() ?? 0,
      orders90d: (json['orders_90d'] as num?)?.toInt() ?? 0,
      associationId: (json['association_id'] as num?)?.toInt(),
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'].toString())
          : null,
      anniversary: json['anniversary'] != null
          ? DateTime.tryParse(json['anniversary'].toString())
          : null,
    );
  }

  /// Returns all applicable segment labels for this customer.
  Set<String> get segments {
    final now = DateTime.now();
    final twoMonthsAgo = now.subtract(const Duration(days: 60));
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final segs = <String>{};

    final isInactive = lastOrderDate == null
        ? (createdAt == null || createdAt!.isBefore(thirtyDaysAgo))
        : lastOrderDate!.isBefore(twoMonthsAgo);

    if (isInactive) segs.add('inactive');
    if (currentBalance > 0) segs.add('credit');
    if (!isInactive && totalSpent >= 10000) segs.add('bulk');
    if (!isInactive && orders30d >= 3) segs.add('regular');
    if (!isInactive && !segs.contains('regular') && orders90d >= 1) {
      segs.add('occasional');
    }
    if (!isInactive && segs.isEmpty) segs.add('impulse');

    return segs;
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'phone': phone,
      'email': email,
      'household_size': householdSize,
      'total_spent': totalSpent,
      'total_orders': totalOrders,
      'balance': currentBalance,
    };
  }

  Customer copyWith({
    String? name,
    String? phone,
    String? email,
    int? householdSize,
    double? totalSpent,
    int? totalOrders,
    double? currentBalance,
    DateTime? lastOrderDate,
    int? orders30d,
    int? orders90d,
    Object? associationId = _sentinel,
  }) {
    return Customer(
      customerId: customerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      householdSize: householdSize ?? this.householdSize,
      createdAt: createdAt,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      totalSpent: totalSpent ?? this.totalSpent,
      totalOrders: totalOrders ?? this.totalOrders,
      currentBalance: currentBalance ?? this.currentBalance,
      orders30d: orders30d ?? this.orders30d,
      orders90d: orders90d ?? this.orders90d,
      associationId: associationId == _sentinel
          ? this.associationId
          : associationId as int?,
    );
  }
}

const _sentinel = Object();
