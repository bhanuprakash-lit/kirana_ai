import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/gemini_item.dart';
import '../../../../core/services/gemini_vision_service.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../models/pos_product.dart';
import '../../providers/pos_provider.dart';

// ── Public entry point ────────────────────────────────────────────────────────

Future<void> showHandwritingOrderSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HandwritingOrderSheet(ref: ref),
  );
}

// ── Matched item (same as voice sheet) ───────────────────────────────────────

class _MatchedItem {
  final GeminiItem gemini;
  final PosProduct? product;

  const _MatchedItem({required this.gemini, this.product});
  bool get found => product != null;
  bool get inStock => product != null && product!.stockQuantity > 0;
}

// ── State ─────────────────────────────────────────────────────────────────────

enum _DetectState { idle, processing, done, error }

// ── Sheet ─────────────────────────────────────────────────────────────────────

class _HandwritingOrderSheet extends StatefulWidget {
  final WidgetRef ref;
  const _HandwritingOrderSheet({required this.ref});

  @override
  State<_HandwritingOrderSheet> createState() => _HandwritingOrderSheetState();
}

class _HandwritingOrderSheetState extends State<_HandwritingOrderSheet> {
  final _visionSvc = GeminiVisionService();
  final _repaintKey = GlobalKey();

  final _strokes = <List<Offset>>[];
  List<Offset> _current = [];

  _DetectState _detectState = _DetectState.idle;
  String _transcript = '';
  List<_MatchedItem> _matches = [];
  String _errorMsg = '';
  bool _hasDrawn = false;

  // Auto-detect timer (fires 2s after user stops drawing, first time only)
  Timer? _autoDetectTimer;
  bool _autoDetectFired = false;

  // ── Drawing ───────────────────────────────────────────────────────────────

  void _onPanStart(DragStartDetails d) {
    setState(() {
      _current = [d.localPosition];
      _hasDrawn = true;
    });
    _scheduleAutoDetect();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _current.add(d.localPosition));
    _scheduleAutoDetect();
  }

  void _onPanEnd(DragEndDetails _) {
    setState(() {
      if (_current.isNotEmpty) _strokes.add(List.from(_current));
      _current = [];
    });
  }

  void _scheduleAutoDetect() {
    if (_autoDetectFired) return;
    _autoDetectTimer?.cancel();
    _autoDetectTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && _hasDrawn && !_autoDetectFired) {
        _autoDetectFired = true;
        _detect();
      }
    });
  }

  void _clear() {
    _autoDetectTimer?.cancel();
    _autoDetectFired = false;
    setState(() {
      _strokes.clear();
      _current = [];
      _hasDrawn = false;
      _detectState = _DetectState.idle;
      _transcript = '';
      _matches = [];
      _errorMsg = '';
    });
  }

  // ── Detect ────────────────────────────────────────────────────────────────

  Future<void> _detect() async {
    if (_strokes.isEmpty && _current.isEmpty) return;
    setState(() => _detectState = _DetectState.processing);

    try {
      final boundary =
          _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Canvas not ready');

      final image = await boundary.toImage(pixelRatio: 2.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = data?.buffer.asUint8List();
      if (pngBytes == null) throw Exception('Failed to capture canvas');

      final result = await _visionSvc.processHandwriting(pngBytes);
      final products = widget.ref.read(posProvider).products;

      setState(() {
        _transcript = result.transcript;
        _matches = result.items.map((item) {
          final product = _matchProduct(item, products);
          return _MatchedItem(gemini: item, product: product);
        }).toList();
        _detectState = _DetectState.done;
      });
    } catch (e) {
      setState(() {
        _detectState = _DetectState.error;
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  PosProduct? _matchProduct(GeminiItem item, List<PosProduct> products) {
    final base = item.baseName;
    for (final p in products) {
      if (p.name.toLowerCase() == base) return p;
    }
    for (final p in products) {
      if (p.name.toLowerCase().contains(base)) return p;
    }
    for (final p in products) {
      final pn = p.name.toLowerCase();
      if (pn.length > 2 && base.contains(pn)) return p;
    }
    return null;
  }

  // ── Add to cart ───────────────────────────────────────────────────────────

  void _addToCart() {
    final notifier = widget.ref.read(posProvider.notifier);
    int added = 0;
    for (final m in _matches) {
      if (!m.inStock) continue;
      notifier.addToCart(m.product!, qty: m.gemini.parsedQty);
      added++;
    }
    if (mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$added item${added != 1 ? 's' : ''} added to cart from handwriting'),
      backgroundColor: BrandColors.success,
      duration: const Duration(milliseconds: 1800),
    ));
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _autoDetectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matched = _matches.where((m) => m.inStock).length;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.96,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 14),

            // Title + clear
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.draw_rounded, color: Color(0xFF7C3AED), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Handwrite Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: BrandColors.ink)),
                        Text('Write items in any script', style: TextStyle(fontSize: 12, color: BrandColors.muted)),
                      ],
                    ),
                  ),
                  if (_hasDrawn)
                    TextButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.clear_rounded, size: 16),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: BrandColors.muted,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Language banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ScriptBanner(),
            ),
            const SizedBox(height: 12),

            // Canvas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasDrawn ? const Color(0xFF7C3AED).withValues(alpha: 0.4) : BrandColors.border,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      RepaintBoundary(
                        key: _repaintKey,
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: CustomPaint(
                            painter: _StrokePainter(strokes: _strokes, current: _current),
                            size: const Size(double.infinity, 220),
                          ),
                        ),
                      ),
                      if (!_hasDrawn)
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.gesture_rounded, size: 32, color: BrandColors.border),
                              SizedBox(height: 8),
                              Text('Write items here', style: TextStyle(fontSize: 13, color: BrandColors.muted, fontWeight: FontWeight.w500)),
                              Text('e.g. Rice 5kg, Sugar 2kg', style: TextStyle(fontSize: 11, color: BrandColors.border)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Detect button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: (_detectState == _DetectState.processing || !_hasDrawn) ? null : _detect,
                  icon: _detectState == _DetectState.processing
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: Text(
                    _detectState == _DetectState.processing ? 'Detecting…' : 'Detect Items',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Results
            Expanded(
              child: SingleChildScrollView(
                controller: scrollCtrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_detectState == _DetectState.error) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BrandColors.error.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: BrandColors.error, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_errorMsg, style: const TextStyle(color: BrandColors.error, fontSize: 12))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (_detectState == _DetectState.done) ...[
                      // Transcript
                      if (_transcript.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: BrandColors.surfaceTint,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: BrandColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Read', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: BrandColors.muted, letterSpacing: 1)),
                              const SizedBox(height: 4),
                              Text(_transcript, style: const TextStyle(fontSize: 12, color: BrandColors.ink, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Items
                      if (_matches.isEmpty)
                        const Text('No items detected. Try writing more clearly.', style: TextStyle(color: BrandColors.muted, fontSize: 13))
                      else
                        Column(
                          children: [
                            for (final m in _matches) ...[
                              _MatchTile(match: m),
                              const Divider(height: 1),
                            ],
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Action row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _clear,
                              icon: const Icon(Icons.draw_rounded, size: 16),
                              label: const Text('Write Again'),
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: matched > 0 ? _addToCart : null,
                              icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                              label: Text('Add $matched to Cart'),
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                            ),
                          ),
                        ],
                      ),
                    ],
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

// ── Canvas painter ────────────────────────────────────────────────────────────

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> current;

  const _StrokePainter({required this.strokes, required this.current});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    final paint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    _drawStroke(canvas, current, paint);
  }

  void _drawStroke(Canvas canvas, List<Offset> pts, Paint p) {
    if (pts.length < 2) return;
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_StrokePainter old) => true;
}

// ── Script language banner ────────────────────────────────────────────────────

class _ScriptBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withValues(alpha: 0.07),
            BrandColors.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.translate_rounded, size: 13, color: Color(0xFF7C3AED)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Any script: English · తెలుగు · हिंदी · Tamil · ಕನ್ನಡ · മലയാളം',
              style: TextStyle(
                fontSize: 11,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Match tile (shared UI) ────────────────────────────────────────────────────

class _MatchTile extends StatelessWidget {
  final _MatchedItem match;
  const _MatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final color = match.inStock
        ? BrandColors.success
        : match.found
            ? Colors.orange
            : BrandColors.muted;

    final icon = match.inStock
        ? Icons.check_circle_rounded
        : match.found
            ? Icons.warning_amber_rounded
            : Icons.cancel_rounded;

    final statusLabel = match.inStock ? 'In stock' : match.found ? 'Low stock' : 'Not found';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.product?.displayName ?? match.gemini.name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: match.found ? BrandColors.ink : BrandColors.muted),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                if (!match.found)
                  Text('"${match.gemini.name}"', style: const TextStyle(fontSize: 11, color: BrandColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(match.gemini.quantity, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BrandColors.ink)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
