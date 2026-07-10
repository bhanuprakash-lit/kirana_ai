import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';

/// First-class racks (Module M3). A rack exists on its own — it can be created
/// before anything is placed in it, renamed, merged and (when empty) deleted.
/// The backend folds case/space/punctuation variants of a label into one rack
/// ("A1" == "a 1" == "A-1"); [rackLabelKey] mirrors that rule client-side so
/// the UI can warn about duplicates before a round-trip.

class StoreRack {
  final int id;
  final String label;
  final int items;
  final double totalQty;
  const StoreRack({
    required this.id,
    required this.label,
    required this.items,
    required this.totalQty,
  });
  factory StoreRack.fromJson(Map<String, dynamic> j) => StoreRack(
    id: (j['rack_id'] as num).toInt(),
    label: (j['label'] ?? '').toString(),
    items: (j['items'] as num?)?.toInt() ?? 0,
    totalQty: (j['total_qty'] as num?)?.toDouble() ?? 0,
  );
}

/// Normalized rack identity — must match rack_label_key() on the backend.
String rackLabelKey(String label) => label
    .toUpperCase()
    .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '');

/// Canonical display spelling — trimmed, single-spaced, uppercased.
String rackDisplayLabel(String label) =>
    label.trim().replaceAll(RegExp(r'\s+'), ' ').toUpperCase();

final storeRacksProvider = FutureProvider<List<StoreRack>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/racks/list');
  final l = (d is Map ? d['racks'] : null) as List<dynamic>? ?? [];
  return l
      .whereType<Map>()
      .map((e) => StoreRack.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// Creates the rack (or returns the existing one when the normalized label is
/// already taken — the backend answers with `created: false`).
Future<({StoreRack rack, bool created})> createRack(
  ApiClient api,
  String label,
) async {
  final d =
      await api.post('/kirana/racks', {'label': label}) as Map<String, dynamic>;
  return (
    rack: StoreRack.fromJson({...d, 'items': 0, 'total_qty': 0}),
    created: (d['created'] as bool?) ?? true,
  );
}

/// Renames a rack. Throws [ApiException] with statusCode 409 when another rack
/// already owns the normalized label (offer merge instead).
Future<void> renameRack(ApiClient api, int rackId, String label) async {
  await api.patch('/kirana/racks/$rackId', {'label': label});
}

/// Deletes an empty rack. Throws [ApiException] 409 (`rack_not_empty`) when
/// items are still placed in it.
Future<void> deleteRack(ApiClient api, int rackId) async {
  await api.delete('/kirana/racks/$rackId');
}

/// Moves every placement of [sourceId] into [targetId] (summing quantities of
/// SKUs present in both) and deletes the source rack.
Future<void> mergeRacks(ApiClient api, int sourceId, int targetId) async {
  await api.post('/kirana/racks/$sourceId/merge', {'target_rack_id': targetId});
}
