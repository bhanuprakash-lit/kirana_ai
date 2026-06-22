part of '../add_product_sheet_new.dart';

class _AddProductScreen extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final String? initialBarcode;
  const _AddProductScreen({required this.ref, this.initialBarcode});

  @override
  ConsumerState<_AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<_AddProductScreen> {
  _Stage _stage = _Stage.search;
  _CatalogProduct? _linked; // set when user picks from catalog

  final _searchCtrl = TextEditingController();
  List<_CatalogProduct> _searchResults = [];
  bool _searching = false;
  bool _hasMore = false;
  int _searchOffset = 0;
  String _lastQuery = '';
  Timer? _debounce;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _gstCtrl = TextEditingController(); // F3 — GST %
  final _hsnCtrl = TextEditingController(); // F3 — HSN code

  int? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isPerishable = false;
  bool _isLoose = false;
  bool _saving = false;
  bool _success = false;
  String? _error;

  // Variants — first variant is always present (the "main" product)
  final List<_VariantData> _variants = [_VariantData()];

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    if (widget.initialBarcode != null) {
      _variants[0].barcodeCtrl.text = widget.initialBarcode!;
      // auto-search by barcode
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _searchCatalog(barcode: widget.initialBarcode!),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _gstCtrl.dispose();
    _hsnCtrl.dispose();
    for (final v in _variants) {
      v.dispose();
    }
    super.dispose();
  }

  static const _pageSize = 20;

  void _onSearchChanged() {
    _debounce?.cancel();
    final q = _searchCtrl.text.trim();
    if (q.length < 2) {
      setState(() {
        _searchResults = [];
        _hasMore = false;
        _searchOffset = 0;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _lastQuery = q;
      _searchOffset = 0;
      _searchCatalog(query: q);
    });
  }

  Future<void> _searchCatalog({
    String query = '',
    String barcode = '',
    bool append = false,
  }) async {
    setState(() => _searching = true);
    try {
      final client = ref.read(apiClientProvider);
      final String uri;
      if (barcode.isNotEmpty) {
        uri = '/kirana/catalog/search?barcode=${Uri.encodeComponent(barcode)}';
      } else {
        uri =
            '/kirana/catalog/search?q=${Uri.encodeComponent(query)}&limit=$_pageSize&offset=$_searchOffset';
      }
      final res = await client.get(uri) as Map<String, dynamic>;
      final products = (res['products'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(_CatalogProduct.fromJson)
          .toList();
      if (mounted) {
        setState(() {
          if (append) {
            _searchResults = [..._searchResults, ...products];
          } else {
            _searchResults = products;
          }
          _hasMore = products.length >= _pageSize;
          _searching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _loadMore() async {
    if (_searching || !_hasMore) return;
    _searchOffset += _pageSize;
    await _searchCatalog(query: _lastQuery, append: true);
  }

  void _selectCatalogProduct(_CatalogProduct p) {
    _linked = p;
    _nameCtrl.text = p.name;
    _brandCtrl.text = p.brand ?? '';
    // Populate first variant from catalog data
    _variants[0].barcodeCtrl.text = p.barcode ?? '';
    _variants[0].selectedUnit = p.unit ?? 'pcs';
    _variants[0].weightCtrl.text = p.weight?.toString() ?? '';
    _selectedCategoryId = p.categoryId;
    _selectedCategoryName = p.categoryName;
    _isPerishable = p.isPerishable;
    _isLoose = p.isLoose;

    // Prefill price / MRP / stock with this priority:
    //   1. Local inventory row (this store already stocks the product) — most
    //      authoritative; reflects whatever the shopkeeper last set.
    //   2. Catalog row's price/mrp returned by /kirana/catalog/search — that
    //      now joins the most-recent pricing row for this store server-side,
    //      so brand-new products that haven't hit `inventory` yet still come
    //      with sensible Blinkit-seeded numbers.
    final v = _variants[0];
    final localProducts = ref.read(posProvider).products;
    final existing = localProducts
        .where(
          (lp) =>
              lp.productId == p.productId ||
              (p.barcode != null &&
                  p.barcode!.isNotEmpty &&
                  lp.barcode == p.barcode),
        )
        .firstOrNull;

    final priceSource = existing?.price ?? p.price;
    final mrpSource = existing?.mrp ?? p.mrp;
    if (priceSource != null && priceSource > 0 && v.priceCtrl.text.isEmpty) {
      v.priceCtrl.text = priceSource.toStringAsFixed(
        priceSource % 1 == 0 ? 0 : 2,
      );
    }
    if (mrpSource != null && mrpSource > 0 && v.mrpCtrl.text.isEmpty) {
      v.mrpCtrl.text = mrpSource.toStringAsFixed(mrpSource % 1 == 0 ? 0 : 2);
    }
    if (existing != null && existing.stockQuantity > 0) {
      v.stockCtrl.text = existing.stockQuantity.toStringAsFixed(
        existing.stockQuantity % 1 == 0 ? 0 : 2,
      );
    }

    setState(() => _stage = _Stage.form);
  }

  void _goManual() {
    _linked = null;
    setState(() => _stage = _Stage.form);
  }

  Future<void> _pickCategory() async {
    final inventoryAsync = ref.read(inventoryProvider);
    final allCats = inventoryAsync.value?.categories ?? [];

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryPickerSheet(categories: allCats),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedCategoryId = (result['category_id'] as num?)?.toInt();
        _selectedCategoryName = result['name'] as String?;
      });
    }
  }

  Future<void> _addNewCategory() async {
    final created = await showAddCategorySheet(context, ref);
    if (created && mounted) setState(() {});
  }

  Future<void> _scanBarcode({int variantIndex = 0}) async {
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (scanned == null || !mounted) return;
    setState(() => _variants[variantIndex].barcodeCtrl.text = scanned);
    if (variantIndex == 0) {
      // Auto-search catalog by barcode only for the first variant
      await _searchCatalog(barcode: scanned);
      if (_searchResults.isNotEmpty) {
        _selectCatalogProduct(_searchResults.first);
      }
    }
  }

  Future<void> _scanBarcodeFromSearch() async {
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (scanned == null || !mounted) return;
    _searchCtrl.text = scanned;
    _lastQuery = scanned;
    _searchOffset = 0;
    await _searchCatalog(barcode: scanned);
    if (_searchResults.length == 1) {
      _selectCatalogProduct(_searchResults.first);
    } else {
      setState(() {});
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      setState(() => _error = _l10n.invSelectCategoryError);
      return;
    }
    // Validate all variants have a price
    for (int i = 0; i < _variants.length; i++) {
      if (_variants[i].priceCtrl.text.trim().isEmpty) {
        setState(() => _error = _l10n.invVariantPriceRequired(i + 1));
        return;
      }
    }
    // F2 — each variant must have every axis set so it is uniquely identifiable.
    if (verticalConfigOf(ref).has('variants')) {
      final axes = (ref.read(attributeDefsProvider).asData?.value ?? [])
          .where((a) => a.isVariantAxis)
          .toList();
      for (final v in _variants) {
        for (final a in axes) {
          if ((v.attributes[a.attrCode] ?? '').trim().isEmpty) {
            setState(() => _error = _l10n.invVariantAxisRequired(a.label));
            return;
          }
        }
      }
    }
    setState(() {
      _saving = true;
      _error = null;
      _success = false;
    });

    final name = _toTitleCase(_nameCtrl.text.trim());
    final brand = _brandCtrl.text.trim().isNotEmpty
        ? _brandCtrl.text.trim()
        : null;
    // F3 — product-level GST (gated to non-grocery in the UI).
    final gstRate = _gstCtrl.text.trim().isNotEmpty
        ? double.tryParse(_gstCtrl.text.trim())
        : null;
    final hsnCode = _hsnCtrl.text.trim().isNotEmpty ? _hsnCtrl.text.trim() : null;

    String? firstError;
    if (verticalConfigOf(ref).has('variants')) {
      // F2 — one product carrying many real variants (size/colour/model).
      final first = _variants.first;
      double totalStock = 0;
      final specs = <Map<String, dynamic>>[];
      for (final v in _variants) {
        final stock = double.tryParse(v.stockCtrl.text.trim()) ?? 0;
        totalStock += stock;
        specs.add({
          'attributes': Map<String, String>.from(v.attributes),
          'price': double.tryParse(v.priceCtrl.text.trim()),
          'mrp': v.mrpCtrl.text.trim().isNotEmpty
              ? double.tryParse(v.mrpCtrl.text.trim())
              : null,
          'cost': v.costCtrl.text.trim().isNotEmpty
              ? double.tryParse(v.costCtrl.text.trim())
              : null,
          'stock': stock,
          'barcode': v.barcodeCtrl.text.trim(),
        });
      }
      firstError = await ref.read(inventoryProvider.notifier).addProduct(
            name: name,
            categoryId: _selectedCategoryId!,
            sellingPrice: double.parse(first.priceCtrl.text),
            initialStock: totalStock,
            brand: brand,
            unit: 'pcs',
            barcode: first.barcodeCtrl.text.trim().isNotEmpty
                ? first.barcodeCtrl.text.trim()
                : null,
            mrp: first.mrpCtrl.text.trim().isNotEmpty
                ? double.tryParse(first.mrpCtrl.text.trim())
                : null,
            existingProductId: _linked?.productId,
            imageUrl: _linked?.imageUrl,
            variants: specs,
            gstRate: gstRate,
            hsnCode: hsnCode,
          );
    } else {
      for (int i = 0; i < _variants.length; i++) {
        final v = _variants[i];
        // Only the first variant reuses the catalog product_id.
        // Each additional variant must create its own product row so it gets
        // a unique product_id and a separate inventory entry.
        final err = await ref
            .read(inventoryProvider.notifier)
            .addProduct(
              name: name,
              categoryId: _selectedCategoryId!,
              sellingPrice: double.parse(v.priceCtrl.text),
              initialStock: double.parse(
                v.stockCtrl.text.isEmpty ? '0' : v.stockCtrl.text,
              ),
              brand: brand,
              unit: v.selectedUnit,
              weight: v.weightCtrl.text.trim().isNotEmpty
                  ? double.tryParse(v.weightCtrl.text.trim())
                  : null,
              barcode: v.barcodeCtrl.text.trim().isNotEmpty
                  ? v.barcodeCtrl.text.trim()
                  : null,
              mrp: v.mrpCtrl.text.isNotEmpty
                  ? double.tryParse(v.mrpCtrl.text)
                  : null,
              costPrice: v.costCtrl.text.isNotEmpty
                  ? double.tryParse(v.costCtrl.text)
                  : null,
              isPerishable: _isPerishable,
              isLoose: _isLoose,
              expiryDate: _isPerishable && v.expiryCtrl.text.isNotEmpty
                  ? v.expiryCtrl.text
                  : null,
              existingProductId: i == 0 ? _linked?.productId : null,
              // V2+ create new product rows — copy catalog image so they show the same photo
              imageUrl: i == 0 ? null : _linked?.imageUrl,
              gstRate: gstRate,
              hsnCode: hsnCode,
            );
        if (err != null) {
          firstError = err;
          break;
        }
      }
    }

    if (!mounted) return;
    if (firstError == null) {
      setState(() {
        _saving = false;
        _success = true;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context);
        final count = _variants.length;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              count == 1
                  ? _l10n.invProductSavedSyncing
                  : _l10n.invVariantsSavedSyncing(count),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {
        _saving = false;
        _error = firstError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
        title: Text(
          _stage == _Stage.search
              ? verticalConfigOf(ref).copy('add_title', l10n.invAddProduct)
              : (_linked != null ? l10n.invAddFromCatalog : l10n.invNewProduct),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (_stage == _Stage.form) {
              setState(() {
                _stage = _Stage.search;
                _linked = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (_stage == _Stage.form && !_success)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: BrandColors.primary,
                        ),
                      )
                    : Text(
                        l10n.invSave,
                        style: const TextStyle(
                          color: BrandColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
        ],
      ),
      body: _stage == _Stage.search ? _buildSearch() : _buildForm(),
    );
  }

  Widget _buildSearch() {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        // Search bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText:
                        verticalConfigOf(ref).copy('search_hint', l10n.invSearchProductName),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: BrandColors.muted,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: BrandColors.surfaceTint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    suffixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 18,
                              color: BrandColors.muted,
                            ),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchResults = []);
                            },
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _scanBarcodeFromSearch,
                child: Container(
                  width: 44,
                  height: 44,
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
            ],
          ),
        ),

        // Results
        Expanded(
          child: _searchResults.isEmpty && !_searching
              ? _buildSearchEmpty()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _searchResults.length + (_hasMore ? 2 : 1) + 1,
                  itemBuilder: (_, i) {
                    if (i < _searchResults.length) {
                      return _CatalogResultTile(
                        product: _searchResults[i],
                        onTap: () => _selectCatalogProduct(_searchResults[i]),
                      );
                    }
                    final afterResults = i - _searchResults.length;
                    if (_hasMore && afterResults == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextButton.icon(
                          onPressed: _searching ? null : _loadMore,
                          icon: _searching
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.expand_more_rounded),
                          label: Text(l10n.invLoadMoreResults),
                        ),
                      );
                    }
                    if (!_hasMore &&
                        _searchResults.isNotEmpty &&
                        afterResults == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Center(
                          child: Text(
                            l10n.invNoMoreSearchResults,
                            style: const TextStyle(
                              color: BrandColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }
                    return _buildManualEntry();
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchEmpty() {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_rounded, size: 56, color: BrandColors.border),
        const SizedBox(height: 14),
        Text(
          l10n.invSearchProductCatalog,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: BrandColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.invSearchCatalogHint,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: BrandColors.muted,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        _buildManualEntry(),
      ],
    );
  }

  Widget _buildManualEntry() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _goManual,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: BrandColors.border,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BrandColors.surfaceTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: BrandColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.invAddManually,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: BrandColors.ink,
                      ),
                    ),
                    Text(
                      l10n.invAddManuallySub,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: BrandColors.muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            successMessage: _variants.length == 1
                ? l10n.invProductAdded
                : l10n.invVariantsAdded(_variants.length),
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          // Catalog link chip
          if (_linked != null) ...[
            _LinkedChip(product: _linked!),
            const SizedBox(height: 20),
          ],

          // Loose toggle — grocery-style loose/weight selling. Hidden for
          // verticals that don't sell loose (vertical config feature flag).
          if (verticalConfigOf(ref).has('loose')) ...[
            _ToggleRow(
              label: l10n.invLooseItem,
              sublabel: l10n.invLooseItemSub,
              value: _isLoose,
              enabled: !_saving && !_success,
              onChanged: (v) => setState(() {
                _isLoose = v;
                if (v) {
                  for (final vt in _variants) {
                    if (vt.selectedUnit == 'pcs') vt.selectedUnit = 'kg';
                  }
                }
              }),
            ),
            const SizedBox(height: 20),
          ],

          _SectionHeader(l10n.invBasicDetails),
          const SizedBox(height: 12),

          TextFormField(
            controller: _nameCtrl,
            enabled: _linked == null && !_saving && !_success,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.invProductNameLabel),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? l10n.invRequired : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _brandCtrl,
            enabled: _linked == null && !_saving && !_success,
            decoration: InputDecoration(labelText: l10n.invBrandOptional),
          ),
          const SizedBox(height: 14),

          // Searchable category picker
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (_saving || _success) ? null : _pickCategory,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedCategoryId == null
                            ? BrandColors.border
                            : BrandColors.primary.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedCategoryName ?? l10n.invSelectCategoryStar,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _selectedCategoryId == null
                                  ? BrandColors.muted
                                  : BrandColors.ink,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: BrandColors.muted,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: (_saving || _success) ? null : _addNewCategory,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: BrandColors.surfaceTint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: BrandColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (_error != null && _selectedCategoryId == null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                l10n.invSelectCategoryError,
                style: const TextStyle(fontSize: 12, color: BrandColors.error),
              ),
            ),
          const SizedBox(height: 24),

          // Expiry tracking is grocery-only; hidden where the vertical config
          // has no 'expiry' feature (e.g. apparel, electronics).
          if (verticalConfigOf(ref).has('expiry')) ...[
            _SectionHeader(l10n.invOther),
            const SizedBox(height: 12),
            _ToggleRow(
              label: l10n.invPerishableItem,
              sublabel: l10n.invPerishableItemSub,
              value: _isPerishable,
              enabled: !_saving && !_success,
              onChanged: (v) => setState(() => _isPerishable = v),
            ),
            const SizedBox(height: 24),
          ],

          // F3 — GST / HSN for non-grocery (taxable) verticals.
          if (verticalConfigOf(ref).verticalCode != 'grocery') ...[
            _SectionHeader(l10n.invGstRate),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gstCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.invGstRate,
                      suffixText: '%',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hsnCtrl,
                    decoration: InputDecoration(labelText: l10n.invHsnCode),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionHeader(
                verticalConfigOf(ref).has('variants')
                    ? l10n.invVariants
                    : (_variants.length == 1
                          ? l10n.invSizePriceStock
                          : l10n.invVariantsCount(_variants.length)),
              ),
              if (!_saving && !_success)
                TextButton.icon(
                  onPressed: () => setState(() {
                    final v = _VariantData();
                    // Inherit unit from catalog so V2 matches V1's unit
                    if (_linked != null) {
                      v.selectedUnit = _linked!.unit ?? 'pcs';
                    }
                    _variants.add(v);
                  }),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(
                    l10n.invAddVariant,
                    style: const TextStyle(fontSize: 13),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          for (int i = 0; i < _variants.length; i++) ...[
            verticalConfigOf(ref).has('variants')
                ? _buildF2VariantRow(i)
                : _buildVariantRow(i),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 28),
          SizedBox(
            height: 56,
            child: LoadingButton(
              label: verticalConfigOf(ref).has('variants')
                  ? l10n.invSaveProduct
                  : (_variants.length == 1
                        ? l10n.invSaveProduct
                        : l10n.invSaveVariants(_variants.length)),
              isLoading: _saving,
              onPressed: _success ? null : _save,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// F2 inline row: variant axes (size/colour/model) + price + stock. Used when
  /// the store's vertical `has('variants')`; produces one product_variant.
  Widget _buildF2VariantRow(int idx) {
    final l10n = AppLocalizations.of(context);
    final v = _variants[idx];
    final axes = (ref.watch(attributeDefsProvider).asData?.value ?? [])
        .where((a) => a.isVariantAxis)
        .toList();
    final canRemove = _variants.length > 1 && !_saving && !_success;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.invVariantNumber(idx + 1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: BrandColors.muted,
                    fontSize: 12,
                  ),
                ),
              ),
              if (canRemove)
                InkWell(
                  onTap: () => setState(() {
                    _variants[idx].dispose();
                    _variants.removeAt(idx);
                  }),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: BrandColors.muted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (final a in axes) ...[
            _f2AxisField(v, a),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(child: _f2NumField(v.priceCtrl, l10n.invPrice, prefix: '₹ ')),
              const SizedBox(width: 10),
              Expanded(child: _f2NumField(v.stockCtrl, l10n.invStock)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _f2AxisField(_VariantData v, AttributeDef a) {
    if (a.isEnum) {
      return DropdownButtonFormField<String>(
        initialValue: (v.attributes[a.attrCode]?.isNotEmpty ?? false)
            ? v.attributes[a.attrCode]
            : null,
        isExpanded: true,
        decoration: InputDecoration(labelText: a.label),
        items: a.options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (_saving || _success)
            ? null
            : (val) => setState(() => v.attributes[a.attrCode] = val ?? ''),
      );
    }
    return TextFormField(
      initialValue: v.attributes[a.attrCode],
      enabled: !_saving && !_success,
      decoration: InputDecoration(labelText: a.label),
      onChanged: (val) => v.attributes[a.attrCode] = val.trim(),
    );
  }

  Widget _f2NumField(TextEditingController c, String label, {String? prefix}) =>
      TextField(
        controller: c,
        enabled: !_saving && !_success,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(labelText: label, prefixText: prefix),
      );

  Widget _buildVariantRow(int idx) {
    final l10n = AppLocalizations.of(context);
    final v = _variants[idx];
    // Units come from the store's vertical config (grocery defaults otherwise).
    // Always include the current selection so the dropdown value stays valid.
    final units = <String>{...verticalConfigOf(ref).unitSet, v.selectedUnit}
        .toList();
    final isFirst = idx == 0;
    final canRemove = _variants.length > 1 && !_saving && !_success;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Variant header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _variants.length == 1
                      ? l10n.invProduct
                      : l10n.invVariantNumber(idx + 1),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: BrandColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              if (canRemove)
                GestureDetector(
                  onTap: () => setState(() {
                    _variants[idx].dispose();
                    _variants.removeAt(idx);
                  }),
                  child: const Icon(
                    Icons.remove_circle_outline_rounded,
                    size: 20,
                    color: BrandColors.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Unit + weight
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: v.selectedUnit,
                  decoration: InputDecoration(
                    labelText: l10n.invUnit,
                    isDense: true,
                  ),
                  isExpanded: true,
                  items: units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (_saving || _success)
                      ? null
                      : (val) => setState(
                          () => v.selectedUnit = val ?? v.selectedUnit,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: v.weightCtrl,
                  enabled: !_isLoose && !_saving && !_success,
                  decoration: InputDecoration(
                    labelText: _isLoose ? l10n.invBaseUnit : l10n.invPackSize,
                    hintText: l10n.invPackSizeHint,
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Barcode — locked only when catalog already supplied one
          if (!_isLoose)
            Builder(
              builder: (_) {
                final catalogHasBarcode =
                    _linked != null &&
                    isFirst &&
                    (_linked!.barcode?.isNotEmpty ?? false);
                final barcodeEditable =
                    !catalogHasBarcode && !_saving && !_success;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: v.barcodeCtrl,
                        enabled: barcodeEditable,
                        decoration: InputDecoration(
                          labelText: l10n.invBarcode,
                          hintText: catalogHasBarcode
                              ? l10n.invFromCatalog
                              : l10n.invOptional,
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: barcodeEditable
                          ? () => _scanBarcode(variantIndex: idx)
                          : null,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: barcodeEditable
                              ? BrandColors.primary
                              : BrandColors.border,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 10),

          // Price + MRP
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: v.priceCtrl,
                  autofocus: isFirst && _linked != null,
                  enabled: !_saving && !_success,
                  decoration: InputDecoration(
                    labelText: _isLoose
                        ? l10n.invPricePerUnit(v.selectedUnit)
                        : l10n.invSellingPriceStar,
                    prefixText: '₹ ',
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (val) {
                    if (val == null || val.isEmpty) return l10n.invRequired;
                    if (double.tryParse(val) == null) return l10n.invInvalid;
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: v.mrpCtrl,
                  enabled: !_saving && !_success,
                  decoration: InputDecoration(
                    labelText: l10n.invMrp,
                    prefixText: '₹ ',
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Cost price (what you pay) — feeds profit/margin KPIs.
          TextFormField(
            controller: v.costCtrl,
            enabled: !_saving && !_success,
            decoration: InputDecoration(
              labelText: l10n.invCostPrice,
              hintText: l10n.invCostPriceHint,
              prefixText: '₹ ',
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: 10),

          // Stock
          TextFormField(
            controller: v.stockCtrl,
            enabled: !_saving && !_success,
            decoration: InputDecoration(
              labelText: _isLoose
                  ? l10n.invOpeningStockUnit(v.selectedUnit)
                  : l10n.invOpeningStockUnits,
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),

          // Expiry (only if perishable)
          if (_isPerishable) ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: v.expiryCtrl,
              enabled: !_saving && !_success,
              decoration: InputDecoration(
                labelText: l10n.invExpiryDate,
                hintText: l10n.invExpiryDateHint,
                prefixIcon: const Icon(Icons.event_rounded, size: 18),
                isDense: true,
              ),
              readOnly: true,
              validator: (val) =>
                  (_isPerishable && (val == null || val.isEmpty))
                  ? l10n.invRequiredForPerishables
                  : null,
              onTap: () async {
                if (_saving || _success) return;
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) {
                  v.expiryCtrl.text =
                      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  setState(() {});
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}

