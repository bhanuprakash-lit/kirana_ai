import 'package:flutter/material.dart';

/// One tier in the basket auto-discount ladder. [max] is the upper bound of the
/// gross total for this tier (null = open-ended, the top tier).
class BasketTier {
  final String name; // bronze | silver | gold | platinum
  final double? max;
  final double discountPct;

  const BasketTier({required this.name, this.max, required this.discountPct});

  BasketTier copyWith({
    double? max,
    double? discountPct,
    bool clearMax = false,
  }) => BasketTier(
    name: name,
    max: clearMax ? null : (max ?? this.max),
    discountPct: discountPct ?? this.discountPct,
  );

  factory BasketTier.fromJson(Map<String, dynamic> j) => BasketTier(
    name: j['name'] as String,
    max: (j['max'] as num?)?.toDouble(),
    discountPct: (j['discount_pct'] as num? ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'max': max,
    'discount_pct': discountPct,
  };
}

class BasketTierConfig {
  final List<BasketTier> tiers; // always 4, ascending, last open-ended

  const BasketTierConfig({required this.tiers});

  static const defaults = BasketTierConfig(
    tiers: [
      BasketTier(name: 'bronze', max: 100, discountPct: 2),
      BasketTier(name: 'silver', max: 300, discountPct: 4),
      BasketTier(name: 'gold', max: 500, discountPct: 6),
      BasketTier(name: 'platinum', max: null, discountPct: 8),
    ],
  );

  factory BasketTierConfig.fromJson(Map<String, dynamic> j) {
    final raw = (j['tiers'] as List?)?.cast<Map<String, dynamic>>();
    if (raw == null || raw.length != 4) return defaults;
    return BasketTierConfig(tiers: raw.map(BasketTier.fromJson).toList());
  }

  Map<String, dynamic> toJson() => {
    'tiers': tiers.map((t) => t.toJson()).toList(),
  };

  BasketTierConfig withTierAt(int i, BasketTier tier) {
    final next = [...tiers];
    next[i] = tier;
    return BasketTierConfig(tiers: next);
  }

  /// Resolve (tierName, discountPct) for a gross total — mirrors the backend.
  BasketTier tierFor(double grossTotal) {
    for (final t in tiers) {
      if (t.max == null || grossTotal <= t.max!) return t;
    }
    return tiers.last;
  }

  /// Final discounted price for a gross total.
  double priceFor(double grossTotal) {
    final t = tierFor(grossTotal);
    final p = grossTotal * (1 - t.discountPct / 100.0);
    return double.parse(p.toStringAsFixed(2));
  }

  /// Boundaries must strictly ascend and be positive.
  bool get isValid {
    final bounds = tiers.take(3).map((t) => t.max).toList();
    if (bounds.any((b) => b == null || b <= 0)) return false;
    for (var i = 0; i < bounds.length - 1; i++) {
      if (bounds[i]! >= bounds[i + 1]!) return false;
    }
    return tiers.every((t) => t.discountPct >= 0 && t.discountPct <= 100);
  }
}

/// Display metadata for each tier (icon + colour), keyed by tier name.
class TierStyle {
  final Color color;
  final IconData icon;
  const TierStyle(this.color, this.icon);

  static const _map = {
    'bronze': TierStyle(Color(0xFFCD7F32), Icons.workspace_premium_rounded),
    'silver': TierStyle(Color(0xFF9CA3AF), Icons.workspace_premium_rounded),
    'gold': TierStyle(Color(0xFFD4A017), Icons.workspace_premium_rounded),
    'platinum': TierStyle(Color(0xFF7C3AED), Icons.diamond_rounded),
  };

  static TierStyle of(String? tier) =>
      _map[tier] ??
      const TierStyle(Color(0xFF9CA3AF), Icons.workspace_premium_rounded);
}
