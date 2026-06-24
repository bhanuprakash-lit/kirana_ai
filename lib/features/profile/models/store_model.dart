class StoreProfile {
  final int storeId;
  final String name;
  final String type;
  final int footfall;
  final double budget;
  final double dailyBudget;
  final String? location;
  final String? region;
  final String? city; // M2 — zone/city rollup
  final String? verticalCode; // F1 — current vertical (switchable)

  const StoreProfile({
    required this.storeId,
    required this.name,
    required this.type,
    required this.footfall,
    required this.budget,
    required this.dailyBudget,
    this.location,
    this.region,
    this.city,
    this.verticalCode,
  });

  StoreProfile copyWith({String? city, String? verticalCode}) => StoreProfile(
    storeId: storeId,
    name: name,
    type: type,
    footfall: footfall,
    budget: budget,
    dailyBudget: dailyBudget,
    location: location,
    region: region,
    city: city ?? this.city,
    verticalCode: verticalCode ?? this.verticalCode,
  );

  factory StoreProfile.fromJson(Map<String, dynamic> j) => StoreProfile(
    storeId: j['store_id'] as int,
    name: j['store_name'] as String? ?? 'My Store',
    type: j['store_type'] as String? ?? 'kirana',
    footfall: (j['footfall'] as num?)?.toInt() ?? 0,
    budget: (j['budget'] as num?)?.toDouble() ?? 0.0,
    dailyBudget: (j['daily_budget'] as num?)?.toDouble() ?? 0.0,
    location: j['location'] as String?,
    region: j['region'] as String?,
    city: j['city'] as String?,
    verticalCode: j['vertical_code'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'store_name': name,
    'store_type': type,
    'footfall': footfall,
    'budget': budget,
    'daily_budget': dailyBudget,
    'location': location,
    'region': region,
    if (city != null) 'city': city,
    if (verticalCode != null) 'vertical_code': verticalCode,
  };
}
