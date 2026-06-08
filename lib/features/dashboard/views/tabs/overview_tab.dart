import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/models/alert_model.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../../shared/providers/alert_provider.dart';
import '../../../../shared/views/notifications_screen.dart';
import '../../../../shared/widgets/notification_bell.dart';
import '../../../subscription/models/subscription_model.dart';
import '../../../subscription/providers/subscription_provider.dart';
import '../../../subscription/widgets/trial_countdown_widget.dart';
import '../../models/overview_models.dart';
import '../../providers/kpi_provider.dart';
import '../../providers/overview_provider.dart';
import '../dashboard_screen.dart';

class OverviewTab extends ConsumerStatefulWidget {
  const OverviewTab({super.key});

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
  String _fullName = '';
  String _storeName = '';

  @override
  void initState() {
    super.initState();
    _loadLocalUser();
  }

  Future<void> _loadLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _fullName = prefs.getString('full_name') ?? '';
        _storeName = prefs.getString('store_name') ?? '';
      });
    }
  }

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return _l10n.dashGreetingMorning;
    if (h < 17) return _l10n.dashGreetingAfternoon;
    return _l10n.dashGreetingEvening;
  }

  String get _dateLabel {
    final now = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(overviewProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'overview_pos_fab',
        onPressed: () {
          ref.read(dashboardTabProvider.notifier).switchTab(2);
          ref.read(dashboardSubTabProvider.notifier).setSubTab(0);
        },
        backgroundColor: BrandColors.primary,
        icon: const Icon(Icons.point_of_sale_rounded, color: Colors.white),
        label: Text(
          l10n.dashNewSale,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(overviewProvider.notifier).refresh(),
        color: BrandColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _GreetingHeader(
                greeting: _greeting,
                fullName: _fullName,
                storeName: _storeName,
                dateLabel: _dateLabel,
              ),
            ),
            asyncData.when(
              loading: () => const SliverToBoxAdapter(child: OverviewShimmer()),
              error: (err, _) => SliverFillRemaining(
                child: _ErrorView(
                  message: err.toString(),
                  onRetry: () => ref.read(overviewProvider.notifier).refresh(),
                ),
              ),
              data: (data) => SliverList(
                delegate: SliverChildListDelegate([
                  _MorningBriefingRibbon(reco: data.recommendations),
                  const _ProAlertsStrip(),
                  _IntelligenceStrip(reco: data.recommendations),
                  const SizedBox(height: 24),
                  _TodaySalesCard(sales: data.dailySales),
                  const SizedBox(height: 16),
                  const _KpiSummaryRow(),
                  const SizedBox(height: 16),
                  _StoreOverviewCard(store: data.store),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MorningBriefingRibbon extends ConsumerWidget {
  final RecommendationSummary reco;
  const _MorningBriefingRibbon({required this.reco});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (reco.highRiskSkus == 0 && reco.reorderCandidates == 0) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        ref.read(dashboardTabProvider.notifier).switchTab(2);
        ref
            .read(dashboardSubTabProvider.notifier)
            .setSubTab(1); // Go to Inventory
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(22, 20, 22, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              BrandColors.primary.withValues(alpha: 0.08),
              BrandColors.accent.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: BrandColors.primary.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: BrandColors.primary.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: BrandColors.primary.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: BrandColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dashMorningBriefing,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: BrandColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.dashBriefingBody(
                      reco.highRiskSkus,
                      reco.reorderCandidates,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.ink,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0);
  }
}

class _GreetingHeader extends ConsumerWidget {
  final String greeting;
  final String fullName;
  final String storeName;
  final String dateLabel;

  const _GreetingHeader({
    required this.greeting,
    required this.fullName,
    required this.storeName,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final firstName = fullName.split(' ').first;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BrandColors.primary, Color(0xFF1E3A5F)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                              l10n.dashGreetingWithName(greeting, firstName),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.white, fontSize: 20),
                            )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideX(begin: -0.1, end: 0),
                        const SizedBox(height: 4),
                        Text(
                          dateLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 13,
                              ),
                        ).animate(delay: 60.ms).fadeIn(duration: 400.ms),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Trial countdown (shown only during trial)
                  const TrialCountdownWidget(),
                  const SizedBox(width: 8),

                  // 1️⃣ Notifications first
                  const NotificationBell(color: Colors.white),
                  const SizedBox(width: 8),

                  // 2️⃣ Profile circular button
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntelligenceStrip extends StatelessWidget {
  final RecommendationSummary reco;
  const _IntelligenceStrip({required this.reco});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final metrics = [
      _Metric(
        id: 'stockout',
        label: l10n.dashMetricStockoutLabel,
        sublabel: l10n.dashMetricStockoutSub,
        count: reco.highRiskSkus,
        icon: Icons.warning_amber_rounded,
        color: BrandColors.error,
      ),
      _Metric(
        id: 'reorder',
        label: l10n.dashMetricReorderLabel,
        sublabel: l10n.dashMetricReorderSub,
        count: reco.reorderCandidates,
        icon: Icons.refresh_rounded,
        color: BrandColors.accent,
      ),
      _Metric(
        id: 'fast_moving',
        label: l10n.dashMetricFastLabel,
        sublabel: l10n.dashMetricFastSub,
        count: reco.fastMovingSkus,
        icon: Icons.trending_up_rounded,
        color: BrandColors.success,
      ),
      _Metric(
        id: 'profit',
        label: l10n.dashMetricProfitLabel,
        sublabel: l10n.dashMetricProfitSub,
        count: reco.profitOpportunities,
        icon: Icons.stars_rounded,
        color: BrandColors.primary,
      ),
      _Metric(
        id: 'customer',
        label: l10n.dashMetricCustomerLabel,
        sublabel: l10n.dashMetricCustomerSub,
        count: reco.customerInsights,
        icon: Icons.people_outline_rounded,
        color: Colors.indigo,
      ),
      _Metric(
        id: 'sales',
        label: l10n.dashMetricSalesLabel,
        sublabel: l10n.dashMetricSalesSub,
        count: reco.salesInsights,
        icon: Icons.shopping_bag_outlined,
        color: Colors.teal,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 3),
          child: Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 16,
                color: BrandColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.dashIntelligence,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              // Give cells proportionally more height as the system font scales
              // up, so the count + labels never overflow on large display sizes.
              childAspectRatio:
                  1.2 /
                  MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.4),
            ),
            itemCount: metrics.length,
            itemBuilder: (context, i) =>
                _MetricCard(metric: metrics[i], index: i),
          ),
        ),
      ],
    );
  }
}

class _Metric {
  final String id;
  final String label;
  final String sublabel;
  final int count;
  final IconData icon;
  final Color color;
  const _Metric({
    required this.id,
    required this.label,
    required this.sublabel,
    required this.count,
    required this.icon,
    required this.color,
  });
}

class _MetricCard extends ConsumerWidget {
  final _Metric metric;
  final int index;
  const _MetricCard({required this.metric, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
          onTap: () {
            if (metric.id == 'customer') {
              ref.read(dashboardTabProvider.notifier).switchTab(1); // Finance
              ref
                  .read(financeSubTabProvider.notifier)
                  .setSubTab(1); // Customer Udhaar
            } else if (metric.id == 'sales') {
              context.push('/pos-history');
            } else {
              context.push('/intelligence-detail/${metric.id}');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: BrandColors.border.withValues(alpha: 0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: metric.color.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 3.5, color: metric.color),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                metric.count.toString(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: metric.color,
                                  height: 1,
                                ),
                              ),
                              Icon(metric.icon, size: 14, color: metric.color),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            metric.label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: BrandColors.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            metric.sublabel,
                            style: const TextStyle(
                              fontSize: 9,
                              color: BrandColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

class _TodaySalesCard extends StatelessWidget {
  final DailySales? sales;
  const _TodaySalesCard({required this.sales});

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.today_rounded,
                size: 14,
                color: BrandColors.muted,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.dashTodaysPerformance,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: BrandColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: BrandColors.border.withValues(alpha: 0.8),
                  ),
                ),
                child: sales == null
                    ? _NoDataRow(
                        message: l10n.dashPosNotAvailable,
                        icon: Icons.point_of_sale_outlined,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 9,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SalesStat(
                              value: _fmt(sales!.totalSales),
                              label: l10n.dashStatRevenue,
                              color: BrandColors.success,
                              icon: Icons.currency_rupee_rounded,
                            ),
                            _VerticalDivider(),
                            _SalesStat(
                              value: sales!.totalOrders.toString(),
                              label: l10n.dashStatOrders,
                              color: BrandColors.primary,
                              icon: Icons.receipt_long_rounded,
                            ),
                            _VerticalDivider(),
                            _SalesStat(
                              value: _fmt(sales!.avgOrderValue),
                              label: l10n.dashStatAvgOrder,
                              color: BrandColors.accent,
                              icon: Icons.shopping_bag_outlined,
                            ),
                          ],
                        ),
                      ),
              )
              .animate(delay: 200.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

class _SalesStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _SalesStat({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: BrandColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: BrandColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 48, width: 1, color: BrandColors.border);
}

class _StoreOverviewCard extends StatelessWidget {
  final StoreInfo store;
  const _StoreOverviewCard({required this.store});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.storefront_outlined,
                size: 16,
                color: BrandColors.muted,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.dashStoreOverview,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: BrandColors.border),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [BrandColors.primary, Color(0xFF3730A3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store.storeName,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: BrandColors.accent.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  store.storeType.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: BrandColors.accent,
                                        letterSpacing: 0.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _StoreStat(
                          icon: Icons.inventory_2_outlined,
                          value: store.skuCount.toString(),
                          label: l10n.dashStoreSkus,
                        ),
                        _VerticalDivider(),
                        _StoreStat(
                          icon: Icons.people_outline_rounded,
                          value: store.footfall.toString(),
                          label: l10n.dashStoreFootfall,
                        ),
                        _VerticalDivider(),
                        _StoreStat(
                          icon: Icons.account_balance_wallet_outlined,
                          value: store.dailyBudget > 0
                              ? '₹${(store.dailyBudget / 1000).toStringAsFixed(1)}K'
                              : '—',
                          label: l10n.dashStoreDailyBudget,
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate(delay: 300.ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

class _StoreStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StoreStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: BrandColors.muted),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NoDataRow extends StatelessWidget {
  final String message;
  final IconData icon;
  const _NoDataRow({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: BrandColors.muted),
          const SizedBox(width: 10),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: BrandColors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.dashCouldNotLoad,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.dashRetry),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pro alerts strip (home screen) ───────────────────────────────────────────

class _ProAlertsStrip extends ConsumerWidget {
  const _ProAlertsStrip();

  static const _typeColor = {
    AlertType.lowStock: Color(0xFFEF4444),
    AlertType.expiry: Color(0xFFF97316),
    AlertType.udhaar: Color(0xFF8B5CF6),
    AlertType.performance: Color(0xFF3B82F6),
    AlertType.subscription: Color(0xFF10B981),
  };

  void _navigate(BuildContext context, WidgetRef ref, BusinessAlert alert) {
    switch (alert.type) {
      case AlertType.udhaar:
        ref.read(dashboardTabProvider.notifier).switchTab(1); // Finance
        ref
            .read(financeSubTabProvider.notifier)
            .setSubTab(1); // Customer Udhaar tab
      case AlertType.performance:
        ref.read(dashboardTabProvider.notifier).switchTab(1); // Finance
        ref
            .read(financeSubTabProvider.notifier)
            .setSubTab(2); // Supplier Udhaar tab
      case AlertType.lowStock:
      case AlertType.expiry:
        ref.read(dashboardTabProvider.notifier).switchTab(2); // POS/Inventory
        ref
            .read(dashboardSubTabProvider.notifier)
            .setSubTab(1); // Inventory sub-tab
      case AlertType.subscription:
        context.push('/profile/subscription');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(subTierProvider);
    if (tier != SubTier.pro) return const SizedBox.shrink();

    final alerts = ref.watch(alertProvider);
    final visible = alerts
        .where(
          (a) =>
              a.priority == AlertPriority.high ||
              a.priority == AlertPriority.medium,
        )
        .take(8)
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 16, 8),
            child: Row(
              children: [
                Text(
                  l10n.dashAlerts,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: BrandColors.muted,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  ),
                  child: Text(
                    l10n.dashSeeAll,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              itemCount: visible.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final alert = visible[i];
                final color = _typeColor[alert.type] ?? BrandColors.primary;
                final isHigh = alert.priority == AlertPriority.high;
                return GestureDetector(
                  onTap: () => _navigate(context, ref, alert),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isHigh ? 0.12 : 0.07),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withValues(alpha: isHigh ? 0.4 : 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(alert.icon, size: 13, color: color),
                        const SizedBox(width: 5),
                        Text(
                          alert.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── KPI Summary Row ───────────────────────────────────────────────────────────

class _KpiSummaryRow extends ConsumerStatefulWidget {
  const _KpiSummaryRow();

  @override
  ConsumerState<_KpiSummaryRow> createState() => _KpiSummaryRowState();
}

class _KpiSummaryRowState extends ConsumerState<_KpiSummaryRow> {
  final _sc = ScrollController();
  bool _showLeft = false;
  bool _showRight = true;

  @override
  void initState() {
    super.initState();
    _sc.addListener(_update);
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  void _update() {
    if (!_sc.hasClients) return;
    final pos = _sc.position;
    final newLeft = pos.pixels > 4;
    final newRight = pos.pixels < pos.maxScrollExtent - 4;
    if (newLeft != _showLeft || newRight != _showRight) {
      setState(() {
        _showLeft = newLeft;
        _showRight = newRight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncKpis = ref.watch(kpiCardsProvider);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
          child: Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 16,
                color: BrandColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.dashStoreKpis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        asyncKpis.when(
          loading: () => SizedBox(
            height: 88,
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE5E7EB),
              highlightColor: const Color(0xFFF9FAFB),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, __) => Container(
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (cards) {
            if (cards.isEmpty) return const SizedBox.shrink();
            WidgetsBinding.instance.addPostFrameCallback((_) => _update());
            return Stack(
              children: [
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    controller: _sc,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    scrollDirection: Axis.horizontal,
                    itemCount: cards.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => _KpiMiniCard(card: cards[i]),
                  ),
                ),
                if (_showLeft)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _sc.animateTo(
                        _sc.offset - 200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              BrandColors.background,
                              BrandColors.background.withValues(alpha: 0),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: BrandColors.muted,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_showRight)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _sc.animateTo(
                        _sc.offset + 200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              BrandColors.background.withValues(alpha: 0),
                              BrandColors.background,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: BrandColors.muted,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _KpiMiniCard extends StatelessWidget {
  final KpiCard card;
  const _KpiMiniCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final isUp = card.direction == 'up';
    final isDown = card.direction == 'down';
    final trendColor = isUp
        ? BrandColors.success
        : isDown
        ? BrandColors.error
        : BrandColors.muted;
    final trendIcon = isUp
        ? Icons.arrow_upward_rounded
        : isDown
        ? Icons.arrow_downward_rounded
        : Icons.remove_rounded;

    return Container(
      width: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            card.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: BrandColors.muted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  card.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Profit-confidence dot: margin is based on only part of sales.
              if (card.coveragePct != null && card.coveragePct! < 90) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: AppLocalizations.of(context).dashKpiCoverageTooltip(
                    card.coveragePct!.toStringAsFixed(0),
                  ),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE87722),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              Icon(trendIcon, size: 12, color: trendColor),
              const SizedBox(width: 3),
              Text(
                card.pctChange != null
                    ? '${card.pctChange!.abs().toStringAsFixed(1)}%'
                    : '—',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: trendColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
