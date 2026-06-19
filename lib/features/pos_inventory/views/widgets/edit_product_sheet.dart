// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../models/inventory_item.dart';
import '../../providers/inventory_provider.dart';
// import 'add_product_sheet.dart' show showCategoryPicker;
import 'add_product_sheet_new.dart' show showCategoryPicker;
import 'add_category_sheet.dart';
import 'barcode_scanner_overlay.dart';

const _editUnits = [
  'pcs',
  'kg',
  'g',
  'L',
  'ml',
  'dozen',
  'pack',
  'box',
  'bundle',
];

Future<void> showEditProductSheet(
  BuildContext context,
  WidgetRef ref,
  InventoryItem item,
) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _EditProductScreen(ref: ref, item: item),
    ),
  );
}

class _EditProductScreen extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final InventoryItem item;
  const _EditProductScreen({required this.ref, required this.item});

  @override
  ConsumerState<_EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<_EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.item.name);
  late final _brandCtrl = TextEditingController(text: widget.item.brand ?? '');
  late final _weightCtrl = TextEditingController(
    text: widget.item.weight != null ? widget.item.weight.toString() : '',
  );
  late final _barcodeCtrl = TextEditingController(
    text: widget.item.barcode ?? '',
  );
  late final _priceCtrl = TextEditingController(
    text: widget.item.price.toStringAsFixed(2),
  );
  late final _mrpCtrl = TextEditingController(
    text: widget.item.mrp != null ? widget.item.mrp!.toStringAsFixed(2) : '',
  );
  late final _stockCtrl = TextEditingController(
    text: widget.item.stockQuantity.toStringAsFixed(
      widget.item.stockQuantity % 1 == 0 ? 0 : 2,
    ),
  );

  late int _selectedCategoryId = widget.item.categoryId;
  late String? _selectedCategoryName = widget.item.categoryName;
  late String? _selectedUnit = widget.item.unit ?? 'pcs';
  late bool _isPerishable = widget.item.isPerishable;
  late bool _isLoose = widget.item.isLoose;
  bool _saving = false;
  bool _success = false;
  String? _error;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _brandCtrl,
      _weightCtrl,
      _barcodeCtrl,
      _priceCtrl,
      _mrpCtrl,
      _stockCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final allCats = ref.read(inventoryProvider).value?.categories ?? [];
    final result = await showCategoryPicker(context, allCats);
    if (result != null && mounted) {
      setState(() {
        _selectedCategoryId =
            (result['category_id'] as num?)?.toInt() ?? _selectedCategoryId;
        _selectedCategoryName = result['name'] as String?;
      });
    }
  }

  Future<void> _addNewCategory() async {
    final created = await showAddCategorySheet(context, ref);
    if (created && mounted) setState(() {});
  }

  Future<void> _scanBarcode() async {
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (scanned != null && mounted) {
      setState(() => _barcodeCtrl.text = scanned);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
      _success = false;
    });

    final err = await ref
        .read(inventoryProvider.notifier)
        .updateProduct(
          productId: widget.item.productId,
          name: _toTitleCase(_nameCtrl.text.trim()),
          categoryId: _selectedCategoryId,
          sellingPrice: double.parse(_priceCtrl.text),
          stockQuantity: double.parse(_stockCtrl.text),
          brand: _brandCtrl.text.trim().isNotEmpty
              ? _brandCtrl.text.trim()
              : null,
          unit: _selectedUnit,
          weight: _weightCtrl.text.trim().isNotEmpty
              ? double.tryParse(_weightCtrl.text.trim())
              : null,
          barcode: _barcodeCtrl.text.trim().isNotEmpty
              ? _barcodeCtrl.text.trim()
              : null,
          mrp: _mrpCtrl.text.isNotEmpty ? double.tryParse(_mrpCtrl.text) : null,
          isPerishable: _isPerishable,
          isLoose: _isLoose,
        );

    if (!mounted) return;
    if (err == null) {
      setState(() {
        _saving = false;
        _success = true;
      });
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_l10n.invProductUpdated(widget.item.name))),
        );
      }
    } else {
      setState(() {
        _saving = false;
        _error = err;
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
          l10n.invEditProduct,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_success)
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ActionStatusOverlay(
              isSaving: _saving,
              error: _error,
              isSuccess: _success,
              successMessage: l10n.invProductUpdatedSuccess,
            ),
            if (_saving || _error != null || _success)
              const SizedBox(height: 16),

            // Product image preview (if available)
            if (widget.item.imageUrl != null)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: BrandColors.surfaceTint,
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.item.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.inventory_2_rounded,
                        color: BrandColors.muted,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),

            _ToggleRow(
              label: l10n.invLooseItem,
              sublabel: l10n.invLooseItemSub,
              value: _isLoose,
              enabled: !_saving && !_success,
              onChanged: (v) => setState(() {
                _isLoose = v;
                if (v && _selectedUnit == 'pcs') _selectedUnit = 'kg';
              }),
            ),
            const SizedBox(height: 20),

            _SectionHeader(l10n.invBasicDetails),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameCtrl,
              enabled: !_saving && !_success,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.invProductNameLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.invRequired : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _brandCtrl,
              enabled: !_saving && !_success,
              decoration: InputDecoration(labelText: l10n.invBrandOptional),
            ),
            const SizedBox(height: 14),

            // Category picker
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
                          color: BrandColors.primary.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedCategoryName ??
                                  l10n.invSelectCategoryStar,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _selectedCategoryName == null
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
            const SizedBox(height: 14),

            // Unit + weight
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedUnit,
                    decoration: InputDecoration(labelText: l10n.invSellingUnit),
                    isExpanded: true,
                    items: _editUnits
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (_saving || _success)
                        ? null
                        : (v) => setState(() => _selectedUnit = v),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    controller: _weightCtrl,
                    enabled: !_isLoose && !_saving && !_success,
                    decoration: InputDecoration(
                      labelText: _isLoose ? l10n.invBaseUnit : l10n.invPackSize,
                      hintText: l10n.invPackSizeHint,
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
            const SizedBox(height: 14),

            // Barcode
            if (!_isLoose)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeCtrl,
                      enabled: !_saving && !_success,
                      decoration: InputDecoration(
                        labelText: l10n.invBarcode,
                        hintText: l10n.invOptional,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: (_saving || _success) ? null : _scanBarcode,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (_saving || _success)
                            ? BrandColors.border
                            : BrandColors.primary,
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
            const SizedBox(height: 24),

            _SectionHeader(l10n.invPricing),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceCtrl,
                    enabled: !_saving && !_success,
                    decoration: InputDecoration(
                      labelText: _isLoose
                          ? l10n.invPricePerSelected(_selectedUnit ?? '')
                          : l10n.invSellingPriceStar,
                      prefixText: '₹ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.invRequired;
                      if (double.tryParse(v) == null) return l10n.invInvalid;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    controller: _mrpCtrl,
                    enabled: !_saving && !_success,
                    decoration: InputDecoration(
                      labelText: l10n.invMrpOptional,
                      prefixText: '₹ ',
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
            const SizedBox(height: 24),

            _SectionHeader(l10n.invStock),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stockCtrl,
              enabled: !_saving && !_success,
              decoration: InputDecoration(
                labelText: _isLoose
                    ? l10n.invStockInUnit(_selectedUnit ?? '')
                    : l10n.invStockQuantityStar,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (v) =>
                  (v == null || v.isEmpty) ? l10n.invRequired : null,
            ),
            if (widget.item.isPerishable)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.invPerishableBatchNote,
                  style: TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted.withValues(alpha: 0.8),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            _SectionHeader(l10n.invOther),
            const SizedBox(height: 12),
            _ToggleRow(
              label: l10n.invPerishableItem,
              sublabel: l10n.invPerishableItemSub,
              value: _isPerishable,
              enabled: !_saving && !_success,
              onChanged: (v) => setState(() => _isPerishable = v),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: (_saving || _success) ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrandColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.invSaveChanges,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

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
