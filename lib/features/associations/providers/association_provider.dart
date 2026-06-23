import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../models/association_model.dart';

// ── Associations list ─────────────────────────────────────────────────────────

class AssociationNotifier extends AsyncNotifier<List<StoreAssociation>> {
  @override
  Future<List<StoreAssociation>> build() {
    ref.watch(storeScopeProvider); // rebuild when the active store changes
    return _fetch();
  }

  Future<List<StoreAssociation>> _fetch() async {
    final client = ref.read(apiClientProvider);
    try {
      final res =
          await client.get('/kirana/associations') as Map<String, dynamic>;
      return (res['associations'] as List)
          .map((e) => StoreAssociation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<StoreAssociation> add({
    required String name,
    required AreaType areaType,
    int? estimatedHouseholds,
    String? notes,
  }) async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.post('/kirana/associations', {
              'name': name,
              'area_type': areaType.name,
              'estimated_households': estimatedHouseholds,
              if (notes?.isNotEmpty == true) 'notes': notes,
            })
            as Map<String, dynamic>;
    final created = StoreAssociation.fromJson(res);
    state = AsyncData([created, ...state.value ?? []]);
    return created;
  }

  Future<void> delete(int associationId) async {
    final client = ref.read(apiClientProvider);
    await client.delete('/kirana/associations/$associationId');
    state = AsyncData(
      (state.value ?? [])
          .where((a) => a.associationId != associationId)
          .toList(),
    );
  }

  Future<void> toggleActive(StoreAssociation assoc) async {
    final client = ref.read(apiClientProvider);
    await client.patch('/kirana/associations/${assoc.associationId}', {
      'is_active': !assoc.isActive,
    });
    await refresh();
  }
}

final associationProvider =
    AsyncNotifierProvider<AssociationNotifier, List<StoreAssociation>>(
      AssociationNotifier.new,
    );

// ── Heatmap ───────────────────────────────────────────────────────────────────

class HeatmapNotifier extends AsyncNotifier<List<AssociationHeatmap>> {
  @override
  Future<List<AssociationHeatmap>> build() {
    ref.watch(storeScopeProvider); // rebuild when the active store changes
    return _fetch();
  }

  Future<List<AssociationHeatmap>> _fetch() async {
    final client = ref.read(apiClientProvider);
    try {
      final res =
          await client.get('/kirana/associations/heatmap')
              as Map<String, dynamic>;
      return (res['heatmap'] as List)
          .map((e) => AssociationHeatmap.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final heatmapProvider =
    AsyncNotifierProvider<HeatmapNotifier, List<AssociationHeatmap>>(
      HeatmapNotifier.new,
    );
