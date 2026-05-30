import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/subscription_provider.dart';

class TrialCountdownWidget extends ConsumerStatefulWidget {
  const TrialCountdownWidget({super.key});

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

  String _formatDuration(Duration d) {
    if (d.inDays >= 1) {
      final h = d.inHours.remainder(24).toString().padLeft(2, '0');
      final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '${d.inDays}d $h:$m:$s';
    }
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final subAsync = ref.watch(subscriptionProvider);
    final info = subAsync.asData?.value;

    if (info == null || !info.isTrial || info.trialEndsAt == null) {
      return const SizedBox.shrink();
    }

    final remaining = info.trialEndsAt!.difference(DateTime.now());
    if (remaining.isNegative) return const SizedBox.shrink();

    final isUrgent = remaining.inHours < 24;
    final color = isUrgent ? Colors.red.shade400 : const Color(0xFFFF8C00);

    return GestureDetector(
      onTap: () => context.push('/profile/subscription'),
      child: Container(
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
                  _formatDuration(remaining),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
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
