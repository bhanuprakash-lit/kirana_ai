import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../theme/brand_theme.dart';
import 'tutorial_controller.dart';

// Step declarations at call sites need these two enums; re-export so screens
// only import the tutorial engine, not the package.
export 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show ContentAlign, ShapeLightFocus;

/// One spotlight step of a guided tour.
///
/// Two kinds:
///  - info step: explains the highlighted control; a Next/Got-it button (and
///    tapping the highlight) advances.
///  - action step ([tapTarget] true): the owner must tap the highlighted
///    control itself; [onTapTarget] then performs the REAL action (open the
///    sheet, start checkout…) so the tutorial *is* the task, not a slideshow.
class TutStep {
  final GlobalKey targetKey;
  final String title;
  final String body;
  final bool tapTarget;
  final VoidCallback? onTapTarget;
  final ShapeLightFocus shape;
  final ContentAlign align;

  const TutStep({
    required this.targetKey,
    required this.title,
    required this.body,
    this.tapTarget = false,
    this.onTapTarget,
    this.shape = ShapeLightFocus.RRect,
    this.align = ContentAlign.bottom,
  });
}

/// Show one tour segment. Steps whose anchor isn't mounted are dropped; if
/// nothing is mounted the segment doesn't fire (and stays un-seen, so it can
/// retry on a later visit). Marks the segment seen on finish; Skip abandons
/// the whole guided flow — "leave me alone" must mean it.
void showTutorialSegment(
  BuildContext context,
  WidgetRef ref, {
  required String id,
  required List<TutStep> steps,
  String? nextLabel,
  String? doneLabel,
  String? skipLabel,
  String? tapHint,
  VoidCallback? onFinish,
}) {
  final controller = ref.read(tutorialProvider.notifier);
  final mounted = [
    for (final s in steps)
      if (s.targetKey.currentContext != null) s,
  ];
  if (mounted.isEmpty) return;

  controller.setOverlayActive(true);
  var finished = false;

  void done({required bool skipped}) {
    if (finished) return;
    finished = true;
    controller.setOverlayActive(false);
    if (skipped) {
      controller.skipFlow(id);
    } else {
      controller.markSeen(id);
      onFinish?.call();
    }
  }

  late final TutorialCoachMark mark;
  mark = TutorialCoachMark(
    targets: [
      for (var i = 0; i < mounted.length; i++)
        _target(
          mounted[i],
          isLast: i == mounted.length - 1,
          nextLabel: nextLabel ?? 'Next',
          doneLabel: doneLabel ?? 'OK',
          tapHint: tapHint,
        ),
    ],
    colorShadow: Colors.black,
    opacityShadow: 0.75,
    paddingFocus: 6,
    hideSkip: true, // we render our own skip inside the content card
    onClickTarget: (t) {
      final step = mounted.firstWhere((s) => s.targetKey == t.keyTarget);
      if (step.tapTarget) {
        // Advancing past the last target finishes the mark; run the real
        // action after the overlay is gone so sheets/dialogs open cleanly.
        Future.microtask(() => step.onTapTarget?.call());
      }
    },
    onFinish: () => done(skipped: false),
    onSkip: () {
      done(skipped: true);
      return true;
    },
  );
  mark.show(context: context, rootOverlay: true);

  // Expose skip to the content cards.
  _activeSkip = () => mark.skip();
  _activeNext = () => mark.next();
  _skipLabel = skipLabel ?? 'Skip';
}

// The content builders need to drive the coach mark; tutorial_coach_mark's
// TargetContent builder hands us its controller, but wiring the skip label &
// callbacks through one module-level slot keeps the step declarations terse.
VoidCallback? _activeSkip;
VoidCallback? _activeNext;
String _skipLabel = 'Skip';

TargetFocus _target(
  TutStep step, {
  required bool isLast,
  required String nextLabel,
  required String doneLabel,
  String? tapHint,
}) {
  return TargetFocus(
    identify: step.targetKey.toString(),
    keyTarget: step.targetKey,
    shape: step.shape,
    radius: 14,
    enableTargetTab: true,
    enableOverlayTab: false,
    contents: [
      TargetContent(
        align: step.align,
        builder: (context, _) => _StepCard(
          title: step.title,
          body: step.body,
          actionHint: step.tapTarget ? tapHint : null,
          nextLabel: isLast ? doneLabel : nextLabel,
          // Action steps advance by tapping the real control, so no Next.
          onNext: step.tapTarget ? null : () => _activeNext?.call(),
          onSkip: () => _activeSkip?.call(),
        ),
      ),
    ],
  );
}

class _StepCard extends StatelessWidget {
  final String title;
  final String body;
  final String? actionHint;
  final String nextLabel;
  final VoidCallback? onNext;
  final VoidCallback onSkip;

  const _StepCard({
    required this.title,
    required this.body,
    required this.actionHint,
    required this.nextLabel,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: BrandColors.ink,
            ),
          ),
          if (actionHint != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.touch_app_rounded,
                  size: 18,
                  color: BrandColors.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    actionHint!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkip,
                child: Text(
                  _skipLabel,
                  style: const TextStyle(color: BrandColors.muted),
                ),
              ),
              if (onNext != null)
                FilledButton(onPressed: onNext, child: Text(nextLabel)),
            ],
          ),
        ],
      ),
    );
  }
}
