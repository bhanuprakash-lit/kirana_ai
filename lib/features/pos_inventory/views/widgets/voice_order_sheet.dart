import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/gemini_audio_service.dart';
import '../../../../core/services/gemini_item.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../models/pos_product.dart';
import '../../providers/pos_provider.dart';

// ── Public entry point ────────────────────────────────────────────────────────

Future<void> showVoiceOrderSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VoiceOrderSheet(ref: ref),
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

class _VoiceOrderSheet extends StatefulWidget {
  final WidgetRef ref;
  const _VoiceOrderSheet({required this.ref});

  @override
  State<_VoiceOrderSheet> createState() => _VoiceOrderSheetState();
}

class _VoiceOrderSheetState extends State<_VoiceOrderSheet>
    with SingleTickerProviderStateMixin {
  final _svc = GeminiAudioService();
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
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
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
        _errorMsg = 'Microphone permission denied. Please enable it in Settings.';
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
    final path = '${dir.path}/voice_order_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _svc.startRecording(path);
    setState(() {
      _status = _VoiceState.recording;
      _seconds = 0;
    });
    _pulse.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  Future<void> _stopAndProcess() async {
    _timer?.cancel();
    _pulse.stop();
    setState(() => _status = _VoiceState.processing);

    try {
      final result = await _svc.stopAndProcess();
      final products = widget.ref.read(posProvider).products;

      setState(() {
        _transcript = result.transcript;
        _matches = result.items.map((item) {
          final product = _matchProduct(item, products);
          return _MatchedItem(gemini: item, product: product);
        }).toList();
        _status = _VoiceState.done;
      });
    } catch (e) {
      setState(() {
        _status = _VoiceState.error;
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  PosProduct? _matchProduct(GeminiItem item, List<PosProduct> products) {
    final base = item.baseName;
    // Exact → contains → reverse contains
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

  // ── Add matched items to cart ─────────────────────────────────────────────

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
      content: Text('$added item${added != 1 ? 's' : ''} added to cart from voice order'),
      backgroundColor: BrandColors.success,
      duration: const Duration(milliseconds: 1800),
    ));
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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        left: 24, right: 24, top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2)),
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
                child: const Icon(Icons.mic_rounded, color: BrandColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Voice Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: BrandColors.ink)),
                    Text('Speak in any Indian language', style: TextStyle(fontSize: 12, color: BrandColors.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Language banner
          _LanguageBanner(),

          const SizedBox(height: 20),

          // Mic area
          if (_status == _VoiceState.idle || _status == _VoiceState.recording) ...[
            _MicButton(
              status: _status,
              pulseAnim: _pulseAnim,
              timerLabel: _timerLabel,
              onTap: _status == _VoiceState.idle ? _startRecording : _stopAndProcess,
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
                  CircularProgressIndicator(),
                  SizedBox(height: 14),
                  Text('Kirana AI is processing…', style: TextStyle(color: BrandColors.muted, fontSize: 13)),
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
                  const Icon(Icons.error_outline_rounded, color: BrandColors.error, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_errorMsg, style: const TextStyle(color: BrandColors.error, fontSize: 13))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => setState(() { _status = _VoiceState.idle; _seconds = 0; }),
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
                    const Text('Heard', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: BrandColors.muted, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(_transcript, style: const TextStyle(fontSize: 13, color: BrandColors.ink, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Matched items list
            if (_matches.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No items detected. Please try again.', style: TextStyle(color: BrandColors.muted)),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _matches.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => _MatchTile(match: _matches[i]),
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
          const Icon(Icons.language_rounded, size: 14, color: BrandColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Auto-detects: Telugu · Hindi · Urdu · Tamil · Kannada · Malayalam · English',
              style: TextStyle(fontSize: 11, color: BrandColors.primary.withValues(alpha: 0.85), fontWeight: FontWeight.w600),
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
  final VoidCallback onTap;

  const _MicButton({
    required this.status,
    required this.pulseAnim,
    required this.timerLabel,
    required this.onTap,
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
              width: 80, height: 80,
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
          Text(
            timerLabel,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: BrandColors.error, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ],
      ],
    );
  }
}

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
                  Text('"${match.gemini.name}"', style: const TextStyle(fontSize: 11, color: BrandColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(match.gemini.quantity,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BrandColors.ink)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(statusLabel, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
