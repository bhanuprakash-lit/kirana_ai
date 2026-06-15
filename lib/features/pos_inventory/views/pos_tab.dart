import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/pos_inventory/views/widgets/add_product_sheet.dart';

import '../../../core/locale/locale_provider.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../../../core/providers/usage_limits_provider.dart';
import '../../../core/services/usage_limits_service.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/pos_product.dart';
import '../providers/pos_provider.dart';
import '../providers/inventory_provider.dart';
import '../../../../core/services/contact_service.dart';
import 'widgets/continuous_scanner_sheet.dart';
import 'widgets/order_dialog.dart';
import 'widgets/basket_savings_banner.dart';
import '../../baskets/models/basket_model.dart';
import '../../baskets/providers/basket_provider.dart';
import '../../subscription/models/subscription_model.dart';
import '../../subscription/providers/subscription_provider.dart';
import 'widgets/voice_order_sheet.dart';
import 'widgets/handwriting_order_sheet.dart';
import '../../campaigns/models/campaign_model.dart' as campaign_card_lib;
import '../../campaigns/providers/campaign_provider.dart';
import '../../campaigns/views/widgets/campaign_card.dart';

class PosTab extends ConsumerStatefulWidget {
  const PosTab({super.key});

  @override
  ConsumerState<PosTab> createState() => _PosTabState();
}

class _PosTabState extends ConsumerState<PosTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

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
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          title: Text(l10n.posEnterQtyTitle(p.unit ?? l10n.posQtyFallback)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                l10n.posPriceLabel(p.priceLabel),
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
                  labelText: l10n.posWeightMeasurement,
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
              child: Text(l10n.posCommonCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, double.tryParse(ctrl.text)),
              child: Text(l10n.posCommonAddToCart),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleUnknownBarcode(String barcode) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          title: Text(l10n.posUnknownBarcodeTitle),
          content: Text(l10n.posUnknownBarcodeBody(barcode)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'new'),
              child: Text(l10n.posAddAsNew),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, 'link'),
              child: Text(l10n.posLinkToExisting),
            ),
          ],
        );
      },
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
            final l10n = AppLocalizations.of(context);
            final inventoryAsync = ref.watch(inventoryProvider);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.posLinkBarcodeTitle(barcode),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: inventoryAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: ListShimmer(itemCount: 5, itemHeight: 60),
                    ),
                    error: (err, _) => Center(
                      child: Text(l10n.posErrLoadingInventory('$err')),
                    ),
                    data: (data) {
                      final unbarcoded = data.items
                          .where((i) => i.barcode == null || i.barcode!.isEmpty)
                          .toList();

                      if (unbarcoded.isEmpty) {
                        return Center(child: Text(l10n.posNoUnbarcodedItems));
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
                              l10n.posCategoryLabel(
                                item.categoryName ?? l10n.posCategoryGeneral,
                              ),
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
                                        l10n.posLinkedToItem(
                                          barcode,
                                          item.name,
                                        ),
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

  // Adds all in-stock campaign items to cart. Cross-checks local stock so a
  // stale `in_stock` flag from the backend can't push 0-qty products into the
  // cart (which would then fail at /pos/orders with "insufficient stock").
  void _addCampaignToCart(campaign_card_lib.Campaign campaign) {
    final notifier = ref.read(posProvider.notifier);
    final localProducts = ref.read(posProvider).products;
    int added = 0;
    int skipped = 0;
    double resolvedGross = 0;
    for (final item in campaign.stockedItems) {
      final p = item.product;
      if (p == null) continue;
      final local = localProducts
          .where((lp) => lp.productId == p.productId)
          .firstOrNull;
      if (local == null || local.stockQuantity <= 0) {
        skipped++;
        continue;
      }
      final qty = item.quantity.clamp(0, local.stockQuantity).toDouble();
      if (qty <= 0) {
        skipped++;
        continue;
      }
      notifier.addToCart(local, qty: qty);
      resolvedGross += local.price * qty;
      added++;
    }
    if (added == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.posCampaignOutOfStock(campaign.name)),
          duration: const Duration(milliseconds: 1800),
        ),
      );
      return;
    }
    // Attribute the sale to the AI combo. Campaigns aren't saved baskets (no
    // int id) and carry no bundle discount, so id and savings are null — only
    // the name + value are recorded, which is what shows in order history.
    notifier.setAppliedBasket(
      id: null,
      name: campaign.name,
      gross: resolvedGross,
      savings: null,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          skipped == 0
              ? _l10n.posCampaignItemsAdded(added, campaign.name)
              : _l10n.posAddedSkipped(added, skipped),
        ),
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  // Persists an AI-recommended campaign as a saved basket. Only the in-stock
  // items are carried over; the server auto-assigns a tier + discount.
  Future<void> _saveCampaignAsBasket(
    campaign_card_lib.Campaign campaign,
  ) async {
    final items = campaign.stockedItems
        .where((i) => i.product != null)
        .map(
          (i) => {
            'product_id': i.product!.productId,
            'product_name': i.product!.name,
            'qty': i.quantity,
          },
        )
        .toList();
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_l10n.posCampaignOutOfStock(campaign.name))),
      );
      return;
    }
    try {
      await ref.read(basketProvider.notifier).createBasket({
        'name': campaign.name,
        'description': campaign.description.isNotEmpty
            ? campaign.description
            : null,
        'valid_from': null,
        'valid_to': null,
        'items': items,
      });
      // Make sure the Baskets screen reflects the new basket even if it was
      // already built and cached this session.
      ref.invalidate(basketProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_l10n.mktBasketSavedFromCampaign(campaign.name)),
            backgroundColor: BrandColors.success,
          ),
        );
      }
    } catch (e) {
      // Surface the real reason (e.g. a 4xx/validation error) instead of a
      // vague "something went wrong" — the swallowed error hid why AI baskets
      // weren't saving.
      if (mounted) {
        final msg = e is ApiException
            ? e.message
            : e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: BrandColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _showVoiceOrderSheet() => showVoiceOrderSheet(context, ref);

  Future<void> _showHandwritingSheet() =>
      showHandwritingOrderSheet(context, ref);

  // Adds basket products to cart — only those that are in stock locally.
  // Quantities are clamped to available stock so /pos/orders won't reject
  // the cart with an "insufficient stock" error.
  //
  // When the basket has a bundle price, it is distributed across the lines
  // (proportional to each product's normal price) so the cart total equals the
  // advertised deal price — not the sum of individual prices. The bundle price
  // is only honored when the FULL basket is in stock; a deal applies to the
  // complete set, so a partial basket falls back to regular per-item prices.
  void _addBasketToCart(Basket basket) {
    final notifier = ref.read(posProvider.notifier);
    final products = ref.read(posProvider).products;

    // Resolve in-stock products + clamped quantities first.
    final resolved = <MapEntry<PosProduct, double>>[];
    int skipped = 0;
    for (final item in basket.items) {
      final product = products
          .where((p) => p.productId == item.productId)
          .firstOrNull;
      if (product == null || product.stockQuantity <= 0) {
        skipped++;
        continue;
      }
      final qty = item.qty.clamp(0, product.stockQuantity).toDouble();
      if (qty <= 0) {
        skipped++;
        continue;
      }
      resolved.add(MapEntry(product, qty));
    }

    if (!mounted) return;
    if (resolved.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_l10n.posCampaignOutOfStock(basket.name))),
      );
      return;
    }

    // Normal-price value of the items actually added from this basket. Derived
    // from the cart (not basket.grossTotal, which is null for baskets created
    // without the tier system) so the order can show real value + savings.
    final resolvedGross = resolved.fold<double>(
      0,
      (s, r) => s + r.key.price * r.value,
    );

    // The bundle deal price applies only when the COMPLETE basket is in stock.
    final fullBundle = skipped == 0 && resolved.length == basket.items.length;
    final bundlePrice = basket.price;
    double? factor;
    if (fullBundle &&
        bundlePrice != null &&
        bundlePrice > 0 &&
        resolvedGross > 0) {
      factor = bundlePrice / resolvedGross;
    }

    for (final r in resolved) {
      notifier.addToCart(
        r.key,
        qty: r.value,
        unitPriceOverride: factor != null ? r.key.price * factor : null,
      );
    }

    // Attribute the sale to the basket whenever it contributed at least one
    // item (we returned early above if nothing resolved), so order history and
    // details show it came from a basket even when not every item was in stock.
    // The savings only exists when the FULL bundle deal applied; a partial add
    // is sold at regular price, so savings is null there.
    final basketSavings = factor != null ? resolvedGross - bundlePrice! : 0.0;
    notifier.setAppliedBasket(
      id: basket.basketId,
      name: basket.name,
      gross: resolvedGross,
      savings: basketSavings > 0 ? basketSavings : null,
    );

    final added = resolved.length;
    final String msg;
    if (factor != null) {
      msg =
          'Bundle "${basket.name}" added at ₹${bundlePrice!.toStringAsFixed(0)}';
    } else if (skipped == 0) {
      msg = bundlePrice != null
          ? '$added items added at regular price (bundle needs all items in stock)'
          : '$added item${added == 1 ? '' : 's'} from "${basket.name}" added';
    } else {
      msg = '$added added · $skipped skipped (out of stock)';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  void _openScanner() async {
    final items = await showContinuousScannerSheet(
      context,
      ref,
      onUnknownBarcode: (barcode) => _handleUnknownBarcode(barcode),
    );
    if (items == null || items.isEmpty || !mounted) return;

    // For loose items we need a weight dialog; all others are added directly.
    for (final ScanSessionItem item in items) {
      if (item.product.isLoose) {
        final qty = await _showWeightDialog(
          item.product,
          initialValue: item.qty.toDouble(),
        );
        if (qty != null && qty > 0) {
          ref.read(posProvider.notifier).addToCart(item.product, qty: qty);
        }
      } else {
        ref
            .read(posProvider.notifier)
            .addToCart(item.product, qty: item.qty.toDouble());
      }
    }

    if (mounted) {
      final count = items.fold<int>(0, (s, i) => s + i.qty);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$count item${count > 1 ? 's' : ''} added to cart'),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  void _showCustomerSearchSheet() {
    final searchCtrl = TextEditingController();
    // Load all customers once when sheet opens; text changes only filter locally
    // (avoids a fresh network/DB call on every keystroke).
    final allFuture = ref.read(posProvider.notifier).searchCustomers('');

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
                  Expanded(
                    child: Text(
                      _l10n.posSelectCustomer,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showAddCustomerDialog();
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(_l10n.posNew),
                  ),
                ],
              ),
              // const SizedBox(height: 16),
              TextField(
                controller: searchCtrl,
                decoration: InputDecoration(
                  hintText: _l10n.posSearchNameOrPhone,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (v) => setState(() {}),
              ),
              // const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: allFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: ListShimmer(itemCount: 4, itemHeight: 60),
                      );
                    }
                    final all = snapshot.data ?? [];
                    final q = searchCtrl.text.toLowerCase();
                    final customers = q.isEmpty
                        ? all
                        : all.where((c) {
                            final name = (c['name'] ?? '')
                                .toString()
                                .toLowerCase();
                            final phone = (c['phone'] ?? '').toString();
                            return name.contains(q) || phone.contains(q);
                          }).toList();
                    if (customers.isEmpty) {
                      return Center(child: Text(_l10n.posNoCustomersFound));
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
                          title: Text(c['name'] as String? ?? ''),
                          subtitle: Text(c['phone'] as String? ?? ''),
                          onTap: () {
                            ref
                                .read(posProvider.notifier)
                                .setCustomer(
                                  c['customer_id'] as int,
                                  c['name'] as String? ?? '',
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
              Expanded(
                child: Text(
                  _l10n.posAddNewCustomer,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                tooltip: _l10n.posSelectFromContacts,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: _l10n.posCustomerName),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: _l10n.posPhoneNumber),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(_l10n.posCommonCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) return;
                await ref
                    .read(posProvider.notifier)
                    .createCustomer(nameCtrl.text, phoneCtrl.text);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(_l10n.posSaveAndSelect),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Open the scanner when something requests it (e.g. the home-screen widget's
    // "New Bill" action deep-link). Guard against re-entrancy if already open.
    ref.listen<int>(posScanRequestProvider, (_, _) {
      if (mounted) _openScanner();
    });

    final state = ref.watch(posProvider);
    final cart = state.cart;
    final isSearching = _query.isNotEmpty;
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return PopScope(
      // Intercept back when there's something to clear on this screen first.
      // Without this, hitting back while searching used to pop the POS tab
      // (and Android would land you on the next visible tab, Stock).
      canPop: !isSearching && !keyboardOpen,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (keyboardOpen) {
          FocusManager.instance.primaryFocus?.unfocus();
          return;
        }
        if (isSearching) {
          _searchCtrl.clear();
          setState(() => _query = '');
        }
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Search + toggle + QR scan
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: _l10n.posSearchProducts,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: BrandColors.muted,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          suffixIcon: _query.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    size: 16,
                                  ),
                                  splashRadius: 18,
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _query = '');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          filled: true,
                          fillColor: BrandColors.surfaceTint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: BrandColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: BrandColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: BrandColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Customer-specific pricing suggestion (Phase 1: last-paid prices).
          if (!isSearching && state.showCustomerPriceBanner)
            const _CustomerPriceBanner(),

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
            child: RefreshIndicator.adaptive(
              onRefresh: () => ref.read(posProvider.notifier).reloadProducts(),
              child: state.isLoadingProducts && state.products.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: ListShimmer(itemCount: 5),
                    )
                  : cart.isEmpty
                  ? _EmptyCartWithCampaigns(
                      // Treat as "POS Offline" only when we genuinely have no
                      // products to sell. An order-placement failure also sets
                      // state.error but isn't a connectivity issue — surfacing
                      // it as "POS Offline" was misleading users into restarting.
                      hasPosError:
                          state.error != null && state.products.isEmpty,
                      errorMsg: state.error,
                      onAddCampaign: _addCampaignToCart,
                      onSaveCampaignAsBasket: _saveCampaignAsBasket,
                      onAddBasket: _addBasketToCart,
                    )
                  : Column(
                      children: [
                        // Cart header with clear button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 12, 2),
                          child: Row(
                            children: [
                              Text(
                                '${cart.length} item${cart.length > 1 ? 's' : ''} in cart',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: BrandColors.muted,
                                ),
                              ),
                              const Spacer(),
                              TextButton.icon(
                                onPressed: () async {
                                  final ok = await showModalBottomSheet<bool>(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (ctx) => Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24),
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(
                                        20,
                                        12,
                                        20,
                                        20 + MediaQuery.of(ctx).padding.bottom,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 44,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: BrandColors.border,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: BrandColors.error
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.delete_sweep_rounded,
                                                  color: BrandColors.error,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _l10n.posClearCartTitle,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      _l10n.posClearCartBody,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            BrandColors.muted,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, false),
                                                  child: Text(
                                                    _l10n.posCommonCancel,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: FilledButton(
                                                  onPressed: () =>
                                                      Navigator.pop(ctx, true),
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        BrandColors.error,
                                                  ),
                                                  child: Text(
                                                    _l10n.posCommonClear,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  if (ok == true) {
                                    ref.read(posProvider.notifier).clearCart();
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete_sweep_rounded,
                                  size: 16,
                                ),
                                label: Text(_l10n.posCommonClear),
                                style: TextButton.styleFrom(
                                  foregroundColor: BrandColors.error,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            itemCount: cart.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) => Dismissible(
                              key: ValueKey(cart[i].product.productId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: BrandColors.error,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) => ref
                                  .read(posProvider.notifier)
                                  .removeFromCart(cart[i].product.productId),
                              child: _CartTile(
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
                        ),
                      ],
                    ),
            ),
          ),

          const _SmartAssortmentHints(),

          // Primary input actions in the bottom thumb-zone (one-hand friendly).
          if (!isSearching)
            _PosBottomBar(
              onScan: _openScanner,
              onVoice: _showVoiceOrderSheet,
              onHandwrite: _showHandwritingSheet,
            ),

          if (cart.isNotEmpty)
            _OrderFooter(
              subtotal: state.subtotal,
              itemCount: state.cartItemCount,
              basketName: state.appliedBasketName,
              basketGross: state.basketGross,
              basketSavings: state.basketSavings,
              isPlacing: state.isPlacingOrder,
              selectedCustomer: state.selectedCustomerName,
              onSelectCustomer: _showCustomerSearchSheet,
              onClearCustomer: () =>
                  ref.read(posProvider.notifier).clearCustomer(),
              onOrder: () => showOrderDialog(context, ref),
            ),
        ],
      ),
    );
  }
}

class _SmartAssortmentHints extends ConsumerStatefulWidget {
  const _SmartAssortmentHints();

  @override
  ConsumerState<_SmartAssortmentHints> createState() =>
      _SmartAssortmentHintsState();
}

class _SmartAssortmentHintsState extends ConsumerState<_SmartAssortmentHints> {
  bool _expanded = true;
  bool _visible = false;
  Timer? _collapseTimer;

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  /// Keep the suggestions visible for 5 seconds, then auto-collapse.
  void _startCollapseTimer() {
    _collapseTimer?.cancel();
    _collapseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _expanded = false);
    });
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _startCollapseTimer();
    } else {
      _collapseTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posProvider);
    final cart = state.cart;

    final cartIds = cart.map((e) => e.product.productId).toSet();
    final suggestions = (cart.isEmpty || state.products.isEmpty)
        ? const <PosProduct>[]
        : state.products
              .where((p) => !cartIds.contains(p.productId))
              .take(5)
              .toList();

    if (suggestions.isEmpty) {
      // Reset so the strip re-opens (and re-times) the next time it appears.
      _visible = false;
      _collapseTimer?.cancel();
      return const SizedBox.shrink();
    }

    // Suggestions just became visible — open it and start the 5s auto-collapse.
    if (!_visible) {
      _visible = true;
      _expanded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startCollapseTimer();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: BrandColors.primary,
                ),
                const SizedBox(width: 6),
                const Text(
                  'FREQUENTLY BOUGHT TOGETHER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 18,
                    color: BrandColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: !_expanded
              ? const SizedBox(width: double.infinity)
              : SizedBox(
                  height: 64,
                  // Scrolling the suggestions also keeps the strip alive.
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) {
                      _startCollapseTimer();
                      return false;
                    },
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
                                // Interacting keeps the strip alive another 5s.
                                _startCollapseTimer();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: BrandColors.border),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
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
                                        color: BrandColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add_rounded,
                                        size: 12,
                                        color: BrandColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}

Widget _posIconBox(double size) => Container(
  width: size,
  height: size,
  color: BrandColors.surfaceTint,
  child: Icon(
    Icons.inventory_2_rounded,
    size: size * 0.45,
    color: BrandColors.muted,
  ),
);

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
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: ListShimmer(itemCount: 3, itemHeight: 60),
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
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: p.imageUrl != null
                        ? Image.network(
                            p.imageUrl!,
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => _posIconBox(36),
                          )
                        : _posIconBox(36),
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

/// Sheet to set or clear the selected customer's personal price for a product.
Future<void> _showSetCustomerPriceSheet(
  BuildContext context,
  WidgetRef ref,
  PosProduct product,
  double? currentOverride,
) async {
  final state = ref.read(posProvider);
  final name = state.selectedCustomerName?.trim().isNotEmpty == true
      ? state.selectedCustomerName!.trim()
      : 'this customer';
  final cp = state.customerPriceFor(product.productId);
  final hasPin = cp?.isPinned ?? false;
  final initial = currentOverride ?? cp?.price ?? product.price;
  final notifier = ref.read(posProvider.notifier);
  final messenger = ScaffoldMessenger.maybeOf(context);

  // The sheet is a StatefulWidget so its TextEditingController is disposed in
  // the normal element-unmount order when the route pops, and we pop
  // synchronously. The earlier inline builder + function-scoped controller +
  // post-pop `endOfFrame`/delayed mutation tore down out of order and tripped
  // the framework's `_dependents.isEmpty` MediaQuery assertion on save.
  final action = await showModalBottomSheet<_CustomerPriceEditAction>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SetCustomerPriceSheet(
      product: product,
      customerName: name,
      hasPin: hasPin,
      initial: initial,
    ),
  );

  if (action == null) return;
  final ok = await notifier.setCustomerPrice(product.productId, action.price);
  if (!ok && (messenger?.mounted ?? false)) {
    messenger!.showSnackBar(
      const SnackBar(content: Text('Could not save price. Try again.')),
    );
  }
}

class _CustomerPriceEditAction {
  final double? price;

  const _CustomerPriceEditAction.remove() : price = null;
  const _CustomerPriceEditAction.set(this.price);
}

/// Bottom sheet that edits a customer's personal price for one product. Owns
/// and disposes its controller, and pops synchronously with the chosen
/// [_CustomerPriceEditAction] — the caller persists it after the sheet closes.
class _SetCustomerPriceSheet extends StatefulWidget {
  final PosProduct product;
  final String customerName;
  final bool hasPin;
  final double initial;

  const _SetCustomerPriceSheet({
    required this.product,
    required this.customerName,
    required this.hasPin,
    required this.initial,
  });

  @override
  State<_SetCustomerPriceSheet> createState() => _SetCustomerPriceSheetState();
}

class _SetCustomerPriceSheetState extends State<_SetCustomerPriceSheet> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final v = widget.initial;
    _ctrl = TextEditingController(
      text: v > 0
          ? (v == v.roundToDouble()
                ? v.toStringAsFixed(0)
                : v.toStringAsFixed(2))
          : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final price = double.tryParse(_ctrl.text.trim());
    if (price == null || price < 0) return;
    Navigator.pop(context, _CustomerPriceEditAction.set(price));
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
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Price for ${widget.customerName}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.product.displayName}  ·  catalog ₹${widget.product.price.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12.5, color: BrandColors.muted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: 'Enter price',
                filled: true,
                fillColor: BrandColors.surfaceTint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.hasPin)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(
                        context,
                        const _CustomerPriceEditAction.remove(),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Remove'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: BrandColors.error,
                        side: const BorderSide(color: BrandColors.error),
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                if (widget.hasPin) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: BrandColors.accent,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text(
                      'Save price',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

    // Customer-specific pricing: badge the line when its override matches the
    // selected customer's remembered price.
    final posState = ref.watch(posProvider);
    final hasCustomer = posState.selectedCustomerId != null;
    final cp = posState.customerPriceFor(p.productId);
    final override = item.unitPriceOverride as double?;
    final isCustomerPriced =
        override != null && cp != null && (override - cp.price).abs() < 0.01;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: p.imageUrl != null
                ? Image.network(
                    p.imageUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => _posIconBox(40),
                  )
                : _posIconBox(40),
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
                if (isCustomerPriced)
                  GestureDetector(
                    onTap: hasCustomer
                        ? () => _showSetCustomerPriceSheet(
                            context,
                            ref,
                            p,
                            override,
                          )
                        : null,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                cp.isPinned
                                    ? Icons.push_pin_rounded
                                    : Icons.history_rounded,
                                size: 9,
                                color: BrandColors.accent,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '₹${override.toStringAsFixed(1)} · ${cp.isPinned ? 'set' : 'last'}',
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: BrandColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (cp.catalogPrice != null) ...[
                          const SizedBox(width: 5),
                          Text(
                            '₹${cp.catalogPrice!.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: BrandColors.muted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: hasCustomer
                        ? () => _showSetCustomerPriceSheet(
                            context,
                            ref,
                            p,
                            override,
                          )
                        : null,
                    child: Row(
                      children: [
                        Text(
                          p.priceLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: BrandColors.muted,
                          ),
                        ),
                        if (hasCustomer) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.edit_rounded,
                            size: 10,
                            color: BrandColors.muted.withValues(alpha: 0.7),
                          ),
                        ],
                      ],
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

class _EmptyCartWithCampaigns extends ConsumerWidget {
  final bool hasPosError;
  final String? errorMsg;
  final void Function(campaign_card_lib.Campaign) onAddCampaign;
  final void Function(campaign_card_lib.Campaign) onSaveCampaignAsBasket;
  final void Function(Basket) onAddBasket;

  const _EmptyCartWithCampaigns({
    required this.hasPosError,
    required this.onAddCampaign,
    required this.onSaveCampaignAsBasket,
    required this.onAddBasket,
    this.errorMsg,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (hasPosError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: BrandColors.muted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'POS Offline',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                errorMsg ?? 'Could not connect to POS.',
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

    final campaignsAsync = ref.watch(campaignProvider);
    final basketsAsync = ref.watch(basketProvider);
    final posProducts = ref.watch(posProvider).products;
    // Baskets are Pro-only — basic users see campaigns but no saved baskets
    // and no "Save as Basket".
    final canUseBaskets = ref.watch(subInfoProvider).canAccessBaskets;

    return campaignsAsync.when(
      loading: () => const _EmptyCartHint(),
      error: (_, _) => const _EmptyCartHint(),
      data: (campaigns) {
        final activeBaskets = canUseBaskets
            ? (basketsAsync.value
                      ?.where((b) => b.isActive2 && b.items.isNotEmpty)
                      .toList() ??
                  [])
            : <Basket>[];

        if (campaigns.isEmpty && activeBaskets.isEmpty) {
          // Keep it pull-to-refreshable even though there's nothing to scroll.
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const _EmptyCartHint(),
              ),
            ),
          );
        }

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          children: [
            // ── Single unified header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Near Commerce',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.muted,
                      letterSpacing: 0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(campaignProvider.notifier).refresh(),
                    child: const Text(
                      'Refresh AI',
                      style: TextStyle(
                        fontSize: 12,
                        color: BrandColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── User baskets first ─────────────────────────────────────────
            for (final basket in activeBaskets)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PosBasketCard(
                  basket: basket,
                  posProducts: posProducts,
                  onAddToCart: () => onAddBasket(basket),
                ),
              ),

            // ── AI campaigns after ─────────────────────────────────────────
            for (int i = 0; i < campaigns.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CampaignCard(
                  campaign: campaigns[i],
                  index: i,
                  onAddAll: () => onAddCampaign(campaigns[i]),
                  onSaveAsBasket: canUseBaskets
                      ? () => onSaveCampaignAsBasket(campaigns[i])
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Basket card — same visual structure as CampaignCard ──────────────────────

class _PosBasketCard extends StatelessWidget {
  static const _color = Color(
    0xFF0EA5E9,
  ); // sky-blue distinguishes user baskets from AI

  final Basket basket;
  final List<PosProduct> posProducts;
  final VoidCallback onAddToCart;

  const _PosBasketCard({
    required this.basket,
    required this.posProducts,
    required this.onAddToCart,
  });

  int get _inStockCount => basket.items
      .where(
        (i) => posProducts.any(
          (p) => p.productId == i.productId && p.stockQuantity > 0,
        ),
      )
      .length;

  @override
  Widget build(BuildContext context) {
    final inStock = _inStockCount;
    final total = basket.items.length;
    final allReady = inStock == total;

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _BasketDetailSheet(
          basket: basket,
          posProducts: posProducts,
          onAddToCart: onAddToCart,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basket.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _color,
                          ),
                        ),
                        if (basket.description != null)
                          Text(
                            basket.description!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: BrandColors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            '${basket.items.length} items in bundle',
                            style: const TextStyle(
                              fontSize: 11,
                              color: BrandColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // In-stock pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: allReady
                          ? Colors.green.withValues(alpha: 0.12)
                          : Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$inStock/$total',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: allReady
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Item chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: basket.items.take(5).map((item) {
                  final matched = posProducts
                      .where((p) => p.productId == item.productId)
                      .firstOrNull;
                  final inStockItem =
                      matched != null && matched.stockQuantity > 0;
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: inStockItem
                            ? _color.withValues(alpha: 0.08)
                            : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: inStockItem
                              ? _color.withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            inStockItem
                                ? Icons.check_circle_rounded
                                : Icons.remove_circle_outline_rounded,
                            size: 10,
                            color: inStockItem ? _color : BrandColors.muted,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '${item.productName ?? 'Item'} × ${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: inStockItem ? _color : BrandColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (basket.price != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${basket.price!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _color,
                          ),
                        ),
                        const Text(
                          'bundle price',
                          style: TextStyle(
                            fontSize: 11,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: ElevatedButton.icon(
                      onPressed: inStock == 0 ? null : onAddToCart,
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 16,
                      ),
                      label: Text(
                        AppLocalizations.of(context).posCommonAddToCart,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Basket detail sheet (mirrors CampaignDetailSheet) ────────────────────────

class _BasketDetailSheet extends StatelessWidget {
  static const _color = Color(0xFF0EA5E9);

  final Basket basket;
  final List<PosProduct> posProducts;
  final VoidCallback onAddToCart;

  const _BasketDetailSheet({
    required this.basket,
    required this.posProducts,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basket.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _color,
                          ),
                        ),
                        if (basket.description != null)
                          Text(
                            basket.description!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: BrandColors.muted,
                            ),
                          ),
                        if (basket.validTo != null)
                          Text(
                            'Valid until ${basket.validTo}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: basket.items.length,
                itemBuilder: (_, i) {
                  final item = basket.items[i];
                  final matched = posProducts
                      .where((p) => p.productId == item.productId)
                      .firstOrNull;
                  final inStk = matched != null && matched.stockQuantity > 0;
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: inStk
                            ? _color.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        inStk ? Icons.check_rounded : Icons.close_rounded,
                        color: inStk ? _color : BrandColors.muted,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item.productName ?? 'Item',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: inStk ? BrandColors.ink : BrandColors.muted,
                      ),
                    ),
                    subtitle: inStk
                        ? Text(
                            'Stock: ${matched.stockQuantity.toStringAsFixed(0)} ${matched.unit ?? 'pcs'}  ·  ₹${matched.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12),
                          )
                        : const Text(
                            'Not in stock',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                    trailing: Text(
                      '× ${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _color,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                children: [
                  if (basket.price != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Bundle Price',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${basket.price!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _color,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          basket.items.every(
                            (i) => !posProducts.any(
                              (p) =>
                                  p.productId == i.productId &&
                                  p.stockQuantity > 0,
                            ),
                          )
                          ? null
                          : () {
                              Navigator.pop(context);
                              onAddToCart();
                            },
                      icon: const Icon(Icons.add_shopping_cart_rounded),
                      label: Text(
                        AppLocalizations.of(context).posAddAvailableToCart,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AI Entry Strip ────────────────────────────────────────────────────────────

/// Bottom thumb-zone action bar: the screen's primary inputs (Scan / Voice /
/// Handwrite) anchored low so the screen is usable one-handed.
class _PosBottomBar extends ConsumerWidget {
  final VoidCallback onScan;
  final VoidCallback onVoice;
  final VoidCallback onHandwrite;

  const _PosBottomBar({
    required this.onScan,
    required this.onVoice,
    required this.onHandwrite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subInfo = ref.watch(subInfoProvider);
    final isPro = subInfo.effectiveTier == SubTier.pro;
    final limits = ref.watch(usageLimitsProvider).value;

    final voiceRemaining =
        limits?.voiceRemaining ?? kDailyLimits[kFeatureVoice]!;
    final handwriteRemaining =
        limits?.handwriteRemaining ?? kDailyLimits[kFeatureHandwrite]!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BrandColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: _BottomAction(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan',
              color: BrandColors.primary,
              filled: true,
              onTap: onScan,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _BottomAction(
              icon: Icons.mic_rounded,
              label: isPro ? 'Voice $voiceRemaining' : 'Voice',
              color: isPro && voiceRemaining == 0
                  ? BrandColors.error
                  : BrandColors.primary,
              locked: !isPro,
              onTap: onVoice,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _BottomAction(
              icon: Icons.draw_rounded,
              label: isPro ? 'Write $handwriteRemaining' : 'Write',
              color: isPro && handwriteRemaining == 0
                  ? BrandColors.error
                  : BrandColors.purple,
              locked: !isPro,
              onTap: onHandwrite,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool filled;
  final bool locked;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: filled
              ? null
              : Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ),
            if (locked) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.lock_rounded,
                size: 12,
                color: filled ? Colors.white70 : color.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EmptyCartHint extends StatelessWidget {
  const _EmptyCartHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: BrandColors.muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Cart is empty',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Search for a product or scan a barcode to start a sale.',
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

/// Non-blocking prompt offering the selected customer's personal prices.
class _CustomerPriceBanner extends ConsumerWidget {
  const _CustomerPriceBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posProvider);
    // Count items actually in the cart that have a special price — not the
    // customer's whole saved list, which would over-count items that aren't here.
    final count = state.customerPricedCartCount;
    if (count == 0) return const SizedBox.shrink();
    final name = state.selectedCustomerName?.trim().isNotEmpty == true
        ? state.selectedCustomerName!.trim()
        : 'This customer';
    final notifier = ref.read(posProvider.notifier);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: BrandColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sell_rounded, size: 18, color: BrandColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.3,
                  color: BrandColors.ink,
                ),
                children: [
                  TextSpan(text: '$name has special prices on '),
                  TextSpan(
                    text: '$count item${count > 1 ? 's' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          TextButton(
            onPressed: notifier.dismissCustomerPrices,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              foregroundColor: BrandColors.muted,
            ),
            child: const Text(
              'Ignore',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 4),
          FilledButton(
            onPressed: notifier.applyCustomerPrices,
            style: FilledButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: BrandColors.accent,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _OrderFooter extends StatelessWidget {
  final double subtotal;
  final double itemCount;
  final String? basketName;
  final double? basketGross;
  final double? basketSavings;
  final bool isPlacing;
  final String? selectedCustomer;
  final VoidCallback onSelectCustomer;
  final VoidCallback onClearCustomer;
  final VoidCallback onOrder;

  const _OrderFooter({
    required this.subtotal,
    required this.itemCount,
    this.basketName,
    this.basketGross,
    this.basketSavings,
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
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
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
          // Bundle savings banner — shows the original value, % off and net so
          // the shopkeeper sees exactly what the basket discount is doing.
          if (basketName != null) ...[
            BasketSavingsBanner(
              name: basketName!,
              gross: basketGross,
              savings: basketSavings,
            ),
            const SizedBox(height: 8),
          ],
          // Row 1: customer chip (left) + item count & total (right)
          Row(
            children: [
              Expanded(
                child: selectedCustomer != null
                    ? GestureDetector(
                        onTap: onSelectCustomer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.primary.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: BrandColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_rounded,
                                size: 14,
                                color: BrandColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  selectedCustomer!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: BrandColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: onClearCustomer,
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: BrandColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: onSelectCustomer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.surfaceTint,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: BrandColors.border),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add_alt_1_rounded,
                                size: 14,
                                color: BrandColors.muted,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Add Customer',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: BrandColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${itemCount % 1 == 0 ? itemCount.toInt() : itemCount.toStringAsFixed(2)} item${itemCount == 1 ? '' : 's'}',
                    style: const TextStyle(
                      color: BrandColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    _fmt(subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: BrandColors.ink,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: Place Order button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: isPlacing ? null : onOrder,
              child: isPlacing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(
                        context,
                      ).posPlaceOrderAmount(_fmt(subtotal)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
