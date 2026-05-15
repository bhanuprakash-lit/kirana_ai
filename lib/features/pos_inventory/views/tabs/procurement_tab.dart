import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../core/services/contact_service.dart';
import '../../models/procurement_models.dart';
import '../../providers/procurement_provider.dart';
import '../../providers/inventory_provider.dart';

class ProcurementTab extends ConsumerWidget {
  const ProcurementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(procurementProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (data) => RefreshIndicator(
        onRefresh: () => ref.read(procurementProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader(context, 'Suppliers', onAdd: () => _showAddSupplierSheet(context, ref)),
            const SizedBox(height: 12),
            if (data.suppliers.isEmpty)
              _emptyState('No suppliers added yet.')
            else
              ...data.suppliers.map((s) => _SupplierTile(
                supplier: s,
                onEdit: () => _showEditSupplierSheet(context, ref, s),
              )),
            
            const SizedBox(height: 24),
            _sectionHeader(
              context, 
              'Recent Purchases', 
              onAdd: data.suppliers.isEmpty ? null : () => _showAddPurchaseSheet(context, ref, data.suppliers),
            ),
            if (data.suppliers.isEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BrandColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: BrandColors.error.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: BrandColors.error),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'If you want to add a purchase, add at least 1 supplier.',
                        style: TextStyle(color: BrandColors.error, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (data.purchases.isEmpty)
              _emptyState('No purchase orders yet.')
            else
              ...data.purchases.map((p) => _PurchaseOrderTile(order: p)),
          ],
        ),
      ),
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
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24, right: 24, top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Add New Supplier', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        final contact = await ContactService.pickContact();
                        if (contact != null) {
                          setModalState(() {
                            nameCtrl.text = contact.name!.first.toString();
                            if (contact.phones.isNotEmpty) {
                              phoneCtrl.text = ContactService.formatPhone(contact.phones.first.number);
                            }
                          });

                        }
                      },
                      icon: const Icon(Icons.contacts_rounded, size: 18),
                      label: const Text('Contacts'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Supplier Name')),
                const SizedBox(height: 16),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category (e.g. Dairy, FMCG, Beverages)')),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameCtrl.text.isEmpty) return;
                      await ref.read(procurementProvider.notifier).createSupplier(
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        category: categoryCtrl.text,
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text('Save Supplier'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditSupplierSheet(BuildContext context, WidgetRef ref, Supplier supplier) {
    final nameCtrl = TextEditingController(text: supplier.name);
    final phoneCtrl = TextEditingController(text: supplier.phone ?? '');
    final categoryCtrl = TextEditingController(text: supplier.category ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24, right: 24, top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Supplier', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        final contact = await ContactService.pickContact();
                        if (contact != null) {
                          setModalState(() {
                            nameCtrl.text = contact.name!.first.toString();
                            if (contact.phones.isNotEmpty) {
                              phoneCtrl.text = ContactService.formatPhone(contact.phones.first.number);
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.contacts_rounded, size: 18),
                      label: const Text('Contacts'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Supplier Name')),
                const SizedBox(height: 16),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category (e.g. Dairy, FMCG, Beverages)')),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameCtrl.text.isEmpty) return;
                      await ref.read(procurementProvider.notifier).updateSupplier(
                        supplierId: supplier.supplierId,
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        category: categoryCtrl.text,
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddPurchaseSheet(BuildContext context, WidgetRef ref, List<Supplier> suppliers) {
    Supplier? selectedSupplier = suppliers.first;
    final products = ref.read(inventoryProvider).value?.items ?? [];
    
    // UI State
    bool saving = false;
    List<Map<String, dynamic>> selectedItems = [];
    DateTime? dueDate = DateTime.now().add(const Duration(days: 7));
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('New Purchase Order', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close_rounded)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Record items purchased from a distributor.', style: TextStyle(color: BrandColors.muted, fontSize: 14)),
                const SizedBox(height: 24),
                
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // 1. Supplier & Dates
                      _formSectionTitle('Order Details'),
                      const SizedBox(height: 12),
                      _inputLabel('Distributor'),
                      DropdownButtonFormField<Supplier>(
                        initialValue: selectedSupplier,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: BrandColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        items: suppliers.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                        onChanged: (v) => setState(() => selectedSupplier = v),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _inputLabel('Payment Due Date'),
                                InkWell(
                                  onTap: () async {
                                    final d = await showDatePicker(
                                      context: ctx,
                                      initialDate: dueDate ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (d != null) setState(() => dueDate = d);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: BrandColors.background, borderRadius: BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today_rounded, size: 16, color: BrandColors.primary),
                                        const SizedBox(width: 8),
                                        Text(dueDate == null ? 'Select Date' : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 2. Items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _formSectionTitle('Items (${selectedItems.length})'),
                          TextButton.icon(
                            onPressed: () => _showInlineProductPicker(ctx, products, (item) {
                              setState(() => selectedItems.add(item));
                            }),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Item'),
                          ),
                        ],
                      ),
                      if (selectedItems.isEmpty)
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: BrandColors.border, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: Text('No items added yet', style: TextStyle(color: BrandColors.muted))),
                        )
                      else
                        ...selectedItems.map((item) => Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: BrandColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('₹${item['cost_price']} × ${item['quantity']}', style: TextStyle(color: BrandColors.muted, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text('₹${(item['quantity'] * item['cost_price']).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () => setState(() => selectedItems.remove(item)),
                                child: const Icon(Icons.remove_circle_outline, color: BrandColors.error, size: 20),
                              ),
                            ],
                          ),
                        )),
                        
                      const SizedBox(height: 32),
                      _inputLabel('Notes'),
                      TextField(
                        controller: notesCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Bill number, delivery notes, etc.',
                          filled: true,
                          fillColor: BrandColors.background,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                
                // Bottom Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: BrandColors.border))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Amount', style: TextStyle(fontSize: 12, color: BrandColors.muted)),
                            Text('₹${selectedItems.fold(0.0, (sum, item) => sum + (item['quantity'] * item['cost_price'])).toStringAsFixed(0)}', 
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (selectedItems.isEmpty || saving) ? null : () async {
                            setState(() => saving = true);
                            try {
                              await ref.read(procurementProvider.notifier).createPurchaseOrder(
                                supplierId: selectedSupplier!.supplierId,
                                items: selectedItems,
                                dueDate: dueDate,
                                notes: notesCtrl.text,
                              );
                              if (ctx.mounted) Navigator.pop(ctx);
                            } finally {
                              if (ctx.mounted) setState(() => saving = false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Save Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5));
  }

  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontSize: 12, color: BrandColors.muted, fontWeight: FontWeight.bold)),
    );
  }

  void _showInlineProductPicker(BuildContext context, List<dynamic> products, Function(Map<String, dynamic>) onAdd) {
    List<dynamic> filteredProducts = products;
    final searchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.7,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                controller: searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search product...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onChanged: (v) {
                  setState(() {
                    filteredProducts = products.where((p) => p.name.toLowerCase().contains(v.toLowerCase())).toList();
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (ctx, index) {
                    final p = filteredProducts[index];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text(p.brand ?? ''),
                      onTap: () {
                        Navigator.pop(ctx);
                        _showItemDetailsDialog(context, p, onAdd);
                      },
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

  void _showItemDetailsDialog(BuildContext context, dynamic product, Function(Map<String, dynamic>) onAdd) {
    final qtyCtrl = TextEditingController(text: '1');
    final costCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add ${product.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qtyCtrl,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            TextField(
              controller: costCtrl,
              decoration: const InputDecoration(labelText: 'Cost Price per unit'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final qty = int.tryParse(qtyCtrl.text) ?? 0;
              final cost = double.tryParse(costCtrl.text) ?? 0.0;
              if (qty <= 0 || cost <= 0) return;
              onAdd({
                'product_id': product.productId,
                'name': product.name,
                'quantity': qty,
                'cost_price': cost,
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _SupplierTile extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback? onEdit;
  const _SupplierTile({required this.supplier, this.onEdit});

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
                Row(
                  children: [
                    Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (supplier.category != null && supplier.category!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: BrandColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          supplier.category!.toUpperCase(),
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: BrandColors.primary),
                        ),
                      ),
                    ],
                  ],
                ),
                if (supplier.phone != null)
                  Text(supplier.phone!, style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, color: BrandColors.muted, size: 20),
            tooltip: 'Edit supplier',
          ),
        ],
      ),
    );
  }
}

class _PurchaseOrderTile extends ConsumerWidget {
  final PurchaseOrder order;
  const _PurchaseOrderTile({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '${order.purchaseDate.day}/${order.purchaseDate.month}/${order.purchaseDate.year}',
                      style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.status.name.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (order.status == PurchaseStatus.ordered) ...[
            const Divider(height: 16),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                onPressed: () => ref.read(procurementProvider.notifier).markAsReceived(order.purchaseId),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: BrandColors.success),
                  foregroundColor: BrandColors.success,
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Mark as Received', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.ordered: return Colors.orange;
      case PurchaseStatus.received: return BrandColors.success;
      case PurchaseStatus.cancelled: return BrandColors.error;
      default: return BrandColors.muted;
    }
  }
}
