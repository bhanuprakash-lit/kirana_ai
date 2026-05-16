import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';
import '../../subscription/models/subscription_model.dart';
import '../../subscription/providers/subscription_provider.dart';

@immutable
class KpiRegistryItem {
  final String kpiId;
  final String name;
  final String vertical;
  final String theme;
  final String category;
  final String why;
  final String target;
  final String baseline;
  final String aiAgent;
  final String status;
  final String? endpoint;

  const KpiRegistryItem({
    required this.kpiId,
    required this.name,
    required this.vertical,
    required this.theme,
    required this.category,
    required this.why,
    required this.target,
    required this.baseline,
    required this.aiAgent,
    required this.status,
    this.endpoint,
  });

  factory KpiRegistryItem.fromJson(Map<String, dynamic> json) {
    return KpiRegistryItem(
      kpiId: json['kpi_id'] ?? '',
      name: json['name'] ?? '',
      vertical: json['vertical'] ?? '',
      theme: json['theme'] ?? '',
      category: json['category'] ?? '',
      why: json['why'] ?? '',
      target: json['target'] ?? '',
      baseline: json['baseline'] ?? '',
      aiAgent: json['ai_agent'] ?? '',
      status: json['status'] ?? '',
      endpoint: json['endpoint'],
    );
  }
}

@immutable
class KpiData {
  final String kpiId;
  final String kpiKey;
  final String name;
  final dynamic value;
  final String? trendDirection;
  final double? trendPctChange;
  final String status;

  const KpiData({
    required this.kpiId,
    required this.kpiKey,
    required this.name,
    this.value,
    this.trendDirection,
    this.trendPctChange,
    required this.status,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) {
    return KpiData(
      kpiId: json['kpi_id'] ?? '',
      kpiKey: json['kpi_key'] ?? '',
      name: json['name'] ?? '',
      value: json['value'],
      trendDirection: json['trend_direction'],
      trendPctChange: (json['trend_pct_change'] as num?)?.toDouble(),
      status: json['status'] ?? '',
    );
  }
}

@immutable
class KpiState {
  final List<KpiRegistryItem> registry;
  final List<KpiData> subscribedData;
  final Set<String> subscribedIds;
  // kpi_id → 'basic'|'pro' as fetched from backend
  final Map<String, String> tierConfig;

  const KpiState({
    required this.registry,
    required this.subscribedData,
    required this.subscribedIds,
    this.tierConfig = const {},
  });

  Map<String, List<KpiRegistryItem>> get groupedRegistry {
    final map = <String, List<KpiRegistryItem>>{};
    for (final item in registry) {
      final cat = item.category.toLowerCase() == 'common' ? 'Core Insights' : item.category;
      map.putIfAbsent(cat, () => []).add(item);
    }
    return map;
  }

  /// Returns true if the given KPI is accessible for the provided subscription tier.
  /// Uses server-side tier config when available; falls back to positional defaults.
  bool isKpiAccessible(String kpiId, SubTier tier) {
    if (tier == SubTier.pro) return true;
    final required = tierConfig[kpiId];
    if (required != null) return required == 'basic';
    // Fallback: Core Insight category → pro only; first 3 per category → basic
    final grouped = groupedRegistry;
    for (final entry in grouped.entries) {
      final items = entry.value;
      final idx = items.indexWhere((k) => k.kpiId == kpiId);
      if (idx == -1) continue;
      if (entry.key == 'Core Insights') return false;
      return idx < 3;
    }
    return false;
  }

  Map<String, List<KpiData>> get groupedSubscribedData {
    final map = <String, List<KpiData>>{};
    final idToTheme = {
      for (final item in registry)
        item.kpiId: item.category.toLowerCase() == 'common' ? 'Core Insights' : item.category,
    };

    for (final data in subscribedData) {
      final cat = idToTheme[data.kpiId] ?? 'Other';
      map.putIfAbsent(cat, () => []).add(data);
    }
    return map;
  }

  KpiState copyWith({
    List<KpiRegistryItem>? registry,
    List<KpiData>? subscribedData,
    Set<String>? subscribedIds,
    Map<String, String>? tierConfig,
  }) {
    return KpiState(
      registry: registry ?? this.registry,
      subscribedData: subscribedData ?? this.subscribedData,
      subscribedIds: subscribedIds ?? this.subscribedIds,
      tierConfig: tierConfig ?? this.tierConfig,
    );
  }
}

class KpiNotifier extends AsyncNotifier<KpiState> {
  @override
  Future<KpiState> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<KpiState> _fetch() async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    // Fetch registry, summary, server prefs, and tier config in parallel
    final registryFuture = client.get('/kirana/kpis/registry');
    final summaryFuture  = client.get('/kirana/kpis/summary?store_id=$storeId');
    final prefsFuture    = client.get('/kirana/preferences');
    final tiersFuture    = client.get('/kirana/kpis/tiers');

    final registryRes = await registryFuture;
    final summaryRes  = await summaryFuture;
    final prefsRes    = await prefsFuture;
    final tiersRes    = await tiersFuture.catchError((_) => <String, dynamic>{});

    final registry = (registryRes['kpis'] as List)
        .map((e) => KpiRegistryItem.fromJson(e as Map<String, dynamic>))
        .toList();

    // Load subscribed IDs from server; default to Finance KPIs on first use
    final subscribedKpisStr = prefsRes['subscribed_kpis'] as String?;
    final Set<String> subscribedIds;

    if (subscribedKpisStr == null || subscribedKpisStr.isEmpty) {
      // First-time: default to all Finance category KPIs
      subscribedIds = registry
          .where((k) => k.category.toLowerCase().contains('finance'))
          .map((k) => k.kpiId)
          .toSet();
    } else {
      subscribedIds = subscribedKpisStr
          .split(',')
          .where((s) => s.isNotEmpty)
          .toSet();
    }

    final subscribedData = (summaryRes['kpis'] as List)
        .map((e) => KpiData.fromJson(e as Map<String, dynamic>))
        .where((k) => subscribedIds.contains(k.kpiId))
        .toList();

    final rawTiers = (tiersRes as Map<String, dynamic>?)?['tiers'] as Map<String, dynamic>? ?? {};
    final tierConfig = rawTiers.map((k, v) => MapEntry(k, v as String));

    return KpiState(
      registry: registry,
      subscribedData: subscribedData,
      subscribedIds: subscribedIds,
      tierConfig: tierConfig,
    );
  }

  Future<Map<String, dynamic>?> fetchKpiDetail(String endpoint) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    try {
      final connector = endpoint.contains('?') ? '&' : '?';
      return await client.get('$endpoint${connector}store_id=$storeId');
    } catch (e) {
      return null;
    }
  }

  Future<void> save() async {
    final currentState = state.value;
    if (currentState == null) return;

    final client = ref.read(apiClientProvider);
    final tier = ref.read(subTierProvider);

    // Strip KPIs the user's tier can't access before saving
    final accessibleIds = currentState.subscribedIds
        .where((id) => currentState.isKpiAccessible(id, tier))
        .toSet();

    await client.patch('/kirana/preferences', {
      'subscribed_kpis': accessibleIds.join(','),
    });

    // Silent refresh: fetch fresh data without showing loading indicator
    try {
      final newState = await _fetch();
      state = AsyncData(newState);
    } catch (_) {
      // If refresh fails, keep current state with updated selection
      final newSubscribedData = currentState.subscribedData
          .where((k) => currentState.subscribedIds.contains(k.kpiId))
          .toList();
      state = AsyncData(currentState.copyWith(subscribedData: newSubscribedData));
    }
  }

  void toggleKpi(String id) {
    final currentState = state.value;
    if (currentState == null) return;

    final newIds = Set<String>.from(currentState.subscribedIds);
    if (newIds.contains(id)) {
      newIds.remove(id);
    } else {
      newIds.add(id);
    }
    state = AsyncData(currentState.copyWith(subscribedIds: newIds));
  }

  void toggleCategory(String categoryName, bool subscribe) {
    final currentState = state.value;
    if (currentState == null) return;

    final newIds = Set<String>.from(currentState.subscribedIds);
    final group = currentState.groupedRegistry[categoryName] ?? [];

    for (final item in group) {
      if (subscribe) {
        newIds.add(item.kpiId);
      } else {
        newIds.remove(item.kpiId);
      }
    }
    state = AsyncData(currentState.copyWith(subscribedIds: newIds));
  }

  void selectAll() {
    final currentState = state.value;
    if (currentState == null) return;

    final allIds = currentState.registry.map((e) => e.kpiId).toSet();
    state = AsyncData(currentState.copyWith(subscribedIds: allIds));
  }

  void clearAll() {
    final currentState = state.value;
    if (currentState == null) return;

    state = AsyncData(currentState.copyWith(subscribedIds: {}));
  }
}

final kpiProvider = AsyncNotifierProvider.autoDispose<KpiNotifier, KpiState>(KpiNotifier.new);
