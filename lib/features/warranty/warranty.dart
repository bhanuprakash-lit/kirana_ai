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
        bottom: TabBar(controller: _tabs, tabs: const [
          Tab(text: 'Claims'),
          Tab(text: 'Serials'),
        ]),
      ),
      body: TabBarView(controller: _tabs, children: [_claims(), _serials()]),
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
                  child: Text('No warranty claims logged.',
                      style: TextStyle(color: BrandColors.muted))))
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
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${c['product_name'] ?? "Product"}${c['serial_no'] != null ? " · ${c['serial_no']}" : ""}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    if (c['issue'] != null)
                      Text(c['issue'].toString(),
                          style: const TextStyle(
                              fontSize: 12, color: BrandColors.muted)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 6, children: ['open', 'resolved', 'rejected'].map((st) {
                      return ChoiceChip(
                        label: Text(st, style: const TextStyle(fontSize: 11)),
                        selected: status == st,
                        onSelected: (_) async {
                          await ref.read(apiClientProvider).patch(
                              '/kirana/warranty-claims/${c['claim_id']}', {'status': st});
                          ref.invalidate(claimsProvider);
                        },
                      );
                    }).toList()),
                  ]),
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
                  child: Text('No serials registered.',
                      style: TextStyle(color: BrandColors.muted))))
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
