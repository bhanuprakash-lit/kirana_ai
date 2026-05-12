import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/inventory_provider.dart';
import 'add_category_sheet.dart';
import 'barcode_scanner_overlay.dart';

const _units = [
  'pcs', 'kg', 'g', 'L', 'ml', 'dozen', 'pack', 'box', 'bundle',
];

Future<void> showAddProductSheet(
    BuildContext context, WidgetRef ref, {String? initialBarcode}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _AddProductScreen(ref: ref, initialBarcode: initialBarcode),
    ),
  );
}

class _AddProductScreen extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final String? initialBarcode;
  const _AddProductScreen({required this.ref, this.initialBarcode});

  @override
  ConsumerState<_AddProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<_AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _weightCtrl = TextEditingController(text: '1');
  late final TextEditingController _barcodeCtrl;
  final _priceCtrl = TextEditingController();
  final _mrpCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '0');
  final _expiryCtrl = TextEditingController();

  int? _selectedCategoryId;
  String? _selectedUnit = 'pcs';
  bool _isPerishable = false;
  bool _isLoose = false;
  bool _saving = false;
  bool _success = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: widget.initialBarcode);
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _brandCtrl, _weightCtrl, _barcodeCtrl, _priceCtrl,
      _mrpCtrl, _stockCtrl, _expiryCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      setState(() => _error = 'Please select a category');
      return;
    }
    setState(() { 
      _saving = true; 
      _error = null; 
      _success = false;
    });

    final err = await ref.read(inventoryProvider.notifier).addProduct(
          name: _nameCtrl.text.trim(),
          categoryId: _selectedCategoryId!,
          sellingPrice: double.parse(_priceCtrl.text),
          initialStock: double.parse(_stockCtrl.text),
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
          mrp: _mrpCtrl.text.isNotEmpty
              ? double.tryParse(_mrpCtrl.text)
              : null,
          isPerishable: _isPerishable,
          isLoose: _isLoose,
          expiryDate: _isPerishable && _expiryCtrl.text.isNotEmpty
              ? _expiryCtrl.text
              : null,
        );

    if (!mounted) return;
    if (err == null) {
      setState(() {
        _saving = false;
        _success = true;
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to inventory!')),
        );
      }
    } else {
      setState(() { _saving = false; _error = err; });
    }
  }

  Future<void> _addCategory() async {
    final created = await showAddCategorySheet(context, ref);
    if (created && mounted) setState(() {});
  }

  Future<void> _scanBarcode() async {
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const BarcodeScannerOverlay(),
      ),
    );
    if (scanned != null && mounted) {
      setState(() => _barcodeCtrl.text = scanned);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryAsync = ref.watch(inventoryProvider);
    final categories = inventoryAsync.value?.categories ?? [];

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
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
                            strokeWidth: 2.5, color: BrandColors.primary),
                      )
                    : const Text('Save',
                        style: TextStyle(
                            color: BrandColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
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
              successMessage: 'Product added successfully!',
            ),
            if (_saving || _error != null || _success) const SizedBox(height: 20),

            _SectionHeader('Type & Properties'),
            const SizedBox(height: 12),
            _ToggleRow(
              label: 'Loose item',
              sublabel: 'Sold by weight (e.g. Maida, Pulse)',
              value: _isLoose,
              enabled: !_saving && !_success,
              onChanged: (v) => setState(() {
                _isLoose = v;
                if (v) {
                   _weightCtrl.text = '1';
                   if (_selectedUnit == 'pcs') _selectedUnit = 'kg';
                }
              }),
            ),
            const SizedBox(height: 24),

            _SectionHeader('Basic Details'),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameCtrl,
              enabled: !_saving && !_success,
              decoration:
                  const InputDecoration(labelText: 'Product name *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _brandCtrl,
              enabled: !_saving && !_success,
              decoration:
                  const InputDecoration(labelText: 'Brand (optional)'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedCategoryId,
                    decoration:
                        const InputDecoration(labelText: 'Category *'),
                    hint: const Text('Select category'),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(18),
                    items: categories
                        .map((c) => DropdownMenuItem<int>(
                              value:
                                  (c['category_id'] as num?)?.toInt(),
                              child: Text(c['name'] as String? ?? ''),
                            ))
                        .toList(),
                    onChanged: (_saving || _success) ? null : (v) =>
                        setState(() => _selectedCategoryId = v),
                    validator: (_) => _selectedCategoryId == null
                        ? 'Required'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: (_saving || _success) ? null : _addCategory,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: BrandColors.surfaceTint,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: BrandColors.border),
                    ),
                    child: const Icon(Icons.add_rounded,
                        color: BrandColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedUnit,
                    decoration: const InputDecoration(labelText: 'Selling Unit'),
                    hint: const Text('Unit'),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(18),
                    items: _units
                        .map((u) => DropdownMenuItem(
                            value: u, child: Text(u)))
                        .toList(),
                    onChanged: (_saving || _success) ? null : (v) =>
                        setState(() => _selectedUnit = v),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weightCtrl,
                    enabled: !_isLoose && !_saving && !_success,
                    decoration: InputDecoration(
                      labelText: _isLoose ? 'Base Unit' : 'Pack Size',
                      hintText: _isLoose ? '1' : 'e.g. 250',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!_isLoose)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeCtrl,
                      enabled: !_saving && !_success,
                      decoration: const InputDecoration(
                        labelText: 'Barcode',
                        hintText: 'optional',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: (_saving || _success) ? null : _scanBarcode,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (_saving || _success) ? BrandColors.border : BrandColors.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 24),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 28),

            _SectionHeader('Pricing'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceCtrl,
                    enabled: !_saving && !_success,
                    decoration: InputDecoration(
                        labelText: _isLoose ? 'Price per $_selectedUnit *' : 'Selling price *',
                        prefixText: '₹ '),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _mrpCtrl,
                    enabled: !_saving && !_success,
                    decoration: const InputDecoration(
                        labelText: 'MRP (optional)',
                        prefixText: '₹ '),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            _SectionHeader('Stock'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stockCtrl,
              enabled: !_saving && !_success,
              decoration: InputDecoration(
                  labelText: _isLoose ? 'Opening stock (in $_selectedUnit) *' : 'Opening stock (in packs) *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 28),

            _SectionHeader('Other Properties'),
            const SizedBox(height: 12),
            _ToggleRow(
              label: 'Perishable item',
              sublabel: 'Has an expiry date',
              value: _isPerishable,
              enabled: !_saving && !_success,
              onChanged: (v) => setState(() => _isPerishable = v),
            ),
            if (_isPerishable) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _expiryCtrl,
                enabled: !_saving && !_success,
                decoration: const InputDecoration(
                  labelText: 'Expiry date',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.event_rounded),
                ),
                readOnly: true,
                validator: (v) {
                  if (!_isPerishable) return null;
                  if (v == null || v.isEmpty) {
                    return 'Required for perishables';
                  }
                  return null;
                },
                onTap: () async {
                  if (_saving || _success) return;
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now()
                        .add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    _expiryCtrl.text =
                        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
            ],
            const SizedBox(height: 48),
            
            SizedBox(
              height: 56,
              child: LoadingButton(
                label: 'Save Product',
                isLoading: _saving,
                onPressed: _success ? null : _save,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: BrandColors.muted,
          letterSpacing: 1.2),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.sublabel,
    required this.value,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(sublabel,
                    style: const TextStyle(
                        fontSize: 12, color: BrandColors.muted, fontWeight: FontWeight.w500)),
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
}
