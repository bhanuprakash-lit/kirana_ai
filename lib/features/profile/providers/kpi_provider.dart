import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';

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

  const KpiState({
    required this.registry,
    required this.subscribedData,
    required this.subscribedIds,
  });

  Map<String, List<KpiRegistryItem>> get groupedRegistry {
    final map = <String, List<KpiRegistryItem>>{};
    for (final item in registry) {
      // Use 'Core Insights' for 'Common' business category
      final cat = item.category.toLowerCase() == 'common' ? 'Core Insights' : item.category;
      map.putIfAbsent(cat, () => []).add(item);
    }
    return map;
  }

  Map<String, List<KpiData>> get groupedSubscribedData {
    final map = <String, List<KpiData>>{};
    // Map kpiId to theme for lookup
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
  }) {
    return KpiState(
      registry: registry ?? this.registry,
      subscribedData: subscribedData ?? this.subscribedData,
      subscribedIds: subscribedIds ?? this.subscribedIds,
    );
  }
}

class KpiNotifier extends AsyncNotifier<KpiState> {
  static const _prefKey = 'subscribed_kpis';

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
    final subscribedIds = prefs.getStringList(_prefKey)?.toSet() ?? {};

    // Fetch registry and summary in parallel
    final registryFuture = client.get('/kirana/kpis/registry');
    final summaryFuture = client.get('/kirana/kpis/summary?store_id=$storeId');

    final registryRes = await registryFuture;
    final summaryRes = await summaryFuture;

    final registry = (registryRes['kpis'] as List)
        .map((e) => KpiRegistryItem.fromJson(e))
        .toList();

    final subscribedData = (summaryRes['kpis'] as List)
        .map((e) => KpiData.fromJson(e))
        .where((k) => subscribedIds.contains(k.kpiId))
        .toList();

    return KpiState(
      registry: registry,
      subscribedData: subscribedData,
      subscribedIds: subscribedIds,
    );
  }

  Future<Map<String, dynamic>?> fetchKpiDetail(String endpoint) async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;
    
    try {
      // Append store_id if not present
      final connector = endpoint.contains('?') ? '&' : '?';
      return await client.get('$endpoint${connector}store_id=$storeId');
    } catch (e) {
      return null;
    }
  }

  Future<void> save() async {
    final currentState = state.value;
    if (currentState == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, currentState.subscribedIds.toList());
    
    // Refresh to update subscribedData based on new selection
    await refresh();
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
