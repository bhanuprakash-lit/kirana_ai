import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/product_picker.dart';

/// Module M3 — multi-rack stock. Browse what's in each rack, and place a product
/// into a rack. The owner picks products by name/barcode (never a raw ID) and
/// browses racks visually — the point is to find "where is item X?" fast.

class RackPlacement {
  final int id;
  final int productId;
  final String productName;
  final int? variantId;
  final String rack;
  final double quantity;
  const RackPlacement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.rack,
    required this.quantity,
  });
  factory RackPlacement.fromJson(Map<String, dynamic> j) => RackPlacement(
    id: (j['id'] as num).toInt(),
    productId: (j['product_id'] as num).toInt(),
    productName: (j['product_name'] ?? 'Product').toString(),
    variantId: (j['variant_id'] as num?)?.toInt(),
    rack: (j['rack'] ?? '').toString(),
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

/// Open the "place stock in a rack" sheet, prefilled for a specific product.
/// Reused from the inventory screen so the owner can set a product's location
/// right where they manage it. Returns true if a placement was saved.
Future<bool?> showPlaceInRackSheet(
  BuildContext context,
  WidgetRef ref, {
  required int productId,
  required String productName,
  String? rack,
  double? qty,
  String? title,
}) {
  final known =
      (ref.read(rackPlacementsProvider).asData?.value ??
              const <RackPlacement>[])
          .map((p) => p.rack)
          .toSet()
          .toList()
        ..sort();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PlaceSheet(
      initialProductId: productId,
      initialProductName: productName,
      initialRack: rack,
      initialQty: qty,
      knownRacks: known,
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
    final async = ref.watch(rackPlacementsProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.rackTitle)),
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
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorState(
                onRetry: () => ref.invalidate(rackPlacementsProvider),
              ),
              data: (all) =>
                  _RackList(all: all, query: _query, onEdit: _editPlacement),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async => ref.invalidate(rackPlacementsProvider);

  Future<void> _placeStock({
    int? productId,
    String? productName,
    String? rack,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlaceSheet(
        initialProductId: productId,
        initialProductName: productName,
        initialRack: rack,
        knownRacks: _knownRacks(),
      ),
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
    if (action == 'remove') {
      await ref.read(apiClientProvider).delete('/kirana/locations/${p.id}');
      await _refresh();
      if (mounted) _toast(l10n.rackRemoved);
    } else if (action == 'qty') {
      await _placeStock(
        productId: p.productId,
        productName: p.productName,
        rack: p.rack,
      );
    } else if (action == 'move') {
      // Move = place into the new rack, then drop the old placement.
      final moved = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _PlaceSheet(
          initialProductId: p.productId,
          initialProductName: p.productName,
          initialQty: p.quantity,
          knownRacks: _knownRacks(),
          title: l10n.rackMove,
        ),
      );
      if (moved == true) {
        await ref.read(apiClientProvider).delete('/kirana/locations/${p.id}');
        await _refresh();
        if (mounted) _toast(l10n.rackMoved);
      }
    }
  }

  List<String> _knownRacks() {
    final data = ref.read(rackPlacementsProvider).asData?.value ?? const [];
    final set = <String>{for (final p in data) p.rack};
    final list = set.toList()..sort();
    return list;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: BrandColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Placements grouped by rack. Search filters by product name or rack label.
class _RackList extends StatelessWidget {
  final List<RackPlacement> all;
  final String query;
  final void Function(RackPlacement) onEdit;
  const _RackList({
    required this.all,
    required this.query,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all
              .where(
                (p) =>
                    p.productName.toLowerCase().contains(q) ||
                    p.rack.toLowerCase().contains(q),
              )
              .toList();

    if (all.isEmpty) {
      return _Empty(icon: Icons.grid_view_rounded, message: l10n.rackEmpty);
    }
    if (filtered.isEmpty) {
      return _Empty(icon: Icons.search_off_rounded, message: l10n.rackNoMatch);
    }

    // Group by rack, preserving sorted order.
    final byRack = <String, List<RackPlacement>>{};
    for (final p in filtered) {
      byRack.putIfAbsent(p.rack, () => []).add(p);
    }
    final racks = byRack.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      itemCount: racks.length,
      itemBuilder: (_, i) {
        final rack = racks[i];
        final items = byRack[rack]!;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shelves,
                      size: 18,
                      color: BrandColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rack,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${items.length} ${l10n.rackItems}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              for (final p in items)
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
                  onTap: () => onEdit(p),
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

/// Place / move / re-quantity a product into a rack. Product is chosen via the
/// shared product picker; rack is typed or chosen from existing racks.
class _PlaceSheet extends ConsumerStatefulWidget {
  final int? initialProductId;
  final String? initialProductName;
  final String? initialRack;
  final double? initialQty;
  final List<String> knownRacks;
  final String? title;
  const _PlaceSheet({
    this.initialProductId,
    this.initialProductName,
    this.initialRack,
    this.initialQty,
    this.knownRacks = const [],
    this.title,
  });

  @override
  ConsumerState<_PlaceSheet> createState() => _PlaceSheetState();
}

class _PlaceSheetState extends ConsumerState<_PlaceSheet> {
  int? _productId;
  String? _productName;
  late final TextEditingController _rack;
  late final TextEditingController _qty;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _productId = widget.initialProductId;
    _productName = widget.initialProductName;
    _rack = TextEditingController(text: widget.initialRack ?? '');
    final q0 = widget.initialQty;
    _qty = TextEditingController(
      text: q0 == null
          ? ''
          : (q0.truncateToDouble() == q0 ? '${q0.toInt()}' : '$q0'),
    );
  }

  @override
  void dispose() {
    _rack.dispose();
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

  Future<void> _save() async {
    final rack = _rack.text.trim();
    if (_productId == null) {
      setState(
        () => _error = AppLocalizations.of(context).rackPickProductFirst,
      );
      return;
    }
    if (rack.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).rackNeedLabel);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(apiClientProvider).post(
        '/kirana/products/$_productId/locations',
        {'rack': rack, 'quantity': double.tryParse(_qty.text.trim()) ?? 0},
      );
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
              onTap: _productId == null || widget.initialProductId == null
                  ? _pickProduct
                  : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.rackProduct,
                  border: const OutlineInputBorder(),
                  suffixIcon: widget.initialProductId == null
                      ? const Icon(Icons.search_rounded)
                      : null,
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
            _RackField(controller: _rack, knownRacks: widget.knownRacks),
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

/// Rack label input with quick-pick chips for racks already in use.
class _RackField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> knownRacks;
  const _RackField({required this.controller, required this.knownRacks});

  @override
  State<_RackField> createState() => _RackFieldState();
}

class _RackFieldState extends State<_RackField> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          textCapitalization: TextCapitalization.characters,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.rackLabel,
            hintText: l10n.rackLabelHint,
            border: const OutlineInputBorder(),
          ),
        ),
        if (widget.knownRacks.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.knownRacks
                .take(12)
                .map(
                  (r) => ActionChip(
                    label: Text(r, style: const TextStyle(fontSize: 12)),
                    onPressed: () => setState(() => widget.controller.text = r),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
        ],
      ],
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
