import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../counter/counter_engine.dart';
import '../counter/counter_model.dart';
import '../counter/model_provisioner.dart';
import '../counter/simple_tracker.dart';
import '../models/counter_models.dart';
import '../providers/counter_provider.dart';
import 'widgets/model_download_view.dart';

/// Live sale-area counter. On-device YOLO detects products in the camera feed;
/// a Dart tracker gives each a stable id; [CounterEngine] counts each item once
/// as it crosses the sold line. On finish, the per-product tally is synced to the
/// backend (which resolves class names → product_ids).
///
/// Fully on-device: it counts even with no network. Sync is best-effort and
/// queued locally, so it also works before the counter backend is deployed.
class CounterScreen extends ConsumerStatefulWidget {
  const CounterScreen({super.key});

  @override
  ConsumerState<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends ConsumerState<CounterScreen> {
  final _controller = YOLOViewController();
  final _engine = CounterEngine(lineFrac: 0.5);
  final _tracker = SimpleTracker();

  PermissionStatus? _camPerm;
  bool _running = false; // actively counting vs paused
  bool _started = false; // a session is in progress (started at least once)
  DateTime? _startedAt;
  String? _lastCountedLabel;
  Timer? _flashTimer;

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    if (mounted) setState(() => _camPerm = status);
  }

  /// Landing → live counting. Requests the camera only now (not on tab visit).
  Future<void> _beginSession() async {
    final perm = _camPerm ?? await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _camPerm = perm;
      _started = true;
      _running = perm.isGranted;
      if (perm.isGranted) _startedAt = DateTime.now();
    });
  }

  // ── Detection → tracking → counting ─────────────────────────────────────────

  void _onResult(List<YOLOResult> results) {
    if (!_running) return;
    final inputs = <TrackerInput>[
      for (final r in results)
        if (r.confidence >= CounterModel.defaultConfidence)
          TrackerInput(r.normalizedBox, r.className, r.confidence),
    ];
    final tracked = _tracker.update(inputs);
    final dets = [
      for (final t in tracked)
        CounterDetection(
          trackId: t.id,
          className: t.className,
          confidence: t.confidence,
          boxNorm: t.box,
        ),
    ];
    final events = _engine.processFrame(dets);
    // The UI (count badge, tally strip, flash) only changes when something is
    // counted — so rebuild on crossings, not on every camera frame.
    if (events.isNotEmpty && mounted) {
      HapticFeedback.selectionClick();
      _lastCountedLabel = _prettify(events.last.className);
      _flashTimer?.cancel();
      _flashTimer = Timer(const Duration(milliseconds: 1400), () {
        if (mounted) setState(() => _lastCountedLabel = null);
      });
      setState(() {});
    }
  }

  // ── Controls ─────────────────────────────────────────────────────────────────

  void _toggleRun() {
    setState(() {
      _running = !_running;
      if (_running) {
        _started = true;
        _startedAt ??= DateTime.now();
      }
    });
  }

  void _flip() {
    setState(() {
      _engine.direction = _engine.direction == CountDirection.leftToRight
          ? CountDirection.rightToLeft
          : CountDirection.leftToRight;
    });
  }

  void _undo() {
    final removed = _engine.undoLast();
    if (removed != null) HapticFeedback.lightImpact();
    setState(() {});
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context);
    if (_engine.isEmpty) {
      setState(() {
        _running = false;
        _started = false;
        _startedAt = null;
      });
      return;
    }
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (_) =>
          _FinishSheet(total: _engine.totalUnits, skus: _engine.totalSkus),
    );
    if (confirmed != true) return;

    final items = [
      for (final t in _engine.tally)
        CounterItemPayload(
          className: t.className,
          qty: t.qty,
          avgConfidence: t.avgConfidence,
        ),
    ];
    final now = DateTime.now();
    final session = CounterSession(
      clientUid: _newUid(),
      sessionDate: now.toIso8601String().substring(0, 10),
      startedAt: _startedAt?.toIso8601String(),
      endedAt: now.toIso8601String(),
      items: items,
    );
    final total = _engine.totalUnits;
    final skus = _engine.totalSkus;

    await ref.read(counterProvider.notifier).finalizeAndSync(session);
    if (!mounted) return;

    final reachable = ref.read(counterProvider).backendReachable;
    _engine.reset();
    _tracker.reset();
    setState(() {
      _running = false;
      _started = false;
      _startedAt = null;
      _lastCountedLabel = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          reachable
              ? l10n.visionCounterSaved(total, skus)
              : '${l10n.visionCounterSaved(total, skus)} ${l10n.visionCounterOfflineNote}',
        ),
        backgroundColor: BrandColors.success,
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // PAI-15 — the model is fetched, not bundled. Until it's on disk the screen
    // belongs to the setup flow, which runs itself and only reports progress.
    final model = ref.watch(counterModelProvider);

    // A setup that just finished walks straight into the camera. Someone who
    // waited out the download has already said what they want; making them tap
    // "Start" on a landing page afterwards is a step for its own sake.
    ref.listen(counterModelProvider, (prev, next) {
      if (next.phase == ModelPhase.ready &&
          next.justInstalled &&
          prev?.phase == ModelPhase.downloading &&
          !_started) {
        _beginSession();
      }
    });

    switch (model.phase) {
      case ModelPhase.checking:
      case ModelPhase.downloading:
      case ModelPhase.failed:
        return _ModelGate(state: model, l10n: l10n);
      case ModelPhase.unavailable:
        return _CounterMessage(
          icon: Icons.videocam_off_rounded,
          title: l10n.visionCounterModelMissingTitle,
          message: l10n.visionCounterModelMissingDesc,
          actionLabel: l10n.visionModelRetry,
          onAction: () => ref.read(counterModelProvider.notifier).retry(),
        );
      case ModelPhase.ready:
        final path = model.path;
        if (path == null || path.isEmpty) {
          return _CounterMessage(
            icon: Icons.download_for_offline_outlined,
            title: l10n.visionCounterModelMissingTitle,
            message: l10n.visionCounterModelMissingDesc,
          );
        }
        if (!_started) {
          return _CounterLanding(onStart: _beginSession);
        }
        return _buildActive(context, l10n, path);
    }
  }

  Widget _buildActive(
    BuildContext context,
    AppLocalizations l10n,
    String modelPath,
  ) {
    final perm = _camPerm;
    if (perm == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!perm.isGranted) {
      return _PermissionPrompt(
        permanentlyDenied: perm.isPermanentlyDenied,
        onGrant: _requestCamera,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        YOLOView(
          modelPath: modelPath,
          task: YOLOTask.detect,
          controller: _controller,
          confidenceThreshold: CounterModel.defaultConfidence,
          onResult: _onResult,
        ),
        // Sold line + zone tint.
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _LinePainter(
                lineFrac: _engine.lineFrac,
                soldOnRight: _engine.direction == CountDirection.leftToRight,
              ),
            ),
          ),
        ),
        _zoneLabels(l10n),
        _topBar(context, l10n),
        _bottomBar(context, l10n),
        if (_lastCountedLabel != null) _countedFlash(),
      ],
    );
  }

  Widget _zoneLabels(AppLocalizations l10n) {
    final soldOnRight = _engine.direction == CountDirection.leftToRight;
    return Positioned(
      top: 90,
      left: 12,
      right: 12,
      child: IgnorePointer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _zoneChip(
              soldOnRight
                  ? l10n.visionCounterZoneStore
                  : l10n.visionCounterZoneSold,
              soldOnRight ? Colors.white70 : BrandColors.success,
            ),
            _zoneChip(
              soldOnRight
                  ? l10n.visionCounterZoneSold
                  : l10n.visionCounterZoneStore,
              soldOnRight ? BrandColors.success : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  Widget _zoneChip(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );

  Widget _topBar(BuildContext context, AppLocalizations l10n) {
    final pending = ref.watch(counterProvider).pendingCount;
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.visionCounterCounted}: ',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  '${_engine.totalUnits}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (pending > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: BrandColors.orange.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.visionCounterPending(pending),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _countedFlash() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.32,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  '+1  ${_lastCountedLabel ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context, AppLocalizations l10n) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.75), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tallyStrip(),
            const SizedBox(height: 10),
            if (!_started || !_running)
              Text(
                _started ? l10n.visionCounterHint : l10n.visionCounterStartDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                _roundBtn(
                  Icons.undo_rounded,
                  l10n.visionCounterUndo,
                  onTap: _engine.isEmpty ? null : _undo,
                ),
                const SizedBox(width: 10),
                _roundBtn(
                  Icons.swap_horiz_rounded,
                  l10n.visionCounterFlip,
                  onTap: _flip,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _toggleRun,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: _running
                          ? BrandColors.orange
                          : BrandColors.success,
                    ),
                    icon: Icon(
                      _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      _running
                          ? l10n.visionCounterPause
                          : (_started
                                ? l10n.visionCounterResume
                                : l10n.visionCounterStart),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (_started)
                  _roundBtn(
                    Icons.check_rounded,
                    l10n.visionCounterFinish,
                    onTap: _finish,
                    color: BrandColors.primary,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tallyStrip() {
    final tally = _engine.tally;
    if (tally.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tally.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final t = tally[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Text(
                  _prettify(t.className),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(width: 6),
                Text(
                  '×${t.qty}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _roundBtn(
    IconData icon,
    String tooltip, {
    VoidCallback? onTap,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: (color ?? Colors.white).withValues(
          alpha: onTap == null ? 0.15 : 0.22,
        ),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(
              icon,
              color: onTap == null ? Colors.white38 : Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  static String _prettify(String className) => className
      .replaceAll('_', ' ')
      .replaceAll('-', ' ')
      .trim()
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  static final _rng = math.Random.secure();
  static String _newUid() {
    final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    final rnd = _rng.nextInt(0x7FFFFFFF).toRadixString(16);
    return 'cnt_$ts$rnd';
  }
}

// ── Landing (before the camera starts) ───────────────────────────────────────

class _CounterLanding extends ConsumerWidget {
  final VoidCallback onStart;
  const _CounterLanding({required this.onStart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(counterProvider);
    final summary = state.summary;

    return RefreshIndicator(
      onRefresh: () => ref.read(counterProvider.notifier).loadSummary(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: BrandColors.success.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.videocam_rounded,
                      color: BrandColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.visionCounterStartTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.visionCounterStartDesc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BrandColors.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: BrandColors.success,
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.visionCounterStart),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.visionCounterSummaryTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              if (state.pendingCount > 0)
                Text(
                  l10n.visionCounterPending(state.pendingCount),
                  style: const TextStyle(
                    color: BrandColors.orange,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (state.summaryLoading && summary.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          if (!state.summaryLoading && summary.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.visionCounterSummaryEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(color: BrandColors.muted),
              ),
            ),
          if (summary.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BrandColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: BrandColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.visionCounterSummaryTotal,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${state.summaryTotal}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: BrandColors.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (final it in summary)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      it.isUnknown
                          ? Icons.help_outline_rounded
                          : Icons.check_circle_rounded,
                      size: 18,
                      color: it.isUnknown
                          ? BrandColors.orange
                          : BrandColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        it.isUnknown
                            ? '${it.displayName} · ${l10n.visionCounterUnknownItem}'
                            : it.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: it.isUnknown
                              ? BrandColors.muted
                              : BrandColors.ink,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      '×${it.qty}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ── Sold line painter ──────────────────────────────────────────────────────────

class _LinePainter extends CustomPainter {
  final double lineFrac;
  final bool soldOnRight;
  _LinePainter({required this.lineFrac, required this.soldOnRight});

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width * lineFrac;
    // Tint the sold zone green.
    final soldRect = soldOnRight
        ? Rect.fromLTRB(x, 0, size.width, size.height)
        : Rect.fromLTRB(0, 0, x, size.height);
    canvas.drawRect(
      soldRect,
      Paint()..color = BrandColors.success.withValues(alpha: 0.12),
    );
    // The line itself.
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      Paint()
        ..color = BrandColors.success
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.lineFrac != lineFrac || old.soldOnRight != soldOnRight;
}

// ── Finish confirmation sheet ────────────────────────────────────────────────

class _FinishSheet extends StatelessWidget {
  final int total;
  final int skus;
  const _FinishSheet({required this.total, required this.skus});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.visionCounterFinishConfirmTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.visionCounterSaved(total, skus),
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.visionCounterFinishConfirmDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.visionCounterKeepCounting),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.visionCounterSave),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Permission + missing-model states ────────────────────────────────────────

class _PermissionPrompt extends StatelessWidget {
  final bool permanentlyDenied;
  final VoidCallback onGrant;
  const _PermissionPrompt({
    required this.permanentlyDenied,
    required this.onGrant,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _CounterMessage(
      icon: Icons.photo_camera_front_outlined,
      title: l10n.visionCounterPermTitle,
      message: l10n.visionCounterPermDesc,
      actionLabel: permanentlyDenied
          ? l10n.visionCounterOpenSettings
          : l10n.visionCounterGrant,
      onAction: permanentlyDenied ? openAppSettings : onGrant,
    );
  }
}

class _CounterMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _CounterMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 52,
              color: BrandColors.muted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: BrandColors.muted),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// The pre-flight screen for the counter model: ask, show progress, recover.
///
/// This is deliberately a full screen rather than a spinner or a dialog. A
/// ~38 MB transfer on a shop's connection can run for minutes, and the two
/// things the user needs — that it's working, and that leaving costs them —
/// can't be conveyed by an indeterminate circle.
/// The setup screen for the counter model: run it, show it, recover from it.
///
/// Deliberately not a prompt. The user already chose the Counter by opening it;
/// asking a shopkeeper to then approve a "38 MB model download" hands them an
/// engineering decision they have no basis to make and no way to opt out of.
/// So this only ever reports — what's happening, how far along, and the one
/// thing they can get wrong (leaving). The size is shown, not hidden, but it
/// isn't a gate.
class _ModelGate extends ConsumerWidget {
  final CounterModelState state;
  final AppLocalizations l10n;
  const _ModelGate({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failed = state.phase == ModelPhase.failed;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShelfStockingLoader(
              // Nothing measurable during the manifest check or after a
              // failure — run the indeterminate wave rather than show a
              // percentage we can't stand behind.
              progress: state.phase == ModelPhase.downloading
                  ? state.progress
                  : null,
            ),
            const SizedBox(height: 22),
            Text(
              failed ? l10n.visionModelFailedTitle : l10n.visionModelSettingUp,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 10),

            if (failed) ...[
              Text(
                state.resumable
                    ? l10n.visionModelFailedResume(formatBytes(state.received))
                    : l10n.visionModelFailedFresh,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: BrandColors.muted,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(counterModelProvider.notifier).retry(),
                icon: const Icon(Icons.refresh_rounded, size: 19),
                label: Text(l10n.visionModelRetry),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 46),
                  backgroundColor: BrandColors.primary,
                ),
              ),
            ] else if (state.phase == ModelPhase.downloading) ...[
              Text(
                l10n.visionModelKeepOpen,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: BrandColors.muted,
                ),
              ),
              const SizedBox(height: 20),
              ModelPercentText(progress: state.progress),
              const SizedBox(height: 12),
              ModelProgressBar(progress: state.progress),
              const SizedBox(height: 10),
              Text(
                l10n.visionModelOfTotal(
                  formatBytes(state.received),
                  formatBytes(state.total),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: BrandColors.muted,
                ),
              ),
              const SizedBox(height: 20),
              // A long silent wait reads as a hang. A line that changes is
              // proof of life, and buys space to explain what they're getting.
              SizedBox(
                height: 38,
                child: RotatingHint(
                  hints: [
                    l10n.visionModelHint1,
                    l10n.visionModelHint2,
                    l10n.visionModelHint3,
                  ],
                ),
              ),
            ] else ...[
              Text(
                l10n.visionModelChecking,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: BrandColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
