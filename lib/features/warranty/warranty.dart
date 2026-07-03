import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';

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
  late final _tabs = TabController(length: 2, vsync: this);
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Warranty & Serials'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Claims'),
            Tab(text: 'Serials'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabs, children: [_claims(), _serials()]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newClaim,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('New claim'),
      ),
    );
  }

  /// Create a warranty claim against a sold serial/IMEI.
  void _newClaim() {
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
                const Text(
                  'New warranty claim',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
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
                    decoration: const InputDecoration(
                      labelText: 'Serial / IMEI',
                      suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                    ),
                    child: Text(
                      serial == null
                          ? 'Select a serial'
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
                  decoration: const InputDecoration(
                    labelText: 'Issue / problem',
                  ),
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
                    child: const Text('Create claim'),
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
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No warranty claims logged.',
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
    final async = ref.watch(serialsProvider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (list) => list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No serials registered.',
                  style: TextStyle(color: BrandColors.muted),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = list[i];
                return ListTile(
                  title: Text(s['serial_no']?.toString() ?? '—'),
                  subtitle: Text('status: ${s['status'] ?? "in_stock"}'),
                );
              },
            ),
    );
  }
}

/// Searchable serial/IMEI picker for the new-claim flow. Sold serials first
/// (those are what get claimed). Returns the chosen serial row, or null.
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
                    hintText: 'Search serial / IMEI',
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
                    ? const Center(
                        child: Text(
                          'No serials registered.',
                          style: TextStyle(color: BrandColors.muted),
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
                              'status: ${s['status'] ?? "in_stock"}',
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
