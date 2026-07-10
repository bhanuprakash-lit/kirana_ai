import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/product_picker.dart';
import 'rack_data.dart';
import 'rack_picker.dart';

/// Module M3 — multi-rack stock. Racks are first-class: the owner sets up
/// shelf labels once (A1, TOP SHELF, …), then places products into them by
/// picking both from lists — no typed IDs, no near-duplicate labels. The point
/// of the screen is answering "where is item X?" fast.

class RackPlacement {
  final int id;
  final int productId;
  final String productName;
  final int? variantId;
  final String rack;
  final int? rackId;
  final double quantity;
  const RackPlacement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.rack,
    required this.rackId,
    required this.quantity,
  });
  factory RackPlacement.fromJson(Map<String, dynamic> j) => RackPlacement(
    id: (j['id'] as num).toInt(),
    productId: (j['product_id'] as num).toInt(),
    productName: (j['product_name'] ?? 'Product').toString(),
    variantId: (j['variant_id'] as num?)?.toInt(),
    rack: (j['rack'] ?? '').toString(),
    rackId: (j['rack_id'] as num?)?.toInt(),
    quantity: (j['quantity'] as num?)?.toDouble() ?? 0,
  );
}

final rackPlacementsProvider = FutureProvider<List<RackPlacement>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/racks/all');
  final l = (d is Map ? d['items'] : null) as List<dynamic>? ?? [];
  return l
      .whereType<Map>()
      .map((e) => RackPlacement.fromJson(e.cast<String, dynamic>()))
      .toList();
});

/// One rack card on the screen: a first-class rack (possibly empty), or a
/// legacy label group for placements created before racks became rows.
class _RackGroup {
  final StoreRack? rack;
  final String label;
  final List<RackPlacement> items;
  const _RackGroup({this.rack, required this.label, required this.items});
}

/// Open the "place stock in a rack" sheet, prefilled for a specific product.
/// Reused from the inventory screen so the owner can set a product's location
/// right where they manage it. Returns true if a placement was saved.
Future<bool?> showPlaceInRackSheet(
  BuildContext context,
  WidgetRef ref, {
  required int productId,
  required String productName,
  String? title,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PlaceSheet(
      initialProductId: productId,
      initialProductName: productName,
      title: title,
    ),
  );
}

/// Where is this product? Lists its current rack placements and lets the owner
/// add another — the inventory-side entry point to the rack system.
Future<void> showProductRacksSheet(
  BuildContext context,
  WidgetRef ref, {
  required int productId,
  required String productName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _ProductRacksSheet(productId: productId, productName: productName),
  );
}

class StockRacksScreen extends ConsumerStatefulWidget {
  const StockRacksScreen({super.key});
  @override
  ConsumerState<StockRacksScreen> createState() => _StockRacksScreenState();
}

class _StockRacksScreenState extends ConsumerState<StockRacksScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final placementsAsync = ref.watch(rackPlacementsProvider);
    final racksAsync = ref.watch(storeRacksProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.rackTitle),
        actions: [
          IconButton(
            tooltip: l10n.rackAddRack,
            icon: const Icon(Icons.playlist_add_rounded),
            onPressed: _addRack,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _placeStock(),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(l10n.rackPlaceStock),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.rackSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: BrandColors.border),
                ),
              ),
            ),
          ),
          Expanded(
            child: placementsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorState(onRetry: _refresh),
              data: (all) => _RackList(
                groups: _buildGroups(racksAsync.asData?.value ?? const [], all),
                query: _query,
                onEditPlacement: _editPlacement,
                onRackMenu: _rackMenu,
                onPlaceInRack: (g) => _placeStock(rack: g.rack),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// First-class racks (label order, empty ones included) followed by legacy
  /// label-only groups for placements that predate the rack table.
  List<_RackGroup> _buildGroups(
    List<StoreRack> racks,
    List<RackPlacement> placements,
  ) {
    final byRackId = <int, List<RackPlacement>>{};
    final legacyByLabel = <String, List<RackPlacement>>{};
    for (final p in placements) {
      if (p.rackId != null) {
        byRackId.putIfAbsent(p.rackId!, () => []).add(p);
      } else {
        legacyByLabel.putIfAbsent(p.rack, () => []).add(p);
      }
    }
    final groups = <_RackGroup>[
      for (final r in racks)
        _RackGroup(rack: r, label: r.label, items: byRackId[r.id] ?? const []),
    ];
    final known = racks.map((r) => r.id).toSet();
    // Placements pointing at a rack the racks call hasn't caught up with yet
    // (e.g. created seconds ago) still deserve a card.
    for (final e in byRackId.entries) {
      if (!known.contains(e.key)) {
        groups.add(_RackGroup(label: e.value.first.rack, items: e.value));
      }
    }
    final legacyLabels = legacyByLabel.keys.toList()..sort();
    for (final label in legacyLabels) {
      groups.add(_RackGroup(label: label, items: legacyByLabel[label]!));
    }
    return groups;
  }

  Future<void> _refresh() async {
    ref.invalidate(rackPlacementsProvider);
    ref.invalidate(storeRacksProvider);
  }

  // ── Rack management ────────────────────────────────────────────────────

  Future<void> _addRack() async {
    final l10n = AppLocalizations.of(context);
    final label = await _promptRackLabel(title: l10n.rackAddRack);
    if (label == null || !mounted) return;
    try {
      final res = await createRack(ref.read(apiClientProvider), label);
      await _refresh();
      if (!mounted) return;
      _toast(
        res.created ? l10n.rackAdded : l10n.rackAlreadyExists(res.rack.label),
        success: res.created,
      );
    } catch (_) {
      if (mounted) _toast(l10n.rackSaveFailed, success: false);
    }
  }

  Future<void> _rackMenu(_RackGroup g) async {
    final rack = g.rack;
    if (rack == null) return; // legacy label groups have no rack row to manage
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline_rounded),
              title: Text(l10n.rackRenameRack),
              onTap: () => Navigator.pop(ctx, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.merge_rounded),
              title: Text(l10n.rackMergeInto),
              onTap: () => Navigator.pop(ctx, 'merge'),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: BrandColors.error,
              ),
              title: Text(l10n.rackDeleteRack),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    final api = ref.read(apiClientProvider);
    if (action == 'rename') {
      final label = await _promptRackLabel(
        title: l10n.rackRenameRack,
        initial: rack.label,
      );
      if (label == null || !mounted) return;
      try {
        await renameRack(api, rack.id, label);
        await _refresh();
        if (mounted) _toast(l10n.rackRenamed);
      } on ApiException catch (e) {
        if (!mounted) return;
        _toast(
          e.statusCode == 409
              ? l10n.rackAlreadyExists(rackDisplayLabel(label))
              : l10n.rackSaveFailed,
          success: false,
        );
      } catch (_) {
        if (mounted) _toast(l10n.rackSaveFailed, success: false);
      }
    } else if (action == 'merge') {
      final target = await showRackPicker(context, ref);
      if (target == null || !mounted) return;
      if (target.id == rack.id) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.rackMergeInto),
          content: Text(l10n.rackMergeConfirm(rack.label, target.label)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
      try {
        await mergeRacks(api, rack.id, target.id);
        await _refresh();
        if (mounted) _toast(l10n.rackMerged);
      } catch (_) {
        if (mounted) _toast(l10n.rackSaveFailed, success: false);
      }
    } else if (action == 'delete') {
      try {
        await deleteRack(api, rack.id);
        await _refresh();
        if (mounted) _toast(l10n.rackDeleted);
      } on ApiException catch (e) {
        if (!mounted) return;
        _toast(
          e.statusCode == 409 ? l10n.rackDeleteNotEmpty : l10n.rackSaveFailed,
          success: false,
        );
      } catch (_) {
        if (mounted) _toast(l10n.rackSaveFailed, success: false);
      }
    }
  }

  Future<String?> _promptRackLabel({
    required String title,
    String? initial,
  }) async {
    final l10n = AppLocalizations.of(context);
    final ctrl = TextEditingController(text: initial ?? '');
    final label = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: l10n.rackNameLabel,
            hintText: l10n.rackLabelHint,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text(l10n.rackSave),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (label == null || rackLabelKey(label).isEmpty) return null;
    return label;
  }

  // ── Placements ─────────────────────────────────────────────────────────

  Future<void> _placeStock({StoreRack? rack}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _PlaceSheet(initialRackId: rack?.id, initialRackLabel: rack?.label),
    );
    if (result == true && mounted) {
      final msg = AppLocalizations.of(context).rackSaved;
      await _refresh();
      if (mounted) _toast(msg);
    }
  }

  Future<void> _editPlacement(RackPlacement p) async {
    final l10n = AppLocalizations.of(context);
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.tune_rounded),
              title: Text(l10n.rackChangeQty),
              onTap: () => Navigator.pop(ctx, 'qty'),
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move_outline),
              title: Text(l10n.rackMove),
              onTap: () => Navigator.pop(ctx, 'move'),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: BrandColors.error,
              ),
              title: Text(l10n.rackRemove),
              onTap: () => Navigator.pop(ctx, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    final api = ref.read(apiClientProvider);
    if (action == 'remove') {
      await api.delete('/kirana/locations/${p.id}');
      await _refresh();
      if (mounted) _toast(l10n.rackRemoved);
    } else if (action == 'qty') {
      final result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _PlaceSheet(
          initialProductId: p.productId,
          initialProductName: p.productName,
          initialRackId: p.rackId,
          initialRackLabel: p.rack,
          rackLocked: true,
          initialQty: p.quantity,
          title: l10n.rackChangeQty,
        ),
      );
      if (result == true && mounted) {
        await _refresh();
        if (mounted) _toast(l10n.rackSaved);
      }
    } else if (action == 'move') {
      // Move = pick the destination rack; the quantity travels along.
      final target = await showRackPicker(context, ref);
      if (target == null || !mounted) return;
      if (p.rackId != null && target.id == p.rackId) return; // same rack
      try {
        await api.post('/kirana/products/${p.productId}/locations', {
          'rack_id': target.id,
          'quantity': p.quantity,
          if (p.variantId != null) 'variant_id': p.variantId,
        });
        await api.delete('/kirana/locations/${p.id}');
        await _refresh();
        if (mounted) _toast(l10n.rackMoved);
      } catch (_) {
        if (mounted) _toast(l10n.rackSaveFailed, success: false);
      }
    }
  }

  void _toast(String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? BrandColors.success : BrandColors.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Rack cards in label order. Search filters by product name or rack label;
/// empty racks stay visible so the owner sees their whole shelf layout.
class _RackList extends StatelessWidget {
  final List<_RackGroup> groups;
  final String query;
  final void Function(RackPlacement) onEditPlacement;
  final void Function(_RackGroup) onRackMenu;
  final void Function(_RackGroup) onPlaceInRack;
  const _RackList({
    required this.groups,
    required this.query,
    required this.onEditPlacement,
    required this.onRackMenu,
    required this.onPlaceInRack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = query.trim().toLowerCase();

    // A group survives the search if its label matches (kept whole) or any of
    // its items match (narrowed to those items).
    final visible = <_RackGroup>[];
    for (final g in groups) {
      if (q.isEmpty || g.label.toLowerCase().contains(q)) {
        visible.add(g);
        continue;
      }
      final hits = g.items
          .where((p) => p.productName.toLowerCase().contains(q))
          .toList();
      if (hits.isNotEmpty) {
        visible.add(_RackGroup(rack: g.rack, label: g.label, items: hits));
      }
    }

    if (groups.isEmpty) {
      return _Empty(icon: Icons.grid_view_rounded, message: l10n.rackEmpty);
    }
    if (visible.isEmpty) {
      return _Empty(icon: Icons.search_off_rounded, message: l10n.rackNoMatch);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: visible.length,
      itemBuilder: (_, i) {
        final g = visible[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: g.rack == null ? null : () => onRackMenu(g),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 6, 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shelves,
                        size: 18,
                        color: BrandColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          g.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        '${g.items.length} ${l10n.rackItems}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                      if (g.rack != null)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            size: 18,
                            color: BrandColors.muted,
                          ),
                          onPressed: () => onRackMenu(g),
                        )
                      else
                        const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              if (g.items.isEmpty)
                InkWell(
                  onTap: () => onPlaceInRack(g),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_location_alt_outlined,
                          size: 16,
                          color: BrandColors.muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.rackEmptyHint,
                          style: const TextStyle(
                            fontSize: 12,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              for (final p in g.items)
                ListTile(
                  dense: true,
                  title: Text(
                    p.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _trimQty(p.quantity),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.more_vert_rounded,
                        size: 18,
                        color: BrandColors.muted,
                      ),
                    ],
                  ),
                  onTap: () => onEditPlacement(p),
                ),
            ],
          ),
        );
      },
    );
  }

  static String _trimQty(double v) =>
      v.truncateToDouble() == v ? '${v.toInt()}' : '$v';
}

/// Place / re-quantity a product in a rack. Product comes from the shared
/// product picker, rack from the rack picker — both lists, never typed IDs.
class _PlaceSheet extends ConsumerStatefulWidget {
  final int? initialProductId;
  final String? initialProductName;
  final int? initialRackId;
  final String? initialRackLabel;
  final bool rackLocked;
  final double? initialQty;
  final String? title;
  const _PlaceSheet({
    this.initialProductId,
    this.initialProductName,
    this.initialRackId,
    this.initialRackLabel,
    this.rackLocked = false,
    this.initialQty,
    this.title,
  });

  @override
  ConsumerState<_PlaceSheet> createState() => _PlaceSheetState();
}

class _PlaceSheetState extends ConsumerState<_PlaceSheet> {
  int? _productId;
  String? _productName;
  int? _rackId;
  String? _rackLabel;
  late final TextEditingController _qty;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _productId = widget.initialProductId;
    _productName = widget.initialProductName;
    _rackId = widget.initialRackId;
    _rackLabel = widget.initialRackLabel;
    final q0 = widget.initialQty;
    _qty = TextEditingController(
      text: q0 == null
          ? ''
          : (q0.truncateToDouble() == q0 ? '${q0.toInt()}' : '$q0'),
    );
  }

  @override
  void dispose() {
    _qty.dispose();
    super.dispose();
  }

  Future<void> _pickProduct() async {
    final p = await showProductPicker(context, ref);
    if (p != null) {
      setState(() {
        _productId = p.productId;
        _productName = p.displayName;
      });
    }
  }

  Future<void> _pickRack() async {
    final r = await showRackPicker(context, ref);
    if (r != null) {
      setState(() {
        _rackId = r.id;
        _rackLabel = r.label;
      });
    }
  }

  Future<void> _save() async {
    if (_productId == null) {
      setState(
        () => _error = AppLocalizations.of(context).rackPickProductFirst,
      );
      return;
    }
    if (_rackId == null && (_rackLabel == null || _rackLabel!.isEmpty)) {
      setState(() => _error = AppLocalizations.of(context).rackPickRackFirst);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(apiClientProvider)
          .post('/kirana/products/$_productId/locations', {
            // Legacy placements (pre rack-table) may only carry a label; the
            // backend resolves it to a rack via the same normalization.
            if (_rackId != null) 'rack_id': _rackId else 'rack': _rackLabel,
            'quantity': double.tryParse(_qty.text.trim()) ?? 0,
          });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = AppLocalizations.of(context).rackSaveFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final productLocked = widget.initialProductId != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? l10n.rackPlaceStock,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            // Product picker — never a raw ID.
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: productLocked ? null : _pickProduct,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.rackProduct,
                  border: const OutlineInputBorder(),
                  suffixIcon: productLocked
                      ? null
                      : const Icon(Icons.search_rounded),
                ),
                child: Text(
                  _productName ?? l10n.rackSelectProduct,
                  style: TextStyle(
                    color: _productName == null
                        ? BrandColors.muted
                        : BrandColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Rack picker — existing racks first; new labels are created there.
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.rackLocked ? null : _pickRack,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.rackLabel,
                  border: const OutlineInputBorder(),
                  suffixIcon: widget.rackLocked
                      ? null
                      : const Icon(Icons.expand_more_rounded),
                ),
                child: Text(
                  _rackLabel ?? l10n.rackChooseRack,
                  style: TextStyle(
                    color: _rackLabel == null
                        ? BrandColors.muted
                        : BrandColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qty,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.rackQuantity,
                border: const OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(color: BrandColors.error, fontSize: 13),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.rackSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Per-product rack view for the inventory long-press: current placements plus
/// a button to place it into a (new) rack.
class _ProductRacksSheet extends ConsumerStatefulWidget {
  final int productId;
  final String productName;
  const _ProductRacksSheet({
    required this.productId,
    required this.productName,
  });

  @override
  ConsumerState<_ProductRacksSheet> createState() => _ProductRacksSheetState();
}

class _ProductRacksSheetState extends ConsumerState<_ProductRacksSheet> {
  List<Map<String, dynamic>>? _rows;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await ref
        .read(apiClientProvider)
        .get('/kirana/products/${widget.productId}/locations');
    final l = (d is Map ? d['locations'] : null) as List<dynamic>? ?? [];
    if (mounted) {
      setState(
        () => _rows = l
            .whereType<Map>()
            .map((e) => e.cast<String, dynamic>())
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = _rows;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rackLocation,
              style: const TextStyle(fontSize: 13, color: BrandColors.muted),
            ),
            const SizedBox(height: 2),
            Text(
              widget.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            if (rows == null)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.rackNoneForProduct,
                  style: const TextStyle(color: BrandColors.muted),
                ),
              )
            else
              ...rows.map(
                (r) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.shelves,
                    color: BrandColors.primary,
                  ),
                  title: Text(r['rack']?.toString() ?? '—'),
                  trailing: Text(
                    _trimNum(r['quantity']),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () async {
                  final saved = await showPlaceInRackSheet(
                    context,
                    ref,
                    productId: widget.productId,
                    productName: widget.productName,
                  );
                  if (saved == true) {
                    ref.invalidate(rackPlacementsProvider);
                    ref.invalidate(storeRacksProvider);
                    await _load();
                  }
                },
                icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                label: Text(l10n.rackSetLocation),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _trimNum(Object? q) {
    final v = (q as num?)?.toDouble() ?? 0;
    return v.truncateToDouble() == v ? '${v.toInt()}' : '$v';
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String message;
  const _Empty({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: BrandColors.muted.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: BrandColors.muted),
          ),
        ],
      ),
    ),
  );
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 44,
            color: BrandColors.muted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.rackLoadFailed,
            style: const TextStyle(color: BrandColors.muted),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l10n.rackRetry),
          ),
        ],
      ),
    );
  }
}
