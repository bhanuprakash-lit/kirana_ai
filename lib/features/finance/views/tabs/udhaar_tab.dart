import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../../profile/models/customer_model.dart';
import '../../../profile/providers/customer_provider.dart';
import '../../models/finance_models.dart';
import '../../providers/finance_provider.dart';

class UdhaarTab extends ConsumerWidget {
  const UdhaarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(financeProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: BrandColors.error),
            const SizedBox(height: 16),
            const Text(
              'Failed to load udhaar data',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Please check your connection and try again.',
                textAlign: TextAlign.center, style: TextStyle(color: BrandColors.muted)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(financeProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.read(financeProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _UdhaarStatsCard(stats: data.stats),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Dues',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddUdhaarSheet(context, ref),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New Udhaar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (data.udhaarList.isEmpty)
              const _EmptyUdhaar()
            else
              ...data.udhaarList.map((item) => _UdhaarTile(item: item)),
            const SizedBox(height: 80),
          ],
        ),
      ),
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
              const Text(
                'Add New Udhaar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
              ),
              if (!_saving && !_success)
                TextButton.icon(
                  onPressed: () async {
                    final contact = await ContactService.pickContact();
                    if (contact != null) {
                      setState(() {
                        _selectedCustomer = null;
                        widget.nameController.text = contact.name!.first.toString();
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
                  label: const Text(
                    'Contacts',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Existing customer picker
          if (customers.isNotEmpty && !_saving && !_success) ...[
            GestureDetector(
              onTap: _selectedCustomer != null ? _clearCustomer : _showCustomerPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                          : const Text(
                              'Select existing customer',
                              style: TextStyle(
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
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('or enter manually', style: TextStyle(fontSize: 11, color: BrandColors.muted)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
          ],

          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            successMessage: 'Udhaar recorded!',
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: widget.nameController,
            enabled: !_saving && !_success,
            decoration: const InputDecoration(
              labelText: 'Customer Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.phoneController,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.amountController,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              prefixIcon: Icon(Icons.currency_rupee_rounded),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: 'Save Udhaar',
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
                          () => _error = 'Enter valid name, phone and amount',
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

  const _CustomerPickerSheet({required this.customers, required this.onSelected});

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
    final filtered = widget.customers
        .where((c) {
          if (_query.isEmpty) return true;
          final q = _query.toLowerCase();
          return c.name.toLowerCase().contains(q) || c.phone.contains(q);
        })
        .toList();

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
              width: 40, height: 4,
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
                  const Text('Select Customer',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: BrandColors.muted),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
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
                  ? const Center(
                      child: Text('No customers found',
                          style: TextStyle(color: BrandColors.muted)),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          leading: CircleAvatar(
                            backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                  color: BrandColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(c.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          subtitle: c.phone.isNotEmpty
                              ? Text(c.phone,
                                  style: const TextStyle(
                                      fontSize: 12, color: BrandColors.muted))
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
            label: 'Total Pending',
            value: '₹${stats.totalUdhaarPending.toStringAsFixed(0)}',
            color: BrandColors.error,
          ),

          _MiniStat(
            label: 'Recovered',
            value: '₹${stats.totalUdhaarRecovered.toStringAsFixed(0)}',
            color: BrandColors.success,
          ),

          _MiniStat(
            label: 'Customers',
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

class _UdhaarTile extends ConsumerWidget {
  final UdhaarItem item;

  const _UdhaarTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecovered = item.isRecovered;

    return Opacity(
      opacity: isRecovered ? 0.6 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRecovered ? BrandColors.surfaceTint : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isRecovered
                  ? BrandColors.muted
                  : BrandColors.primary.withValues(alpha: 0.1),
              child: Text(
                item.customerName.isNotEmpty
                    ? item.customerName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: isRecovered ? BrandColors.muted : BrandColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (item.phone.isNotEmpty)
                    Text(
                      item.phone,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Text(
                    'Taken: ${_formatDate(item.dateTaken)} (${item.daysPending} days ago)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${item.balance.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: isRecovered ? BrandColors.muted : BrandColors.error,
                  ),
                ),

                if (!isRecovered)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(financeProvider.notifier)
                                .sendReminder(item.khataId);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('WhatsApp reminder sent!'),
                                  backgroundColor: BrandColors.success,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to send reminder: $e'),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.message_outlined,
                          size: 20,
                          color: BrandColors.success,
                        ),
                        tooltip: 'Send WhatsApp Reminder',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _showRecoveryBottomSheet(context, ref),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('Recover'),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () => _showHistorySheet(context, ref),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: BrandColors.muted,
                        ),
                        child: const Text('History'),
                      ),
                    ],
                  ),

                if (isRecovered)
                  const Text(
                    'Settled',
                    style: TextStyle(
                      fontSize: 12,
                      color: BrandColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    return "${d.day}/${d.month}/${d.year}";
  }

  void _showRecoveryBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RecoverUdhaarSheet(ref: ref, item: item),
    );
  }

  void _showHistorySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UdhaarHistorySheet(ref: ref, item: item),
    );
  }
}

class _RecoverUdhaarSheet extends StatefulWidget {
  final WidgetRef ref;
  final UdhaarItem item;

  const _RecoverUdhaarSheet({required this.ref, required this.item});

  @override
  State<_RecoverUdhaarSheet> createState() => _RecoverUdhaarSheetState();
}

class _RecoverUdhaarSheetState extends State<_RecoverUdhaarSheet> {
  final _controller = TextEditingController();
  bool _saving = false;
  bool _success = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            'Recover Udhaar from ${widget.item.customerName}',
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
            successMessage: 'Recovery recorded!',
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: _controller,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
              helperText: 'Balance: ₹${widget.item.balance.toStringAsFixed(0)}',
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: 'Confirm Recovery',
              isLoading: _saving,
              onPressed: _success
                  ? null
                  : () async {
                      final amount = double.tryParse(_controller.text) ?? 0;
                      if (amount <= 0) {
                        setState(() => _error = 'Please enter a valid amount');
                        return;
                      }
                      if (amount > widget.item.balance) {
                        setState(() => _error = 'Amount cannot exceed balance ₹${widget.item.balance.toStringAsFixed(0)}');
                        return;
                      }

                      setState(() {
                        _saving = true;
                        _error = null;
                      });
                      try {
                        await widget.ref
                            .read(financeProvider.notifier)
                            .recordRecovery(widget.item.khataId, amount);
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

            const Text(
              'No pending udhaars',
              style: TextStyle(
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
      final res = await client.get('/kirana/finance/udhaar/${widget.item.khataId}/history') as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _payments = (res['payments'] as List).cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() { _loading = false; _error = e.toString(); });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Recovery History', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                        Text(widget.item.customerName, style: const TextStyle(fontSize: 13, color: BrandColors.muted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: BrandColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Balance: ₹${widget.item.balance.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: BrandColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: BrandColors.error)))
                      : _payments.isEmpty
                          ? const Center(child: Text('No recoveries recorded yet.', style: TextStyle(color: BrandColors.muted)))
                          : ListView.separated(
                              controller: scrollCtrl,
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                              itemCount: _payments.length,
                              separatorBuilder: (context2, index2) => const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final p = _payments[i];
                                final amount = (p['amount'] as num?)?.toDouble() ?? 0.0;
                                final paidAt = p['paid_at'] as String?;
                                final dt = paidAt != null ? DateTime.tryParse(paidAt)?.toLocal() : null;
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
                                          color: BrandColors.success.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.arrow_downward_rounded, color: BrandColors.success, size: 18),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Recovery #${_payments.length - i}',
                                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                            Text(dateLabel, style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
                                          ],
                                        ),
                                      ),
                                      Text('+ ₹${amount.toStringAsFixed(0)}',
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: BrandColors.success)),
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
