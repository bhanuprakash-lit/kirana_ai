import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/providers/usage_limits_provider.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/gemini_audio_service.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../../core/utils/product_matcher.dart';
import '../../../../core/services/gemini_item.dart';
import '../../../../core/services/usage_limits_service.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../subscription/models/subscription_model.dart';
import '../../../subscription/providers/subscription_provider.dart';
import '../../../subscription/views/credits_purchase_sheet.dart';
import '../../models/pos_product.dart';
import '../../providers/pos_provider.dart';
import 'ai_gate_widgets.dart';

// ── Public entry point ────────────────────────────────────────────────────────

Future<void> showVoiceOrderSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _VoiceOrderSheet(),
  );
}

// ── Matched item result ───────────────────────────────────────────────────────

class _MatchedItem {
  final GeminiItem gemini;
  final PosProduct? product;

  const _MatchedItem({required this.gemini, this.product});

  bool get found => product != null;
  bool get inStock => product != null && product!.stockQuantity > 0;
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

enum _VoiceState { idle, recording, processing, done, error }

class _VoiceOrderSheet extends ConsumerStatefulWidget {
  const _VoiceOrderSheet();

  @override
  ConsumerState<_VoiceOrderSheet> createState() => _VoiceOrderSheetState();
}

class _VoiceOrderSheetState extends ConsumerState<_VoiceOrderSheet>
    with SingleTickerProviderStateMixin {
  late final GeminiAudioService _svc;
  _VoiceState _status = _VoiceState.idle;
  String _transcript = '';
  List<_MatchedItem> _matches = [];
  String _errorMsg = '';

  // Timer
  Timer? _timer;
  int _seconds = 0;

  // Pulse animation for mic
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _svc = GeminiAudioService(ref.read(apiClientProvider));
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _pulse.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    _svc.dispose();
    super.dispose();
  }

  // ── Recording control ─────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final granted = await Permission.microphone.request();
    if (!granted.isGranted) {
      setState(() {
        _status = _VoiceState.error;
        _errorMsg =
            'Microphone permission denied. Please enable it in Settings.';
      });
      return;
    }

    final hasPermission = await _svc.hasPermission();
    if (!hasPermission) {
      setState(() {
        _status = _VoiceState.error;
        _errorMsg = 'Microphone not accessible.';
      });
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_order_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _svc.startRecording(path);
    setState(() {
      _status = _VoiceState.recording;
      _seconds = 0;
    });
    _pulse.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
      // Auto-cut at 15 seconds
      if (_seconds >= kVoiceMaxSeconds && _status == _VoiceState.recording) {
        _stopAndProcess();
      }
    });
  }

  Future<void> _stopAndProcess() async {
    _timer?.cancel();
    _pulse.stop();
    setState(() => _status = _VoiceState.processing);

    try {
      final result = await _svc.stopAndProcess();
      final products = ref.read(posProvider).products;

      setState(() {
        _transcript = result.transcript;
        _matches = result.items.map((item) {
          final product = _matchProduct(item, products);
          return _MatchedItem(gemini: item, product: product);
        }).toList();
        _status = _VoiceState.done;
      });
      // Server already recorded the use; apply the inline status update instantly
      if (result.aiStatus != null) {
        ref
            .read(usageLimitsProvider.notifier)
            .applyInlineUpdate(kFeatureVoice, result.aiStatus!);
      }
    } catch (e) {
      setState(() {
        _status = _VoiceState.error;
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

  // ── Add matched items to cart ─────────────────────────────────────────────

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
        content: Text(
          '$added item${added != 1 ? 's' : ''} added to cart from voice order',
        ),
        backgroundColor: BrandColors.success,
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  String get _timerLabel {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final matched = _matches.where((m) => m.inStock).length;
    final subInfo = ref.watch(subInfoProvider);
    final isPro = subInfo.effectiveTier == SubTier.pro;
    final limitsAsync = ref.watch(usageLimitsProvider);
    final canUse = isPro && (limitsAsync.value?.canUseVoice ?? true);
    final remaining =
        limitsAsync.value?.voiceRemaining ?? kDailyLimits[kFeatureVoice]!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Title row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: BrandColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: BrandColors.ink,
                      ),
                    ),
                    Text(
                      'Speak in any Indian language',
                      style: TextStyle(fontSize: 12, color: BrandColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Language banner
          _LanguageBanner(),
          const SizedBox(height: 10),

          // Usage banner (pro gate or daily limit)
          if (!isPro)
            AiGateBanner(
              icon: Icons.workspace_premium_rounded,
              color: BrandColors.orange,
              message: 'Voice Order is a Pro feature. Upgrade to access.',
              actionLabel: 'Upgrade',
              onAction: () {
                Navigator.pop(context);
              },
            )
          else if (!canUse)
            AiGateBanner(
              icon: Icons.bolt_rounded,
              color: BrandColors.error,
              message: 'No voice orders left today. Get more credits.',
              actionLabel: 'Get Credits',
              onAction: () => showCreditsPurchaseSheet(
                context,
                ref,
                highlightFeature: kFeatureVoice,
              ),
            )
          else
            AiUsageBadge(
              remaining: remaining,
              total: kDailyLimits[kFeatureVoice]!,
              label: 'voice',
            ),

          const SizedBox(height: 20),

          // Mic area
          if (_status == _VoiceState.idle ||
              _status == _VoiceState.recording) ...[
            _MicButton(
              status: _status,
              pulseAnim: _pulseAnim,
              timerLabel: _timerLabel,
              maxSeconds: kVoiceMaxSeconds,
              onTap: (!isPro || !canUse) && _status == _VoiceState.idle
                  ? null
                  : _status == _VoiceState.idle
                  ? _startRecording
                  : _stopAndProcess,
            ),
            const SizedBox(height: 8),
            Text(
              _status == _VoiceState.idle
                  ? 'Tap mic to start recording'
                  : 'Tap to stop & process',
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ],

          if (_status == _VoiceState.processing)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: CardShimmer(height: 48, radius: 12),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Kirana AI is processing…',
                    style: TextStyle(color: BrandColors.muted, fontSize: 13),
                  ),
                ],
              ),
            ),

          if (_status == _VoiceState.error) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BrandColors.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: BrandColors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMsg,
                      style: const TextStyle(
                        color: BrandColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => setState(() {
                _status = _VoiceState.idle;
                _seconds = 0;
              }),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],

          // Results
          if (_status == _VoiceState.done) ...[
            // Transcript
            if (_transcript.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BrandColors.surfaceTint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: BrandColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heard',
                      style: TextStyle(
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
                        fontSize: 13,
                        color: BrandColors.ink,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Matched items list
            if (_matches.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No items detected. Please try again.',
                  style: TextStyle(color: BrandColors.muted),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _matches.length,
                  separatorBuilder: (context2, index2) =>
                      const Divider(height: 1),
                  itemBuilder: (_, i) => _MatchTile(
                    match: _matches[i],
                    onLink: _matches[i].found
                        ? null
                        : () => _showInventoryPicker(i),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _status = _VoiceState.idle;
                      _seconds = 0;
                      _transcript = '';
                      _matches = [];
                    }),
                    icon: const Icon(Icons.mic_rounded, size: 16),
                    label: const Text('Record Again'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: matched > 0 ? _addToCart : null,
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                    label: Text('Add $matched to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _LanguageBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BrandColors.primary.withValues(alpha: 0.07),
            const Color(0xFF7C3AED).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.language_rounded,
            size: 14,
            color: BrandColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Auto-detects: Telugu · Hindi · Urdu · Tamil · Kannada · Malayalam · English',
              style: TextStyle(
                fontSize: 11,
                color: BrandColors.primary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final _VoiceState status;
  final Animation<double> pulseAnim;
  final String timerLabel;
  final int maxSeconds;
  final VoidCallback? onTap;

  const _MicButton({
    required this.status,
    required this.pulseAnim,
    required this.timerLabel,
    required this.maxSeconds,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRecording = status == _VoiceState.recording;
    final color = isRecording ? BrandColors.error : BrandColors.primary;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, child) => Transform.scale(
              scale: isRecording ? pulseAnim.value : 1.0,
              child: child,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: isRecording ? 0.4 : 0.25),
                    blurRadius: isRecording ? 20 : 10,
                    spreadRadius: isRecording ? 4 : 0,
                  ),
                ],
              ),
              child: Icon(
                isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
        ),
        if (isRecording) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                timerLabel,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: BrandColors.error,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ ${maxSeconds}s',
                style: const TextStyle(fontSize: 13, color: BrandColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar toward auto-cut
          Builder(
            builder: (ctx) {
              final secs = int.tryParse(timerLabel.split(':').last) ?? 0;
              final mins = int.tryParse(timerLabel.split(':').first) ?? 0;
              final total = mins * 60 + secs;
              final progress = (total / maxSeconds).clamp(0.0, 1.0);
              return SizedBox(
                width: 160,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: BrandColors.border,
                  color: progress > 0.8 ? BrandColors.error : Colors.orange,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _MatchTile extends StatelessWidget {
  final _MatchedItem match;
  final VoidCallback? onLink;
  const _MatchTile({required this.match, this.onLink});

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

    final statusLabel = match.inStock
        ? 'In stock'
        : match.found
        ? 'Low stock'
        : 'Not found';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
              child: const Text(
                'Pick',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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
                  const Text(
                    'Pick from Inventory',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search products…',
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
                  ? const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(color: BrandColors.muted),
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
                            '${p.priceLabel} · Stock: ${p.stockLabel}',
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
