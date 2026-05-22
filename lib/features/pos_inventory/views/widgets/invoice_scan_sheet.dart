import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/providers/usage_limits_provider.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/gemini_invoice_service.dart';
import '../../../../core/services/usage_limits_service.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../subscription/models/subscription_model.dart';
import '../../../subscription/providers/subscription_provider.dart';
import '../../../subscription/views/credits_purchase_sheet.dart';
import '../../models/invoice_extraction.dart';
import '../../models/procurement_models.dart';
import '../../models/pos_product.dart';
import '../../providers/pos_provider.dart';
import '../../providers/procurement_provider.dart';
import 'ai_gate_widgets.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

Future<void> showInvoiceScanSheet(
    BuildContext context, WidgetRef ref, List<Supplier> suppliers) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => _InvoiceScanSheet(suppliers: suppliers),
  );
}

// ── State ─────────────────────────────────────────────────────────────────────

enum _ScanState { idle, processing, review, creating, done, error }

// ── Matched item ──────────────────────────────────────────────────────────────

class _MappedItem {
  final InvoiceLineItem invoice;
  PosProduct? product;
  _MappedItem({required this.invoice, this.product});
  bool get matched => product != null;
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

class _InvoiceScanSheet extends ConsumerStatefulWidget {
  final List<Supplier> suppliers;
  const _InvoiceScanSheet({required this.suppliers});

  @override
  ConsumerState<_InvoiceScanSheet> createState() => _InvoiceScanSheetState();
}

class _InvoiceScanSheetState extends ConsumerState<_InvoiceScanSheet> {
  late final GeminiInvoiceService _svc;
  _ScanState _state = _ScanState.idle;

  @override
  void initState() {
    super.initState();
    _svc = GeminiInvoiceService(ref.read(apiClientProvider));
  }

  InvoiceExtraction? _extraction;
  List<_MappedItem> _items = [];
  Supplier? _selectedSupplier;
  String _errorMsg = '';

  // ── Pick & process ────────────────────────────────────────────────────────

  Future<void> _pickCamera() async {
    final xf = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 90);
    if (xf == null || !mounted) return;
    await _process(await xf.readAsBytes(), 'image/jpeg');
  }

  Future<void> _pickGallery() async {
    final xf = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (xf == null || !mounted) return;
    final mime = xf.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
    await _process(await xf.readAsBytes(), mime);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (result == null || result.files.isEmpty || !mounted) return;
    final f = result.files.first;
    final bytes = f.bytes;
    if (bytes == null) return;
    final ext = (f.extension ?? 'jpg').toLowerCase();
    final mime = ext == 'pdf'
        ? 'application/pdf'
        : ext == 'png'
            ? 'image/png'
            : 'image/jpeg';
    await _process(bytes, mime);
  }

  Future<void> _process(Uint8List bytes, String mime) async {
    setState(() { _state = _ScanState.processing; _errorMsg = ''; });
    try {
      final result = await _svc.extractInvoice(bytes, mime);
      final extraction = result.extraction;
      final posProducts = ref.read(posProvider).products;

      final mapped = extraction.items.map((item) {
        final product = _matchProduct(item.name ?? '', posProducts);
        return _MappedItem(invoice: item, product: product);
      }).toList();

      // Auto-match supplier by vendor name
      final vendorName = extraction.vendor.name ?? '';
      Supplier? matched;
      if (vendorName.isNotEmpty) {
        matched = _matchSupplier(vendorName, widget.suppliers);
      }

      // Server already recorded the use; apply inline status update instantly
      if (result.aiStatus != null) {
        ref.read(usageLimitsProvider.notifier).applyInlineUpdate(kFeatureInvoice, result.aiStatus!);
      }

      setState(() {
        _extraction = extraction;
        _items = mapped;
        _selectedSupplier = matched;
        _state = _ScanState.review;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
        _state = _ScanState.error;
      });
    }
  }

  // ── Matching helpers ──────────────────────────────────────────────────────

  PosProduct? _matchProduct(String name, List<PosProduct> products) {
    final base = name.trim().toLowerCase();
    if (base.isEmpty) return null;
    for (final p in products) {
      if (p.name.toLowerCase() == base) return p;
    }
    for (final p in products) {
      final pn = p.name.toLowerCase();
      if (pn.contains(base) || (base.contains(pn) && pn.length > 3)) return p;
    }
    final words = base.split(RegExp(r'\s+')).where((w) => w.length >= 4).toList();
    for (final word in words) {
      for (final p in products) {
        if (p.name.toLowerCase().contains(word)) return p;
      }
    }
    return null;
  }

  Supplier? _matchSupplier(String vendorName, List<Supplier> suppliers) {
    final v = vendorName.toLowerCase();
    for (final s in suppliers) {
      if (s.name.toLowerCase() == v) return s;
    }
    for (final s in suppliers) {
      if (s.name.toLowerCase().contains(v) || v.contains(s.name.toLowerCase())) return s;
    }
    final words = v.split(RegExp(r'\s+')).where((w) => w.length >= 4).toList();
    for (final word in words) {
      for (final s in suppliers) {
        if (s.name.toLowerCase().contains(word)) return s;
      }
    }
    return null;
  }

  void _linkProduct(int index, PosProduct p) {
    setState(() => _items[index].product = p);
  }

  Future<void> _showProductPicker(int index) async {
    final products = ref.read(posProvider).products;
    final query = _items[index].invoice.name ?? '';
    final picked = await showModalBottomSheet<PosProduct>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductPickerSheet(products: products, initialQuery: query),
    );
    if (picked != null && mounted) _linkProduct(index, picked);
  }

  // ── Create Purchase Order ─────────────────────────────────────────────────

  Future<void> _createPO() async {
    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a supplier first')),
      );
      return;
    }
    setState(() => _state = _ScanState.creating);

    try {
      final matchedItems = _items.where((m) => m.matched && m.invoice.quantity != null).map((m) => {
        'product_id': m.product!.productId,
        'quantity': m.invoice.quantity!,
        'cost_price': m.invoice.effectiveCostPrice,
      }).toList();

      final grand = _extraction?.totals.grandTotal;
      final inv = _extraction?.details;

      await ref.read(procurementProvider.notifier).createPurchaseOrder(
        supplierId: _selectedSupplier!.supplierId,
        items: matchedItems,
        notes: [
          if (inv?.number != null) 'Invoice: ${inv!.number}',
          if (inv?.date != null) 'Date: ${inv!.date}',
        ].join(' · ').isEmpty ? 'From scanned invoice' : [
          if (inv?.number != null) 'Invoice: ${inv!.number}',
          if (inv?.date != null) 'Date: ${inv!.date}',
        ].join(' · '),
        totalAmountOverride: grand,
      );

      if (mounted) setState(() => _state = _ScanState.done);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);

      final unmatched = _items.where((m) => !m.matched).length;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          unmatched > 0
              ? 'Purchase order created! ($unmatched item${unmatched > 1 ? 's' : ''} not matched)'
              : 'Purchase order created from invoice!',
        ),
        backgroundColor: BrandColors.success,
        duration: const Duration(seconds: 3),
      ));
    } catch (e) {
      setState(() {
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
        _state = _ScanState.error;
      });
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // ── Pro + usage gating ───────────────────────────────────────────────────
    final subInfo = ref.watch(subInfoProvider);
    final isPro = subInfo.effectiveTier == SubTier.pro;
    final limitsAsync = ref.watch(usageLimitsProvider);
    final remaining = limitsAsync.value?.invoiceRemaining ?? kDailyLimits[kFeatureInvoice]!;
    final canUse = isPro && remaining > 0;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: BrandColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.document_scanner_rounded, color: BrandColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scan Invoice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: BrandColors.ink)),
                        Text('Camera · Gallery · PDF', style: TextStyle(fontSize: 12, color: BrandColors.muted)),
                      ],
                    ),
                  ),
                  if (isPro) AiUsageBadge(remaining: remaining, total: kDailyLimits[kFeatureInvoice]!, label: 'scans'),
                  if (_state == _ScanState.review) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: BrandColors.muted),
                      tooltip: 'Scan again',
                      onPressed: () => setState(() { _state = _ScanState.idle; _extraction = null; _items = []; }),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Gate banners
            if (!isPro)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiGateBanner(
                  icon: Icons.workspace_premium_rounded,
                  color: BrandColors.orange,
                  message: 'Invoice Scan is a Pro feature.',
                  actionLabel: 'Upgrade to Pro',
                  onAction: () => Navigator.pop(context),
                ),
              )
            else if (remaining == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiGateBanner(
                  icon: Icons.bolt_rounded,
                  color: BrandColors.error,
                  message: 'Daily limit reached. Top up credits to continue.',
                  actionLabel: 'Buy Credits',
                  onAction: () => showCreditsPurchaseSheet(context, ref, highlightFeature: kFeatureInvoice),
                ),
              ),
            if (!canUse) const SizedBox(height: 4),

            const Divider(height: 1),

            Expanded(
              child: _buildBody(canUse: canUse),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({required bool canUse}) {
    switch (_state) {
      case _ScanState.idle:
        return _buildIdleState(canUse: canUse);
      case _ScanState.processing:
        return _buildProcessing();
      case _ScanState.review:
        return _buildReview();
      case _ScanState.creating:
        return const Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Creating purchase order…', style: TextStyle(color: BrandColors.muted, fontSize: 13)),
          ],
        ));
      case _ScanState.done:
        return const Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, color: BrandColors.success, size: 56),
            SizedBox(height: 12),
            Text('Purchase order created!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: BrandColors.success)),
          ],
        ));
      case _ScanState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: BrandColors.error, size: 48),
                const SizedBox(height: 12),
                Text(_errorMsg, textAlign: TextAlign.center, style: const TextStyle(color: BrandColors.error, fontSize: 13)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _state = _ScanState.idle),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildIdleState({required bool canUse}) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: BrandColors.surfaceTint,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BrandColors.border),
            ),
            child: Column(
              children: [
                Icon(Icons.receipt_long_rounded, size: 56,
                    color: (canUse ? BrandColors.primary : BrandColors.muted).withValues(alpha: 0.6)),
                const SizedBox(height: 12),
                Text(
                  canUse ? 'Capture or upload a supplier invoice' : 'Upgrade to Pro or top up credits',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: BrandColors.muted, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                const Text('Kirana AI reads items, totals & supplier details', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: BrandColors.muted)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _PickButton(icon: Icons.camera_alt_rounded, label: 'Camera', color: BrandColors.primary, onTap: canUse ? _pickCamera : null)),
              const SizedBox(width: 12),
              Expanded(child: _PickButton(icon: Icons.photo_library_rounded, label: 'Gallery', color: const Color(0xFF7C3AED), onTap: canUse ? _pickGallery : null)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _PickButton(icon: Icons.picture_as_pdf_rounded, label: 'Upload PDF / Image File', color: BrandColors.muted, onTap: canUse ? _pickFile : null),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Kirana AI is reading your invoice…', style: TextStyle(fontSize: 14, color: BrandColors.ink, fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text('Extracting items, quantities and totals', style: TextStyle(fontSize: 12, color: BrandColors.muted)),
        ],
      ),
    );
  }

  Widget _buildReview() {
    final ext = _extraction!;
    final grand = ext.totals.grandTotal;
    final confidence = ext.confidenceScore;
    final matched = _items.where((m) => m.matched).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confidence + validation row
          Row(
            children: [
              if (confidence != null) ...[
                _ConfidenceBadge(score: confidence),
                const SizedBox(width: 10),
              ],
              _StatusBadge(status: ext.validationStatus),
            ],
          ),
          const SizedBox(height: 16),

          // Vendor + Invoice info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BrandColors.surfaceTint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BrandColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ext.vendor.name != null)
                  Text(ext.vendor.name!, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                if (ext.vendor.gstin != null)
                  Text('GSTIN: ${ext.vendor.gstin}', style: const TextStyle(fontSize: 11, color: BrandColors.muted)),
                if (ext.details.number != null || ext.details.date != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    [if (ext.details.number != null) '# ${ext.details.number}', if (ext.details.date != null) ext.details.date!].join('  ·  '),
                    style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                  ),
                ],
                if (grand != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('₹${grand.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: BrandColors.primary)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Supplier picker
          const Text('SUPPLIER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: BrandColors.muted, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          _SupplierPicker(
            suppliers: widget.suppliers,
            selected: _selectedSupplier,
            vendorName: ext.vendor.name,
            onChanged: (s) => setState(() => _selectedSupplier = s),
          ),
          const SizedBox(height: 16),

          // Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ITEMS (${_items.length})', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: BrandColors.muted, letterSpacing: 1.2)),
              Text('$matched matched', style: TextStyle(fontSize: 11, color: matched > 0 ? BrandColors.success : BrandColors.muted, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),

          for (int i = 0; i < _items.length; i++) ...[
            _InvoiceItemTile(
              item: _items[i],
              onPick: () => _showProductPicker(i),
            ),
            const SizedBox(height: 6),
          ],

          if (_items.where((m) => !m.matched).isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    '${_items.where((m) => !m.matched).length} unmatched item${_items.where((m) => !m.matched).length > 1 ? 's' : ''} will not be added as line items, but the full invoice total will be recorded.',
                    style: const TextStyle(fontSize: 11, color: Colors.orange),
                  )),
                ],
              ),
            ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _selectedSupplier == null ? null : _createPO,
              icon: const Icon(Icons.add_task_rounded),
              label: Text(
                _selectedSupplier == null
                    ? 'Select a supplier to continue'
                    : 'Create Purchase Order${grand != null ? ' · ₹${grand.toStringAsFixed(0)}' : ''}',
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _PickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _PickButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final effectiveColor = disabled ? BrandColors.muted : color;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: effectiveColor.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              Icon(icon, color: effectiveColor, size: 28),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(color: effectiveColor, fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final double score;
  const _ConfidenceBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).round();
    final color = score >= 0.85 ? BrandColors.success : score >= 0.65 ? Colors.orange : BrandColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 13, color: color),
          const SizedBox(width: 4),
          Text('$pct% confidence', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'valid' ? BrandColors.success : status == 'mismatch' ? BrandColors.error : BrandColors.muted;
    final label = status == 'valid' ? '✓ Totals match' : status == 'mismatch' ? '⚠ Total mismatch' : 'Unverified';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _InvoiceItemTile extends StatelessWidget {
  final _MappedItem item;
  final VoidCallback onPick;
  const _InvoiceItemTile({required this.item, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final color = item.matched ? BrandColors.success : BrandColors.muted;
    final inv = item.invoice;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.matched ? BrandColors.success.withValues(alpha: 0.3) : BrandColors.border),
      ),
      child: Row(
        children: [
          Icon(item.matched ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.matched ? item.product!.displayName : (inv.name ?? ''),
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: item.matched ? BrandColors.ink : BrandColors.muted),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                if (!item.matched && inv.name != null)
                  Text('"${inv.name}"', style: const TextStyle(fontSize: 10, color: BrandColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (inv.quantity != null)
            Text('${inv.quantity!.toStringAsFixed(inv.quantity! == inv.quantity!.roundToDouble() ? 0 : 1)} ${inv.unit ?? ''}',
                style: const TextStyle(fontSize: 11, color: BrandColors.muted)),
          const SizedBox(width: 8),
          if (inv.finalAmount != null)
            Text('₹${inv.finalAmount!.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          if (!item.matched) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onPick,
              style: TextButton.styleFrom(
                foregroundColor: BrandColors.primary,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text('Pick', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Supplier picker ───────────────────────────────────────────────────────────

class _SupplierPicker extends StatelessWidget {
  final List<Supplier> suppliers;
  final Supplier? selected;
  final String? vendorName;
  final ValueChanged<Supplier?> onChanged;

  const _SupplierPicker({
    required this.suppliers,
    required this.selected,
    required this.onChanged,
    this.vendorName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected != null ? BrandColors.primary.withValues(alpha: 0.05) : BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected != null ? BrandColors.primary.withValues(alpha: 0.3) : BrandColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.business_rounded, size: 18,
                color: selected != null ? BrandColors.primary : BrandColors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: selected != null
                  ? Text(selected!.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: BrandColors.ink))
                  : Text(
                      vendorName != null ? 'No match for "$vendorName" — tap to select' : 'Select supplier',
                      style: const TextStyle(fontSize: 13, color: BrandColors.muted),
                    ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: BrandColors.muted, size: 20),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SupplierPickerSheet(
        suppliers: suppliers,
        selected: selected,
        onSelect: (s) {
          Navigator.pop(context);
          onChanged(s);
        },
      ),
    );
  }
}

class _SupplierPickerSheet extends StatelessWidget {
  final List<Supplier> suppliers;
  final Supplier? selected;
  final ValueChanged<Supplier> onSelect;

  const _SupplierPickerSheet({
    required this.suppliers,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Select Supplier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: suppliers.isEmpty
                  ? const Center(child: Text('No suppliers yet. Add suppliers in the Purchase tab.', textAlign: TextAlign.center, style: TextStyle(color: BrandColors.muted)))
                  : ListView.builder(
                      controller: ctrl,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: suppliers.length,
                      itemBuilder: (_, i) {
                        final s = suppliers[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          leading: CircleAvatar(
                            backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.business_rounded, color: BrandColors.primary, size: 18),
                          ),
                          title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: s.phone != null ? Text(s.phone!) : null,
                          trailing: selected?.supplierId == s.supplierId
                              ? const Icon(Icons.check_circle_rounded, color: BrandColors.primary)
                              : null,
                          onTap: () => onSelect(s),
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

// ── Product picker (reused from voice/handwriting) ────────────────────────────

class _ProductPickerSheet extends StatefulWidget {
  final List<PosProduct> products;
  final String initialQuery;
  const _ProductPickerSheet({required this.products, required this.initialQuery});

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  late final TextEditingController _ctrl;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _ctrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return p.name.toLowerCase().contains(q) || (p.brand?.toLowerCase().contains(q) ?? false);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: BrandColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Link to Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search products…',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: BrandColors.muted),
                      filled: true, fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No products found', style: TextStyle(color: BrandColors.muted)))
                  : ListView.builder(
                      controller: ctrl,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          title: Text(p.displayName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          subtitle: Text('${p.priceLabel} · Stock: ${p.stockLabel}', style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
                          trailing: const Icon(Icons.link_rounded, color: BrandColors.primary),
                          onTap: () => Navigator.pop(context, p),
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
