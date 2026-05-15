import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/pos_inventory/views/widgets/add_product_sheet.dart';
import 'package:kirana_ai/features/referral/views/referral_scan_sheet.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/brand_theme.dart';
import '../models/pos_product.dart';
import '../providers/pos_provider.dart';
import '../providers/inventory_provider.dart';
import '../../../../core/services/contact_service.dart';
import 'widgets/barcode_scanner_overlay.dart';
import 'widgets/order_dialog.dart';
import 'widgets/today_orders_sheet.dart';

class PosTab extends ConsumerStatefulWidget {
  const PosTab({super.key});

  @override
  ConsumerState<PosTab> createState() => _PosTabState();
}

class _PosTabState extends ConsumerState<PosTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<PosProduct> get _filtered {
    final products = ref.read(posProvider).products;
    if (_query.isEmpty) return products;
    final q = _query.toLowerCase();
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              (p.brand?.toLowerCase().contains(q) ?? false) ||
              (p.barcode?.contains(q) ?? false),
        )
        .toList();
  }

  Future<void> _handleProductAdd(PosProduct p) async {
    if (p.isLoose) {
      final qty = await _showWeightDialog(p);
      if (qty != null && qty > 0) {
        ref.read(posProvider.notifier).addToCart(p, qty: qty);
      }
    } else {
      ref.read(posProvider.notifier).addToCart(p);
    }
  }

  Future<double?> _showWeightDialog(
    PosProduct p, {
    double? initialValue,
  }) async {
    final ctrl = TextEditingController(text: initialValue?.toString() ?? '');
    return showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Enter ${p.unit ?? "Qty"}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Price: ${p.priceLabel}',
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
              ],
              decoration: InputDecoration(
                labelText: 'Weight / Measurement',
                suffixText: p.unit ?? '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
            onPressed: () => Navigator.pop(ctx, double.tryParse(ctrl.text)),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUnknownBarcode(String barcode) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unknown Barcode'),
        content: Text(
          'Barcode "$barcode" is not in your inventory. What would you like to do?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'new'),
            child: const Text('Add as New'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, 'link'),
            child: const Text('Link to Existing Item'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (choice == 'new') {
      await showAddProductSheet(context, ref, initialBarcode: barcode);
    } else if (choice == 'link') {
      _showLinkToExistingDialog(barcode);
    }
  }

  void _showLinkToExistingDialog(String barcode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true, // Use root to ensure it pops correctly
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollCtrl) => Consumer(
          builder: (context, ref, _) {
            final inventoryAsync = ref.watch(inventoryProvider);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Link Barcode "$barcode"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: inventoryAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) =>
                        Center(child: Text('Error loading inventory: $err')),
                    data: (data) {
                      final unbarcoded = data.items
                          .where((i) => i.barcode == null || i.barcode!.isEmpty)
                          .toList();

                      if (unbarcoded.isEmpty) {
                        return const Center(
                          child: Text('No items found without barcodes.'),
                        );
                      }

                      return ListView.separated(
                        controller: scrollCtrl,
                        itemCount: unbarcoded.length,
                        separatorBuilder: (_, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final item = unbarcoded[i];
                          return ListTile(
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              'Category: ${item.categoryName ?? "General"}',
                            ),
                            trailing: const Icon(
                              Icons.link_rounded,
                              color: BrandColors.primary,
                            ),
                            onTap: () async {
                              final messenger = ScaffoldMessenger.of(
                                this.context,
                              );
                              final success = await ref
                                  .read(inventoryProvider.notifier)
                                  .linkBarcode(item.productId, barcode);
                              if (context.mounted) {
                                Navigator.of(
                                  ctx,
                                ).pop(); // Use the bottom sheet's context explicitly
                                if (success) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Linked $barcode to ${item.name}',
                                      ),
                                    ),
                                  );
                                  // Automatically add the linked item to cart
                                  final updatedProduct = ref
                                      .read(posProvider)
                                      .products
                                      .firstWhere(
                                        (p) => p.productId == item.productId,
                                      );
                                  _handleProductAdd(updatedProduct);
                                }
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openReferralScanner() async {
    const prefix = 'KIRANA_REF:';
    String? scannedToken;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Scan Referral QR',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            backgroundColor: BrandColors.accent,
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue ?? '';
              if (code.startsWith(prefix) && scannedToken == null) {
                scannedToken = code.substring(prefix.length);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );

    if (!mounted || scannedToken == null) return;

    final pending = await showReferralScanSheet(context, ref, scannedToken!);
    if (!mounted || pending == null) return;

    ref.read(posProvider.notifier).setPendingReferral(pending);
  }

  void _openScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodeScannerOverlay(
          onDetected: (barcode) async {
            // Show feedback overlay immediately on the POS screen
            final overlay = OverlayEntry(
              builder: (context) => Container(
                color: Colors.black45,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Looking for $barcode...',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: BrandColors.ink,
                            decoration: TextDecoration.none,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            Overlay.of(context).insert(overlay);

            try {
              final product = await ref
                  .read(posProvider.notifier)
                  .lookupBarcode(barcode);
              overlay.remove();

              if (product != null) {
                _handleProductAdd(product);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} added to cart'),
                      duration: const Duration(milliseconds: 600),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  _handleUnknownBarcode(barcode);
                }
              }
            } catch (_) {
              overlay.remove();
            }
          },
        ),
      ),
    );
  }

  void _showCustomerSearchSheet() {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Customer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showAddCustomerDialog();
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by name or phone...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (v) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: ref
                      .read(posProvider.notifier)
                      .searchCustomers(searchCtrl.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final customers = snapshot.data ?? [];
                    if (customers.isEmpty) {
                      return const Center(child: Text('No customers found.'));
                    }
                    return ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (ctx, index) {
                        final c = customers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: BrandColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: BrandColors.primary,
                            ),
                          ),
                          title: Text(c['name'] as String),
                          subtitle: Text(c['phone'] as String),
                          onTap: () {
                            ref
                                .read(posProvider.notifier)
                                .setCustomer(
                                  c['customer_id'] as int,
                                  c['name'] as String,
                                );
                            Navigator.pop(ctx);
                          },
                        );
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

  void _showAddCustomerDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add New Customer'),
              IconButton(
                onPressed: () async {
                  final contact = await ContactService.pickContact();
                  if (contact != null) {
                    setModalState(() {
                      nameCtrl.text = contact.name!.first.toString();
                      if (contact.phones.isNotEmpty) {
                        phoneCtrl.text = ContactService.formatPhone(
                          contact.phones.first.number,
                        );
                      }
                    });
                  }
                },
                icon: const Icon(
                  Icons.contacts_rounded,
                  color: BrandColors.primary,
                ),
                tooltip: 'Select from Contacts',
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
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
                if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
                await ref
                    .read(posProvider.notifier)
                    .createCustomer(nameCtrl.text, phoneCtrl.text);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Save & Select'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posProvider);
    final cart = state.cart;
    final isSearching = _query.isNotEmpty;

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search products…',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: BrandColors.muted,
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    filled: true,
                    fillColor: BrandColors.surfaceTint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: BrandColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: BrandColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: BrandColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Referral QR scan
              Tooltip(
                message: 'Scan Referral QR',
                child: GestureDetector(
                  onTap: _openReferralScanner,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: BrandColors.accent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Product barcode scan
              GestureDetector(
                onTap: _openScanner,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: BrandColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => showTodayOrdersSheet(context, ref),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: BrandColors.surfaceTint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    size: 20,
                    color: BrandColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isSearching)
          _SearchResults(
            products: _filtered,
            isLoading: state.isLoadingProducts,
            onAdd: (p) {
              _handleProductAdd(p);
              _searchCtrl.clear();
              setState(() => _query = '');
            },
          ),

        Expanded(
          child: state.isLoadingProducts && state.products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : cart.isEmpty
              ? _EmptyCart(
                  hasPosError: state.error != null,
                  errorMsg: state.error,
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _CartTile(
                    item: cart[i],
                    onEditLoose: (item) async {
                      final qty = await _showWeightDialog(
                        item.product,
                        initialValue: item.quantity,
                      );
                      if (qty != null && qty > 0) {
                        ref
                            .read(posProvider.notifier)
                            .updateQty(item.product.productId, qty);
                      }
                    },
                  ),
                ),
        ),

        const _SmartAssortmentHints(),

        if (cart.isNotEmpty)
          _OrderFooter(
            subtotal: state.subtotal,
            itemCount: state.cartItemCount,
            isPlacing: state.isPlacingOrder,
            selectedCustomer: state.selectedCustomerName,
            onSelectCustomer: _showCustomerSearchSheet,
            onClearCustomer: () =>
                ref.read(posProvider.notifier).clearCustomer(),
            onOrder: () => showOrderDialog(context, ref),
          ),
      ],
    );
  }
}

class _SmartAssortmentHints extends ConsumerWidget {
  const _SmartAssortmentHints();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posProvider);
    final cart = state.cart;
    if (cart.isEmpty || state.products.isEmpty) return const SizedBox.shrink();

    final cartIds = cart.map((e) => e.product.productId).toSet();
    final suggestions = state.products
        .where((p) => !cartIds.contains(p.productId))
        .take(5)
        .toList();
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: BrandColors.primary,
              ),
              SizedBox(width: 6),
              Text(
                'FREQUENTLY BOUGHT TOGETHER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 64,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            separatorBuilder: (_, index) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final p = suggestions[i];
              return InkWell(
                    onTap: () {
                      ref.read(posProvider.notifier).addToCart(p);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: BrandColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: BrandColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: BrandColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: BrandColors.ink,
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                '₹${p.price.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: BrandColors.muted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 100 * i))
                  .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<PosProduct> products;
  final bool isLoading;
  final ValueChanged<PosProduct> onAdd;

  const _SearchResults({
    required this.products,
    required this.isLoading,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: BrandColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          : products.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No products found',
                style: TextStyle(color: BrandColors.muted),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: products.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
              itemBuilder: (_, i) {
                final p = products[i];
                return ListTile(
                  dense: true,
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: BrandColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      size: 16,
                      color: BrandColors.primary,
                    ),
                  ),
                  title: Text(
                    p.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${p.priceLabel} · Stock: ${p.stockLabel}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => onAdd(p),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: BrandColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _CartTile extends ConsumerWidget {
  final dynamic item; // CartItem
  final Function(dynamic) onEditLoose;
  const _CartTile({required this.item, required this.onEditLoose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = item.product as PosProduct;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: BrandColors.surfaceTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              size: 18,
              color: BrandColors.muted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  p.priceLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          if (p.isLoose)
            GestureDetector(
              onTap: () => onEditLoose(item),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: BrandColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  '${item.quantity} ${p.unit ?? ""}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: BrandColors.primary,
                  ),
                ),
              ),
            )
          else
            _QtyControl(
              qty: item.quantity.toInt(),
              onDecrement: () => ref
                  .read(posProvider.notifier)
                  .updateQty(p.productId, item.quantity - 1),
              onIncrement: () => ref
                  .read(posProvider.notifier)
                  .updateQty(p.productId, item.quantity + 1),
            ),

          const SizedBox(width: 12),
          Text(
            '₹${item.lineTotal.toStringAsFixed(1)}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: BrandColors.primary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
  }
}

class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtyControl({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
        SizedBox(
          width: 28,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
        _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BrandColors.border),
        ),
        child: Icon(icon, size: 16, color: BrandColors.ink),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final bool hasPosError;
  final String? errorMsg;
  const _EmptyCart({required this.hasPosError, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasPosError
                  ? Icons.cloud_off_rounded
                  : Icons.shopping_cart_outlined,
              size: 56,
              color: BrandColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              hasPosError ? 'POS Offline' : 'Cart is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              hasPosError
                  ? (errorMsg ?? 'Could not connect to POS.')
                  : 'Search for a product or scan a barcode to start a sale.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderFooter extends StatelessWidget {
  final double subtotal;
  final double itemCount;
  final bool isPlacing;
  final String? selectedCustomer;
  final VoidCallback onSelectCustomer;
  final VoidCallback onClearCustomer;
  final VoidCallback onOrder;

  const _OrderFooter({
    required this.subtotal,
    required this.itemCount,
    required this.isPlacing,
    this.selectedCustomer,
    required this.onSelectCustomer,
    required this.onClearCustomer,
    required this.onOrder,
  });

  String _fmt(double v) {
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(1)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BrandColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedCustomer != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: BrandColors.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 16,
                      color: BrandColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Customer: $selectedCustomer',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: BrandColors.primary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onClearCustomer,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: BrandColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: onSelectCustomer,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: BrandColors.surfaceTint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 16,
                        color: BrandColors.muted,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add/Select Customer',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: BrandColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${itemCount % 1 == 0 ? itemCount.toInt() : itemCount.toStringAsFixed(2)} item${itemCount == 1 ? '' : 's'}',
                style: const TextStyle(color: BrandColors.muted, fontSize: 13),
              ),
              Text(
                'Subtotal: ${_fmt(subtotal)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isPlacing ? null : onOrder,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: isPlacing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text('Place Order · ${_fmt(subtotal)}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
