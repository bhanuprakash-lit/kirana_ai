import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/product_picker.dart';

/// Module M7 — Warranty & Serial (electronics).

final claimsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/warranty-claims');
  final l = (d is Map ? d['claims'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
});

final serialsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/serials');
  final l = (d is Map ? d['serials'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
});

class WarrantyScreen extends ConsumerStatefulWidget {
  const WarrantyScreen({super.key});
  @override
  ConsumerState<WarrantyScreen> createState() => _WarrantyScreenState();
}

class _WarrantyScreenState extends ConsumerState<WarrantyScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  String _serialQuery = '';
  String? _statusFilter; // null = all

  @override
  void initState() {
    super.initState();
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSerials = _tabs.index == 1;
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.wtyTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.wtyTabClaims),
            Tab(text: l10n.wtyTabSerials),
          ],
        ),
      ),
      body: TabBarView(controller: _tabs, children: [_claims(), _serials()]),
      floatingActionButton: onSerials
          ? FloatingActionButton.extended(
              onPressed: _addSerial,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.wtyAddSerial),
            )
          : FloatingActionButton.extended(
              onPressed: _newClaim,
              icon: const Icon(Icons.add_task_rounded),
              label: Text(l10n.wtyNewClaim),
            ),
    );
  }

  /// Create a warranty claim against a sold serial/IMEI.
  void _newClaim() {
    final l10n = AppLocalizations.of(context);
    Map<String, dynamic>? serial;
    final issue = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
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
                  l10n.wtyNewClaim,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                // Pick the serial/IMEI the claim is about (never free-typed).
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final picked = await _pickSerial();
                    if (picked != null) setSt(() => serial = picked);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.wtySerialImei,
                      suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                    ),
                    child: Text(
                      serial == null
                          ? l10n.wtySelectSerial
                          : serial!['serial_no'].toString(),
                      style: TextStyle(
                        color: serial == null
                            ? BrandColors.muted
                            : BrandColors.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: issue,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: l10n.wtyIssue),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () async {
                      if (serial == null) return;
                      await ref
                          .read(apiClientProvider)
                          .post('/kirana/warranty-claims', {
                            'serial_id': serial!['serial_id'],
                            'product_id': serial!['product_id'],
                            if (serial!['customer_id'] != null)
                              'customer_id': serial!['customer_id'],
                            if (issue.text.trim().isNotEmpty)
                              'issue': issue.text.trim(),
                          });
                      ref.invalidate(claimsProvider);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text(l10n.wtyCreateClaim),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _pickSerial() {
    final serials = ref.read(serialsProvider).asData?.value ?? const [];
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SerialPickerSheet(serials: serials),
    );
  }

  Widget _claims() {
    final async = ref.watch(claimsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => list.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  AppLocalizations.of(context).wtyNoClaims,
                  style: TextStyle(color: BrandColors.muted),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final c = list[i];
                final status = (c['status'] ?? 'open').toString();
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${c['product_name'] ?? "Product"}${c['serial_no'] != null ? " · ${c['serial_no']}" : ""}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      if (c['customer_name'] != null || c['claim_date'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            [
                              if (c['customer_name'] != null)
                                c['customer_name'].toString(),
                              if (c['claim_date'] != null)
                                c['claim_date'].toString().length >= 10
                                    ? c['claim_date'].toString().substring(
                                        0,
                                        10,
                                      )
                                    : c['claim_date'].toString(),
                            ].join('  ·  '),
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: BrandColors.muted,
                            ),
                          ),
                        ),
                      if (c['issue'] != null)
                        Text(
                          c['issue'].toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: BrandColors.muted,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: ['open', 'resolved', 'rejected'].map((st) {
                          return ChoiceChip(
                            label: Text(
                              st,
                              style: const TextStyle(fontSize: 11),
                            ),
                            selected: status == st,
                            onSelected: (_) async {
                              await ref.read(apiClientProvider).patch(
                                '/kirana/warranty-claims/${c['claim_id']}',
                                {'status': st},
                              );
                              ref.invalidate(claimsProvider);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _serials() {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(serialsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) {
        final q = _serialQuery.trim().toLowerCase();
        final filtered = list.where((s) {
          final matchesStatus =
              _statusFilter == null || s['status'] == _statusFilter;
          final matchesQuery =
              q.isEmpty ||
              (s['serial_no']?.toString().toLowerCase().contains(q) ?? false) ||
              (s['product_name']?.toString().toLowerCase().contains(q) ??
                  false);
          return matchesStatus && matchesQuery;
        }).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                onChanged: (v) => setState(() => _serialQuery = v),
                decoration: InputDecoration(
                  hintText: l10n.wtySearchSerials,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: BrandColors.border),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final st in [null, 'in_stock', 'sold'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_statusLabel(l10n, st)),
                        selected: _statusFilter == st,
                        onSelected: (_) => setState(() => _statusFilter = st),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text(
                        l10n.wtyNoSerials,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _SerialCard(filtered[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  String _statusLabel(AppLocalizations l10n, String? st) =>
      _serialStatusLabel(l10n, st);

  /// Register a serial/IMEI outside checkout (e.g. warehouse intake): pick the
  /// product (or scan), type the serial (or scan).
  Future<void> _addSerial() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddSerialSheet(),
    );
    if (saved == true) ref.invalidate(serialsProvider);
  }
}

/// One serial/IMEI with product, sold date, and a warranty-status badge.
class _SerialCard extends StatelessWidget {
  final Map<String, dynamic> s;
  const _SerialCard(this.s);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sold = s['status'] == 'sold';
    final warrantyUntil = s['warranty_until']?.toString();
    final soldAt = s['sold_at']?.toString();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s['serial_no']?.toString() ?? '—',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              _statusChip(sold ? l10n.wtySold : l10n.wtyInStock, sold),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            s['product_name']?.toString() ?? l10n.wtyProduct,
            style: const TextStyle(fontSize: 12.5, color: BrandColors.ink),
          ),
          if (soldAt != null && soldAt.length >= 10)
            Text(
              '${l10n.wtySoldOn} ${soldAt.substring(0, 10)}',
              style: const TextStyle(fontSize: 11, color: BrandColors.muted),
            ),
          if (warrantyUntil != null && warrantyUntil.length >= 10) ...[
            const SizedBox(height: 6),
            _WarrantyBadge(untilIso: warrantyUntil.substring(0, 10)),
          ],
        ],
      ),
    );
  }

  Widget _statusChip(String label, bool sold) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: (sold ? BrandColors.primary : BrandColors.muted).withValues(
        alpha: 0.12,
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: sold ? BrandColors.primary : BrandColors.muted,
      ),
    ),
  );
}

/// Warranty-until pill coloured by urgency: expired (red), expiring ≤30d
/// (amber), or active (green).
class _WarrantyBadge extends StatelessWidget {
  final String untilIso;
  const _WarrantyBadge({required this.untilIso});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final until = DateTime.tryParse(untilIso);
    if (until == null) return const SizedBox.shrink();
    final days = until.difference(DateTime.now()).inDays;
    final (Color color, String text) = days < 0
        ? (BrandColors.error, '${l10n.wtyExpired} $untilIso')
        : days <= 30
        ? (const Color(0xFFE87722), '${l10n.wtyExpires} $untilIso')
        : (BrandColors.success, '${l10n.wtyWarrantyTill} $untilIso');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Add a serial/IMEI to stock (product picker + optional warranty).
class _AddSerialSheet extends ConsumerStatefulWidget {
  const _AddSerialSheet();
  @override
  ConsumerState<_AddSerialSheet> createState() => _AddSerialSheetState();
}

class _AddSerialSheetState extends ConsumerState<_AddSerialSheet> {
  int? _productId;
  String? _productName;
  final _serial = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _serial.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_productId == null) {
      setState(() => _error = l10n.wtyPickProduct);
      return;
    }
    if (_serial.text.trim().isEmpty) {
      setState(() => _error = l10n.wtyEnterSerial);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(apiClientProvider).post('/kirana/serials', {
        'product_id': _productId,
        'serial_no': _serial.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = l10n.wtySaveFailed;
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
              l10n.wtyAddSerial,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final p = await showProductPicker(context, ref);
                if (p != null) {
                  setState(() {
                    _productId = p.productId;
                    _productName = p.displayName;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.wtyProduct,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.search_rounded),
                ),
                child: Text(
                  _productName ?? l10n.wtySelectProduct,
                  style: TextStyle(
                    color: _productName == null
                        ? BrandColors.muted
                        : BrandColors.ink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _serial,
              decoration: InputDecoration(
                labelText: l10n.wtySerialImei,
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
                    : Text(l10n.wtySave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Searchable serial/IMEI picker for the new-claim flow. Sold serials first
/// (those are what get claimed). Returns the chosen serial row, or null.
/// Human, localized label for a serial's status. Shared by the serials list
/// and the picker sheet. Falls back to the raw value for statuses we don't yet
/// have a translation for (e.g. a future 'claimed'/'returned').
String _serialStatusLabel(AppLocalizations l10n, String? st) => switch (st) {
  null => l10n.wtyAll,
  'in_stock' => l10n.wtyInStock,
  'sold' => l10n.wtySold,
  _ => st,
};

class _SerialPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> serials;
  const _SerialPickerSheet({required this.serials});

  @override
  State<_SerialPickerSheet> createState() => _SerialPickerSheetState();
}

class _SerialPickerSheetState extends State<_SerialPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sorted = [...widget.serials]
      ..sort((a, b) {
        final aSold = (a['status'] == 'sold') ? 0 : 1;
        final bSold = (b['status'] == 'sold') ? 0 : 1;
        return aSold.compareTo(bSold);
      });
    final q = _query.toLowerCase();
    final filtered = q.isEmpty
        ? sorted
        : sorted
              .where(
                (s) => (s['serial_no']?.toString().toLowerCase() ?? '')
                    .contains(q),
              )
              .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: BrandColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: l10n.wtyPickerSearchHint,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: BrandColors.muted,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.wtyNoSerials,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final s = filtered[i];
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              s['serial_no']?.toString() ?? '—',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              _serialStatusLabel(
                                l10n, s['status']?.toString() ?? 'in_stock',
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.muted,
                              ),
                            ),
                            onTap: () => Navigator.pop(context, s),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
