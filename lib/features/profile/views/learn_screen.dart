import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../core/tutorial/tutorial_controller.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../dashboard/views/dashboard_screen.dart';

/// Learn — the replay surface for every guided tour, plus the "Show tips"
/// master switch. A tour is never gone: whatever the owner skipped or forgot
/// can be re-run from here, in his language, any time.
class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tut = ref.watch(tutorialProvider);
    final c = ref.read(tutorialProvider.notifier);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.learnTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.learnSubtitle,
            style: const TextStyle(color: BrandColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          _tourTile(
            context,
            icon: Icons.tour_rounded,
            title: l10n.learnReplayWelcome,
            replayLabel: l10n.learnReplay,
            onReplay: () {
              // Re-arm and land on Home, where the tour fires.
              c.replaySegment(Tut.welcome);
              ref.read(dashboardTabProvider.notifier).switchTab(0);
              context.go('/home');
            },
          ),
          _tourTile(
            context,
            icon: Icons.add_box_rounded,
            title: l10n.learnFlowAddProduct,
            replayLabel: l10n.learnReplay,
            onReplay: () {
              c.startFlow(Tut.flowAddProduct);
              ref.read(dashboardTabProvider.notifier).switchTab(2);
              ref.read(dashboardSubTabProvider.notifier).setSubTab(1);
              context.go('/home');
            },
          ),
          _tourTile(
            context,
            icon: Icons.point_of_sale_rounded,
            title: l10n.learnFlowFirstSale,
            replayLabel: l10n.learnReplay,
            onReplay: () {
              c.startFlow(Tut.flowFirstSale);
              ref.read(dashboardTabProvider.notifier).switchTab(2);
              ref.read(dashboardSubTabProvider.notifier).setSubTab(0);
              context.go('/home');
            },
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BrandColors.border),
            ),
            child: SwitchListTile(
              value: tut.enabled,
              onChanged: c.setEnabled,
              title: Text(
                l10n.learnShowTips,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                l10n.learnShowTipsDesc,
                style: const TextStyle(
                  fontSize: 12,
                  color: BrandColors.muted,
                ),
              ),
              activeThumbColor: BrandColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tourTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String replayLabel,
    required VoidCallback onReplay,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: BrandColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        trailing: FilledButton.tonal(
          onPressed: onReplay,
          child: Text(replayLabel),
        ),
        onTap: onReplay,
      ),
    );
  }
}
