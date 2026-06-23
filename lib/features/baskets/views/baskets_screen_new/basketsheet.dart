part of '../baskets_screen_new.dart';

class _BasketSheet extends ConsumerStatefulWidget {
  final Basket? existing;
  const _BasketSheet({this.existing});

  @override
  ConsumerState<_BasketSheet> createState() => _BasketSheetState();
}

class _BasketSheetState extends ConsumerState<_BasketSheet> {
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  final _items = <_SelectedItem>[];

  String? _validFrom;
  String? _validTo;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final b = widget.existing;
    _nameCtrl = TextEditingController(text: b?.name ?? '');
    _descCtrl = TextEditingController(text: b?.description ?? '');
    _validFrom = b?.validFrom;
    _validTo = b?.validTo;
    if (b != null) {
      // Map saved items back to selected items, resolving current prices.
      final products = ref.read(posProvider).products;
      for (final it in b.items) {
        final matches = products
            .where((x) => x.productId == it.productId)
            .toList();
        final p = matches.isNotEmpty ? matches.first : null;
        _items.add(
          _SelectedItem(
            productId: it.productId,
            productName: it.productName ?? p?.displayName ?? _l10n.mktItem,
            price: p?.price ?? 0,
            qty: it.qty,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  double get _grossTotal => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? now : now.add(const Duration(days: 7)),
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    final label =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    setState(() {
      if (isFrom) {
        _validFrom = label;
      } else {
        _validTo = label;
      }
    });
  }

  Future<void> _showProductPicker() async {
    final products = ref.read(posProvider).products;
    if (products.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.mktNoProductsInInventory)));
      return;
    }
    final alreadyAdded = _items.map((i) => i.productId).toSet();
    final available = products
        .where((p) => !alreadyAdded.contains(p.productId))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.mktAllProductsAdded)));
      return;
    }

    final picked = await showModalBottomSheet<PosProduct>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductPickerSheet(products: available),
    );

    if (picked == null || !mounted) return;
    setState(() {
      _items.add(
        _SelectedItem(
          productId: picked.productId,
          productName: picked.displayName,
          price: picked.price,
        ),
      );
    });
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = _l10n.mktBasketNameRequired);
      return;
    }
    if (_items.isEmpty) {
      setState(() => _error = _l10n.mktAddAtLeastOneProduct);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final items = _items
        .map(
          (i) => {
            'product_id': i.productId,
            'product_name': i.productName,
            'qty': i.qty,
          },
        )
        .toList();

    final payload = {
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim().isNotEmpty
          ? _descCtrl.text.trim()
          : null,
      'valid_from': _validFrom,
      'valid_to': _validTo,
      'items': items,
    };

    try {
      final notifier = ref.read(basketProvider.notifier);
      if (_isEdit) {
        await notifier.updateBasket(widget.existing!.basketId, payload);
      } else {
        await notifier.createBasket(payload);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = _msg(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final configAsync = ref.watch(basketTierConfigProvider);
    final config = configAsync.asData?.value ?? BasketTierConfig.defaults;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isEdit ? l10n.mktEditBasket : l10n.mktNewBasket,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            l10n.mktSave,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: BrandColors.error,
                    fontSize: 13,
                  ),
                ),
              ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(20),
                children: [
                  // Name
                  TextField(
                    controller: _nameCtrl,
                    enabled: !_saving,
                    decoration: InputDecoration(
                      labelText: l10n.mktBasketNameLabel,
                      hintText: l10n.mktBasketNameHint,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Description
                  TextField(
                    controller: _descCtrl,
                    enabled: !_saving,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.mktDescriptionOptional,
                      hintText: l10n.mktDescriptionHint,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Auto-priced tier preview
                  _TierPreview(grossTotal: _grossTotal, config: config),
                  const SizedBox(height: 20),

                  // Validity dates
                  Text(
                    l10n.mktValidity,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      color: BrandColors.muted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          icon: Icons.calendar_today_rounded,
                          caption: l10n.mktFromDateLabel,
                          value: _validFrom,
                          placeholder: l10n.mktSelectDate,
                          onTap: _saving ? null : () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateField(
                          icon: Icons.event_rounded,
                          caption: l10n.mktToDateLabel,
                          value: _validTo,
                          placeholder: l10n.mktSelectDate,
                          onTap: _saving
                              ? null
                              : () => _pickDate(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Products
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.mktProducts,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            color: BrandColors.muted,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _saving ? null : _showProductPicker,
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: Text(l10n.mktAddProduct),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_items.isEmpty)
                    GestureDetector(
                      onTap: _saving ? null : _showProductPicker,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BrandColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: BrandColors.muted,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.mktTapToPickProducts,
                              style: const TextStyle(
                                color: BrandColors.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    for (int i = 0; i < _items.length; i++) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BrandColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _items[i].productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: BrandColors.ink,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    l10n.mktPricePerUnit(
                                      _items[i].price.toStringAsFixed(0),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: BrandColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _items[i].qtyCtrl,
                                enabled: !_saving,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,1}'),
                                  ),
                                ],
                                textAlign: TextAlign.center,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: l10n.mktQty,
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(() {
                                      _items[i].dispose();
                                      _items.removeAt(i);
                                    }),
                              icon: const Icon(
                                Icons.remove_circle_outline_rounded,
                                color: BrandColors.error,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: LoadingButton(
                      label: _isEdit
                          ? l10n.mktSaveChanges
                          : l10n.mktCreateBasket,
                      isLoading: _saving,
                      onPressed: _saving ? null : _save,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

