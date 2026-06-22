import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../profile/models/customer_model.dart';
import '../../shared/widgets/customer_picker.dart';

/// Module M9 — Job Cards (alteration / repair / pre-order).

class JobCard {
  final int jobId;
  final String jobType;
  final String displayName;
  final String? itemDesc;
  final double? charge;
  final String status;
  final String? promisedDate;
  const JobCard({
    required this.jobId,
    required this.jobType,
    required this.displayName,
    this.itemDesc,
    this.charge,
    required this.status,
    this.promisedDate,
  });
  factory JobCard.fromJson(Map<String, dynamic> j) => JobCard(
        jobId: (j['job_id'] as num).toInt(),
        jobType: (j['job_type'] ?? 'repair').toString(),
        displayName: (j['customer_name'] ?? 'Customer').toString(),
        itemDesc: j['item_desc'] as String?,
        charge: (j['charge'] as num?)?.toDouble(),
        status: (j['status'] ?? 'received').toString(),
        promisedDate: j['promised_date']?.toString(),
      );
}

final jobCardsProvider = FutureProvider<List<JobCard>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/job-cards');
  final l = (d is Map ? d['job_cards'] : null) as List<dynamic>? ?? [];
  return l.whereType<Map>().map((e) => JobCard.fromJson(e.cast<String, dynamic>())).toList();
});

const _statuses = ['received', 'in_progress', 'ready', 'delivered', 'cancelled'];

class JobCardsScreen extends ConsumerWidget {
  const JobCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(jobCardsProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: const Text('Job Cards')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New job'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No job cards yet.\nTrack alterations, repairs and pre-orders here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: BrandColors.muted))))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _card(context, ref, list[i]),
              ),
      ),
    );
  }

  Widget _card(BuildContext context, WidgetRef ref, JobCard j) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: BrandColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(j.jobType,
                style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.primary,
                    fontWeight: FontWeight.w700)),
          ),
          const Spacer(),
          if (j.charge != null)
            Text('₹${j.charge!.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 6),
        Text('${j.displayName}${j.itemDesc != null ? " · ${j.itemDesc}" : ""}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        if (j.promisedDate != null)
          Text('Promised: ${j.promisedDate}',
              style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          children: _statuses.map((st) {
            final on = j.status == st;
            return ChoiceChip(
              label: Text(st.replaceAll('_', ' '),
                  style: const TextStyle(fontSize: 11)),
              selected: on,
              onSelected: (_) async {
                await ref.read(apiClientProvider).patch(
                    '/kirana/job-cards/${j.jobId}', {'status': st});
                ref.invalidate(jobCardsProvider);
              },
            );
          }).toList(),
        ),
      ]),
    );
  }

  void _add(BuildContext context, WidgetRef ref) {
    final item = TextEditingController();
    final charge = TextEditingController();
    String type = 'repair';
    Customer? customer;
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
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('New job card',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'repair', label: Text('Repair')),
                  ButtonSegment(value: 'alteration', label: Text('Alteration')),
                  ButtonSegment(value: 'preorder', label: Text('Pre-order')),
                ],
                selected: {type},
                onSelectionChanged: (s) => setSt(() => type = s.first),
              ),
              const SizedBox(height: 12),
              // Pick the customer from the store list (never free-typed) — also
              // captures their phone for follow-up.
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final picked = await showCustomerPicker(context, ref);
                  if (picked != null) setSt(() => customer = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                  ),
                  child: Text(
                    customer == null
                        ? 'Select customer'
                        : '${customer!.name}${customer!.phone.isNotEmpty ? " · ${customer!.phone}" : ""}',
                    style: TextStyle(
                      color: customer == null
                          ? BrandColors.muted
                          : BrandColors.ink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(controller: item, decoration: const InputDecoration(labelText: 'Item / description')),
              const SizedBox(height: 12),
              TextField(
                controller: charge,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Charge ₹ (optional)'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () async {
                    if (customer == null) return;
                    await ref.read(apiClientProvider).post('/kirana/job-cards', {
                      'job_type': type,
                      'customer_id': customer!.customerId,
                      'customer_name': customer!.name,
                      if (customer!.phone.isNotEmpty)
                        'customer_phone': customer!.phone,
                      if (item.text.trim().isNotEmpty) 'item_desc': item.text.trim(),
                      if (charge.text.trim().isNotEmpty)
                        'charge': double.tryParse(charge.text.trim()),
                    });
                    ref.invalidate(jobCardsProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Create'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
