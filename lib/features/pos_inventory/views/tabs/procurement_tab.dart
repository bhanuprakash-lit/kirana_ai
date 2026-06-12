import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../models/procurement_models.dart';
import '../../providers/procurement_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/reorder_provider.dart';
import '../widgets/invoice_scan_sheet.dart';

class ProcurementTab extends ConsumerWidget {
  const ProcurementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncData = ref.watch(procurementProvider);

    // Arriving from a reorder suggestion / ML reorder screen: open the New
    // Purchase Order sheet pre-filled, once suppliers are loaded.
    final prefill = ref.watch(purchasePrefillProvider);
    if (prefill != null && asyncData.hasValue) {
      final suppliers = asyncData.value!.suppliers;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(purchasePrefillProvider.notifier).clear();
        if (suppliers.isNotEmpty) {
          _showAddPurchaseSheet(context, ref, suppliers, prefill: prefill);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.procAddSupplierFirstToCreatePo)),
          );
        }
      });
    }

    return asyncData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: ListShimmer(itemCount: 6),
      ),
      error: (err, _) => Center(child: Text(l10n.procErrorWithMessage('$err'))),
      data: (data) => RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref.read(procurementProvider.notifier).refresh();
          await ref.read(reorderProvider.notifier).refresh();
        },
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ..._reorderSection(
              context,
              ref,
              ref.watch(reorderProvider),
              data.suppliers,
            ),
            _sectionHeader(
              context,
              l10n.procSuppliers,
              onAdd: () => _showAddSupplierSheet(context, ref),
            ),
            const SizedBox(height: 12),
            if (data.suppliers.isEmpty)
              _emptyState(l10n.procNoSuppliersYet)
            else
              ...data.suppliers.map(
                (s) => _SupplierTile(
                  supplier: s,
                  onEdit: () => _showEditSupplierSheet(context, ref, s),
                ),
              ),

            const SizedBox(height: 24),
            _sectionHeader(
              context,
              l10n.procRecentPurchases,
              onAdd: data.suppliers.isEmpty
                  ? null
                  : () => _showAddPurchaseSheet(context, ref, data.suppliers),
              onScan: () => showInvoiceScanSheet(context, ref, data.suppliers),
            ),
            if (data.suppliers.isEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BrandColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: BrandColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: BrandColors.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.procAddAtLeastOneSupplier,
                        style: const TextStyle(
                          color: BrandColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (data.purchases.isEmpty)
              _emptyState(l10n.procNoPurchaseOrdersYet)
            else
              ...data.purchases.map((p) => _PurchaseOrderTile(order: p)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onAdd,
    VoidCallback? onScan,
  }) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onScan != null)
              TextButton.icon(
                onPressed: onScan,
                icon: const Icon(Icons.document_scanner_rounded, size: 16),
                label: Text(l10n.procScanInvoice),
                style: TextButton.styleFrom(
                  foregroundColor: BrandColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            if (onAdd != null)
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(l10n.procAdd),
              ),
          ],
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

  /// Velocity-based reorder suggestions, shown above Suppliers. Empty list when
  /// nothing is running low (or while loading/erroring) so the tab stays clean.
  List<Widget> _reorderSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ReorderSuggestion>> async,
    List<Supplier> suppliers,
  ) {
    final l10n = AppLocalizations.of(context);
    final items = async.asData?.value ?? const <ReorderSuggestion>[];
    if (items.isEmpty) return const [];
    return [
      _sectionHeader(context, l10n.procSuggestedReorders),
      Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 8),
        child: Text(
          l10n.procRunningLowLast30Days,
          style: const TextStyle(fontSize: 12, color: BrandColors.muted),
        ),
      ),
      ...items.map(
        (s) => _ReorderCard(
          s: s,
          onOrder: suppliers.isEmpty
              ? null
              : () => _showAddPurchaseSheet(
                  context,
                  ref,
                  suppliers,
                  prefill: PurchasePrefill(
                    productId: s.productId,
                    productName: s.productName,
                    qty: s.suggestedQty,
                    cost: s.costPrice,
                    supplierId: s.supplierId,
                  ),
                ),
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  void _showAddSupplierSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.procAddNewSupplier,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: saving
                            ? null
                            : () async {
                                final contact =
                                    await ContactService.pickContact();
                                if (contact != null) {
                                  setModalState(() {
                                    nameCtrl.text = contact.name!.first
                                        .toString();
                                    if (contact.phones.isNotEmpty) {
                                      phoneCtrl.text =
                                          ContactService.formatPhone(
                                            contact.phones.first.number,
                                          );
                                    }
                                  });
                                }
                              },
                        icon: const Icon(Icons.contacts_rounded, size: 18),
                        label: Text(l10n.procContacts),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    enabled: !saving,
                    maxLength: 60,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[<>{}\\\\&;"\']'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.procSupplierName,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneCtrl,
                    enabled: !saving,
                    keyboardType: TextInputType.phone,
                    maxLength: 15,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[-0-9+ ]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.procPhoneNumber,
                      counterText: '',
                      hintText: '+91 XXXXX XXXXX',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: categoryCtrl,
                    enabled: !saving,
                    maxLength: 40,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[<>{}\\\\&;"\']'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.procCategoryHint,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saving
                          ? null
                          : () async {
                              final name = nameCtrl.text.trim();
                              final phone = phoneCtrl.text
                                  .trim()
                                  .replaceAll(' ', '')
                                  .replaceAll('-', '');
                              if (name.isEmpty) return;
                              if (phone.isNotEmpty) {
                                final digits = phone.replaceAll('+', '');
                                if (digits.length < 7 ||
                                    !RegExp(r'^\+?\d+$').hasMatch(phone)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.procEnterValidPhone),
                                    ),
                                  );
                                  return;
                                }
                              }
                              setModalState(() => saving = true);
                              try {
                                await ref
                                    .read(procurementProvider.notifier)
                                    .createSupplier(
                                      name: name,
                                      phone: phone.isEmpty ? null : phone,
                                      category: categoryCtrl.text.trim(),
                                    );
                              } catch (_) {
                                setModalState(() => saving = false);
                                return;
                              }
                              if (ctx.mounted) Navigator.pop(ctx);
                            },
                      child: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.procSaveSupplier),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditSupplierSheet(
    BuildContext context,
    WidgetRef ref,
    Supplier supplier,
  ) {
    final l10n = AppLocalizations.of(context);
    final nameCtrl = TextEditingController(text: supplier.name);
    final phoneCtrl = TextEditingController(text: supplier.phone ?? '');
    final categoryCtrl = TextEditingController(text: supplier.category ?? '');
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.procEditSupplier,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: saving
                            ? null
                            : () async {
                                final contact =
                                    await ContactService.pickContact();
                                if (contact != null) {
                                  setModalState(() {
                                    nameCtrl.text = contact.name!.first
                                        .toString();
                                    if (contact.phones.isNotEmpty) {
                                      phoneCtrl.text =
                                          ContactService.formatPhone(
                                            contact.phones.first.number,
                                          );
                                    }
                                  });
                                }
                              },
                        icon: const Icon(Icons.contacts_rounded, size: 18),
                        label: Text(l10n.procContacts),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameCtrl,
                    enabled: !saving,
                    maxLength: 60,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[<>{}\\\\&;"\']'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.procSupplierName,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneCtrl,
                    enabled: !saving,
                    keyboardType: TextInputType.phone,
                    maxLength: 15,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[-0-9+ ]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.procPhoneNumber,
                      counterText: '',
                      hintText: '+91 XXXXX XXXXX',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: categoryCtrl,
                    enabled: !saving,
                    maxLength: 40,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[<>{}\\\\&;"\']'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.procCategoryHint,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saving
                          ? null
                          : () async {
                              final name = nameCtrl.text.trim();
                              final phone = phoneCtrl.text
                                  .trim()
                                  .replaceAll(' ', '')
                                  .replaceAll('-', '');
                              if (name.isEmpty) return;
                              if (phone.isNotEmpty) {
                                final digits = phone.replaceAll('+', '');
                                if (digits.length < 7 ||
                                    !RegExp(r'^\+?\d+$').hasMatch(phone)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.procEnterValidPhone),
                                    ),
                                  );
                                  return;
                                }
                              }
                              setModalState(() => saving = true);
                              try {
                                await ref
                                    .read(procurementProvider.notifier)
                                    .updateSupplier(
                                      supplierId: supplier.supplierId,
                                      name: name,
                                      phone: phone.isEmpty ? null : phone,
                                      category: categoryCtrl.text.trim(),
                                    );
                              } catch (_) {
                                setModalState(() => saving = false);
                                return;
                              }
                              if (ctx.mounted) Navigator.pop(ctx);
                            },
                      child: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.procSaveChanges),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddPurchaseSheet(
    BuildContext context,
    WidgetRef ref,
    List<Supplier> suppliers, {
    PurchasePrefill? prefill,
  }) {
    final l10n = AppLocalizations.of(context);
    Supplier? selectedSupplier = prefill?.supplierId != null
        ? suppliers.firstWhere(
            (s) => s.supplierId == prefill!.supplierId,
            orElse: () => suppliers.first,
          )
        : suppliers.first;
    final products = ref.read(inventoryProvider).value?.items ?? [];

    // UI State
    bool saving = false;
    // Pre-fill the line item when arriving from a reorder suggestion.
    List<Map<String, dynamic>> selectedItems = prefill != null
        ? [
            {
              'product_id': prefill.productId,
              'name': prefill.productName,
              'quantity': prefill.qty,
              'cost_price': prefill.cost,
            },
          ]
        : [];
    DateTime? dueDate = DateTime.now().add(const Duration(days: 7));
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.procNewPurchaseOrder,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.procRecordItemsFromDistributor,
                  style: const TextStyle(
                    color: BrandColors.muted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // 1. Supplier & Dates
                      _formSectionTitle(l10n.procOrderDetails),
                      const SizedBox(height: 12),
                      _inputLabel(l10n.procDistributor),
                      DropdownButtonFormField<Supplier>(
                        initialValue: selectedSupplier,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: BrandColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                        items: suppliers
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedSupplier = v),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _inputLabel(l10n.procPaymentDueDate),
                                InkWell(
                                  onTap: () async {
                                    final d = await showDatePicker(
                                      context: ctx,
                                      initialDate: dueDate ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                    );
                                    if (d != null) setState(() => dueDate = d);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: BrandColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_rounded,
                                          size: 16,
                                          color: BrandColors.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          dueDate == null
                                              ? l10n.procSelectDate
                                              : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                                        ),
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
                          _formSectionTitle(
                            l10n.procItemsCount(selectedItems.length),
                          ),
                          TextButton.icon(
                            onPressed: () => _showInlineProductPicker(
                              ctx,
                              products,
                              (item) {
                                setState(() {
                                  final idx = selectedItems.indexWhere(
                                    (e) =>
                                        e['product_id'] == item['product_id'],
                                  );
                                  if (idx != -1) {
                                    // Merge: add quantity, keep the new cost price
                                    selectedItems[idx] = {
                                      ...selectedItems[idx],
                                      'quantity':
                                          (selectedItems[idx]['quantity']
                                              as int) +
                                          (item['quantity'] as int),
                                      'cost_price': item['cost_price'],
                                    };
                                  } else {
                                    selectedItems.add(item);
                                  }
                                });
                              },
                            ),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: Text(l10n.procAddItem),
                          ),
                        ],
                      ),
                      if (selectedItems.isEmpty)
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: BrandColors.border,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              l10n.procNoItemsAddedYet,
                              style: const TextStyle(color: BrandColors.muted),
                            ),
                          ),
                        )
                      else
                        ...selectedItems.map(
                          (item) => Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '₹${item['cost_price']} × ${item['quantity']}',
                                        style: TextStyle(
                                          color: BrandColors.muted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${(item['quantity'] * item['cost_price']).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => selectedItems.remove(item),
                                  ),
                                  child: const Icon(
                                    Icons.remove_circle_outline,
                                    color: BrandColors.error,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),
                      _inputLabel(l10n.procNotes),
                      TextField(
                        controller: notesCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: l10n.procNotesHint,
                          filled: true,
                          fillColor: BrandColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Bottom Bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: BrandColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.procTotalAmount,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.muted,
                              ),
                            ),
                            Text(
                              '₹${selectedItems.fold(0.0, (sum, item) => sum + (item['quantity'] * item['cost_price'])).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (selectedItems.isEmpty || saving)
                              ? null
                              : () async {
                                  setState(() => saving = true);
                                  try {
                                    await ref
                                        .read(procurementProvider.notifier)
                                        .createPurchaseOrder(
                                          supplierId:
                                              selectedSupplier!.supplierId,
                                          items: selectedItems,
                                          dueDate: dueDate,
                                          notes: notesCtrl.text,
                                        );
                                    if (ctx.mounted) Navigator.pop(ctx);
                                  } finally {
                                    if (ctx.mounted) {
                                      setState(() => saving = false);
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.procSaveOrder),
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
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: BrandColors.muted,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showInlineProductPicker(
    BuildContext context,
    List<dynamic> products,
    Function(Map<String, dynamic>) onAdd,
  ) {
    final l10n = AppLocalizations.of(context);
    List<dynamic> filteredProducts = products;
    final searchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                  hintText: l10n.procSearchProduct,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (v) {
                  setState(() {
                    filteredProducts = products
                        .where(
                          (p) => p.name.toLowerCase().contains(v.toLowerCase()),
                        )
                        .toList();
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

  void _showItemDetailsDialog(
    BuildContext context,
    dynamic product,
    Function(Map<String, dynamic>) onAdd,
  ) {
    final l10n = AppLocalizations.of(context);
    final qtyCtrl = TextEditingController(text: '1');
    final costCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.procAddProduct(product.name)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qtyCtrl,
              decoration: InputDecoration(labelText: l10n.procQuantity),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            TextField(
              controller: costCtrl,
              decoration: InputDecoration(labelText: l10n.procCostPricePerUnit),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.procCancel),
          ),
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
            child: Text(l10n.procAdd),
          ),
        ],
      ),
    );
  }
}

class _ReorderCard extends StatelessWidget {
  final ReorderSuggestion s;
  final VoidCallback? onOrder;
  const _ReorderCard({required this.s, this.onOrder});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cover = s.daysOfCover;
    final coverLabel = cover == null
        ? '—'
        : l10n.procDaysCover(cover.toStringAsFixed(cover < 10 ? 1 : 0));
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
              Expanded(
                child: Text(
                  s.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.procOrderQty('${s.suggestedQty} ${s.unit ?? ''}'.trim()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: BrandColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.procStockLine(
              '${s.stock}',
              s.avgDaily.toStringAsFixed(1),
              coverLabel,
            ),
            style: const TextStyle(fontSize: 12, color: BrandColors.muted),
          ),
          if (s.supplierName != null) ...[
            const SizedBox(height: 2),
            Text(
              '${s.supplierName}'
              '${s.leadTimeDays > 0 ? ' · ${s.leadTimeDays}d lead' : ''}'
              '${s.reorderCost > 0 ? ' · ~₹${s.reorderCost.toStringAsFixed(0)}' : ''}',
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ],
          if (onOrder != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onOrder,
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 15),
                label: Text(
                  l10n.procCreatePurchaseOrder,
                  style: const TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: BrandColors.primary,
                  side: const BorderSide(color: BrandColors.primary),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
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
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
            child: const Icon(
              Icons.business_rounded,
              color: BrandColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        supplier.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (supplier.category != null &&
                        supplier.category!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: BrandColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          supplier.category!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: BrandColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (supplier.phone != null)
                  Text(
                    supplier.phone!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              color: BrandColors.muted,
              size: 20,
            ),
            tooltip: l10n.procEditSupplierTooltip,
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
    final l10n = AppLocalizations.of(context);
    final statusColor = _statusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                    Text(
                      order.supplierName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${order.purchaseDate.day}/${order.purchaseDate.month}/${order.purchaseDate.year}',
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
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
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
                onPressed: () => ref
                    .read(procurementProvider.notifier)
                    .markAsReceived(order.purchaseId),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: BrandColors.success),
                  foregroundColor: BrandColors.success,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  l10n.procMarkAsReceived,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.ordered:
        return Colors.orange;
      case PurchaseStatus.received:
        return BrandColors.success;
      case PurchaseStatus.cancelled:
        return BrandColors.error;
      default:
        return BrandColors.muted;
    }
  }
}
