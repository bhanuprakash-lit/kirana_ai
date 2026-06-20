/// Foundation 1 — the per-vertical config the app reads to branch behaviour
/// (feature flags, unit list, KPI/ML/tax profiles, copy). Fetched once from
/// `GET /kirana/vertical-config` and cached for the session.
///
/// Grocery has everything on, so [grocery] doubles as the safe fallback whenever
/// the network call fails — the UI then behaves exactly as it does today.
class VerticalConfig {
  final String verticalCode;
  final Map<String, dynamic> features;
  final List<String> unitSet;
  final Map<String, dynamic> copyPack;

  const VerticalConfig({
    required this.verticalCode,
    required this.features,
    required this.unitSet,
    required this.copyPack,
  });

  /// Whether a feature flag is explicitly enabled for this vertical.
  bool has(String feature) => features[feature] == true;

  /// Whether a feature is explicitly disabled (flag == false). Absent → not off,
  /// so features default to *shown* unless a vertical opts out (e.g. Vision is
  /// off for apparel/electronics but stays on for grocery and legacy stores).
  bool isOff(String feature) => features[feature] == false;

  factory VerticalConfig.fromJson(Map<String, dynamic> j) {
    final rawUnits = j['unit_set'];
    final units = rawUnits is List
        ? rawUnits.map((e) => e.toString()).toList()
        : const <String>[];
    return VerticalConfig(
      verticalCode: (j['vertical_code'] as String?) ?? 'grocery',
      features: (j['features'] as Map?)?.cast<String, dynamic>() ?? const {},
      unitSet: units.isNotEmpty ? units : grocery.unitSet,
      copyPack: (j['copy_pack'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
  }

  /// Grocery defaults — also the fallback when the fetch fails. Mirrors the
  /// backend `grocery` seed row and the historical hardcoded unit list.
  static const VerticalConfig grocery = VerticalConfig(
    verticalCode: 'grocery',
    features: {
      'expiry': true,
      'loose': true,
      'variants': false,
      'serial': false,
      'warranty': false,
    },
    unitSet: ['pcs', 'kg', 'g', 'L', 'ml', 'dozen', 'pack', 'box', 'bundle'],
    copyPack: {},
  );
}
