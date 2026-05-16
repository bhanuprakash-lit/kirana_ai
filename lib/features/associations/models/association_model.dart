enum AreaType { apartment, hostel, school, office, colony }

extension AreaTypeX on AreaType {
  String get label {
    switch (this) {
      case AreaType.apartment: return 'Apartment';
      case AreaType.hostel:    return 'Hostel';
      case AreaType.school:    return 'School';
      case AreaType.office:    return 'Office';
      case AreaType.colony:    return 'Colony';
    }
  }

  String get emoji {
    switch (this) {
      case AreaType.apartment: return '🏢';
      case AreaType.hostel:    return '🏠';
      case AreaType.school:    return '🏫';
      case AreaType.office:    return '🏗️';
      case AreaType.colony:    return '🏘️';
    }
  }

  String get description {
    switch (this) {
      case AreaType.apartment: return 'Monthly grocery subscriptions';
      case AreaType.hostel:    return 'Snacks + instant food combos';
      case AreaType.school:    return 'Tiffin snacks, stationery, juice';
      case AreaType.office:    return 'Tea, snacks, quick lunch items';
      case AreaType.colony:    return 'Sunday family basket';
    }
  }

  static AreaType fromString(String s) =>
      AreaType.values.firstWhere((t) => t.name == s, orElse: () => AreaType.colony);
}

class StoreAssociation {
  final int associationId;
  final int storeId;
  final String name;
  final AreaType areaType;
  final int? estimatedHouseholds;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;

  const StoreAssociation({
    required this.associationId,
    required this.storeId,
    required this.name,
    required this.areaType,
    this.estimatedHouseholds,
    this.notes,
    required this.isActive,
    this.createdAt,
  });

  factory StoreAssociation.fromJson(Map<String, dynamic> j) => StoreAssociation(
        associationId: (j['association_id'] as num).toInt(),
        storeId: (j['store_id'] as num).toInt(),
        name: j['name'] as String,
        areaType: AreaTypeX.fromString(j['area_type'] as String? ?? 'colony'),
        estimatedHouseholds: (j['estimated_households'] as num?)?.toInt(),
        notes: j['notes'] as String?,
        isActive: j['is_active'] as bool? ?? true,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );
}

class AssociationHeatmap {
  final int associationId;
  final String areaName;
  final AreaType areaType;
  final int? estimatedHouseholds;
  final int customerCount;
  final int totalOrders;
  final double totalRevenue;
  final double avgOrderValue;
  final DateTime? lastOrderAt;

  const AssociationHeatmap({
    required this.associationId,
    required this.areaName,
    required this.areaType,
    this.estimatedHouseholds,
    required this.customerCount,
    required this.totalOrders,
    required this.totalRevenue,
    required this.avgOrderValue,
    this.lastOrderAt,
  });

  factory AssociationHeatmap.fromJson(Map<String, dynamic> j) => AssociationHeatmap(
        associationId: (j['association_id'] as num).toInt(),
        areaName: j['area_name'] as String,
        areaType: AreaTypeX.fromString(j['area_type'] as String? ?? 'colony'),
        estimatedHouseholds: (j['estimated_households'] as num?)?.toInt(),
        customerCount: (j['customer_count'] as num? ?? 0).toInt(),
        totalOrders: (j['total_orders'] as num? ?? 0).toInt(),
        totalRevenue: (j['total_revenue'] as num? ?? 0).toDouble(),
        avgOrderValue: (j['avg_order_value'] as num? ?? 0).toDouble(),
        lastOrderAt: j['last_order_at'] != null
            ? DateTime.tryParse(j['last_order_at'] as String)
            : null,
      );
}
