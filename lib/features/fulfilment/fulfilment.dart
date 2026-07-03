import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../profile/models/customer_model.dart';
import '../../shared/widgets/customer_picker.dart';

/// Module M6 — Orders & Fulfilment: estimates/proforma + customer returns.

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
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Estimates & Returns'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Estimates'),
            Tab(text: 'Returns'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabs, children: [_estimates(), _returns()]),
    );
  }

  Widget _estimates() {
    final async = ref.watch(estimatesProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No estimates yet.',
                      style: TextStyle(color: BrandColors.muted),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final e = list[i];
                    return Container(
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
                                  e['customer_name']?.toString() ?? 'Customer',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '#${e['estimate_id']} · ${e['status']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: BrandColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${(e['total'] as num?)?.toStringAsFixed(0) ?? "0"}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addEst',
            onPressed: _addEstimate,
            icon: const Icon(Icons.add),
            label: const Text('New estimate'),
          ),
        ),
      ],
    );
  }

  Widget _returns() {
    final async = ref.watch(returnsProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No returns logged.',
                      style: TextStyle(color: BrandColors.muted),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final r = list[i];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: BrandColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            r['is_exchange'] == true
                                ? Icons.swap_horiz_rounded
                                : Icons.assignment_return_rounded,
                            color: BrandColors.muted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${r['reason'] ?? "Return"}${r['order_id'] != null ? " · order #${r['order_id']}" : ""}',
                              style: const TextStyle(
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
                    );
                  },
                ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addRet',
            onPressed: _addReturn,
            icon: const Icon(Icons.assignment_return),
            label: const Text('Log return'),
          ),
        ),
      ],
    );
  }

  void _addEstimate() {
    final item = TextEditingController();
    final qty = TextEditingController(text: '1');
    final price = TextEditingController();
    Customer? customer;
    _sheet(
      'New estimate',
      [
        // Pick the customer from the store list instead of free-typing a name.
        StatefulBuilder(
          builder: (ctx, setSt) => InkWell(
            onTap: () async {
              final picked = await showCustomerPicker(ctx, ref);
              if (picked != null) setSt(() => customer = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Customer (optional)',
                suffixIcon: Icon(Icons.arrow_drop_down_rounded),
              ),
              child: Text(
                customer == null ? 'Select customer' : customer!.name,
                style: TextStyle(
                  color: customer == null ? BrandColors.muted : BrandColors.ink,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: item,
          decoration: const InputDecoration(labelText: 'Item'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: qty,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Qty'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: price,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Unit price ₹'),
              ),
            ),
          ],
        ),
      ],
      () async {
        if (item.text.trim().isEmpty) return false;
        await ref.read(apiClientProvider).post('/kirana/estimates', {
          if (customer != null) ...{
            'customer_id': customer!.customerId,
            'customer_name': customer!.name,
          },
          'items': [
            {
              'name': item.text.trim(),
              'quantity': double.tryParse(qty.text.trim()) ?? 1,
              'unit_price': double.tryParse(price.text.trim()) ?? 0,
            },
          ],
        });
        ref.invalidate(estimatesProvider);
        return true;
      },
    );
  }

  void _addReturn() {
    final orderId = TextEditingController();
    final reason = TextEditingController();
    final refund = TextEditingController();
    bool exchange = false;
    _sheet(
      'Log return / exchange',
      [
        TextField(
          controller: orderId,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Order # (optional)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reason,
          decoration: const InputDecoration(labelText: 'Reason'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: refund,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Refund ₹'),
        ),
        StatefulBuilder(
          builder: (ctx, setSt) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: exchange,
            onChanged: (v) => setSt(() => exchange = v ?? false),
            title: const Text('Exchange (not refund)'),
          ),
        ),
      ],
      () async {
        await ref.read(apiClientProvider).post('/kirana/sales-returns', {
          if (orderId.text.trim().isNotEmpty)
            'order_id': int.tryParse(orderId.text.trim()),
          if (reason.text.trim().isNotEmpty) 'reason': reason.text.trim(),
          'refund_amount': double.tryParse(refund.text.trim()) ?? 0,
          'is_exchange': exchange,
        });
        ref.invalidate(returnsProvider);
        return true;
      },
    );
  }

  void _sheet(
    String title,
    List<Widget> fields,
    Future<bool> Function() onSave,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
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
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              ...fields,
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () async {
                    if (await onSave() && ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
