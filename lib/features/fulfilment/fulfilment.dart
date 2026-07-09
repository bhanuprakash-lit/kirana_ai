import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../pos_inventory/providers/pos_provider.dart';
import '../pos_inventory/views/widgets/return_sheet.dart';
import 'estimate_views.dart';

/// Module M6 — Orders & Fulfilment: estimates/proforma + customer returns.
///
/// Returns are RECORDED through the POS return sheet (item-level: restock +
/// return-to-vendor + refund in one transaction) — either from an order's
/// details screen or via the order picker here. This tab is the unified,
/// read-only history of those returns.

final estimatesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/estimates');
  final l = (d is Map ? d['estimates'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
});

final returnsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/sales-returns');
  final l = (d is Map ? d['returns'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
});

class FulfilmentScreen extends ConsumerStatefulWidget {
  const FulfilmentScreen({super.key});
  @override
  ConsumerState<FulfilmentScreen> createState() => _FulfilmentScreenState();
}

class _FulfilmentScreenState extends ConsumerState<FulfilmentScreen>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.fulTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.fulTabEstimates),
            Tab(text: l10n.fulTabReturns),
          ],
        ),
      ),
      body: TabBarView(controller: _tabs, children: [_estimates(), _returns()]),
    );
  }

  Widget _estimates() {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(estimatesProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              _ErrorState(onRetry: () => ref.invalidate(estimatesProvider)),
          data: (list) => list.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: BrandColors.muted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.estEmpty,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _EstimateTile(list[i]),
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addEst',
            onPressed: () => showEstimateEditor(context, ref),
            icon: const Icon(Icons.add),
            label: Text(l10n.estNewEstimate),
          ),
        ),
      ],
    );
  }

  Widget _returns() {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(returnsProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorState(
            onRetry: () {
              ref.invalidate(returnsProvider);
            },
          ),
          data: (list) => list.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_return_outlined,
                          size: 48,
                          color: BrandColors.muted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.fulNoReturns,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _ReturnTile(list[i]),
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addRet',
            onPressed: _logReturn,
            icon: const Icon(Icons.assignment_return),
            label: Text(l10n.fulLogReturn),
          ),
        ),
      ],
    );
  }

  /// Recording a return starts from the ORDER (so items/prices come from what
  /// was actually billed): pick a recent order → the same POS return sheet.
  Future<void> _logReturn() async {
    final order = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _OrderPickerSheet(),
    );
    if (order == null || !mounted) return;
    await showReturnSheet(context, ref, order);
    ref.invalidate(returnsProvider);
  }
}

/// One estimate in the list — tap to open the detail (status / convert / share).
class _EstimateTile extends ConsumerWidget {
  final Map<String, dynamic> e;
  const _EstimateTile(this.e);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = (e['status'] ?? 'draft').toString();
    final color = switch (status) {
      'accepted' => BrandColors.success,
      'rejected' => BrandColors.error,
      'sent' => BrandColors.primary,
      _ => BrandColors.muted,
    };
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () =>
          showEstimateDetail(context, ref, (e['estimate_id'] as num).toInt()),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e['customer_name']?.toString() ?? l10n.estWalkIn,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '#${e['estimate_id']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '₹${(e['total'] as num?)?.toStringAsFixed(0) ?? "0"}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const Icon(Icons.chevron_right_rounded, color: BrandColors.muted),
          ],
        ),
      ),
    );
  }
}

/// One return in the unified history: what came back, from which order,
/// where it went (shelf / vendor), and the refund.
class _ReturnTile extends StatelessWidget {
  final Map<String, dynamic> r;
  const _ReturnTile(this.r);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isExchange = r['is_exchange'] == true;
    final items = (r['items'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .toList();
    final restocked = items
        .where((i) => i['resaleable'] != false)
        .fold<num>(0, (s, i) => s + ((i['qty'] as num?) ?? 0));
    final damaged = items
        .where((i) => i['resaleable'] == false)
        .fold<num>(0, (s, i) => s + ((i['qty'] as num?) ?? 0));
    final itemsLine = items
        .map((i) => '${_trimQty(i['qty'])}× ${i['name'] ?? '—'}')
        .join(', ');
    final created = (r['created_at'] ?? '').toString();
    final date = created.length >= 10 ? created.substring(0, 10) : created;

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
          Row(
            children: [
              Icon(
                isExchange
                    ? Icons.swap_horiz_rounded
                    : Icons.assignment_return_rounded,
                size: 20,
                color: isExchange ? BrandColors.primary : BrandColors.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  [
                    if (isExchange) l10n.fulExchange else l10n.fulRefund,
                    if (r['order_id'] != null) '#${r['order_id']}',
                    date,
                  ].join(' · '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '₹${(r['refund_amount'] as num?)?.toStringAsFixed(0) ?? "0"}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          if (itemsLine.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              itemsLine,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
          if (restocked > 0 || damaged > 0) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                if (restocked > 0)
                  _badge(
                    '${_trimQty(restocked)} ${l10n.fulBackToShelf}',
                    BrandColors.success,
                  ),
                if (damaged > 0)
                  _badge(
                    '${_trimQty(damaged)} ${l10n.fulToVendor}',
                    const Color(0xFFE87722),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _trimQty(Object? q) {
    final v = (q as num?)?.toDouble() ?? 0;
    return v.truncateToDouble() == v ? '${v.toInt()}' : '$v';
  }

  Widget _badge(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
    ),
  );
}

/// Searchable recent-orders picker: the entry point for logging a return when
/// the owner isn't already on the order's details screen.
class _OrderPickerSheet extends ConsumerStatefulWidget {
  const _OrderPickerSheet();

  @override
  ConsumerState<_OrderPickerSheet> createState() => _OrderPickerSheetState();
}

class _OrderPickerSheetState extends ConsumerState<_OrderPickerSheet> {
  List<Map<String, dynamic>>? _orders;
  String _query = '';

  @override
  void initState() {
    super.initState();
    ref
        .read(posProvider.notifier)
        .fetchAllOrders(limit: 100)
        .then((o) => mounted ? setState(() => _orders = o) : null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = _query.trim().toLowerCase();
    final filtered = (_orders ?? const <Map<String, dynamic>>[])
        .where(
          (o) =>
              q.isEmpty ||
              '${o['order_id']}'.contains(q) ||
              (o['customer_name']?.toString().toLowerCase().contains(q) ??
                  false),
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
        builder: (_, sc) => Container(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Text(
                  l10n.fulPickOrderTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: l10n.fulSearchOrders,
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
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
              Expanded(
                child: _orders == null
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.fulNoOrders,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      )
                    : ListView.builder(
                        controller: sc,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final o = filtered[i];
                          final created = (o['created_at'] ?? '').toString();
                          final date = created.length >= 10
                              ? created.substring(0, 10)
                              : created;
                          final n = (o['items'] as List<dynamic>?)?.length ?? 0;
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              '#${o['order_id']}'
                              '${o['customer_name'] != null ? " · ${o['customer_name']}" : ""}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '$date · $n ${l10n.fulItems}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.muted,
                              ),
                            ),
                            trailing: Text(
                              '₹${(o['total_amount'] as num?)?.toStringAsFixed(0) ?? "0"}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onTap: () => Navigator.pop(context, o),
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

/// Friendly retryable error state (replaces raw exception dumps).
class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              l10n.fulLoadFailed,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.fulRetry),
            ),
          ],
        ),
      ),
    );
  }
}
