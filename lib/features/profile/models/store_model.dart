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
  final bool gstEnabled; // V0.5 — store is GST-registered (store-level fact)

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
    this.gstEnabled = false,
  });

  StoreProfile copyWith({
    String? city,
    String? verticalCode,
    bool? gstEnabled,
  }) => StoreProfile(
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
    gstEnabled: gstEnabled ?? this.gstEnabled,
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
    gstEnabled: j['gst_enabled'] as bool? ?? false,
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
    'gst_enabled': gstEnabled,
  };
}
