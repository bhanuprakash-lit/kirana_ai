part of '../pos_tab_new.dart';

class PosTab extends ConsumerStatefulWidget {
  const PosTab({super.key});

  @override
  ConsumerState<PosTab> createState() => _PosTabState();
}

class _VariantChoice {
  final int? variantId;
  final String? variantLabel;
  final double? price;

  const _VariantChoice({this.variantId, this.variantLabel, this.price});

  static const none = _VariantChoice();
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
    final matches = products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              (p.brand?.toLowerCase().contains(q) ?? false) ||
              (p.barcode?.contains(q) ?? false),
        )
        .toList();
    // V2 — services sell at POS too: a haircut is searched and billed like
    // any item. Service matches ride their linked is_service product row
    // (no stock; the sale trigger skips inventory for them).
    matches.addAll(_serviceMatches(q));
    return matches;
  }

  /// Active catalogue services matching the query, as sellable pseudo
  /// products. Empty for verticals without the appointments feature or on
  /// older backends that don't link services to products yet.
  List<PosProduct> _serviceMatches(String q) {
    if (!verticalConfigOf(ref).has('appointments')) return const [];
    final services = ref.read(servicesProvider).asData?.value ?? const [];
    return [
      for (final s in services)
        if (s.productId != null &&
            s.isActive &&
            s.name.toLowerCase().contains(q))
          PosProduct(
            productId: s.productId!,
            name: s.name,
            unit: 'service',
            isPerishable: false,
            isLoose: false,
            categoryId: 0,
            price: s.price,
            stockQuantity: 0,
          ),
    ];
  }

  /// Product ids that are services — the search list uses this to swap the
  /// stock line for a "Service" chip.
  Set<int> get _serviceProductIds {
    if (!verticalConfigOf(ref).has('appointments')) return const {};
    final services = ref.read(servicesProvider).asData?.value ?? const [];
    return {
      for (final s in services)
        if (s.productId != null) s.productId!,
    };
  }

  // F2 — variant verticals: resolve the size/colour/model (its price + stock)
  // before a variant-tracked product is added anywhere in the POS (manual
  // add, basket, barcode scan). A product with real variants only carries
  // per-variant inventory rows server-side — adding it with no variant_id
  // passes client-side checks but then 500s at checkout ("Inventory row
  // missing"), so every add path must go through this resolver instead of
  // calling addToCart directly.
  //
  // Returns `_VariantChoice.none` when the product isn't variant-tracked,
  // a populated choice when the user picked one, or null when the user
  // cancelled the picker or gave up after a fetch failure — callers must
  // skip adding the product in that case.
  Future<_VariantChoice?> _resolveVariant(PosProduct p) async {
    if (!verticalConfigOf(ref).has('variants')) return _VariantChoice.none;
    List<ProductVariant> variants;
    try {
      final all = await ref.read(productVariantsProvider(p.productId).future);
      variants = all.where((v) => !v.isImplicit && v.isActive).toList();
    } catch (_) {
      if (!mounted) return null;
      final retry = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Could not load variants'),
          content: Text(
            "Couldn't fetch sizes/variants for ${p.name}. Adding it without "
            'a variant would fail at checkout.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(_l10n.posCommonCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
      if (retry == true) return _resolveVariant(p);
      return null;
    }
    if (variants.isEmpty) return _VariantChoice.none;
    if (!mounted) return null;
    final chosen = await showVariantPickerSheet(
      context,
      variants: variants,
      productName: p.name,
    );
    if (chosen == null) return null;
    return _VariantChoice(
      variantId: chosen.variantId,
      variantLabel: chosen.label,
      price: chosen.price,
    );
  }

  Future<void> _handleProductAdd(PosProduct p) async {
    final choice = await _resolveVariant(p);
    if (choice == null) return;
    if (choice.variantId != null) {
      ref
          .read(posProvider.notifier)
          .addToCart(
            p,
            variantId: choice.variantId,
            variantLabel: choice.variantLabel,
            unitPriceOverride: choice.price,
          );
      return;
    }
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

  /// Optical / services bar action: show today's booked appointments up-front
  /// (instead of only at checkout). Picking one attributes the sale to that
  /// customer so the appointment surfaces in the order sheet ready to bill.
  Future<void> _showAppointmentsSheet() async {
    final now = DateTime.now();
    final day =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final appts = ref.watch(appointmentsProvider(day));
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.7,
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              16 + MediaQuery.of(ctx).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Today's appointments",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showCustomerSearchSheet();
                      },
                      icon: const Icon(Icons.person_add_alt_rounded, size: 18),
                      label: Text(_l10n.posNew),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: appts.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('$e'),
                    ),
                    data: (list) {
                      final booked =
                          list.where((a) => a.status == 'booked').toList()
                            ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
                      if (booked.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 28),
                          child: Text(
                            'No appointments booked for today.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: BrandColors.muted),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: booked.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) => _appointmentTile(ctx, booked[i]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _appointmentTile(BuildContext sheetCtx, Appointment a) {
    final t = TimeOfDay.fromDateTime(a.startsAt);
    final h12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final ampm = t.period == DayPeriod.am ? 'am' : 'pm';
    final time = '$h12:${t.minute.toString().padLeft(2, '0')} $ampm';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
        child: const Icon(
          Icons.event_available_rounded,
          color: BrandColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        a.displayName,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        '$time · ${a.serviceName ?? 'Service'}'
        '${a.price != null ? ' · ₹${a.price!.toStringAsFixed(0)}' : ''}',
        style: const TextStyle(fontSize: 12, color: BrandColors.muted),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        if (a.customerId != null) {
          ref
              .read(posProvider.notifier)
              .setCustomer(a.customerId!, a.displayName);
        }
        Navigator.pop(sheetCtx);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              a.customerId != null
                  ? '${a.displayName} selected — bill the appointment at checkout'
                  : 'Walk-in appointment — add items, then bill it at checkout',
            ),
            duration: const Duration(milliseconds: 2200),
          ),
        );
      },
    );
  }

  /// Optical bar action: capture/update the selected customer's prescription.
  /// Reuses the Customer 360 detail screen (which owns the Rx editor). Requires
  /// a customer to be selected first.
  void _openPrescription() {
    final state = ref.read(posProvider);
    final id = state.selectedCustomerId;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a customer first to add their prescription'),
          duration: Duration(milliseconds: 2000),
        ),
      );
      _showCustomerSearchSheet();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerDetailScreen(customerId: id)),
    );
  }

  // Adds basket products to cart — only those that are in stock locally.
  // Quantities are clamped to available stock so /pos/orders won't reject
  // the cart with an "insufficient stock" error.
  //
  // When the basket has a bundle price, it is distributed across the lines
  // (proportional to each product's normal price) so the cart total equals the
  // advertised deal price — not the sum of individual prices. The bundle price
  // is only honored when the FULL basket is in stock; a deal applies to the
  // complete set, so a partial basket falls back to regular per-item prices.
  Future<void> _addBasketToCart(Basket basket) async {
    final notifier = ref.read(posProvider.notifier);
    final products = ref.read(posProvider).products;

    // Resolve in-stock products + clamped quantities first.
    final candidates = <MapEntry<PosProduct, double>>[];
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
      candidates.add(MapEntry(product, qty));
    }

    // Variant-tracked products (e.g. apparel sizes) need a variant picked
    // before they can be added — otherwise the order 500s at checkout with
    // "Inventory row missing" since stock only exists per-variant.
    final resolved = <(PosProduct, double, _VariantChoice)>[];
    for (final entry in candidates) {
      final choice = await _resolveVariant(entry.key);
      if (choice == null) {
        skipped++;
        continue;
      }
      resolved.add((entry.key, entry.value, choice));
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
      (s, r) => s + r.$1.price * r.$2,
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

    for (final (product, qty, choice) in resolved) {
      notifier.addToCart(
        product,
        qty: qty,
        variantId: choice.variantId,
        variantLabel: choice.variantLabel,
        unitPriceOverride:
            choice.price ?? (factor != null ? product.price * factor : null),
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
    // Variant-tracked products (e.g. apparel sizes) need a variant picked
    // first — scanning the same barcode for every size means the size must
    // be chosen here, same as a manual add.
    int added = 0;
    int skipped = 0;
    for (final ScanSessionItem item in items) {
      final choice = await _resolveVariant(item.product);
      if (choice == null) {
        skipped++;
        continue;
      }
      if (item.product.isLoose) {
        final qty = await _showWeightDialog(
          item.product,
          initialValue: item.qty.toDouble(),
        );
        if (qty != null && qty > 0) {
          ref
              .read(posProvider.notifier)
              .addToCart(
                item.product,
                qty: qty,
                variantId: choice.variantId,
                variantLabel: choice.variantLabel,
                unitPriceOverride: choice.price,
              );
          added++;
        }
      } else {
        ref
            .read(posProvider.notifier)
            .addToCart(
              item.product,
              qty: item.qty.toDouble(),
              variantId: choice.variantId,
              variantLabel: choice.variantLabel,
              unitPriceOverride: choice.price,
            );
        added++;
      }
    }

    if (mounted) {
      final msg = skipped == 0
          ? '$added item${added > 1 ? 's' : ''} added to cart'
          : '$added added · $skipped skipped';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
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

  /// Add a customer from POS using the SAME full form as the Customer
  /// Relations page (name, phone, area, birthday …) — one form everywhere,
  /// then select the new customer on the bill.
  Future<void> _showAddCustomerDialog() async {
    final created = await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CustomerFormSheet(),
    );
    if (created != null && mounted) {
      ref
          .read(posProvider.notifier)
          .setCustomer(created.customerId, created.name);
    }
  }

  /// Guided first-sale flow (Getting started → "Make your first bill").
  /// The bill's own state machine picks the next lesson: no items yet → show
  /// where to search; items but no customer → tap the customer chip; customer
  /// picked → tap the charge button. Each spotlight makes the owner perform
  /// the REAL action, so finishing the tutorial IS finishing his first sale.
  void _maybeFirstSaleTutorial(PosState state) {
    if (!mounted) return;
    final c = ref.read(tutorialProvider.notifier);
    if (!c.flowActive(Tut.flowFirstSale)) return;
    if (state.products.isEmpty) return; // nothing to sell yet
    final l10n = _l10n;
    if (state.cart.isEmpty) {
      if (!c.shouldShow(Tut.fsSearch, flow: Tut.flowFirstSale)) return;
      showTutorialSegment(
        context,
        ref,
        id: Tut.fsSearch,
        flow: Tut.flowFirstSale,
        steps: [
          TutStep(
            targetKey: TutorialKeys.posSearch,
            title: l10n.tutFsSearchTitle,
            body: l10n.tutFsSearchBody,
          ),
        ],
        nextLabel: l10n.tutNext,
        doneLabel: l10n.tutDone,
        skipLabel: l10n.tutSkip,
      );
    } else if (state.selectedCustomerId == null) {
      if (!c.shouldShow(Tut.fsCustomer, flow: Tut.flowFirstSale)) return;
      showTutorialSegment(
        context,
        ref,
        id: Tut.fsCustomer,
        flow: Tut.flowFirstSale,
        steps: [
          TutStep(
            targetKey: TutorialKeys.posCustomer,
            title: l10n.tutFsCustomerTitle,
            body: l10n.tutFsCustomerBody,
            tapTarget: true,
            onTapTarget: _showCustomerSearchSheet,
            align: ContentAlign.top,
          ),
        ],
        tapHint: l10n.tutTapHere,
        skipLabel: l10n.tutSkip,
      );
    } else {
      if (!c.shouldShow(Tut.fsCharge, flow: Tut.flowFirstSale)) return;
      showTutorialSegment(
        context,
        ref,
        id: Tut.fsCharge,
        flow: Tut.flowFirstSale,
        steps: [
          TutStep(
            targetKey: TutorialKeys.posOrder,
            title: l10n.tutFsChargeTitle,
            body: l10n.tutFsChargeBody,
            tapTarget: true,
            onTapTarget: () => showOrderDialog(context, ref),
            align: ContentAlign.top,
          ),
        ],
        tapHint: l10n.tutTapHere,
        skipLabel: l10n.tutSkip,
      );
    }
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

    // V2 — keep the service catalogue loaded so search can offer services
    // alongside products (no-op for verticals without appointments).
    if (verticalConfigOf(ref).has('appointments')) {
      ref.watch(servicesProvider);
    }

    // Guided first-sale flow reacts to the live bill state on every rebuild.
    ref.watch(tutorialProvider.select((s) => (s.activeFlow, s.loaded)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(milliseconds: 350),
        () => _maybeFirstSaleTutorial(ref.read(posProvider)),
      );
    });

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
                        key: TutorialKeys.posSearch,
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
              serviceIds: _serviceProductIds,
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
                              key: ValueKey(cart[i].lineKey),
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
                                  .removeFromCart(cart[i].lineKey),
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
                                        .updateQty(item.lineKey, qty);
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
              onAppointments: _showAppointmentsSheet,
              onPrescription: _openPrescription,
            ),

          if (cart.isNotEmpty)
            _OrderFooter(
              subtotal: state.subtotal,
              itemCount: state.cartItemCount,
              tax: state.cartTax,
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
