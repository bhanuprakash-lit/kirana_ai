import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../models/pos_product.dart';
import '../../providers/pos_provider.dart';

// ── Data model for a scan-session item ───────────────────────────────────────

class ScanSessionItem {
  final PosProduct product;
  int qty;
  ScanSessionItem(this.product, {this.qty = 1});
}

// ── Public entry point ────────────────────────────────────────────────────────

/// Opens the continuous scanner sheet. Returns the list of items the user
/// confirmed, or null if they dismissed without adding.
Future<List<ScanSessionItem>?> showContinuousScannerSheet(
  BuildContext context,
  WidgetRef ref, {
  void Function(String barcode)? onUnknownBarcode,
}) {
  return Navigator.push<List<ScanSessionItem>>(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _ContinuousScannerSheet(ref: ref, onUnknownBarcode: onUnknownBarcode),
    ),
  );
}

// ── Sheet widget ──────────────────────────────────────────────────────────────

class _ContinuousScannerSheet extends StatefulWidget {
  final WidgetRef ref;
  final void Function(String barcode)? onUnknownBarcode;
  const _ContinuousScannerSheet({required this.ref, this.onUnknownBarcode});

  @override
  State<_ContinuousScannerSheet> createState() => _ContinuousScannerSheetState();
}

class _ContinuousScannerSheetState extends State<_ContinuousScannerSheet> {
  final MobileScannerController _scannerCtrl = MobileScannerController();
  final List<ScanSessionItem> _items = [];
  // Per-barcode cooldown: ignore re-scans within this window
  final Map<String, DateTime> _lastScan = {};
  static const _cooldown = Duration(seconds: 2);

  // Transient UI feedback
  String? _flashMessage;
  bool _flashError = false;

  @override
  void dispose() {
    _scannerCtrl.dispose();
    super.dispose();
  }

  static bool _isProductBarcode(String value, BarcodeFormat? format) {
    if (value.isEmpty) return false;
    if (format == BarcodeFormat.qrCode) return false;
    if (format == BarcodeFormat.aztec ||
        format == BarcodeFormat.dataMatrix ||
        format == BarcodeFormat.pdf417) { return false; }
    if (value.contains('://')) return false;
    if (value.startsWith('KIRANA_REF:')) return false;
    return true;
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;
    if (raw == null || !_isProductBarcode(raw, barcode?.format)) return;

    final now = DateTime.now();
    final last = _lastScan[raw];
    if (last != null && now.difference(last) < _cooldown) {
      // Within cooldown — show brief "already added" hint only if it's in the list
      final existing = _items.indexWhere((i) => i.product.barcode == raw);
      if (existing >= 0) { _showFlash('${_items[existing].product.name} already in list', error: false); }
      return;
    }
    _lastScan[raw] = now;
    _processBarcode(raw);
  }

  void _processBarcode(String barcode) {
    HapticFeedback.lightImpact();

    // 1. Already in session list → increment qty
    final idx = _items.indexWhere((i) => i.product.barcode == barcode);
    if (idx >= 0) {
      setState(() => _items[idx].qty++);
      _showFlash('${_items[idx].product.name} ×${_items[idx].qty}');
      return;
    }

    // 2. Local cache hit (POS products already loaded) → instant add
    final notifier = widget.ref.read(posProvider.notifier);
    final local = notifier.lookupBarcodeLocal(barcode);
    if (local != null) {
      setState(() => _items.insert(0, ScanSessionItem(local)));
      _showFlash('${local.name} added');
      return;
    }

    // 3. Network fallback — add a placeholder while fetching
    final placeholder = ScanSessionItem(
      PosProduct(productId: -1, name: 'Looking up…', price: 0, stockQuantity: 0,
          barcode: barcode, isPerishable: false, isLoose: false, categoryId: 0),
    );
    setState(() => _items.insert(0, placeholder));

    notifier.lookupBarcode(barcode).then((product) {
      if (!mounted) return;
      final pi = _items.indexWhere((i) => i.product.barcode == barcode && i.product.productId == -1);
      if (product != null) {
        setState(() => _items[pi] = ScanSessionItem(product));
        _showFlash('${product.name} added');
      } else {
        setState(() => _items.removeAt(pi));
        _showFlash('Not found — tap to add manually', error: true);
        widget.onUnknownBarcode?.call(barcode);
      }
    }).catchError((_) {
      if (!mounted) return;
      final pi = _items.indexWhere((i) => i.product.barcode == barcode && i.product.productId == -1);
      if (pi >= 0) setState(() => _items.removeAt(pi));
    });
  }

  void _showFlash(String msg, {bool error = false}) {
    setState(() { _flashMessage = msg; _flashError = error; });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _flashMessage = null);
    });
  }

  void _removeItem(int idx) => setState(() => _items.removeAt(idx));
  void _changeQty(int idx, int delta) {
    setState(() {
      _items[idx].qty = (_items[idx].qty + delta).clamp(1, 99);
    });
  }

  void _confirmAndPop() {
    final valid = _items.where((i) => i.product.productId != -1).toList();
    if (valid.isEmpty) return;
    Navigator.pop(context, valid);
  }

  @override
  Widget build(BuildContext context) {
    final total = _items.fold<double>(0, (s, i) => s + i.product.price * i.qty);
    final hasItems = _items.isNotEmpty;
    final pendingCount = _items.where((i) => i.product.productId == -1).length;
    final validCount   = _items.where((i) => i.product.productId != -1).length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            _Header(
              itemCount: validCount,
              onClose: () => Navigator.pop(context, null),
              onClear: hasItems ? () => setState(() { _items.clear(); _lastScan.clear(); }) : null,
            ),

            // ── Scanner — top 40% ────────────────────────────────────────
            Expanded(
              flex: 40,
              child: _ScannerView(
                controller: _scannerCtrl,
                onDetect: _onDetect,
                flashMessage: _flashMessage,
                flashError: _flashError,
              ),
            ),

            // ── Divider ─────────────────────────────────────────────────
            Container(height: 1, color: Colors.white12),

            // ── Scanned items — bottom 60% ───────────────────────────────
            Expanded(
              flex: 60,
              child: Container(
                color: BrandColors.background,
                child: Column(
                  children: [
                    // Items list
                    Expanded(
                      child: hasItems
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _items.length,
                              itemBuilder: (_, i) => _ItemRow(
                                item: _items[i],
                                onRemove: () => _removeItem(i),
                                onQtyChange: (d) => _changeQty(i, d),
                              ),
                            )
                          : const _EmptyState(),
                    ),

                    // ── Add to Cart button ───────────────────────────────
                    if (hasItems)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: pendingCount > 0 ? null : _confirmAndPop,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: BrandColors.primary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: BrandColors.muted,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: pendingCount > 0
                                ? Text('Looking up $pendingCount item${pendingCount > 1 ? 's' : ''}…')
                                : Text(
                                    'Add $validCount item${validCount > 1 ? 's' : ''} to Cart  ·  ₹${total.toStringAsFixed(0)}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int itemCount;
  final VoidCallback onClose;
  final VoidCallback? onClear;
  const _Header({required this.itemCount, required this.onClose, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              itemCount > 0 ? '$itemCount item${itemCount > 1 ? 's' : ''} scanned' : 'Scan items',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          if (onClear != null)
            TextButton(
              onPressed: onClear,
              child: const Text('Clear all', style: TextStyle(color: Colors.white54, fontSize: 13)),
            ),
        ],
      ),
    );
  }
}

class _ScannerView extends StatelessWidget {
  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;
  final String? flashMessage;
  final bool flashError;
  const _ScannerView({required this.controller, required this.onDetect, this.flashMessage, this.flashError = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(controller: controller, onDetect: onDetect),

        // Reticle
        Center(
          child: Container(
            width: 260, height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: BrandColors.accent, width: 2.5),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Flash feedback
        if (flashMessage != null)
          Positioned(
            bottom: 12,
            left: 24,
            right: 24,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: flashError ? Colors.red.shade800 : Colors.green.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  flashMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final ScanSessionItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQtyChange;
  const _ItemRow({required this.item, required this.onRemove, required this.onQtyChange});

  @override
  Widget build(BuildContext context) {
    final isPending = item.product.productId == -1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  if (isPending) ...[
                    const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5)),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      item.product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isPending ? BrandColors.muted : BrandColors.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]),
                if (!isPending)
                  Text(
                    '₹${item.product.price.toStringAsFixed(0)} × ${item.qty}  =  ₹${(item.product.price * item.qty).toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                  ),
              ],
            ),
          ),

          // Qty stepper
          if (!isPending) ...[
            _QtyButton(icon: Icons.remove, onTap: item.qty > 1 ? () => onQtyChange(-1) : null),
            SizedBox(
              width: 28,
              child: Text('${item.qty}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            _QtyButton(icon: Icons.add, onTap: () => onQtyChange(1)),
            const SizedBox(width: 4),
          ],

          // Remove
          GestureDetector(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close_rounded, size: 18, color: BrandColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: onTap != null ? BrandColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: onTap != null ? BrandColors.primary : BrandColors.muted),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_scanner_rounded, size: 40, color: BrandColors.muted),
          SizedBox(height: 10),
          Text('Point camera at a barcode', style: TextStyle(color: BrandColors.muted, fontSize: 14)),
          SizedBox(height: 4),
          Text('Items appear here as you scan', style: TextStyle(color: BrandColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
