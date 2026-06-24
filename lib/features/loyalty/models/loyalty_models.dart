/// Module M1 — Loyalty & Offers models.
library;

class LoyaltyConfig {
  final bool isActive;
  final double pointsPer100; // points earned per ₹100 spent
  final int redeemPaisePerPoint; // ₹ value of 1 point (100 paise = ₹1)
  final int silverThreshold;
  final int goldThreshold;

  const LoyaltyConfig({
    required this.isActive,
    required this.pointsPer100,
    required this.redeemPaisePerPoint,
    required this.silverThreshold,
    required this.goldThreshold,
  });

  static double _d(dynamic v, [double def = 0]) => v == null
      ? def
      : (v is num ? v.toDouble() : double.tryParse('$v') ?? def);
  static int _i(dynamic v, [int def = 0]) =>
      v == null ? def : (v is num ? v.toInt() : int.tryParse('$v') ?? def);

  factory LoyaltyConfig.fromJson(Map<String, dynamic> j) => LoyaltyConfig(
    isActive: j['is_active'] == true,
    pointsPer100: _d(j['points_per_100'], 1),
    redeemPaisePerPoint: _i(j['redeem_paise_per_point'], 100),
    silverThreshold: _i(j['silver_threshold'], 500),
    goldThreshold: _i(j['gold_threshold'], 2000),
  );

  static const fallback = LoyaltyConfig(
    isActive: false,
    pointsPer100: 1,
    redeemPaisePerPoint: 100,
    silverThreshold: 500,
    goldThreshold: 2000,
  );

  LoyaltyConfig copyWith({
    bool? isActive,
    double? pointsPer100,
    int? redeemPaisePerPoint,
    int? silverThreshold,
    int? goldThreshold,
  }) => LoyaltyConfig(
    isActive: isActive ?? this.isActive,
    pointsPer100: pointsPer100 ?? this.pointsPer100,
    redeemPaisePerPoint: redeemPaisePerPoint ?? this.redeemPaisePerPoint,
    silverThreshold: silverThreshold ?? this.silverThreshold,
    goldThreshold: goldThreshold ?? this.goldThreshold,
  );

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    'points_per_100': pointsPer100,
    'redeem_paise_per_point': redeemPaisePerPoint,
    'silver_threshold': silverThreshold,
    'gold_threshold': goldThreshold,
  };
}

class LoyaltyTxn {
  final double points;
  final String kind; // earn | redeem | bonus | adjust
  final String? note;
  final DateTime? at;

  const LoyaltyTxn({
    required this.points,
    required this.kind,
    this.note,
    this.at,
  });

  factory LoyaltyTxn.fromJson(Map<String, dynamic> j) => LoyaltyTxn(
    points: LoyaltyConfig._d(j['points']),
    kind: (j['kind'] ?? '').toString(),
    note: j['note'] as String?,
    at: j['created_at'] != null
        ? DateTime.tryParse(j['created_at'].toString())
        : null,
  );
}

class CustomerLoyalty {
  final int customerId;
  final double points;
  final String tier; // bronze | silver | gold
  final double redeemValue; // ₹ the balance is worth
  final List<LoyaltyTxn> history;

  const CustomerLoyalty({
    required this.customerId,
    required this.points,
    required this.tier,
    required this.redeemValue,
    this.history = const [],
  });

  factory CustomerLoyalty.fromJson(Map<String, dynamic> j) => CustomerLoyalty(
    customerId: LoyaltyConfig._i(j['customer_id']),
    points: LoyaltyConfig._d(j['points']),
    tier: (j['tier'] ?? 'bronze').toString(),
    redeemValue: LoyaltyConfig._d(j['redeem_value']),
    history: ((j['history'] as List?) ?? [])
        .whereType<Map>()
        .map((e) => LoyaltyTxn.fromJson(e.cast<String, dynamic>()))
        .toList(),
  );
}

class Coupon {
  final int couponId;
  final String code;
  final String discountType; // percent | flat
  final double value;
  final double minOrder;
  final double? maxDiscount;
  final int? usageLimit;
  final int usedCount;
  final bool isActive;

  const Coupon({
    required this.couponId,
    required this.code,
    required this.discountType,
    required this.value,
    required this.minOrder,
    this.maxDiscount,
    this.usageLimit,
    required this.usedCount,
    required this.isActive,
  });

  factory Coupon.fromJson(Map<String, dynamic> j) => Coupon(
    couponId: LoyaltyConfig._i(j['coupon_id']),
    code: (j['code'] ?? '').toString(),
    discountType: (j['discount_type'] ?? 'flat').toString(),
    value: LoyaltyConfig._d(j['value']),
    minOrder: LoyaltyConfig._d(j['min_order']),
    maxDiscount: j['max_discount'] == null
        ? null
        : LoyaltyConfig._d(j['max_discount']),
    usageLimit: j['usage_limit'] == null
        ? null
        : LoyaltyConfig._i(j['usage_limit']),
    usedCount: LoyaltyConfig._i(j['used_count']),
    isActive: j['is_active'] != false,
  );

  String get label => discountType == 'percent'
      ? '$code · ${value.toStringAsFixed(0)}% off'
      : '$code · ₹${value.toStringAsFixed(0)} off';
}
