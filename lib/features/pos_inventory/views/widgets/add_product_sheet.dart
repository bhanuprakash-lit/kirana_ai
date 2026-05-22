import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/inventory_provider.dart';
import 'add_category_sheet.dart';
import 'barcode_scanner_overlay.dart';

const _units = ['pcs', 'kg', 'g', 'L', 'ml', 'dozen', 'pack', 'box', 'bundle'];

// ── Entry point ───────────────────────────────────────────────────────────────

Future<void> showAddProductSheet(
  BuildContext context,
  WidgetRef ref, {
  String? initialBarcode,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) =>
          _AddProductScreen(ref: ref, initialBarcode: initialBarcode),
    ),
  );
}

// ── Catalog search result ─────────────────────────────────────────────────────

class _CatalogProduct {
  final int productId;
  final String name;
  final String? brand;
  final String? unit;
  final double? weight;
  final String? barcode;
  final bool isPerishable;
  final bool isLoose;
  final String? imageUrl;
  final int categoryId;
  final String? categoryName;
  final String? parentCategoryName;

  const _CatalogProduct({
    required this.productId,
    required this.name,
    this.brand,
    this.unit,
    this.weight,
    this.barcode,
    required this.isPerishable,
    required this.isLoose,
    this.imageUrl,
    required this.categoryId,
    this.categoryName,
    this.parentCategoryName,
  });

  factory _CatalogProduct.fromJson(Map<String, dynamic> j) => _CatalogProduct(
    productId: j['product_id'] as int,
    name: j['name'] as String,
    brand: j['brand'] as String?,
    unit: j['unit'] as String?,
    weight: (j['weight'] as num?)?.toDouble(),
    barcode: j['barcode'] as String?,
    isPerishable: j['is_perishable'] as bool? ?? false,
    isLoose: j['is_loose'] as bool? ?? false,
    imageUrl: j['image_url'] as String?,
    categoryId: j['category_id'] as int,
    categoryName: j['category_name'] as String?,
    parentCategoryName: j['parent_category_name'] as String?,
  );

  String get subtitle {
    final parts = <String>[];
    if (brand != null) parts.add(brand!);
    if (parentCategoryName != null) parts.add(parentCategoryName!);
    if (categoryName != null && categoryName != parentCategoryName)
      parts.add(categoryName!);
    return parts.join(' · ');
  }
}

// ── Main screen ───────────────────────────────────────────────────────────────

enum _Stage { search, form }

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

  // ── Search state ──────────────────────────────────────────────────────────
  final _searchCtrl = TextEditingController();
  List<_CatalogProduct> _searchResults = [];
  bool _searching = false;
  bool _hasMore = false;
  int _searchOffset = 0;
  String _lastQuery = '';
  Timer? _debounce;

  // ── Form state ────────────────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();

  int? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isPerishable = false;
  bool _isLoose = false;
  bool _saving = false;
  bool _success = false;
  String? _error;

  // Variants — first variant is always present (the "main" product)
  final List<_VariantData> _variants = [_VariantData()];

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
    for (final v in _variants) {
      v.dispose();
    }
    super.dispose();
  }

  // ── Search logic ──────────────────────────────────────────────────────────

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
    setState(() => _stage = _Stage.form);
  }

  void _goManual() {
    _linked = null;
    setState(() => _stage = _Stage.form);
  }

  // ── Category picker ───────────────────────────────────────────────────────

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

  // ── Barcode scan ──────────────────────────────────────────────────────────

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

  // ── Save ─────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      setState(() => _error = 'Please select a category');
      return;
    }
    // Validate all variants have a price
    for (int i = 0; i < _variants.length; i++) {
      if (_variants[i].priceCtrl.text.trim().isEmpty) {
        setState(() => _error = 'Variant ${i + 1}: selling price is required');
        return;
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

    String? firstError;
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
            isPerishable: _isPerishable,
            isLoose: _isLoose,
            expiryDate: _isPerishable && v.expiryCtrl.text.isNotEmpty
                ? v.expiryCtrl.text
                : null,
            existingProductId: i == 0 ? _linked?.productId : null,
            // V2+ create new product rows — copy catalog image so they show the same photo
            imageUrl: i == 0 ? null : _linked?.imageUrl,
          );
      if (err != null) {
        firstError = err;
        break;
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
                  ? 'Product saved — syncing in background'
                  : '$count variants saved — syncing in background',
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
        title: Text(
          _stage == _Stage.search
              ? 'Add Product'
              : (_linked != null ? 'Add from Catalog' : 'New Product'),
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
                    : const Text(
                        'Save',
                        style: TextStyle(
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

  // ── Search stage ──────────────────────────────────────────────────────────

  Widget _buildSearch() {
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
                    hintText: 'Search product name...',
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
                          label: const Text('Load more results'),
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
                            'No more search results',
                            style: TextStyle(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_rounded, size: 56, color: BrandColors.border),
        const SizedBox(height: 14),
        const Text(
          'Search the product catalog',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: BrandColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Type a name or scan a barcode.\nIf not found, add manually.',
          textAlign: TextAlign.center,
          style: TextStyle(color: BrandColors.muted, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 28),
        _buildManualEntry(),
      ],
    );
  }

  Widget _buildManualEntry() {
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add manually',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: BrandColors.ink,
                      ),
                    ),
                    Text(
                      'Product not in catalog? Enter details yourself.',
                      style: TextStyle(fontSize: 12, color: BrandColors.muted),
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

  // ── Form stage ────────────────────────────────────────────────────────────

  Widget _buildForm() {
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
                ? 'Product added!'
                : '${_variants.length} variants added!',
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          // Catalog link chip
          if (_linked != null) ...[
            _LinkedChip(product: _linked!),
            const SizedBox(height: 20),
          ],

          // Loose toggle
          _ToggleRow(
            label: 'Loose item',
            sublabel: 'Sold by weight (e.g. Maida, Pulse)',
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

          _SectionHeader('Basic Details'),
          const SizedBox(height: 12),

          TextFormField(
            controller: _nameCtrl,
            enabled: _linked == null && !_saving && !_success,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Product name *'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _brandCtrl,
            enabled: _linked == null && !_saving && !_success,
            decoration: const InputDecoration(labelText: 'Brand (optional)'),
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
                            _selectedCategoryName ?? 'Select category *',
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
            const Padding(
              padding: EdgeInsets.only(top: 4, left: 4),
              child: Text(
                'Please select a category',
                style: TextStyle(fontSize: 12, color: BrandColors.error),
              ),
            ),
          const SizedBox(height: 24),

          // ── Perishable toggle ──────────────────────────────────────────
          _SectionHeader('Other'),
          const SizedBox(height: 12),
          _ToggleRow(
            label: 'Perishable item',
            sublabel: 'Has an expiry date',
            value: _isPerishable,
            enabled: !_saving && !_success,
            onChanged: (v) => setState(() => _isPerishable = v),
          ),
          const SizedBox(height: 24),

          // ── Variants ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionHeader(
                _variants.length == 1
                    ? 'Size, Price & Stock'
                    : 'Variants (${_variants.length})',
              ),
              if (!_saving && !_success)
                TextButton.icon(
                  onPressed: () => setState(() {
                    final v = _VariantData();
                    // Inherit unit from catalog so V2 matches V1's unit
                    if (_linked != null)
                      v.selectedUnit = _linked!.unit ?? 'pcs';
                    _variants.add(v);
                  }),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text(
                    'Add Variant',
                    style: TextStyle(fontSize: 13),
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
            _buildVariantRow(i),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 28),
          SizedBox(
            height: 56,
            child: LoadingButton(
              label: _variants.length == 1
                  ? 'Save Product'
                  : 'Save ${_variants.length} Variants',
              isLoading: _saving,
              onPressed: _success ? null : _save,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildVariantRow(int idx) {
    final v = _variants[idx];
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
                  _variants.length == 1 ? 'Product' : 'Variant ${idx + 1}',
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
                  value: v.selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    isDense: true,
                  ),
                  isExpanded: true,
                  items: _units
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
                    labelText: _isLoose ? 'Base unit' : 'Pack size',
                    hintText: 'e.g. 250',
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
                          labelText: 'Barcode',
                          hintText: catalogHasBarcode
                              ? 'From catalog'
                              : 'optional',
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
                        ? 'Price / ${v.selectedUnit} *'
                        : 'Selling price *',
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
                    if (val == null || val.isEmpty) return 'Required';
                    if (double.tryParse(val) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: v.mrpCtrl,
                  enabled: !_saving && !_success,
                  decoration: const InputDecoration(
                    labelText: 'MRP',
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

          // Stock
          TextFormField(
            controller: v.stockCtrl,
            enabled: !_saving && !_success,
            decoration: InputDecoration(
              labelText: _isLoose
                  ? 'Opening stock (${v.selectedUnit}) *'
                  : 'Opening stock (units) *',
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
              decoration: const InputDecoration(
                labelText: 'Expiry date',
                hintText: 'YYYY-MM-DD',
                prefixIcon: Icon(Icons.event_rounded, size: 18),
                isDense: true,
              ),
              readOnly: true,
              validator: (val) =>
                  (_isPerishable && (val == null || val.isEmpty))
                  ? 'Required for perishables'
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

// ── Variant data holder ───────────────────────────────────────────────────────

class _VariantData {
  final weightCtrl = TextEditingController(); // empty = no pack size
  final barcodeCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final mrpCtrl = TextEditingController();
  final stockCtrl = TextEditingController(text: '0');
  final expiryCtrl = TextEditingController();
  String selectedUnit = 'pcs';

  void dispose() {
    weightCtrl.dispose();
    barcodeCtrl.dispose();
    priceCtrl.dispose();
    mrpCtrl.dispose();
    stockCtrl.dispose();
    expiryCtrl.dispose();
  }
}

// ── Catalog result tile ───────────────────────────────────────────────────────

class _CatalogResultTile extends StatelessWidget {
  final _CatalogProduct product;
  final VoidCallback onTap;

  const _CatalogResultTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            // Product image / icon
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => _iconFallback(),
                    )
                  : _iconFallback(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.subtitle.isNotEmpty)
                    Text(
                      product.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (product.barcode != null)
                    Text(
                      product.barcode!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: BrandColors.muted,
                        fontFamily: 'monospace',
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.add_circle_rounded,
              color: BrandColors.primary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconFallback() => Container(
    width: 48,
    height: 48,
    color: BrandColors.surfaceTint,
    child: const Icon(
      Icons.inventory_2_rounded,
      color: BrandColors.muted,
      size: 22,
    ),
  );
}

// ── Linked chip ───────────────────────────────────────────────────────────────

class _LinkedChip extends StatelessWidget {
  final _CatalogProduct product;
  const _LinkedChip({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BrandColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          if (product.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl!,
                width: 44,
                height: 44,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (product.imageUrl != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.link_rounded,
                      size: 14,
                      color: BrandColors.primary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Linked from catalog',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: BrandColors.ink,
                  ),
                ),
                if (product.subtitle.isNotEmpty)
                  Text(
                    product.subtitle,
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
    );
  }
}

// ── Searchable category picker sheet ─────────────────────────────────────────

/// Public entry point so other sheets can reuse the category picker.
Future<Map<String, dynamic>?> showCategoryPicker(
  BuildContext context,
  List<Map<String, dynamic>> categories,
) => showModalBottomSheet<Map<String, dynamic>>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => _CategoryPickerSheet(categories: categories),
);

class _CategoryPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  const _CategoryPickerSheet({required this.categories});

  @override
  State<_CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<_CategoryPickerSheet> {
  final _ctrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        widget.categories.where((c) {
          if (_query.isEmpty) return true;
          final name = (c['name'] as String? ?? '').toLowerCase();
          return name.contains(_query.toLowerCase());
        }).toList()..sort(
          (a, b) => (a['name'] as String).compareTo(b['name'] as String),
        );

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: BrandColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
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
            // Header + search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: BrandColors.muted,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _ctrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // List
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No categories found',
                        style: TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final cat = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            cat['name'] as String? ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.check_rounded,
                            color: BrandColors.primary,
                            size: 18,
                          ),
                          onTap: () => Navigator.pop(context, cat),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

String _toTitleCase(String s) => s
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1))
    .join(' ');

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Text(
    title.toUpperCase(),
    style: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 11,
      color: BrandColors.muted,
      letterSpacing: 1.2,
    ),
  );
}

class _ToggleRow extends StatelessWidget {
  final String label, sublabel;
  final bool value, enabled;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.sublabel,
    required this.value,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: BrandColors.surfaceTint,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: BrandColors.border),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeTrackColor: BrandColors.primary,
        ),
      ],
    ),
  );
}
