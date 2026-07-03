import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../models/product_variant.dart';
import '../../providers/variant_provider.dart';
import 'barcode_scanner_overlay.dart';

/// F2 — manage a product's variants (size×colour, model/storage, …). Shown only
/// for verticals whose config `has('variants')`. The implicit grocery variant is
/// never listed here.
Future<void> showVariantManagerSheet(
  BuildContext context,
  WidgetRef ref, {
  required int productId,
  required String productName,
  String? categoryName,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VariantManagerSheet(
      productId: productId,
      productName: productName,
      categoryName: categoryName,
    ),
  );
}

class _VariantManagerSheet extends ConsumerWidget {
  final int productId;
  final String productName;
  final String? categoryName;
  const _VariantManagerSheet({
    required this.productId,
    required this.productName,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // Category-scoped axes (tester #1) — pass the product's category so e.g. a
    // power bank's editor asks Capacity (mAh), not Storage.
    final axes =
        (ref.watch(attributeDefsProvider(categoryName)).asData?.value ?? [])
            .where((a) => a.isVariantAxis)
            .toList();
    final variantsAsync = ref.watch(productVariantsProvider(productId));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 12,
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
          Text(
            l10n.invManageVariants,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          Text(
            productName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: BrandColors.muted),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: variantsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: BrandColors.error),
                ),
              ),
              data: (variants) {
                final real = variants
                    .where((v) => !v.isImplicit && v.isActive)
                    .toList();
                if (real.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Text(
                      l10n.invNoVariantsYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BrandColors.muted),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: real.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) => _VariantTile(
                    productId: productId,
                    variant: real[i],
                    axes: axes,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: axes.isEmpty
                  ? null
                  : () => _openEditor(context, ref, axes, null),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.invAddVariant),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditor(
    BuildContext context,
    WidgetRef ref,
    List<AttributeDef> axes,
    ProductVariant? existing,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _VariantEditor(productId: productId, axes: axes, existing: existing),
    );
  }
}

class _VariantTile extends ConsumerWidget {
  final int productId;
  final ProductVariant variant;
  final List<AttributeDef> axes;
  const _VariantTile({
    required this.productId,
    required this.variant,
    required this.axes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        variant.label.isEmpty ? l10n.invDefaultVariant : variant.label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        '${variant.price != null ? '₹${variant.price!.toStringAsFixed(0)}' : '—'}'
        '  ·  ${l10n.invStock}: ${variant.stock.toStringAsFixed(variant.stock % 1 == 0 ? 0 : 2)}',
        style: const TextStyle(fontSize: 12, color: BrandColors.muted),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: BrandColors.muted,
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _VariantEditor(
                productId: productId,
                axes: axes,
                existing: variant,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: BrandColors.error,
            onPressed: () async {
              await ref
                  .read(variantActionsProvider)
                  .deactivate(productId, variant.variantId);
            },
          ),
        ],
      ),
    );
  }
}

class _VariantEditor extends ConsumerStatefulWidget {
  final int productId;
  final List<AttributeDef> axes;
  final ProductVariant? existing;
  const _VariantEditor({
    required this.productId,
    required this.axes,
    this.existing,
  });

  @override
  ConsumerState<_VariantEditor> createState() => _VariantEditorState();
}

class _VariantEditorState extends ConsumerState<_VariantEditor> {
  final _attrs = <String, String>{};
  final _priceCtrl = TextEditingController();
  final _mrpCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _barcodeCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _attrs.addAll(e.attributes);
      if (e.price != null) _priceCtrl.text = e.price!.toStringAsFixed(0);
      if (e.mrp != null) _mrpCtrl.text = e.mrp!.toStringAsFixed(0);
      if (e.cost != null) _costCtrl.text = e.cost!.toStringAsFixed(0);
      _stockCtrl.text = e.stock.toStringAsFixed(e.stock % 1 == 0 ? 0 : 2);
      _barcodeCtrl.text = e.barcode ?? '';
    }
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _mrpCtrl.dispose();
    _costCtrl.dispose();
    _stockCtrl.dispose();
    _barcodeCtrl.dispose();
    super.dispose();
  }

  double? _parse(TextEditingController c) =>
      c.text.trim().isEmpty ? null : double.tryParse(c.text.trim());

  /// Scan a barcode/IMEI into the new variant's barcode field.
  Future<void> _scanBarcode() async {
    final scanned = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (scanned == null || !mounted) return;
    setState(() => _barcodeCtrl.text = scanned.trim());
  }

  Future<void> _save() async {
    // On create, every axis must have a value so the variant is identifiable.
    if (!_isEdit) {
      for (final a in widget.axes) {
        if ((_attrs[a.attrCode] ?? '').trim().isEmpty) {
          setState(
            () => _error = AppLocalizations.of(
              context,
            ).invVariantAxisRequired(a.label),
          );
          return;
        }
      }
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final actions = ref.read(variantActionsProvider);
      if (_isEdit) {
        await actions.update(
          widget.productId,
          widget.existing!.variantId,
          price: _parse(_priceCtrl),
          mrp: _parse(_mrpCtrl),
          cost: _parse(_costCtrl),
          stock: _parse(_stockCtrl),
        );
      } else {
        await actions.create(
          widget.productId,
          attributes: _attrs,
          barcode: _barcodeCtrl.text.trim(),
          price: _parse(_priceCtrl),
          mrp: _parse(_mrpCtrl),
          cost: _parse(_costCtrl),
          stock: _parse(_stockCtrl),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEdit ? l10n.invEditVariant : l10n.invAddVariant,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          // Variant axes — read-only when editing (identity must not change).
          for (final a in widget.axes) ...[
            _axisField(a),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(child: _numField(_priceCtrl, l10n.invPrice)),
              const SizedBox(width: 12),
              Expanded(child: _numField(_mrpCtrl, l10n.invMrp)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _numField(_costCtrl, l10n.invCostPrice)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _stockCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(labelText: l10n.invStock),
                ),
              ),
            ],
          ),
          if (!_isEdit) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeCtrl,
                    decoration: InputDecoration(labelText: l10n.invBarcode),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: l10n.invBarcode,
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: BrandColors.primary,
                  ),
                  onPressed: _scanBarcode,
                ),
              ],
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: BrandColors.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.invSaveVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _axisField(AttributeDef a) {
    if (_isEdit) {
      // Identity is fixed once created; show it read-only.
      return InputDecorator(
        decoration: InputDecoration(labelText: a.label),
        child: Text(_attrs[a.attrCode] ?? '—'),
      );
    }
    if (a.isEnum) {
      return DropdownButtonFormField<String>(
        initialValue: _attrs[a.attrCode],
        isExpanded: true,
        decoration: InputDecoration(labelText: a.label),
        items: a.options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) => setState(() => _attrs[a.attrCode] = v ?? ''),
      );
    }
    return TextField(
      decoration: InputDecoration(labelText: a.label),
      onChanged: (v) => _attrs[a.attrCode] = v.trim(),
    );
  }

  Widget _numField(TextEditingController c, String label) => TextField(
    controller: c,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    ],
    decoration: InputDecoration(labelText: label, prefixText: '₹ '),
  );
}
