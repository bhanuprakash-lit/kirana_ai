// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../models/inventory_item.dart';
import '../providers/inventory_provider.dart';
import 'widgets/add_product_sheet.dart';
import 'widgets/barcode_scanner_overlay.dart';

class InventoryTab extends ConsumerStatefulWidget {
  const InventoryTab({super.key});

  @override
  ConsumerState<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends ConsumerState<InventoryTab> {
  final _searchCtrl = TextEditingController();
  String? _selectedCategory;
  String _searchQuery = '';
  bool _isExpanded = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (barcode == null || !mounted) return;

    final data = ref.read(inventoryProvider).value;
    if (data == null) return;

    final item = data.items.where((i) => i.barcode == barcode).firstOrNull;

    if (item != null) {
      _showUpdateStockDialog(item);
    } else {
      if (mounted) showAddProductSheet(context, ref, initialBarcode: barcode);
    }
  }

  void _showUpdateStockDialog(InventoryItem item) {
    if (item.isPerishable) {
      _showPerishableOptions(item);
    } else {
      _showSimpleUpdateStock(item);
    }
  }

  void _showPerishableOptions(InventoryItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text('Current stock: ${item.stockLabel}',
                style: const TextStyle(color: BrandColors.muted, fontSize: 13)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showReceiveBatchDialog(item);
                },
                icon: const Icon(Icons.add_box_outlined),
                label: const Text('Receive New Batch'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrandColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSimpleUpdateStock(item);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Correct Stock Count'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiveBatchDialog(InventoryItem item) {
    final qtyCtrl = TextEditingController();
    DateTime? selectedExpiry;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          title: Text('Receive Batch: ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current stock: ${item.stockLabel}',
                  style: const TextStyle(color: BrandColors.muted, fontSize: 12)),
              const SizedBox(height: 16),
              TextField(
                controller: qtyCtrl,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))],
                decoration: InputDecoration(
                  labelText: 'Quantity Received',
                  suffixText: item.isLoose ? (item.unit ?? 'units') : 'units',
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now().add(const Duration(days: 3)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (date != null) setDialog(() => selectedExpiry = date);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: BrandColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: BrandColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        selectedExpiry == null
                            ? 'Select Expiry Date *'
                            : '${selectedExpiry!.day}/${selectedExpiry!.month}/${selectedExpiry!.year}',
                        style: TextStyle(
                          color: selectedExpiry == null ? BrandColors.muted : BrandColors.ink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: selectedExpiry == null ? null : () async {
                final qty = double.tryParse(qtyCtrl.text);
                if (qty == null || qty <= 0) return;
                final expiryStr =
                    '${selectedExpiry!.year}-${selectedExpiry!.month.toString().padLeft(2,'0')}-${selectedExpiry!.day.toString().padLeft(2,'0')}';
                final success = await ref
                    .read(inventoryProvider.notifier)
                    .receiveBatch(
                      productId: item.productId,
                      quantity: qty,
                      expiryDate: expiryStr,
                      currentStock: item.stockQuantity,
                    );
                if (success && ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Batch received for ${item.name}')),
                  );
                }
              },
              child: const Text('Receive'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSimpleUpdateStock(InventoryItem item) {
    final ctrl = TextEditingController(text: item.stockQuantity.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Correct Stock: ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current: ${item.stockLabel}',
                style: const TextStyle(color: BrandColors.muted)),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))],
              decoration: InputDecoration(
                labelText: 'Correct Stock Quantity',
                suffixText: item.isLoose ? (item.unit ?? 'units') : 'units',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newQty = double.tryParse(ctrl.text);
              if (newQty != null) {
                final success = await ref
                    .read(inventoryProvider.notifier)
                    .updateStock(item.productId, newQty);
                if (success && ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Stock corrected for ${item.name}')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product_fab',
        onPressed: () => showAddProductSheet(context, ref),
        backgroundColor: BrandColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorView(
          message: err.toString(),
          onRetry: () => ref.read(inventoryProvider.notifier).refresh(),
        ),
        data: (data) {
          if (data.items.isEmpty) {
            return _EmptyInventory(
              onAdd: () => showAddProductSheet(context, ref),
            );
          }

          final categories = data.categories
              .map((c) => c['name'] as String)
              .toList()
            ..sort();
          
          final q = _searchQuery.toLowerCase().trim();
          final filteredItems = data.items.where((item) {
            final matchesCategory = _selectedCategory == null || 
                item.categoryName == _selectedCategory;
            final matchesSearch = q.isEmpty || 
                item.name.toLowerCase().contains(q) || 
                (item.categoryName?.toLowerCase().contains(q) ?? false) ||
                (item.brand?.toLowerCase().contains(q) ?? false);
            return matchesCategory && matchesSearch;
          }).toList();

          final Map<String, List<InventoryItem>> filteredGrouped = {};
          for (final item in filteredItems) {
            final cat = item.categoryName ?? 'Uncategorised';
            filteredGrouped.putIfAbsent(cat, () => []).add(item);
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(inventoryProvider.notifier).refresh(),
            color: BrandColors.primary,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: InputDecoration(
                              hintText: 'Search items or categories...',
                              prefixIcon: const Icon(Icons.search_rounded,
                                  size: 20, color: BrandColors.muted),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, size: 18),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: BrandColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: BrandColors.border),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _scanBarcode,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: BrandColors.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.qr_code_scanner_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final allCategories = ['All', ...categories];
                        final initialCount = constraints.maxWidth > 400 ? 6 : 4;
                        
                        final displayCategories = _isExpanded 
                            ? allCategories 
                            : allCategories.take(initialCount).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 0,
                              children: [
                                for (final cat in displayCategories)
                                  _CategoryChip(
                                    label: cat,
                                    isSelected: cat == 'All' 
                                        ? _selectedCategory == null 
                                        : _selectedCategory == cat,
                                    onTap: () => setState(() {
                                      _selectedCategory = cat == 'All' ? null : cat;
                                    }),
                                  ),
                                
                                if (!_isExpanded && allCategories.length > initialCount)
                                  _ViewMoreChip(
                                    label: '+${allCategories.length - initialCount} more',
                                    onTap: () => setState(() => _isExpanded = true),
                                  ),
                              ],
                            ),
                            if (_isExpanded)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => setState(() => _isExpanded = false),
                                  icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 18),
                                  label: const Text('Show Less', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                  style: TextButton.styleFrom(
                                    foregroundColor: BrandColors.primary,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                if (filteredItems.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No matches found',
                          style: TextStyle(color: BrandColors.muted)),
                    ),
                  )
                else
                  for (final entry in filteredGrouped.entries) ...[
                    if (_selectedCategory == null)
                      SliverToBoxAdapter(
                        child: _CategoryHeader(
                          name: entry.key,
                          count: entry.value.length,
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _InventoryTile(
                            item: entry.value[i],
                            onTap: () => _showUpdateStockDialog(entry.value[i]),
                          ),
                          childCount: entry.value.length,
                        ),
                      ),
                    ),
                  ],
                const SliverToBoxAdapter(
                    child: SizedBox(height: 100)), // FAB clearance
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: BrandColors.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : BrandColors.ink,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? BrandColors.primary : BrandColors.border,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      ),
    );
  }
}

class _ViewMoreChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ViewMoreChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: BrandColors.surfaceTint,
        labelStyle: const TextStyle(
          color: BrandColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: BrandColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String name;
  final int count;
  const _CategoryHeader({required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: BrandColors.muted,
                  ),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(
                color: BrandColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;
  const _InventoryTile({required this.item, required this.onTap});

  Color _categoryColor(String? cat) {
    final c = cat?.toLowerCase() ?? '';
    if (c.contains('staple') || c.contains('grain')) return Colors.amber;
    if (c.contains('dairy')) return Colors.lightBlue;
    if (c.contains('drink') || c.contains('beverage')) return Colors.teal;
    if (c.contains('snack')) return Colors.deepPurple;
    if (c.contains('care') || c.contains('soap')) return Colors.pink;
    if (c.contains('clean')) return Colors.green;
    if (c.contains('veg')) return Colors.lightGreen;
    if (c.contains('fruit')) return Colors.red;
    if (c.contains('medic')) return Colors.indigo;
    return BrandColors.primary;
  }

  IconData _categoryIcon(String? cat) {
    final c = cat?.toLowerCase() ?? '';
    if (c.contains('staple') || c.contains('grain') || c.contains('rice')) {
      return Icons.grain_rounded;
    }
    if (c.contains('dairy') || c.contains('milk') || c.contains('curd')) {
      return Icons.egg_alt_rounded;
    }
    if (c.contains('drink') || c.contains('beverage') || c.contains('juice')) {
      return Icons.local_drink_rounded;
    }
    if (c.contains('snack') || c.contains('biscuit') || c.contains('chip')) {
      return Icons.cookie_rounded;
    }
    if (c.contains('care') || c.contains('soap') || c.contains('hygiene')) {
      return Icons.spa_rounded;
    }
    if (c.contains('clean') || c.contains('deterg')) {
      return Icons.cleaning_services_rounded;
    }
    if (c.contains('veg')) return Icons.eco_rounded;
    if (c.contains('fruit')) return Icons.apple_rounded;
    if (c.contains('medic') || c.contains('pharma')) {
      return Icons.medication_rounded;
    }
    return Icons.inventory_2_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(item.categoryName);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _categoryIcon(item.categoryName),
            color: catColor,
            size: 20,
          ),
        ),
        title: Text(
          item.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: BrandColors.ink,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              '₹${item.price.toStringAsFixed(0)} / ${item.isLoose ? (item.unit ?? "unit") : "unit"}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: BrandColors.primary,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Stock: ${item.stockLabel}',
              style: TextStyle(
                color: item.isOutOfStock 
                  ? BrandColors.error 
                  : item.isLowStock 
                    ? BrandColors.accent 
                    : BrandColors.muted,
                fontWeight: item.isLowStock || item.isOutOfStock 
                  ? FontWeight.w700 
                  : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: BrandColors.muted,
          size: 20,
        ),
      ),
    );
  }
}

class _EmptyInventory extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyInventory({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: BrandColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.inventory_2_outlined,
                  size: 40, color: BrandColors.primary),
            ),
            const SizedBox(height: 20),
            Text('No inventory yet',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first product.\nCreate a category first, then add items.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add First Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 48, color: BrandColors.muted),
            const SizedBox(height: 16),
            Text('Could not load inventory',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
