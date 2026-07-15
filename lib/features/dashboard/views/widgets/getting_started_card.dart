import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/core/vertical/nav_preset.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/tutorial/tutorial_controller.dart';
import '../../../../core/tutorial/tutorial_keys.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../../../pos_inventory/providers/pos_provider.dart';
import '../dashboard_screen.dart';

/// "Getting started" — five small tasks that walk a new owner through the app
/// by DOING them, each deep-linking into a guided flow. Steps complete from
/// real data (a product exists, a bill was made…), not from watching anything.
/// Auto-hides once everything is done or the owner dismisses it.
class GettingStartedCard extends ConsumerWidget {
  const GettingStartedCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tut = ref.watch(tutorialProvider);
    if (!tut.loaded || tut.checklistDismissed || tut.checklistComplete) {
      return const SizedBox.shrink();
    }

    // The first step ("add a product") completes from live inventory data —
    // also when the product was added outside the guided flow.
    final products = ref.watch(posProvider.select((s) => s.products));
    if (products.isNotEmpty && !tut.checklist.contains(Tut.ckProduct)) {
      Future.microtask(
        () => ref.read(tutorialProvider.notifier).markChecklist(Tut.ckProduct),
      );
    }

    final l10n = AppLocalizations.of(context);
    final done = tut.checklist;
    final doneCount =
        Tut.checklistSteps.where(done.contains).length +
        (products.isNotEmpty && !done.contains(Tut.ckProduct) ? 1 : 0);

    return Container(
      key: TutorialKeys.homeChecklist,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.primary.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: BrandColors.primary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, color: BrandColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.tutChecklistTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      l10n.tutChecklistSubtitle(
                        doneCount,
                        Tut.checklistSteps.length,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.tutDismiss,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: BrandColors.muted,
                ),
                onPressed: () =>
                    ref.read(tutorialProvider.notifier).dismissChecklist(),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _step(
            context,
            ref,
            done: done.contains(Tut.ckProduct) || products.isNotEmpty,
            icon: Icons.add_box_rounded,
            label: l10n.tutStepAddProduct,
            onTap: () {
              ref
                  .read(tutorialProvider.notifier)
                  .startFlow(Tut.flowAddProduct);
              switchToNavTab(ref, NavTabId.billing);
              ref.read(dashboardSubTabProvider.notifier).setSubTab(1);
            },
          ),
          _step(
            context,
            ref,
            done: done.contains(Tut.ckSale),
            icon: Icons.point_of_sale_rounded,
            label: l10n.tutStepFirstSale,
            onTap: () {
              ref.read(tutorialProvider.notifier).startFlow(Tut.flowFirstSale);
              switchToNavTab(ref, NavTabId.billing);
              ref.read(dashboardSubTabProvider.notifier).setSubTab(0);
            },
          ),
          _step(
            context,
            ref,
            done: done.contains(Tut.ckUdhaar),
            icon: Icons.menu_book_rounded,
            label: l10n.tutStepUdhaar,
            onTap: () {
              // Same guided sale — the payment step teaches choosing Udhaar.
              ref.read(tutorialProvider.notifier).startFlow(Tut.flowFirstSale);
              switchToNavTab(ref, NavTabId.billing);
              ref.read(dashboardSubTabProvider.notifier).setSubTab(0);
            },
          ),
          _step(
            context,
            ref,
            done: done.contains(Tut.ckReport),
            icon: Icons.insights_rounded,
            label: l10n.tutStepReport,
            onTap: () => _showReportTour(context, ref, l10n),
          ),
          _step(
            context,
            ref,
            done: done.contains(Tut.ckLanguage),
            icon: Icons.language_rounded,
            label: l10n.tutStepLanguage,
            onTap: () async {
              ref
                  .read(tutorialProvider.notifier)
                  .markChecklist(Tut.ckLanguage);
              await showLanguagePicker(context, ref);
            },
          ),
        ],
      ),
    );
  }

  /// Step 4 is learning, not doing: spotlight today's sales card and say what
  /// it tells him. Marked done once shown.
  void _showReportTour(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    ref.read(tutorialProvider.notifier).replaySegment(Tut.ckReportTour);
    showTutorialSegment(
      context,
      ref,
      id: Tut.ckReportTour,
      steps: [
        TutStep(
          targetKey: TutorialKeys.homeTodaySales,
          title: l10n.tutReportTitle,
          body: l10n.tutReportBody,
          shape: ShapeLightFocus.RRect,
        ),
      ],
      nextLabel: l10n.tutNext,
      doneLabel: l10n.tutDone,
      skipLabel: l10n.tutSkip,
      onFinish: () =>
          ref.read(tutorialProvider.notifier).markChecklist(Tut.ckReport),
    );
  }

  Widget _step(
    BuildContext context,
    WidgetRef ref, {
    required bool done,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: done ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
        child: Row(
          children: [
            Icon(
              done ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 20,
              color: done ? BrandColors.success : BrandColors.muted,
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              size: 18,
              color: done ? BrandColors.muted : BrandColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: done ? BrandColors.muted : BrandColors.ink,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (!done)
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: BrandColors.muted,
              ),
          ],
        ),
      ),
    );
  }
}
