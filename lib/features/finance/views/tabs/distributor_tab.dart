import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/pos_inventory/models/procurement_models.dart';
import 'package:kirana_ai/features/pos_inventory/providers/procurement_provider.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';

class DistributorTab extends ConsumerWidget {
  const DistributorTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(procurementProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (data) {
        final unpaidPurchases = data.purchases.where((p) => p.paymentStatus != 'paid').toList();
        final totalDue = unpaidPurchases.fold(0.0, (sum, p) => sum + p.totalAmount);
        final dueToday = unpaidPurchases.where((p) => p.dueDate != null && 
            p.dueDate!.day == DateTime.now().day && 
            p.dueDate!.month == DateTime.now().month && 
            p.dueDate!.year == DateTime.now().year).toList();
        final totalDueToday = dueToday.fold(0.0, (sum, p) => sum + p.totalAmount);

        return RefreshIndicator(
          onRefresh: () => ref.read(procurementProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _PaymentSummaryCard(totalDue: totalDue, totalDueToday: totalDueToday),
              const SizedBox(height: 24),
              _sectionHeader(context, 'Pending Payments'),
              const SizedBox(height: 12),
              if (unpaidPurchases.isEmpty)
                _emptyState('No pending payments to distributors.')
              else
                ...unpaidPurchases.map((p) => _DistributorPaymentTile(order: p)),
              
              const SizedBox(height: 24),
              _sectionHeader(context, 'Distributors', onAdd: () => _showAddSupplierSheet(context, ref)),
              const SizedBox(height: 12),
              if (data.suppliers.isEmpty)
                _emptyState('No distributors added yet.')
              else
                ...data.suppliers.map((s) => _SupplierTile(supplier: s)),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(BuildContext context, String title, {VoidCallback? onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (onAdd != null)
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add'),
          ),
      ],
    );
  }

  Widget _emptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(message, style: const TextStyle(color: BrandColors.muted)),
      ),
    );
  }

  void _showAddSupplierSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddSupplierSheet(ref: ref),
    );
  }
}

class _AddSupplierSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AddSupplierSheet({required this.ref});

  @override
  State<_AddSupplierSheet> createState() => _AddSupplierSheetState();
}

class _AddSupplierSheetState extends State<_AddSupplierSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
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
          const Text('Add New Distributor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: BrandColors.ink)),
          const SizedBox(height: 16),
          
          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            successMessage: 'Distributor added!',
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: _nameCtrl,
            enabled: !_saving && !_success,
            decoration: const InputDecoration(labelText: 'Distributor Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneCtrl,
            enabled: !_saving && !_success,
            decoration: const InputDecoration(labelText: 'Phone/Contact'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: 'Save Distributor',
              isLoading: _saving,
              onPressed: _success ? null : () async {
                if (_nameCtrl.text.isEmpty) {
                  setState(() => _error = 'Name is required');
                  return;
                }
                setState(() {
                  _saving = true;
                  _error = null;
                });
                try {
                  await widget.ref.read(procurementProvider.notifier).createSupplier(
                    name: _nameCtrl.text,
                    phone: _phoneCtrl.text,
                  );
                  if (mounted) {
                    setState(() {
                      _saving = false;
                      _success = true;
                    });
                    await Future.delayed(const Duration(milliseconds: 600));
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

class _PaymentSummaryCard extends StatelessWidget {
  final double totalDue;
  final double totalDueToday;
  const _PaymentSummaryCard({required this.totalDue, required this.totalDueToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          const Text('Total Outstanding to Distributors', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Text('₹${totalDue.toStringAsFixed(0)}', 
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
              const SizedBox(width: 8),
              Text('₹${totalDueToday.toStringAsFixed(0)} due today', 
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistributorPaymentTile extends ConsumerWidget {
  final PurchaseOrder order;
  const _DistributorPaymentTile({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = order.dueDate != null && order.dueDate!.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isOverdue ? BrandColors.error.withValues(alpha: 0.3) : BrandColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.supplierName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      order.notes ?? 'Stock Purchase',
                      style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${order.totalAmount.toStringAsFixed(0)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: BrandColors.error)),
                  if (order.dueDate != null)
                    Text(
                      'Due: ${order.dueDate!.day}/${order.dueDate!.month}',
                      style: TextStyle(
                        fontSize: 11, 
                        color: isOverdue ? BrandColors.error : BrandColors.muted,
                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showPaymentDetails(context, ref),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => ref.read(procurementProvider.notifier).markAsPaid(order.purchaseId),
                  style: ElevatedButton.styleFrom(backgroundColor: BrandColors.success),
                  child: const Text('Mark Paid'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => FutureBuilder<List<PurchaseItem>>(
        future: ref.read(procurementProvider.notifier).fetchPurchaseItems(order.purchaseId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
          }
          final items = snapshot.data ?? [];
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Purchase Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('From ${order.supplierName}', style: const TextStyle(color: BrandColors.muted)),
                const Divider(height: 32),
                if (items.isEmpty)
                  const Text('No items found for this order.')
                else
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Qty: ${item.quantity.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
                            ],
                          ),
                        ),
                        Text('₹${(item.quantity * item.costPrice).toStringAsFixed(0)}'),
                      ],
                    ),
                  )),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bill', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SupplierTile extends StatelessWidget {
  final Supplier supplier;
  const _SupplierTile({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.business_rounded, color: BrandColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (supplier.phone != null)
                  Text(supplier.phone!, style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right_rounded, color: BrandColors.muted),
          ),
        ],
      ),
    );
  }
}
