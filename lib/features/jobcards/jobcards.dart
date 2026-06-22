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
  final int? customerId;
  final String jobType;
  final String displayName;
  final String? phone;
  final String? itemDesc;
  final double? charge;
  final String status;
  final String? promisedDate;
  final String? receivedDate; // created_at
  const JobCard({
    required this.jobId,
    this.customerId,
    required this.jobType,
    required this.displayName,
    this.phone,
    this.itemDesc,
    this.charge,
    required this.status,
    this.promisedDate,
    this.receivedDate,
  });
  factory JobCard.fromJson(Map<String, dynamic> j) => JobCard(
        jobId: (j['job_id'] as num).toInt(),
        customerId: (j['customer_id'] as num?)?.toInt(),
        jobType: (j['job_type'] ?? 'repair').toString(),
        displayName: (j['customer_name'] ?? 'Customer').toString(),
        phone: j['customer_phone'] as String?,
        itemDesc: j['item_desc'] as String?,
        charge: (j['charge'] as num?)?.toDouble(),
        status: (j['status'] ?? 'received').toString(),
        promisedDate: j['promised_date']?.toString(),
        receivedDate: j['created_at']?.toString(),
      );
}

/// dd MMM from an ISO/date string; returns the raw string if unparseable.
String _shortDate(String? s) {
  if (s == null || s.isEmpty) return '';
  final dt = DateTime.tryParse(s);
  if (dt == null) return s;
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${dt.day} ${months[dt.month - 1]}';
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.edit_outlined,
                size: 18, color: BrandColors.muted),
            onPressed: () => _edit(context, ref, j),
          ),
        ]),
        const SizedBox(height: 6),
        Text('${j.displayName}${j.itemDesc != null ? " · ${j.itemDesc}" : ""}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        if (j.phone != null && j.phone!.isNotEmpty)
          Row(children: [
            const Icon(Icons.phone_rounded, size: 12, color: BrandColors.muted),
            const SizedBox(width: 4),
            Text(j.phone!,
                style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
          ]),
        const SizedBox(height: 4),
        Row(children: [
          if (j.receivedDate != null && j.receivedDate!.isNotEmpty)
            Text('Received: ${_shortDate(j.receivedDate)}',
                style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
          if (j.promisedDate != null && j.promisedDate!.isNotEmpty) ...[
            const SizedBox(width: 12),
            Text('Ready by: ${_shortDate(j.promisedDate)}',
                style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.primary,
                    fontWeight: FontWeight.w600)),
          ],
        ]),
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
    DateTime? readyBy;
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
              const SizedBox(height: 12),
              // Promised "ready by" date (estimate the customer gets).
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: readyBy ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setSt(() => readyBy = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ready by (optional)',
                    prefixIcon: Icon(Icons.event_rounded),
                  ),
                  child: Text(
                    readyBy == null
                        ? 'Select date'
                        : '${readyBy!.day}/${readyBy!.month}/${readyBy!.year}',
                    style: TextStyle(
                      color: readyBy == null ? BrandColors.muted : BrandColors.ink,
                    ),
                  ),
                ),
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
                      if (readyBy != null)
                        'promised_date': _isoDate(readyBy!),
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

  /// Edit an existing job card: item/description, charge and the ready-by date.
  void _edit(BuildContext context, WidgetRef ref, JobCard j) {
    final item = TextEditingController(text: j.itemDesc ?? '');
    final charge =
        TextEditingController(text: j.charge != null ? j.charge!.toStringAsFixed(0) : '');
    DateTime? readyBy = (j.promisedDate != null && j.promisedDate!.isNotEmpty)
        ? DateTime.tryParse(j.promisedDate!)
        : null;
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
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Edit job card',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(
                '${j.displayName}${j.phone != null && j.phone!.isNotEmpty ? " · ${j.phone}" : ""}',
                style: const TextStyle(fontSize: 13, color: BrandColors.muted),
              ),
              const SizedBox(height: 16),
              TextField(controller: item, decoration: const InputDecoration(labelText: 'Item / description')),
              const SizedBox(height: 12),
              TextField(
                controller: charge,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Charge ₹ (optional)'),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: readyBy ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setSt(() => readyBy = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Ready by',
                    prefixIcon: Icon(Icons.event_rounded),
                  ),
                  child: Text(
                    readyBy == null
                        ? 'Select date'
                        : '${readyBy!.day}/${readyBy!.month}/${readyBy!.year}',
                    style: TextStyle(
                      color: readyBy == null ? BrandColors.muted : BrandColors.ink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () async {
                    await ref.read(apiClientProvider).patch('/kirana/job-cards/${j.jobId}', {
                      'item_desc': item.text.trim(),
                      'charge': charge.text.trim().isNotEmpty
                          ? double.tryParse(charge.text.trim())
                          : null,
                      if (readyBy != null) 'promised_date': _isoDate(readyBy!),
                    });
                    ref.invalidate(jobCardsProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save changes'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
