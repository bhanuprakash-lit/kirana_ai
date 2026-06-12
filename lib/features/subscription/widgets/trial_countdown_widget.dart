import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/subscription_provider.dart';

/// How the trial countdown should render.
///
/// - [compact]: bare timer text only, no chrome. Used in tight spots like the
///   dashboard header where surrounding UI already provides context.
/// - [detailed]: full styled chip with label, icon and bordered background.
///   Used on the subscription screen where the countdown is a focal point.
enum TrialCountdownStyle { compact, detailed }

class TrialCountdownWidget extends ConsumerStatefulWidget {
  const TrialCountdownWidget({
    super.key,
    this.style = TrialCountdownStyle.compact,
  });

  /// Convenience constructor for the full styled variant.
  const TrialCountdownWidget.detailed({super.key})
    : style = TrialCountdownStyle.detailed;

  final TrialCountdownStyle style;

  @override
  ConsumerState<TrialCountdownWidget> createState() =>
      _TrialCountdownWidgetState();
}

class _TrialCountdownWidgetState extends ConsumerState<TrialCountdownWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Trigger a rebuild every second so displayed time stays current
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Verbose labelled format, e.g. `5d : 3h : 2m : 4s` — subscription page.
  String _formatLabelled(Duration d) {
    if (d.inDays >= 1) {
      final h = d.inHours.remainder(24).toString().padLeft(2, '0');
      final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '${d.inDays}d : ${h}h : ${m}m : ${s}s';
    }
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${h}h : ${m}m : ${s}s';
  }

  /// Terse format, e.g. `5d:3:2:4` — homescreen header.
  String _formatTerse(Duration d) {
    final h = d.inHours.remainder(24);
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (d.inDays >= 1) {
      return '${d.inDays}d:$h:$m:$s';
    }
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final subAsync = ref.watch(subscriptionProvider);
    final info = subAsync.asData?.value;

    if (info == null || !info.isTrial) {
      return const SizedBox.shrink();
    }

    // Server-authoritative remaining time (immune to timezone parsing of the
    // naive trial_ends_at timestamp).
    final remaining = info.trialRemaining;
    if (remaining == null || remaining.inSeconds <= 0) {
      return const SizedBox.shrink();
    }

    final isUrgent = remaining.inHours < 24;
    final color = isUrgent ? Colors.red.shade400 : const Color(0xFFFF8C00);

    return GestureDetector(
      onTap: () => context.push('/profile/subscription'),
      child: widget.style == TrialCountdownStyle.detailed
          ? _buildDetailed(remaining, color, isUrgent)
          : _buildCompact(remaining, color),
    );
  }

  /// Bare timer text — used on the dashboard header (homepage).
  Widget _buildCompact(Duration remaining, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        _formatLabelled(remaining),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  /// Full styled chip with label, icon and bordered background — used on the
  /// subscription screen.
  Widget _buildDetailed(Duration remaining, Color color, bool isUrgent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isUrgent ? 0.2 : 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Free trial ends in',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 10, color: color),
              const SizedBox(width: 3),
              Text(
                _formatTerse(remaining),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
