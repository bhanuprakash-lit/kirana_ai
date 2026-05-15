import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../shared/widgets/action_widgets.dart';
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
            Text(err.toString()),
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

class _AddUdhaarSheet extends StatefulWidget {
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
  State<_AddUdhaarSheet> createState() => _AddUdhaarSheetState();
}

class _AddUdhaarSheetState extends State<_AddUdhaarSheet> {
  bool _saving = false;
  bool _success = false;
  String? _error;

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
                  label: const Text(
                    'Contacts',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

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
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showRecoveryBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RecoverUdhaarSheet(ref: ref, item: item),
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
