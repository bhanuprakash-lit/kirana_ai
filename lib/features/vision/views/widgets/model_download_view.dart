import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';

/// "Stocking the shelf" loader for the counter-model download.
///
/// A plain [CircularProgressIndicator] is the wrong instrument here: the
/// transfer is ~38 MB and can legitimately run for minutes on a shop's
/// connection, and a spinner that never moves reads as *frozen*. Someone
/// waiting that long needs to see that something is happening, roughly how far
/// along it is, and that leaving will cost them.
///
/// So progress is drawn as the thing the model is for — a shelf filling with
/// stock, one carton at a time, behind a camera viewfinder with a scan line
/// sweeping over it. It doubles as an explanation of what the download is: by
/// the time the shelf is full, the app can recognise what's on it.
class ShelfStockingLoader extends StatefulWidget {
  /// 0..1, or null for indeterminate (size not yet known).
  final double? progress;
  final double width;
  final double height;

  const ShelfStockingLoader({
    super.key,
    required this.progress,
    this.width = 236,
    this.height = 168,
  });

  @override
  State<ShelfStockingLoader> createState() => _ShelfStockingLoaderState();
}

class _ShelfStockingLoaderState extends State<ShelfStockingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _sweep,
        builder: (_, _) => CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _ShelfPainter(
            progress: widget.progress,
            sweep: Curves.easeInOutSine.transform(_sweep.value),
          ),
        ),
      ),
    );
  }
}

class _ShelfPainter extends CustomPainter {
  final double? progress;
  final double sweep;

  _ShelfPainter({required this.progress, required this.sweep});

  static const _cols = 4;
  static const _rows = 3;
  static const _slots = _cols * _rows;

  /// Cartons look hand-stacked rather than machine-perfect. Deterministic, so
  /// a box doesn't jump around between repaints.
  static const _heights = <double>[
    0.92, 0.74, 1.0, 0.82, //
    0.86, 1.0, 0.78, 0.94, //
    0.70, 0.90, 0.84, 1.0,
  ];

  static const _palette = <Color>[
    BrandColors.accent,
    BrandColors.orange,
    BrandColors.purple,
    BrandColors.primary,
    BrandColors.success,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 22.0;
    final innerW = size.width - pad * 2;
    final innerH = size.height - pad * 2;
    final rowH = innerH / _rows;
    final gap = innerW * 0.045;
    final slotW = (innerW - gap * (_cols - 1)) / _cols;

    final filled = (progress ?? 0) * _slots;

    // ---- shelf planks -------------------------------------------------
    final plank = Paint()
      ..color = BrandColors.border
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (var r = 0; r < _rows; r++) {
      final y = pad + innerH - r * rowH;
      canvas.drawLine(Offset(pad, y), Offset(pad + innerW, y), plank);
    }

    // ---- cartons ------------------------------------------------------
    for (var i = 0; i < _slots; i++) {
      final row = i ~/ _cols;
      final col = i % _cols;

      // How much of THIS carton is in place: 1 for settled, a fraction for the
      // one currently landing, 0 for the ones still to come.
      final double fill;
      if (progress == null) {
        // Indeterminate — run a wave across the shelf so it reads as "working"
        // without claiming a percentage we don't have.
        final phase = (sweep * 1.6) - (i / _slots);
        fill = (1 - (phase.abs() * 3)).clamp(0.0, 1.0);
      } else {
        fill = (filled - i).clamp(0.0, 1.0);
      }
      if (fill <= 0.01) {
        // Empty slot: a faint outline, so the shelf's full extent is visible
        // and the bar reads as "4 of 12" rather than an ambiguous blob.
        final ghost = Paint()
          ..color = BrandColors.border.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
        final h = rowH * 0.58 * _heights[i];
        final rect = Rect.fromLTWH(
          pad + col * (slotW + gap),
          pad + innerH - row * rowH - h,
          slotW,
          h,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)),
          ghost,
        );
        continue;
      }

      final full = rowH * 0.58 * _heights[i];
      final h = full * Curves.easeOutBack.transform(fill).clamp(0.0, 1.2);
      final baseY = pad + innerH - row * rowH;
      final rect = Rect.fromLTWH(
        pad + col * (slotW + gap),
        baseY - h,
        slotW,
        h,
      );
      final colour = _palette[i % _palette.length];

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()..color = colour.withValues(alpha: 0.20 + 0.55 * fill),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()
          ..color = colour.withValues(alpha: fill)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
      // Tape seam down the middle — sells it as a carton at this size far
      // better than any amount of extra detail.
      if (h > 10) {
        canvas.drawLine(
          Offset(rect.center.dx, rect.top + 2),
          Offset(rect.center.dx, rect.bottom - 2),
          Paint()
            ..color = colour.withValues(alpha: 0.35 * fill)
            ..strokeWidth = 1.2,
        );
      }
    }

    // ---- scan line ----------------------------------------------------
    final scanY = pad + innerH * (1 - sweep);
    final glow = Rect.fromLTWH(pad, scanY - 16, innerW, 32);
    canvas.drawRect(
      glow,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            BrandColors.accent.withValues(alpha: 0),
            BrandColors.accent.withValues(alpha: 0.22),
            BrandColors.accent.withValues(alpha: 0),
          ],
        ).createShader(glow),
    );
    canvas.drawLine(
      Offset(pad, scanY),
      Offset(pad + innerW, scanY),
      Paint()
        ..color = BrandColors.accent.withValues(alpha: 0.85)
        ..strokeWidth = 2,
    );

    // ---- viewfinder brackets ------------------------------------------
    final bracket = Paint()
      ..color = BrandColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const len = 20.0;
    const r = 8.0;
    final l = pad - 12, t = pad - 12;
    final rt = size.width - pad + 12, b = size.height - pad + 12;
    for (final corner in [
      [Offset(l, t + len), Offset(l, t), Offset(l + len, t), 1.0, 1.0],
      [Offset(rt - len, t), Offset(rt, t), Offset(rt, t + len), -1.0, 1.0],
      [Offset(l, b - len), Offset(l, b), Offset(l + len, b), 1.0, -1.0],
      [Offset(rt - len, b), Offset(rt, b), Offset(rt, b - len), -1.0, -1.0],
    ]) {
      final p = Path()
        ..moveTo((corner[0] as Offset).dx, (corner[0] as Offset).dy);
      final c = corner[1] as Offset;
      final sx = corner[3] as double, sy = corner[4] as double;
      p
        ..lineTo(c.dx, c.dy + r * sy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx + r * sx, c.dy)
        ..lineTo((corner[2] as Offset).dx, (corner[2] as Offset).dy);
      canvas.drawPath(p, bracket);
    }
  }

  @override
  bool shouldRepaint(_ShelfPainter old) =>
      old.progress != progress || old.sweep != sweep;
}

/// Human byte size, in the units a shopkeeper would read on a data pack.
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 MB';
  const mb = 1024 * 1024;
  if (bytes < mb) return '${(bytes / 1024).round()} KB';
  final v = bytes / mb;
  return '${v < 10 ? v.toStringAsFixed(1) : v.round()} MB';
}

/// Thin progress bar under the shelf — the shelf gives the feel, this gives the
/// precision. Indeterminate when the total isn't known.
class ModelProgressBar extends StatelessWidget {
  final double? progress;
  const ModelProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 6,
        backgroundColor: BrandColors.border,
        valueColor: const AlwaysStoppedAnimation(BrandColors.accent),
      ),
    );
  }
}

/// Percentage badge, sized so it stays legible at large text scales.
class ModelPercentText extends StatelessWidget {
  final double? progress;
  const ModelPercentText({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = progress == null ? null : (progress! * 100).floor();
    return Text(
      pct == null ? '· · ·' : '$pct%',
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: BrandColors.ink,
        letterSpacing: -0.5,
      ),
    );
  }
}

/// Rotating reassurance while a long transfer runs. Static copy on a 5-minute
/// wait starts to look like a frozen screen; a line that changes is evidence
/// the app is alive, and it's a free place to explain what the user is getting.
class RotatingHint extends StatefulWidget {
  final List<String> hints;
  const RotatingHint({super.key, required this.hints});

  @override
  State<RotatingHint> createState() => _RotatingHintState();
}

class _RotatingHintState extends State<RotatingHint> {
  int _i = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Must be started here, not as a `late` field: nothing reads the field
    // during build, so a lazy initialiser would only fire in dispose() and the
    // hints would sit frozen on the first line for the whole download.
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.hints.isEmpty) return;
      setState(() => _i = (_i + 1) % widget.hints.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hints.isEmpty) return const SizedBox.shrink();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Text(
        widget.hints[_i],
        key: ValueKey(_i),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, color: BrandColors.muted),
      ),
    );
  }
}
