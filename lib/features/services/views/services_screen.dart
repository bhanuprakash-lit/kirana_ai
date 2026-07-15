import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../../profile/models/customer_model.dart';
import '../../../shared/widgets/customer_picker.dart';
import '../models/service_models.dart';
import '../providers/service_provider.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  DateTime _day = DateTime.now();

  String get _dayKey =>
      '${_day.year.toString().padLeft(4, '0')}-${_day.month.toString().padLeft(2, '0')}-${_day.day.toString().padLeft(2, '0')}';

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
        title: const Text('Services & Appointments'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Appointments'),
            Tab(text: 'Services'),
            Tab(text: 'Memberships'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [_appointmentsTab(), _servicesTab(), _membershipsTab()],
      ),
    );
  }

  // ── Memberships (V3) — prepaid session bundles ─────────────────────────────
  Widget _membershipsTab() {
    final async = ref.watch(membershipsProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: ListShimmer(itemCount: 4),
          ),
          error: (e, _) => Center(
            child: Text('$e', style: const TextStyle(color: BrandColors.muted)),
          ),
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No memberships yet.\nSell a prepaid bundle (e.g. 10 sessions) — '
                    'redeem one session per visit at checkout or right here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BrandColors.muted, height: 1.5),
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _MembershipCard(m: items[i]),
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addMembership',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _MembershipEditor(),
            ),
            icon: const Icon(Icons.card_membership_rounded),
            label: const Text('New membership'),
          ),
        ),
      ],
    );
  }

  // ── Appointments ──────────────────────────────────────────────────────────
  Widget _appointmentsTab() {
    final async = ref.watch(appointmentsProvider(_dayKey));
    return Stack(
      children: [
        Column(
          children: [
            _dayBar(),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No appointments for this day.',
                          style: TextStyle(color: BrandColors.muted),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        _AppointmentCard(appt: list[i], day: _dayKey),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'bookAppt',
            onPressed: _book,
            icon: const Icon(Icons.event_available_rounded),
            label: const Text('Book'),
          ),
        ),
      ],
    );
  }

  void _book() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSheet(day: _day, dayKey: _dayKey),
    );
  }

  Widget _dayBar() {
    final isToday = DateUtils.isSameDay(_day, DateTime.now());
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () =>
                setState(() => _day = _day.subtract(const Duration(days: 1))),
          ),
          Expanded(
            child: Center(
              child: Text(
                isToday
                    ? 'Today · ${_day.day}/${_day.month}'
                    : '${_day.day}/${_day.month}/${_day.year}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () =>
                setState(() => _day = _day.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }

  // ── Services catalogue ────────────────────────────────────────────────────
  Widget _servicesTab() {
    final async = ref.watch(servicesProvider);
    return Stack(
      children: [
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            if (list.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No services yet. Add the services you offer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BrandColors.muted),
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final s = list[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: ListTile(
                    title: Text(
                      s.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '₹${s.price.toStringAsFixed(0)} · ${s.durationMin} min'
                      '${s.category != null ? " · ${s.category}" : ""}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                    trailing: Switch(
                      value: s.isActive,
                      onChanged: (v) => ref
                          .read(serviceActionsProvider)
                          .toggleService(s.serviceId, v),
                    ),
                  ),
                );
              },
            );
          },
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            heroTag: 'addService',
            onPressed: _addService,
            icon: const Icon(Icons.add),
            label: const Text('New service'),
          ),
        ),
      ],
    );
  }

  void _addService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ServiceEditor(),
    );
  }
}

// ── Appointment card with status actions ──────────────────────────────────────
class _AppointmentCard extends ConsumerWidget {
  final Appointment appt;
  final String day;
  const _AppointmentCard({required this.appt, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = switch (appt.status) {
      'completed' => BrandColors.success,
      'cancelled' => BrandColors.muted,
      'no_show' => BrandColors.error,
      _ => BrandColors.primary,
    };
    final time =
        '${appt.startsAt.hour.toString().padLeft(2, '0')}:${appt.startsAt.minute.toString().padLeft(2, '0')}';
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
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${appt.serviceName ?? "Service"}'
                      '${appt.price != null ? " · ₹${appt.price!.toStringAsFixed(0)}" : ""}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appt.status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          if (appt.status == 'booked') ...[
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => ref
                      .read(serviceActionsProvider)
                      .setStatus(appt.appointmentId, 'no_show', day),
                  child: const Text(
                    'No-show',
                    style: TextStyle(color: BrandColors.error),
                  ),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(serviceActionsProvider)
                      .setStatus(appt.appointmentId, 'cancelled', day),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: BrandColors.muted),
                  ),
                ),
                FilledButton(
                  onPressed: () => ref
                      .read(serviceActionsProvider)
                      .setStatus(appt.appointmentId, 'completed', day),
                  child: const Text('Complete'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── New-service editor ────────────────────────────────────────────────────────
class _ServiceEditor extends ConsumerStatefulWidget {
  const _ServiceEditor();

  @override
  ConsumerState<_ServiceEditor> createState() => _ServiceEditorState();
}

class _ServiceEditorState extends ConsumerState<_ServiceEditor> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _durCtrl = TextEditingController(text: '30');
  final _catCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _durCtrl.dispose();
    _catCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a service name');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(serviceActionsProvider).createService({
        'name': name,
        'price': double.tryParse(_priceCtrl.text.trim()) ?? 0,
        'duration_min': int.tryParse(_durCtrl.text.trim()) ?? 30,
        if (_catCtrl.text.trim().isNotEmpty) 'category': _catCtrl.text.trim(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New service',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Service name'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _num(_priceCtrl, 'Price ₹')),
              const SizedBox(width: 12),
              Expanded(child: _num(_durCtrl, 'Duration (min)', intOnly: true)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _catCtrl,
            decoration: const InputDecoration(labelText: 'Category (optional)'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: BrandColors.error)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
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
                  : const Text('Create service'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _num(TextEditingController c, String label, {bool intOnly = false}) =>
      TextField(
        controller: c,
        keyboardType: intOnly
            ? TextInputType.number
            : const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(intOnly ? r'^\d+' : r'^\d+\.?\d{0,2}'),
          ),
        ],
        decoration: InputDecoration(labelText: label),
      );
}

// ── New-appointment booking sheet ─────────────────────────────────────────────
class _BookingSheet extends ConsumerStatefulWidget {
  final DateTime day;
  final String dayKey;
  const _BookingSheet({required this.day, required this.dayKey});

  @override
  ConsumerState<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends ConsumerState<_BookingSheet> {
  Customer? _customer;
  late DateTime _date = widget.day;
  int? _serviceId;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  bool _saving = false;
  String? _error;

  String _keyFor(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    if (_customer == null) {
      setState(() => _error = 'Select a customer');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final d = _date;
    final startsAt = DateTime(d.year, d.month, d.day, _time.hour, _time.minute);
    try {
      await ref.read(serviceActionsProvider).createAppointment({
        'starts_at': startsAt.toUtc().toIso8601String(),
        'customer_id': _customer!.customerId,
        'customer_name': _customer!.name,
        if (_customer!.phone.isNotEmpty) 'customer_phone': _customer!.phone,
        'service_id': ?_serviceId,
      }, _keyFor(_date));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider).asData?.value ?? [];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book appointment',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          // Pick the customer from the store list (captures their phone too).
          InkWell(
            onTap: () async {
              final picked = await showCustomerPicker(context, ref);
              if (picked != null) setState(() => _customer = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Customer',
                prefixIcon: Icon(Icons.person_outline_rounded),
                suffixIcon: Icon(Icons.arrow_drop_down_rounded),
              ),
              child: Text(
                _customer == null
                    ? 'Select customer'
                    : '${_customer!.name}${_customer!.phone.isNotEmpty ? " · ${_customer!.phone}" : ""}',
                style: TextStyle(
                  color: _customer == null
                      ? BrandColors.muted
                      : BrandColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Explicit date (defaults to the day being viewed).
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
              child: Text('${_date.day}/${_date.month}/${_date.year}'),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _serviceId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Service'),
            items: services
                .map(
                  (s) => DropdownMenuItem(
                    value: s.serviceId,
                    child: Text('${s.name} · ₹${s.price.toStringAsFixed(0)}'),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _serviceId = v),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: _time,
              );
              if (t != null) setState(() => _time = t);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Time',
                prefixIcon: Icon(Icons.schedule_rounded),
              ),
              child: Text(_time.format(context)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: BrandColors.error)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
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
                  : const Text('Book'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Membership card (V3) ──────────────────────────────────────────────────────
class _MembershipCard extends ConsumerWidget {
  final Membership m;
  const _MembershipCard({required this.m});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlimited = m.totalSessions <= 0;
    final exhausted = !unlimited && m.remaining == 0;
    final color = !m.isActive || exhausted
        ? BrandColors.muted
        : BrandColors.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.card_membership_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  '${m.customerName ?? "Customer #${m.customerId}"}'
                  ' · ₹${m.price.toStringAsFixed(0)}'
                  ' · ${unlimited ? "Unlimited" : "${m.usedSessions}/${m.totalSessions} used"}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (m.isActive && !exhausted)
            FilledButton.tonal(
              onPressed: () async {
                try {
                  await ref
                      .read(serviceActionsProvider)
                      .useMembershipSession(m.membershipId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Session used')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('$e')));
                  }
                }
              },
              child: const Text('Use session'),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: BrandColors.muted.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                exhausted ? 'Used up' : 'Inactive',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── New-membership editor (V3) ────────────────────────────────────────────────
class _MembershipEditor extends ConsumerStatefulWidget {
  const _MembershipEditor();

  @override
  ConsumerState<_MembershipEditor> createState() => _MembershipEditorState();
}

class _MembershipEditorState extends ConsumerState<_MembershipEditor> {
  final _nameCtrl = TextEditingController();
  final _sessionsCtrl = TextEditingController(text: '10');
  final _priceCtrl = TextEditingController();
  Customer? _customer;
  DateTime? _validUntil;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sessionsCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    if (_customer == null || name.isEmpty || price == null) {
      setState(
        () => _error = 'Pick a customer and fill the name and price.',
      );
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(serviceActionsProvider)
          .createMembership(
            customerId: _customer!.customerId,
            name: name,
            totalSessions: int.tryParse(_sessionsCtrl.text.trim()) ?? 0,
            price: price,
            validUntil: _validUntil != null ? _iso(_validUntil!) : null,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'New membership',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            // Customer — the bundle belongs to someone.
            OutlinedButton.icon(
              onPressed: _saving
                  ? null
                  : () async {
                      final c = await showCustomerPicker(context, ref);
                      if (c != null && mounted) {
                        setState(() => _customer = c);
                      }
                    },
              icon: const Icon(Icons.person_rounded, size: 18),
              label: Text(
                _customer?.name ?? 'Pick customer',
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Membership name (e.g. 10-session gym pass)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sessionsCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Sessions (0 = unlimited)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saving
                  ? null
                  : () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            _validUntil ??
                            DateTime.now().add(const Duration(days: 90)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 3),
                        ),
                      );
                      if (picked != null && mounted) {
                        setState(() => _validUntil = picked);
                      }
                    },
              icon: const Icon(Icons.event_rounded, size: 18),
              label: Text(
                _validUntil == null
                    ? 'Valid until (optional)'
                    : '${_validUntil!.day}/${_validUntil!.month}/${_validUntil!.year}',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                alignment: Alignment.centerLeft,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(
                  color: BrandColors.error,
                  fontSize: 12.5,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Sell membership'),
            ),
          ],
        ),
      ),
    );
  }
}
