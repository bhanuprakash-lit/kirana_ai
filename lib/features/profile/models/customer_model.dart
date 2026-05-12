class Customer {
  final int customerId;
  final String name;
  final String phone;
  final String? email;
  final int householdSize;
  final DateTime? createdAt;
  
  // Computed fields (fetched via aggregations or separate calls)
  final double totalSpent;
  final int totalOrders;
  final double currentBalance; 

  Customer({
    required this.customerId,
    required this.name,
    required this.phone,
    this.email,
    this.householdSize = 4,
    this.createdAt,
    this.totalSpent = 0.0,
    this.totalOrders = 0,
    this.currentBalance = 0.0,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'] as int,
      name: json['name'] as String? ?? 'Unknown',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      householdSize: (json['household_size'] as num?)?.toInt() ?? 4,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      currentBalance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
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
  }) {
    return Customer(
      customerId: customerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      householdSize: householdSize ?? this.householdSize,
      createdAt: createdAt,
      totalSpent: totalSpent ?? this.totalSpent,
      totalOrders: totalOrders ?? this.totalOrders,
      currentBalance: currentBalance ?? this.currentBalance,
    );
  }
}
