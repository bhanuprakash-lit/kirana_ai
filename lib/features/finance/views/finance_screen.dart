import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../features/dashboard/views/dashboard_screen.dart'
    show financeSubTabProvider;
import '../models/finance_models.dart';
import '../providers/finance_provider.dart';
import 'tabs/udhaar_tab.dart';
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

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(financeProvider);

    ref.listen(financeSubTabProvider, (prev, next) {
      if (next != _tabController.index) {
        _tabController.animateTo(next.clamp(0, 2));
      }
    });

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Finance'),
        actions: const [NotificationBell(), SizedBox(width: 8)],
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
                error: (_, _) => const SizedBox(
                  height: 40,
                  child: Center(child: Text('Error loading stats')),
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
                tabs: const [
                  Tab(text: 'Cashflow'),
                  Tab(
                    height: 44,
                    child: Text(
                      'Customer\nUdhaar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, height: 1.2),
                    ),
                  ),
                  Tab(text: 'Supplier Udhaar'),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: "Monthly Sales",
            value: "₹${stats.monthlySalesAmount.toStringAsFixed(0)}",
            icon: Icons.currency_rupee_rounded,
            color: BrandColors.success,
          ),
          _StatItem(
            label: "Monthly SKUs",
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
          const Text(
            'Will be available in future updates',
            style: TextStyle(color: BrandColors.muted),
          ),
        ],
      ),
    );
  }
}
