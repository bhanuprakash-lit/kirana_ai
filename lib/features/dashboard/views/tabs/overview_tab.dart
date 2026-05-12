import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/notification_bell.dart';
import '../../models/overview_models.dart';
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

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
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
        label: const Text(
          'New Sale',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverFillRemaining(
                child: _ErrorView(
                  message: err.toString(),
                  onRetry: () => ref.read(overviewProvider.notifier).refresh(),
                ),
              ),
              data: (data) => SliverList(
                delegate: SliverChildListDelegate([
                  _MorningBriefingRibbon(reco: data.recommendations),
                  _IntelligenceStrip(reco: data.recommendations),
                  const SizedBox(height: 24),
                  _TodaySalesCard(sales: data.dailySales),
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
                  const Text(
                    'MORNING BRIEFING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: BrandColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You have ${reco.highRiskSkus} SKUs at critical risk and ${reco.reorderCandidates} items to reorder today. Tap to fix.',
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            '$greeting, \n$firstName',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.white, fontSize: 20),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 4),
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 13,
                        ),
                      ).animate(delay: 60.ms).fadeIn(duration: 400.ms),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
                  const SizedBox(width: 8),
                  const NotificationBell(color: Colors.white),
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
    final metrics = [
      _Metric(
        id: 'stockout',
        label: 'Stockout Risk',
        sublabel: 'SKUs critical',
        count: reco.highRiskSkus,
        icon: Icons.warning_amber_rounded,
        color: BrandColors.error,
      ),
      _Metric(
        id: 'reorder',
        label: 'Reorder Now',
        sublabel: 'SKUs low stock',
        count: reco.reorderCandidates,
        icon: Icons.refresh_rounded,
        color: BrandColors.accent,
      ),
      _Metric(
        id: 'fast_moving',
        label: 'Fast Moving',
        sublabel: 'Top sellers',
        count: reco.fastMovingSkus,
        icon: Icons.trending_up_rounded,
        color: BrandColors.success,
      ),
      _Metric(
        id: 'profit',
        label: 'Profit Picks',
        sublabel: 'Opportunities',
        count: reco.profitOpportunities,
        icon: Icons.stars_rounded,
        color: BrandColors.primary,
      ),
      _Metric(
        id: 'customer',
        label: 'Customer Dues',
        sublabel: 'Pending khata',
        count: reco.customerInsights,
        icon: Icons.people_outline_rounded,
        color: Colors.indigo,
      ),
      _Metric(
        id: 'sales',
        label: 'Items Sold',
        sublabel: 'Today so far',
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
                'Intelligence',
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
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
                      padding: const EdgeInsets.all(12),
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
              const Text(
                "Today's Performance",
                style: TextStyle(
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
                        message: 'POS data not available',
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
                              label: 'Revenue',
                              color: BrandColors.success,
                              icon: Icons.currency_rupee_rounded,
                            ),
                            _VerticalDivider(),
                            _SalesStat(
                              value: sales!.totalOrders.toString(),
                              label: 'Orders',
                              color: BrandColors.primary,
                              icon: Icons.receipt_long_rounded,
                            ),
                            _VerticalDivider(),
                            _SalesStat(
                              value: _fmt(sales!.avgOrderValue),
                              label: 'Avg order',
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
                'Store Overview',
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
                          label: 'SKUs',
                        ),
                        _VerticalDivider(),
                        _StoreStat(
                          icon: Icons.people_outline_rounded,
                          value: store.footfall.toString(),
                          label: 'Daily footfall',
                        ),
                        _VerticalDivider(),
                        _StoreStat(
                          icon: Icons.account_balance_wallet_outlined,
                          value: store.dailyBudget > 0
                              ? '₹${(store.dailyBudget / 1000).toStringAsFixed(1)}K'
                              : '—',
                          label: 'Daily budget',
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
              'Could not load data',
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
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
