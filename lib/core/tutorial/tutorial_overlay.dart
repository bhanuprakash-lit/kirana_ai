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
///
/// Steps run ONE AT A TIME, each preceded by [Scrollable.ensureVisible] on its
/// anchor: the dim overlay blocks scrolling, so a target below the fold (the
/// Save button at the end of a long form, a card further down the Home feed)
/// would otherwise be spotlit off-screen with no way to reach it.
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
  if (!steps.any((s) => s.targetKey.currentContext != null)) return;

  controller.setOverlayActive(true);
  _skipLabel = skipLabel ?? 'Skip';
  var finished = false;

  // tutorial_coach_mark can invoke onSkip DURING ITS OWN BUILD: when a
  // spotlighted anchor unmounts mid-tour (the tapped action replaced the
  // screen), _buildContents calls skip() synchronously. Provider writes are
  // illegal in the build phase, so all controller mutations here are deferred
  // by a microtask; `finished` still flips synchronously to stay re-entrant.
  void done({required bool skipped}) {
    if (finished) return;
    finished = true;
    Future.microtask(() {
      controller.setOverlayActive(false);
      if (skipped) {
        controller.skipFlow(id);
      } else {
        controller.markSeen(id);
        onFinish?.call();
      }
    });
  }

  // The screen may be disposed mid-tour (owner navigated away via a tapped
  // action, back button, deep link…). Stop without marking seen, so the
  // segment can fire again on the next visit.
  void abort() {
    if (finished) return;
    finished = true;
    Future.microtask(() => controller.setOverlayActive(false));
  }

  // The coach mark measures the target ONCE when it opens — if the anchor is
  // still moving (a FAB scaling in, a tab page settling, a scroll easing) the
  // spotlight lands where the widget *was*, off-target or even off-screen.
  // So: sample the anchor's global position until it holds still for a few
  // consecutive frames (or give up after ~2s and show anyway).
  Future<void> waitForStablePosition(GlobalKey key) async {
    Offset? last;
    var stableRuns = 0;
    for (var i = 0; i < 40; i++) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached || !box.hasSize) {
        stableRuns = 0;
        last = null;
      } else {
        final pos = box.localToGlobal(Offset.zero);
        if (last != null && (pos - last).distance < 0.5) {
          stableRuns++;
          if (stableRuns >= 3) return;
        } else {
          stableRuns = 0;
        }
        last = pos;
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  var index = 0;

  Future<void> showNext() async {
    // Skip anchors that aren't on this screen (vertical-gated tabs etc.).
    while (index < steps.length &&
        steps[index].targetKey.currentContext == null) {
      index++;
    }
    if (index >= steps.length) {
      done(skipped: false);
      return;
    }
    final step = steps[index];
    // No later mounted anchor ⇒ this is the closing step ("Got it").
    final isLast = !steps
        .skip(index + 1)
        .any((s) => s.targetKey.currentContext != null);

    // Bring the anchor into view before spotlighting it.
    final targetCtx = step.targetKey.currentContext;
    if (targetCtx != null) {
      try {
        await Scrollable.ensureVisible(
          targetCtx,
          alignment: 0.5,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      } catch (_) {
        // Not inside a scrollable / viewport quirk — spotlight where it is.
      }
      // Let the scroll/entrance animations settle so the focus ring lands on
      // the anchor's FINAL position, not where it was mid-animation.
      await waitForStablePosition(step.targetKey);
    }
    if (!context.mounted) {
      abort();
      return;
    }

    late final TutorialCoachMark mark;
    mark = TutorialCoachMark(
      targets: [
        _target(
          step,
          isLast: isLast,
          nextLabel: nextLabel ?? 'Next',
          doneLabel: doneLabel ?? 'OK',
          tapHint: tapHint,
        ),
      ],
      colorShadow: Colors.black,
      opacityShadow: 0.75,
      paddingFocus: 6,
      hideSkip: true, // we render our own skip inside the content card
      onClickTarget: (_) {
        if (step.tapTarget) {
          // Advancing finishes this mark; run the real action after the
          // overlay is gone so sheets/dialogs open cleanly.
          Future.microtask(() => step.onTapTarget?.call());
        }
      },
      onFinish: () {
        // Same build-phase hazard as onSkip: defer before touching providers
        // or inserting the next step's overlay.
        Future.microtask(() {
          index++;
          showNext();
        });
      },
      onSkip: () {
        done(skipped: true);
        return true;
      },
    );
    mark.show(context: context, rootOverlay: true);

    // Expose skip/next to the content card of the current step.
    _activeSkip = () => mark.skip();
    _activeNext = () => mark.next();
  }

  showNext();
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
