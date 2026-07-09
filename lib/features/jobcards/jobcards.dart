import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/store/store_scope.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
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
  final String? promisedTime; // HH:mm, when a ready-by time was set
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
    this.promisedTime,
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
    promisedTime: j['promised_time']?.toString(),
    receivedDate: j['created_at']?.toString(),
  );

  /// Promised date + time combined into one ISO-parseable string for display,
  /// e.g. "2026-06-25T14:30". Falls back to the date alone.
  String? get promisedDateTime {
    final d = promisedDate;
    if (d == null || d.isEmpty) return null;
    final t = promisedTime;
    if (t == null || t.isEmpty) return d;
    // promisedDate may itself carry a time; keep just the date part.
    final datePart = d.length >= 10 ? d.substring(0, 10) : d;
    return '${datePart}T$t';
  }
}

/// dd MMM from an ISO/date string; returns the raw string if unparseable.
String _shortDate(String? s) {
  if (s == null || s.isEmpty) return '';
  final dt = DateTime.tryParse(s);
  if (dt == null) return s;
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${dt.day} ${months[dt.month - 1]}';
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// HH:mm (24h) — the time component sent alongside the promised date.
String _isoTime(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

/// "dd MMM · h:mm am" for a promised date+time; date only if no time present.
String _shortDateTime(String? s) {
  if (s == null || s.isEmpty) return '';
  final dt = DateTime.tryParse(s);
  if (dt == null) return s;
  final base = _shortDate(s);
  // A date-only string parses to midnight — don't show a misleading "12:00 am".
  if (dt.hour == 0 && dt.minute == 0) return base;
  final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final ampm = dt.hour < 12 ? 'am' : 'pm';
  return '$base · $h12:${dt.minute.toString().padLeft(2, '0')} $ampm';
}

/// d/m/yyyy, plus h:mm am when a time was chosen (non-midnight).
String _readyByLabel(DateTime d) {
  final date = '${d.day}/${d.month}/${d.year}';
  if (d.hour == 0 && d.minute == 0) return date;
  final h12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final ampm = d.hour < 12 ? 'am' : 'pm';
  return '$date · $h12:${d.minute.toString().padLeft(2, '0')} $ampm';
}

/// Pick a date, then a time, returning the combined DateTime (or null).
Future<DateTime?> _pickDateTime(BuildContext context, DateTime? initial) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: initial ?? now,
    firstDate: now.subtract(const Duration(days: 365)),
    lastDate: now.add(const Duration(days: 365)),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial ?? now),
  );
  // Cancelling the time step keeps the date (defaults to midnight).
  return DateTime(
    date.year,
    date.month,
    date.day,
    time?.hour ?? 0,
    time?.minute ?? 0,
  );
}

final jobCardsProvider = FutureProvider<List<JobCard>>((ref) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final d = await ref.read(apiClientProvider).get('/kirana/job-cards');
  final l = (d is Map ? d['job_cards'] : null) as List<dynamic>? ?? [];
  return l
      .whereType<Map>()
      .map((e) => JobCard.fromJson(e.cast<String, dynamic>()))
      .toList();
});

const _statuses = [
  'received',
  'in_progress',
  'ready',
  'delivered',
  'cancelled',
];

/// Icon + accent colour per job type, for the card's type badge.
({IconData icon, Color color}) _jobTypeStyle(String type) {
  switch (type) {
    case 'alteration':
      return (icon: Icons.content_cut_rounded, color: BrandColors.purple);
    case 'preorder':
      return (icon: Icons.shopping_bag_rounded, color: BrandColors.accent);
    case 'repair':
    default:
      return (icon: Icons.build_rounded, color: BrandColors.primary);
  }
}

/// Accent colour per status chip — green when done, red when cancelled.
Color _statusColor(String status) {
  switch (status) {
    case 'ready':
    case 'delivered':
      return BrandColors.success;
    case 'cancelled':
      return BrandColors.error;
    default:
      return BrandColors.primary;
  }
}

class JobCardsScreen extends ConsumerWidget {
  const JobCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(jobCardsProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.jobTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.jobNewJob),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No job cards yet.\nTrack alterations, repairs and pre-orders here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BrandColors.muted),
                  ),
                ),
              )
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Builder(
                builder: (_) {
                  final ts = _jobTypeStyle(j.jobType);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ts.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(ts.icon, size: 12, color: ts.color),
                        const SizedBox(width: 4),
                        Text(
                          j.jobType,
                          style: TextStyle(
                            fontSize: 11,
                            color: ts.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              if (j.charge != null)
                Text(
                  '₹${j.charge!.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: BrandColors.muted,
                ),
                onPressed: () => _edit(context, ref, j),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${j.displayName}${j.itemDesc != null ? " · ${j.itemDesc}" : ""}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (j.phone != null && j.phone!.isNotEmpty)
            Row(
              children: [
                const Icon(
                  Icons.phone_rounded,
                  size: 12,
                  color: BrandColors.muted,
                ),
                const SizedBox(width: 4),
                Text(
                  j.phone!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (j.receivedDate != null && j.receivedDate!.isNotEmpty)
                Text(
                  'Received: ${_shortDate(j.receivedDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
              if (j.promisedDate != null && j.promisedDate!.isNotEmpty) ...[
                const SizedBox(width: 12),
                Text(
                  'Ready by: ${_shortDateTime(j.promisedDateTime)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: _statuses.map((st) {
              final on = j.status == st;
              final sc = _statusColor(st);
              return ChoiceChip(
                label: Text(
                  st.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                    color: on ? sc : BrandColors.muted,
                  ),
                ),
                selected: on,
                selectedColor: sc.withValues(alpha: 0.12),
                side: on ? BorderSide(color: sc.withValues(alpha: 0.4)) : null,
                showCheckmark: false,
                onSelected: (_) async {
                  await ref.read(apiClientProvider).patch(
                    '/kirana/job-cards/${j.jobId}',
                    {'status': st},
                  );
                  ref.invalidate(jobCardsProvider);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _add(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.jobNewJobCard,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'repair', label: Text(l10n.jobRepair)),
                    ButtonSegment(
                      value: 'alteration',
                      label: Text(l10n.jobAlteration),
                    ),
                    ButtonSegment(
                      value: 'preorder',
                      label: Text(l10n.jobPreorder),
                    ),
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
                TextField(
                  controller: item,
                  decoration: const InputDecoration(
                    labelText: 'Item / description',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: charge,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Charge ₹ (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                // Promised "ready by" date + time (estimate the customer gets).
                InkWell(
                  onTap: () async {
                    final picked = await _pickDateTime(ctx, readyBy);
                    if (picked != null) setSt(() => readyBy = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ready by (optional)',
                      prefixIcon: Icon(Icons.event_rounded),
                    ),
                    child: Text(
                      readyBy == null
                          ? 'Select date & time'
                          : _readyByLabel(readyBy!),
                      style: TextStyle(
                        color: readyBy == null
                            ? BrandColors.muted
                            : BrandColors.ink,
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
                      await ref.read(apiClientProvider).post(
                        '/kirana/job-cards',
                        {
                          'job_type': type,
                          'customer_id': customer!.customerId,
                          'customer_name': customer!.name,
                          if (customer!.phone.isNotEmpty)
                            'customer_phone': customer!.phone,
                          if (item.text.trim().isNotEmpty)
                            'item_desc': item.text.trim(),
                          if (charge.text.trim().isNotEmpty)
                            'charge': double.tryParse(charge.text.trim()),
                          if (readyBy != null)
                            'promised_date': _isoDate(readyBy!),
                          // Only send a time if the shopkeeper actually picked
                          // one (midnight = date-only).
                          if (readyBy != null &&
                              !(readyBy!.hour == 0 && readyBy!.minute == 0))
                            'promised_time': _isoTime(readyBy!),
                        },
                      );
                      ref.invalidate(jobCardsProvider);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Edit an existing job card: item/description, charge and the ready-by date.
  void _edit(BuildContext context, WidgetRef ref, JobCard j) {
    final item = TextEditingController(text: j.itemDesc ?? '');
    final charge = TextEditingController(
      text: j.charge != null ? j.charge!.toStringAsFixed(0) : '',
    );
    DateTime? readyBy = j.promisedDateTime != null
        ? DateTime.tryParse(j.promisedDateTime!)
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit job card',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '${j.displayName}${j.phone != null && j.phone!.isNotEmpty ? " · ${j.phone}" : ""}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: BrandColors.muted,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: item,
                  decoration: const InputDecoration(
                    labelText: 'Item / description',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: charge,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Charge ₹ (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final picked = await _pickDateTime(ctx, readyBy);
                    if (picked != null) setSt(() => readyBy = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ready by',
                      prefixIcon: Icon(Icons.event_rounded),
                    ),
                    child: Text(
                      readyBy == null
                          ? 'Select date & time'
                          : _readyByLabel(readyBy!),
                      style: TextStyle(
                        color: readyBy == null
                            ? BrandColors.muted
                            : BrandColors.ink,
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
                      await ref
                          .read(apiClientProvider)
                          .patch('/kirana/job-cards/${j.jobId}', {
                            'item_desc': item.text.trim(),
                            'charge': charge.text.trim().isNotEmpty
                                ? double.tryParse(charge.text.trim())
                                : null,
                            if (readyBy != null)
                              'promised_date': _isoDate(readyBy!),
                            if (readyBy != null &&
                                !(readyBy!.hour == 0 && readyBy!.minute == 0))
                              'promised_time': _isoTime(readyBy!),
                          });
                      ref.invalidate(jobCardsProvider);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text('Save changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
