import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../core/tutorial/tutorial_controller.dart';
import '../../../core/tutorial/tutorial_keys.dart';
import '../../../core/tutorial/tutorial_overlay.dart';
import '../../../features/dashboard/views/dashboard_screen.dart'
    show financeSubTabProvider;
import '../models/finance_models.dart';
import '../providers/finance_provider.dart';
// import 'tabs/udhaar_tab.dart';
import 'tabs/udhaar_tab_new.dart';
import 'tabs/cashflow_tab.dart';
import 'tabs/distributor_tab.dart';
import '../../../shared/widgets/notification_bell.dart';
import '../../../shared/widgets/shimmer_widgets.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(financeSubTabProvider).clamp(0, 2);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialTab,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(financeSubTabProvider.notifier)
            .setSubTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// First-visit orientation: what the three khata tabs mean. Replayable
  /// from the ? button above and the Learn screen.
  void _maybeIntroTour() {
    if (!mounted) return;
    final c = ref.read(tutorialProvider.notifier);
    if (!c.shouldShow(Tut.khataIntro)) return;
    final l10n = AppLocalizations.of(context);
    showTutorialSegment(
      context,
      ref,
      id: Tut.khataIntro,
      steps: [
        TutStep(
          targetKey: TutorialKeys.finTabUdhaar,
          title: l10n.tutKhataUdhaarTitle,
          body: l10n.tutKhataUdhaarBody,
        ),
        TutStep(
          targetKey: TutorialKeys.finTabCashflow,
          title: l10n.tutKhataCashflowTitle,
          body: l10n.tutKhataCashflowBody,
        ),
        TutStep(
          targetKey: TutorialKeys.finTabSupplier,
          title: l10n.tutKhataSupplierTitle,
          body: l10n.tutKhataSupplierBody,
        ),
      ],
      nextLabel: l10n.tutNext,
      doneLabel: l10n.tutDone,
      skipLabel: l10n.tutSkip,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(tutorialProvider.select((s) => s.loaded));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), _maybeIntroTour);
    });

    final asyncData = ref.watch(financeProvider);
    final l10n = AppLocalizations.of(context);

    ref.listen(financeSubTabProvider, (prev, next) {
      if (next != _tabController.index) {
        _tabController.animateTo(next.clamp(0, 2));
      }
    });

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.dashNavKhata),
        actions: [
          IconButton(
            tooltip: l10n.learnTitle,
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              ref
                  .read(tutorialProvider.notifier)
                  .replaySegment(Tut.khataIntro);
              _maybeIntroTour();
            },
          ),
          const NotificationBell(),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              asyncData.when(
                data: (data) => _MonthlySalesOverview(stats: data.stats),
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: CardShimmer(height: 40, radius: 12),
                ),
                error: (_, _) => SizedBox(
                  height: 40,
                  child: Center(child: Text(l10n.finErrorLoadingStats)),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: BrandColors.primary,
                labelColor: BrandColors.primary,
                unselectedLabelColor: BrandColors.muted,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: [
                  Tab(
                    key: TutorialKeys.finTabCashflow,
                    text: l10n.finTabCashflow,
                  ),
                  Tab(
                    key: TutorialKeys.finTabUdhaar,
                    height: 44,
                    child: Text(
                      l10n.finTabCustomerUdhaar,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, height: 1.2),
                    ),
                  ),
                  Tab(
                    key: TutorialKeys.finTabSupplier,
                    text: l10n.finTabSupplierUdhaar,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [CashflowTab(), UdhaarTab(), DistributorTab()],
      ),
    );
  }
}

class _MonthlySalesOverview extends StatelessWidget {
  final FinanceStats stats;
  const _MonthlySalesOverview({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: l10n.finMonthlySales,
            value: "₹${stats.monthlySalesAmount.toStringAsFixed(0)}",
            icon: Icons.currency_rupee_rounded,
            color: BrandColors.success,
          ),
          _StatItem(
            label: l10n.finMonthlySkus,
            value: "${stats.monthlySkuCount}",
            icon: Icons.inventory_2_outlined,
            color: BrandColors.primary,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: BrandColors.ink,
          ),
        ),
      ],
    );
  }
}

// ignore: unused_element
class _UnderConstruction extends StatelessWidget {
  final String label;
  const _UnderConstruction({required this.label});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.construction_rounded,
            size: 48,
            color: BrandColors.muted,
          ),
          const SizedBox(height: 16),
          Text(label, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            l10n.finAvailableInFuture,
            style: const TextStyle(color: BrandColors.muted),
          ),
        ],
      ),
    );
  }
}
