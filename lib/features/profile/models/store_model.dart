class StoreProfile {
  final int storeId;
  final String name;
  final String type;
  final int footfall;
  final double budget;
  final double dailyBudget;
  final String? location;
  final String? region;

  const StoreProfile({
    required this.storeId,
    required this.name,
    required this.type,
    required this.footfall,
    required this.budget,
    required this.dailyBudget,
    this.location,
    this.region,
  });

  factory StoreProfile.fromJson(Map<String, dynamic> j) => StoreProfile(
    storeId: j['store_id'] as int,
    name: j['store_name'] as String? ?? 'My Store',
    type: j['store_type'] as String? ?? 'kirana',
    footfall: (j['footfall'] as num?)?.toInt() ?? 0,
    budget: (j['budget'] as num?)?.toDouble() ?? 0.0,
    dailyBudget: (j['daily_budget'] as num?)?.toDouble() ?? 0.0,
    location: j['location'] as String?,
    region: j['region'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'store_name': name,
    'store_type': type,
    'footfall': footfall,
    'budget': budget,
    'daily_budget': dailyBudget,
    'location': location,
    'region': region,
  };
}
