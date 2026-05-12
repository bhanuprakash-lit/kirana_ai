import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pos_inventory/views/pos_inventory_screen.dart';
import '../../finance/views/finance_screen.dart';
import '../../support/providers/notification_provider.dart';
import 'tabs/overview_tab.dart';

// Drives the selected tab across the whole dashboard
class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void switchTab(int index) => state = index;
}

final dashboardTabProvider =
    NotifierProvider<TabNotifier, int>(TabNotifier.new);

// Drives the selected sub-tab (e.g., POS vs Inventory)
class SubTabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setSubTab(int index) => state = index;
}

final dashboardSubTabProvider =
    NotifierProvider<SubTabNotifier, int>(SubTabNotifier.new);

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications and FCM token collection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(dashboardTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: const [
          OverviewTab(),
          FinanceScreen(),
          PosInventoryScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: (i) =>
            ref.read(dashboardTabProvider.notifier).switchTab(i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Finance',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale_rounded),
            label: 'POS',
          ),
        ],
      ),
    );
  }
}
