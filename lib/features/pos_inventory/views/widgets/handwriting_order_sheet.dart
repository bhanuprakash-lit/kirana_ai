import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/providers/usage_limits_provider.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/gemini_item.dart';
import '../../../../core/services/gemini_vision_service.dart';
import '../../../../core/utils/product_matcher.dart';
import '../../../../core/services/usage_limits_service.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../subscription/models/subscription_model.dart';
import '../../../subscription/providers/subscription_provider.dart';
import '../../../subscription/views/credits_purchase_sheet.dart';
import '../../models/pos_product.dart';
import '../../providers/pos_provider.dart';
import 'ai_gate_widgets.dart';

// ── Public entry point ────────────────────────────────────────────────────────

Future<void> showHandwritingOrderSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => const _HandwritingOrderSheet(),
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

class _HandwritingOrderSheet extends ConsumerStatefulWidget {
  const _HandwritingOrderSheet();

  @override
  ConsumerState<_HandwritingOrderSheet> createState() =>
      _HandwritingOrderSheetState();
}

class _HandwritingOrderSheetState
    extends ConsumerState<_HandwritingOrderSheet> {
  late final GeminiVisionService _visionSvc;
  final _repaintKey = GlobalKey();

  final _strokes = <List<Offset>>[];
  List<Offset> _current = [];

  _DetectState _detectState = _DetectState.idle;
  String _transcript = '';
  List<_MatchedItem> _matches = [];
  bool _autoDetectEnabled = false; // toggle in sheet
  String _errorMsg = '';
  bool _hasDrawn = false;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  // Auto-detect timer (fires 2s after user stops drawing, first time only)
  Timer? _autoDetectTimer;
  bool _autoDetectFired = false;

  @override
  void initState() {
    super.initState();
    _visionSvc = GeminiVisionService(ref.read(apiClientProvider));
  }

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
    if (_autoDetectFired || !_autoDetectEnabled) return;
    _autoDetectTimer?.cancel();
    _autoDetectTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _hasDrawn && !_autoDetectFired && _autoDetectEnabled) {
        _autoDetectFired = true;
        _detect();
      }
    });
  }

  void _undoStroke() {
    if (_strokes.isEmpty) return;
    _autoDetectTimer?.cancel();
    setState(() {
      _strokes.removeLast();
      if (_strokes.isEmpty) {
        _hasDrawn = false;
        _autoDetectFired = false;
        _detectState = _DetectState.idle;
        _transcript = '';
        _matches = [];
        _errorMsg = '';
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
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw Exception(_l10n.procCanvasNotReady);

      final image = await boundary.toImage(pixelRatio: 2.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = data?.buffer.asUint8List();
      if (pngBytes == null) throw Exception(_l10n.procFailedToCaptureCanvas);

      final result = await _visionSvc.processHandwriting(pngBytes);
      final products = ref.read(posProvider).products;

      // Server already recorded the use; apply inline status update instantly
      if (result.aiStatus != null) {
        ref
            .read(usageLimitsProvider.notifier)
            .applyInlineUpdate(kFeatureHandwrite, result.aiStatus!);
      }

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

  PosProduct? _matchProduct(GeminiItem item, List<PosProduct> products) =>
      matchProductByName(item.name, products);

  void _linkProduct(int index, PosProduct product) {
    setState(() {
      _matches[index] = _MatchedItem(
        gemini: _matches[index].gemini,
        product: product,
      );
    });
  }

  Future<void> _showInventoryPicker(int index) async {
    final products = ref.read(posProvider).products;
    final initial = _matches[index].gemini.baseName;
    final picked = await showModalBottomSheet<PosProduct>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _InlinePickerSheet(products: products, initialQuery: initial),
    );
    if (picked != null && mounted) _linkProduct(index, picked);
  }

  // ── Add to cart ───────────────────────────────────────────────────────────

  void _addToCart() {
    final notifier = ref.read(posProvider.notifier);
    int added = 0;
    for (final m in _matches) {
      if (!m.inStock) continue;
      notifier.addToCart(m.product!, qty: m.gemini.parsedQty);
      added++;
    }
    if (mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_l10n.procAddedToCartFromHandwriting(added)),
        backgroundColor: BrandColors.success,
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _autoDetectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final matched = _matches.where((m) => m.inStock).length;
    final size = MediaQuery.of(context).size;
    // Once items are detected the canvas collapses to a compact preview so the
    // results list gets the room it needs (critical on small screens).
    final reviewing = _detectState == _DetectState.done;

    // ── Pro + usage gating ─────────────────────────────────────────────────────
    final subInfo = ref.watch(subInfoProvider);
    final isPro = subInfo.effectiveTier == SubTier.pro;
    final limitsAsync = ref.watch(usageLimitsProvider);
    final remaining =
        limitsAsync.value?.handwriteRemaining ??
        kDailyLimits[kFeatureHandwrite]!;
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
            // Drag handle + close button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 4, 0),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: BrandColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: BrandColors.muted,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Title + clear
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: BrandColors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.draw_rounded,
                      color: BrandColors.purple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.procHandwriteOrder,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: BrandColors.ink,
                          ),
                        ),
                        Text(
                          l10n.procWriteItemsAnyScript,
                          style: const TextStyle(
                            fontSize: 12,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Usage badge
                  if (isPro)
                    AiUsageBadge(
                      remaining: remaining,
                      total: kDailyLimits[kFeatureHandwrite]!,
                      label: l10n.procDrawsLabel,
                    ),
                  if (_strokes.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: _undoStroke,
                      icon: const Icon(Icons.undo_rounded, size: 20),
                      tooltip: l10n.procUndoLastStroke,
                      color: BrandColors.muted,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    TextButton.icon(
                      onPressed: _clear,
                      icon: const Icon(Icons.clear_all_rounded, size: 16),
                      label: Text(l10n.procClear),
                      style: TextButton.styleFrom(
                        foregroundColor: BrandColors.error,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Gate banners
            if (!isPro)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiGateBanner(
                  icon: Icons.workspace_premium_rounded,
                  color: BrandColors.orange,
                  message: l10n.procHandwriteOrderProFeature,
                  actionLabel: l10n.procUpgradeToPro,
                  onAction: () => Navigator.pop(context),
                ),
              )
            else if (remaining == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiGateBanner(
                  icon: Icons.bolt_rounded,
                  color: BrandColors.error,
                  message: l10n.procDailyLimitReached,
                  actionLabel: l10n.procBuyCredits,
                  onAction: () => showCreditsPurchaseSheet(
                    context,
                    ref,
                    highlightFeature: kFeatureHandwrite,
                  ),
                ),
              ),
            if (!isPro || remaining == 0) const SizedBox(height: 8),

            // Language banner + auto-detect toggle (drawing mode only)
            if (!reviewing) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ScriptBanner(),
              ),
              const SizedBox(height: 8),

              // Auto-detect toggle row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_rounded,
                      size: 14,
                      color: BrandColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.procAutoDetectAfter5s,
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _autoDetectEnabled,
                        onChanged: canUse
                            ? (v) => setState(() => _autoDetectEnabled = v)
                            : null,
                        activeTrackColor: BrandColors.purple,
                        activeThumbColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],

            // Canvas — large while drawing, compact preview while reviewing.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: reviewing ? size.height * 0.15 : size.height * 0.46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasDrawn
                        ? BrandColors.purple.withValues(alpha: 0.4)
                        : BrandColors.border,
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
                          // opaque + an expanding child make the WHOLE canvas
                          // box capture strokes. Previously the painter was
                          // fixed at 220px tall, so anything below that height
                          // was a dead zone the user couldn't write in.
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (canUse && !reviewing)
                              ? _onPanStart
                              : null,
                          onPanUpdate: (canUse && !reviewing)
                              ? _onPanUpdate
                              : null,
                          onPanEnd: (canUse && !reviewing) ? _onPanEnd : null,
                          child: CustomPaint(
                            painter: _StrokePainter(
                              strokes: _strokes,
                              current: _current,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                      if (!_hasDrawn)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.gesture_rounded,
                                size: 32,
                                color: canUse
                                    ? BrandColors.border
                                    : BrandColors.border.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                canUse
                                    ? l10n.procWriteItemsHere
                                    : l10n.procUpgradeOrTopUpToWrite,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: canUse
                                      ? BrandColors.muted
                                      : BrandColors.border,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (canUse)
                                Text(
                                  l10n.procHandwriteExample,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: BrandColors.border,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Detect button (drawing mode only)
            if (!reviewing) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed:
                        (!canUse ||
                            _detectState == _DetectState.processing ||
                            !_hasDrawn)
                        ? null
                        : _detect,
                    icon: _detectState == _DetectState.processing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: Text(
                      _detectState == _DetectState.processing
                          ? l10n.procDetecting
                          : l10n.procDetectItems,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Results
            Expanded(
              child: SingleChildScrollView(
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
                            const Icon(
                              Icons.error_outline_rounded,
                              color: BrandColors.error,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMsg,
                                style: const TextStyle(
                                  color: BrandColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
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
                              Text(
                                l10n.procRead,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: BrandColors.muted,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _transcript,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: BrandColors.ink,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Items
                      if (_matches.isEmpty)
                        Text(
                          l10n.procNoItemsDetectedWriteClearly,
                          style: const TextStyle(
                            color: BrandColors.muted,
                            fontSize: 13,
                          ),
                        )
                      else
                        Column(
                          children: [
                            for (final m in _matches) ...[
                              _MatchTile(
                                match: m,
                                onLink: m.found
                                    ? null
                                    : () => _showInventoryPicker(
                                        _matches.indexOf(m),
                                      ),
                              ),
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
                              label: Text(l10n.procWriteAgain),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: matched > 0 ? _addToCart : null,
                              icon: const Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 16,
                              ),
                              label: Text(l10n.procAddToCartCount(matched)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
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
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BrandColors.purple.withValues(alpha: 0.07),
            BrandColors.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BrandColors.purple.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.translate_rounded,
            size: 13,
            color: BrandColors.purple,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.procAnyScriptLanguages,
              style: TextStyle(
                fontSize: 11,
                color: BrandColors.purple.withValues(alpha: 0.9),
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
  final VoidCallback? onLink;
  const _MatchTile({required this.match, this.onLink});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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

    final statusLabel = match.inStock
        ? l10n.procInStock
        : match.found
        ? l10n.procLowStock
        : l10n.procNotFound;

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
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: match.found ? BrandColors.ink : BrandColors.muted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!match.found)
                  Text(
                    '"${match.gemini.name}"',
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!match.found && onLink != null)
            TextButton(
              onPressed: onLink,
              style: TextButton.styleFrom(
                foregroundColor: BrandColors.primary,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                l10n.procPick,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else ...[
            Text(
              match.gemini.quantity,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Inline inventory picker ───────────────────────────────────────────────────

class _InlinePickerSheet extends StatefulWidget {
  final List<PosProduct> products;
  final String initialQuery;
  const _InlinePickerSheet({
    required this.products,
    required this.initialQuery,
  });

  @override
  State<_InlinePickerSheet> createState() => _InlinePickerSheetState();
}

class _InlinePickerSheetState extends State<_InlinePickerSheet> {
  late final TextEditingController _ctrl;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _ctrl = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          (p.brand?.toLowerCase().contains(q) ?? false);
    }).toList();

    final l10n = AppLocalizations.of(context);
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.procPickFromInventory,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: l10n.procSearchProducts,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
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
                              icon: const Icon(Icons.clear_rounded, size: 16),
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
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        l10n.procNoProductsFound,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.builder(
                      controller: ctrl,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            p.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            l10n.procPriceStockLabel(
                              p.priceLabel,
                              p.stockLabel,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.add_circle_rounded,
                            color: BrandColors.primary,
                          ),
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
