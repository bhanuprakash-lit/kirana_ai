import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../profile/models/customer_model.dart';
import '../../../profile/providers/customer_provider.dart';
import '../../models/finance_models.dart';
import '../../providers/finance_provider.dart';
import '../../providers/smart_udhaar_provider.dart';
import '../smart_reminders_screen.dart';

class UdhaarTab extends ConsumerWidget {
  const UdhaarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(financeProvider);
    final l10n = AppLocalizations.of(context);

    return asyncData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: ListShimmer(itemCount: 6),
      ),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: BrandColors.error),
            const SizedBox(height: 16),
            Text(
              l10n.finFailedLoadUdhaar,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.finCheckConnection,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(financeProvider.notifier).refresh(),
              child: Text(l10n.finRetry),
            ),
          ],
        ),
      ),
      data: (data) {
        // Group the flat khata list by customer so each customer shows as one
        // expandable card instead of one row per udhaar sale. Active customers
        // (with an open balance) come first, sorted by largest balance; fully
        // settled customers drop into a muted collapsed section.
        final groups = _groupByCustomer(data.udhaarList);
        final active = groups.where((g) => !g.isSettled).toList()
          ..sort((a, b) => b.totalBalance.compareTo(a.totalBalance));
        final settled = groups.where((g) => g.isSettled).toList();
        return RefreshIndicator.adaptive(
          onRefresh: () => ref.read(financeProvider.notifier).refresh(),
          color: BrandColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _UdhaarStatsCard(stats: data.stats),
              const SizedBox(height: 16),
              if (data.udhaarList.isNotEmpty) ...[
                _SmartRemindersBanner(
                  highRisk: ref.watch(highRiskUdhaarCountProvider),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SmartRemindersScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.finCustomerDues,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showAddUdhaarSheet(context, ref),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.finNewUdhaar),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (data.udhaarList.isEmpty)
                const _EmptyUdhaar()
              else ...[
                for (final group in active) _CustomerUdhaarCard(group: group),
                if (settled.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SettledSection(groups: settled),
                ],
              ],
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _showAddUdhaarSheet(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddUdhaarSheet(
        ref: ref,
        nameController: nameController,
        amountController: amountController,
        phoneController: phoneController,
        onContactPick: (name, p) {
          nameController.text = name;
          phoneController.text = p;
        },
      ),
    );
  }
}

class _AddUdhaarSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController phoneController;
  final Function(String, String) onContactPick;

  const _AddUdhaarSheet({
    required this.ref,
    required this.nameController,
    required this.amountController,
    required this.phoneController,
    required this.onContactPick,
  });

  @override
  ConsumerState<_AddUdhaarSheet> createState() => _AddUdhaarSheetState();
}

class _AddUdhaarSheetState extends ConsumerState<_AddUdhaarSheet> {
  bool _saving = false;
  bool _success = false;
  String? _error;
  Customer? _selectedCustomer;
  // Repayment deadline; defaults to 30 Jun 2026 (same default as the backend
  // backfill) and is editable.
  DateTime _dueDate = DateTime(2026, 6, 30);

  void _fillFromCustomer(Customer c) {
    setState(() {
      _selectedCustomer = c;
      widget.nameController.text = c.name;
      widget.phoneController.text = c.phone;
    });
  }

  void _clearCustomer() {
    setState(() {
      _selectedCustomer = null;
      widget.nameController.clear();
      widget.phoneController.clear();
    });
  }

  Future<void> _showCustomerPicker() async {
    final customers = ref.read(customerProvider).customers;
    if (customers.isEmpty) return;

    await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerPickerSheet(
        customers: customers,
        onSelected: (c) {
          Navigator.pop(context);
          _fillFromCustomer(c);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerProvider).customers;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: BrandColors.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.finAddNewUdhaar,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (!_saving && !_success)
                TextButton.icon(
                  onPressed: () async {
                    final contact = await ContactService.pickContact();
                    if (contact != null) {
                      setState(() {
                        _selectedCustomer = null;
                        widget.nameController.text = contact.name!.first
                            .toString();
                        if (contact.phones.isNotEmpty) {
                          final p = ContactService.formatPhone(
                            contact.phones.first.number,
                          );
                          widget.phoneController.text = p;
                          widget.onContactPick(widget.nameController.text, p);
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.contacts_rounded, size: 18),
                  label: Text(
                    l10n.finContacts,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Existing customer picker
          if (customers.isNotEmpty && !_saving && !_success) ...[
            GestureDetector(
              onTap: _selectedCustomer != null
                  ? _clearCustomer
                  : _showCustomerPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _selectedCustomer != null
                      ? BrandColors.primary.withValues(alpha: 0.06)
                      : BrandColors.surfaceTint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedCustomer != null
                        ? BrandColors.primary.withValues(alpha: 0.4)
                        : BrandColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedCustomer != null
                          ? Icons.check_circle_rounded
                          : Icons.person_search_rounded,
                      color: _selectedCustomer != null
                          ? BrandColors.primary
                          : BrandColors.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _selectedCustomer != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedCustomer!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: BrandColors.ink,
                                  ),
                                ),
                                if (_selectedCustomer!.phone.isNotEmpty)
                                  Text(
                                    _selectedCustomer!.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: BrandColors.muted,
                                    ),
                                  ),
                              ],
                            )
                          : Text(
                              l10n.finSelectExistingCustomer,
                              style: const TextStyle(
                                fontSize: 14,
                                color: BrandColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                    Icon(
                      _selectedCustomer != null
                          ? Icons.close_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: BrandColors.muted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    l10n.finOrEnterManually,
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
          ],

          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            successMessage: l10n.finUdhaarRecorded,
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: widget.nameController,
            enabled: !_saving && !_success,
            decoration: InputDecoration(
              labelText: l10n.finCustomerName,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.phoneController,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.finPhoneNumber,
              prefixIcon: const Icon(Icons.phone_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.amountController,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.finAmount,
              prefixText: '₹ ',
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
            ),
          ),
          const SizedBox(height: 16),
          // Repayment due date — when the customer promises to clear the dues.
          InkWell(
            onTap: (_saving || _success)
                ? null
                : () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime(2030, 12, 31),
                      helpText: l10n.finDueDateHint,
                    );
                    if (picked != null) setState(() => _dueDate = picked);
                  },
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.finDueDate,
                prefixIcon: const Icon(Icons.event_rounded),
              ),
              child: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: l10n.finSaveUdhaar,
              isLoading: _saving,
              onPressed: _success
                  ? null
                  : () async {
                      final amount =
                          double.tryParse(widget.amountController.text) ?? 0;
                      if (widget.nameController.text.isEmpty ||
                          widget.phoneController.text.isEmpty ||
                          amount <= 0) {
                        setState(
                          () => _error = l10n.finEnterValidNamePhoneAmount,
                        );
                        return;
                      }

                      setState(() {
                        _saving = true;
                        _error = null;
                      });
                      try {
                        await widget.ref
                            .read(financeProvider.notifier)
                            .addUdhaar(
                              name: widget.nameController.text,
                              phone: widget.phoneController.text,
                              amount: amount,
                              dueDate: _dueDate,
                            );
                        if (mounted) {
                          setState(() {
                            _saving = false;
                            _success = true;
                          });
                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );
                          // ignore: use_build_context_synchronously
                          if (mounted) Navigator.pop(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            _saving = false;
                            _error = e.toString();
                          });
                        }
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Customer picker sheet ─────────────────────────────────────────────────────

class _CustomerPickerSheet extends StatefulWidget {
  final List<Customer> customers;
  final ValueChanged<Customer> onSelected;

  const _CustomerPickerSheet({
    required this.customers,
    required this.onSelected,
  });

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
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
    final filtered = widget.customers.where((c) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return c.name.toLowerCase().contains(q) || c.phone.contains(q);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.finSelectCustomer,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: l10n.finSearchByNameOrPhone,
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
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        l10n.finNoCustomersFound,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: BrandColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: BrandColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            c.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: c.phone.isNotEmpty
                              ? Text(
                                  c.phone,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: BrandColors.muted,
                                  ),
                                )
                              : null,
                          onTap: () => widget.onSelected(c),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UdhaarStatsCard extends StatelessWidget {
  final FinanceStats stats;

  const _UdhaarStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MiniStat(
            label: l10n.finTotalPending,
            value: '₹${stats.totalUdhaarPending.toStringAsFixed(0)}',
            color: BrandColors.error,
          ),

          _MiniStat(
            label: l10n.finRecovered,
            value: '₹${stats.totalUdhaarRecovered.toStringAsFixed(0)}',
            color: BrandColors.success,
          ),

          _MiniStat(
            label: l10n.finCustomers,
            value: '${stats.udhaarCustomerCount}',
            color: BrandColors.primary,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: const TextStyle(fontSize: 11, color: BrandColors.muted),
        ),
      ],
    );
  }
}

class _SmartRemindersBanner extends StatelessWidget {
  final int highRisk;
  final VoidCallback onTap;

  const _SmartRemindersBanner({required this.highRisk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final urgent = highRisk > 0;
    final color = urgent ? BrandColors.error : BrandColors.primary;
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.bolt_rounded, color: color, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  urgent
                      ? l10n.finHighRiskDues(highRisk)
                      : l10n.finSmartRemindersSubtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Customer grouping ─────────────────────────────────────────────────────────

/// All of one customer's khata rows, with the aggregates the grouped card needs.
class _CustomerUdhaar {
  final int customerId;
  final String customerName;
  final String phone;
  final List<UdhaarItem> entries;

  _CustomerUdhaar({
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.entries,
  });

  /// Open (unsettled) debts, oldest-first — the order recovery is applied in.
  List<UdhaarItem> get openOldestFirst =>
      entries.where((e) => !e.isRecovered).toList()
        ..sort((a, b) => a.dateTaken.compareTo(b.dateTaken));

  /// All debts newest-first — the order they're listed in when expanded.
  List<UdhaarItem> get entriesNewestFirst =>
      List<UdhaarItem>.from(entries)
        ..sort((a, b) => b.dateTaken.compareTo(a.dateTaken));

  double get totalBalance => openOldestFirst.fold(0.0, (s, e) => s + e.balance);
  double get totalTaken => entries.fold(0.0, (s, e) => s + e.originalAmount);
  double get totalPaid => entries.fold(0.0, (s, e) => s + e.amountPaid);
  int get openCount => openOldestFirst.length;
  int get oldestDays => openOldestFirst.isEmpty
      ? 0
      : openOldestFirst
            .map((e) => e.daysPending)
            .reduce((a, b) => a > b ? a : b);
  bool get remindedToday => openOldestFirst.any((e) => e.remindedToday);
  bool get isSettled => openCount == 0;
  int? get oldestOpenKhataId =>
      openOldestFirst.isEmpty ? null : openOldestFirst.first.khataId;
}

List<_CustomerUdhaar> _groupByCustomer(List<UdhaarItem> items) {
  final byCustomer = <int, List<UdhaarItem>>{};
  for (final it in items) {
    byCustomer.putIfAbsent(it.customerId, () => []).add(it);
  }
  return byCustomer.entries.map((e) {
    final first = e.value.first;
    return _CustomerUdhaar(
      customerId: e.key,
      customerName: first.customerName,
      phone: first.phone,
      entries: e.value,
    );
  }).toList();
}

String _formatUdhaarDate(DateTime date) {
  final d = date.toLocal();
  return "${d.day}/${d.month}/${d.year}";
}

/// Urgency colour for a customer based on how long their oldest debt is overdue.
Color _urgencyColor(int oldestDays) {
  if (oldestDays >= 30) return BrandColors.error;
  if (oldestDays >= 14) return const Color(0xFFD97706);
  return BrandColors.primary;
}

// ── Customer card (collapsed profile → expands to udhaar history) ─────────────

class _CustomerUdhaarCard extends ConsumerStatefulWidget {
  final _CustomerUdhaar group;
  const _CustomerUdhaarCard({required this.group});

  @override
  ConsumerState<_CustomerUdhaarCard> createState() =>
      _CustomerUdhaarCardState();
}

class _CustomerUdhaarCardState extends ConsumerState<_CustomerUdhaarCard> {
  bool _expanded = false;

  void _openHistory(UdhaarItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UdhaarHistorySheet(ref: ref, item: item),
    );
  }

  void _openRecover() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecoverCustomerSheet(ref: ref, group: widget.group),
    );
  }

  Future<void> _remind() async {
    final khataId = widget.group.oldestOpenKhataId;
    if (khataId == null) return;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(financeProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await notifier.sendReminder(khataId);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.finWhatsappReminderSent),
          backgroundColor: BrandColors.success,
        ),
      );
      await notifier.refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.finFailedSendReminder(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final g = widget.group;
    final accent = _urgencyColor(g.oldestDays);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Collapsed header (always visible, tap to expand) ──────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: accent.withValues(alpha: 0.1),
                    child: Text(
                      g.customerName.isNotEmpty
                          ? g.customerName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (g.phone.isNotEmpty)
                          Text(
                            g.phone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.finOpenDuesSummary(g.openCount, g.oldestDays),
                          style: TextStyle(
                            fontSize: 12,
                            color: accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${g.totalBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: BrandColors.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: BrandColors.muted,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded body ─────────────────────────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ExpandedBody(
              group: g,
              onRecover: _openRecover,
              onRemind: _remind,
              onOpenHistory: _openHistory,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _ExpandedBody extends StatelessWidget {
  final _CustomerUdhaar group;
  final VoidCallback onRecover;
  final Future<void> Function() onRemind;
  final void Function(UdhaarItem) onOpenHistory;

  const _ExpandedBody({
    required this.group,
    required this.onRecover,
    required this.onRemind,
    required this.onOpenHistory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Summary strip: Taken / Paid / Balance.
          Row(
            children: [
              _SummaryCell(
                label: l10n.finTaken,
                value: '₹${group.totalTaken.toStringAsFixed(0)}',
                color: BrandColors.ink,
              ),
              _SummaryCell(
                label: l10n.finPaid,
                value: '₹${group.totalPaid.toStringAsFixed(0)}',
                color: BrandColors.success,
              ),
              _SummaryCell(
                label: l10n.finBalanceShort,
                value: '₹${group.totalBalance.toStringAsFixed(0)}',
                color: BrandColors.error,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action row.
          Row(
            children: [
              if (group.remindedToday)
                TextButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: Text(l10n.finRemindedToday),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.muted,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: onRemind,
                  icon: const Icon(Icons.message_rounded, size: 18),
                  label: Text(l10n.finRemind),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.success,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: onRecover,
                icon: const Icon(Icons.payments_rounded, size: 18),
                label: Text(l10n.finRecordPayment),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Per-debt history list.
          ...group.entriesNewestFirst.map(
            (e) => _DebtRow(item: e, onTap: () => onOpenHistory(e), l10n: l10n),
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCell({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: BrandColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtRow extends StatelessWidget {
  final UdhaarItem item;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _DebtRow({required this.item, required this.onTap, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final settled = item.isRecovered;
    return Opacity(
      opacity: settled ? 0.55 : 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (settled ? BrandColors.success : BrandColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  settled ? Icons.check_rounded : Icons.receipt_long_outlined,
                  size: 17,
                  color: settled ? BrandColors.success : BrandColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${item.originalAmount.toStringAsFixed(0)} · ${_formatUdhaarDate(item.dateTaken)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: BrandColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      settled
                          ? l10n.finSettled
                          : l10n.finBalanceLabel(
                              item.balance.toStringAsFixed(0),
                            ),
                      style: TextStyle(
                        fontSize: 11,
                        color: settled
                            ? BrandColors.success
                            : BrandColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!settled && item.effectiveDueDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.finDueBy(
                          _formatUdhaarDate(item.effectiveDueDate!),
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFD97706),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: BrandColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Settled customers (muted, collapsible) ────────────────────────────────────

class _SettledSection extends StatefulWidget {
  final List<_CustomerUdhaar> groups;
  const _SettledSection({required this.groups});

  @override
  State<_SettledSection> createState() => _SettledSectionState();
}

class _SettledSectionState extends State<_SettledSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: BrandColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: BrandColors.muted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.finSettledSectionTitle(widget.groups.length),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: BrandColors.muted,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: BrandColors.muted,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            ...widget.groups.map(
              (g) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: BrandColors.muted.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        g.customerName.isNotEmpty
                            ? g.customerName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: BrandColors.muted,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        g.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.ink,
                        ),
                      ),
                    ),
                    Text(
                      l10n.finSettled,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RecoverCustomerSheet extends StatefulWidget {
  final WidgetRef ref;
  final _CustomerUdhaar group;

  const _RecoverCustomerSheet({required this.ref, required this.group});

  @override
  State<_RecoverCustomerSheet> createState() => _RecoverCustomerSheetState();
}

class _RecoverCustomerSheetState extends State<_RecoverCustomerSheet> {
  final _controller = TextEditingController();
  bool _saving = false;
  bool _success = false;
  String? _error;
  // For the progress/success message: how many open dues this payment touches,
  // and how many it fully clears (recovery is applied oldest-first).
  int _affectedCount = 0;
  int _settledCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalBalance = widget.group.totalBalance;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: BrandColors.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.finRecoverUdhaarFrom(widget.group.customerName),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 16),

          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            savingMessage: l10n.finClearingDues(_affectedCount),
            successMessage: _settledCount > 0
                ? l10n.finDuesCleared(_settledCount)
                : l10n.finRecoveryRecorded,
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: _controller,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.finAmount,
              prefixText: '₹ ',
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
              helperText:
                  '${l10n.finBalanceLabel(totalBalance.toStringAsFixed(0))} · ${l10n.finPaymentOldestFirstNote}',
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: l10n.finConfirmRecovery,
              isLoading: _saving,
              onPressed: _success
                  ? null
                  : () async {
                      final amount = double.tryParse(_controller.text) ?? 0;
                      if (amount <= 0) {
                        setState(() => _error = l10n.finEnterValidAmount);
                        return;
                      }
                      if (amount > totalBalance) {
                        setState(
                          () => _error = l10n.finAmountExceedsBalance(
                            totalBalance.toStringAsFixed(0),
                          ),
                        );
                        return;
                      }

                      // Pre-compute how many dues this payment touches/clears
                      // (oldest-first) so the progress + success messages can
                      // say "Clearing 3 dues…" instead of a generic spinner.
                      final open = widget.group.openOldestFirst;
                      var remaining = amount;
                      var affected = 0;
                      var settled = 0;
                      for (final e in open) {
                        if (remaining <= 0.001) break;
                        affected++;
                        if (remaining >= e.balance - 0.001) settled++;
                        remaining -= e.balance;
                      }

                      setState(() {
                        _saving = true;
                        _error = null;
                        _affectedCount = affected;
                        _settledCount = settled;
                      });
                      try {
                        await widget.ref
                            .read(financeProvider.notifier)
                            .recordCustomerRecovery(
                              widget.group.openOldestFirst,
                              amount,
                            );
                        if (mounted) {
                          setState(() {
                            _saving = false;
                            _success = true;
                          });
                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );
                          // ignore: use_build_context_synchronously
                          if (mounted) Navigator.pop(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            _saving = false;
                            _error = e.toString();
                          });
                        }
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyUdhaar extends StatelessWidget {
  const _EmptyUdhaar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              size: 64,
              color: BrandColors.muted.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 16),

            Text(
              l10n.finNoPendingUdhaars,
              style: const TextStyle(
                color: BrandColors.muted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UdhaarHistorySheet extends StatefulWidget {
  final WidgetRef ref;
  final UdhaarItem item;
  const _UdhaarHistorySheet({required this.ref, required this.item});

  @override
  State<_UdhaarHistorySheet> createState() => _UdhaarHistorySheetState();
}

class _UdhaarHistorySheetState extends State<_UdhaarHistorySheet> {
  List<Map<String, dynamic>> _payments = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final client = widget.ref.read(apiClientProvider);
      final res =
          await client.get(
                '/kirana/finance/udhaar/${widget.item.khataId}/history',
              )
              as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _payments = (res['payments'] as List).cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.finRecoveryHistory,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          widget.item.customerName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: BrandColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      l10n.finBalanceLabel(
                        widget.item.balance.toStringAsFixed(0),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: BrandColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: ListShimmer(itemCount: 4, itemHeight: 60),
                    )
                  : _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: BrandColors.error),
                      ),
                    )
                  : _payments.isEmpty
                  ? Center(
                      child: Text(
                        l10n.finNoRecoveriesYet,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: _payments.length,
                      separatorBuilder: (context2, index2) =>
                          const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = _payments[i];
                        final amount = (p['amount'] as num?)?.toDouble() ?? 0.0;
                        final paidAt = p['paid_at'] as String?;
                        final dt = paidAt != null
                            ? DateTime.tryParse(paidAt)?.toLocal()
                            : null;
                        final dateLabel = dt != null
                            ? '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                            : '—';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: BrandColors.success.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_downward_rounded,
                                  color: BrandColors.success,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.finRecoveryNumber(
                                        _payments.length - i,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      dateLabel,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: BrandColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '+ ₹${amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: BrandColors.success,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
