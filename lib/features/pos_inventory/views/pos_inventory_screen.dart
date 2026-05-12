import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/shared/widgets/notification_bell.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/pos_provider.dart';
import 'inventory_tab.dart';
import 'pos_tab.dart';
import 'tabs/procurement_tab.dart';
import '../../dashboard/views/dashboard_screen.dart';

class PosInventoryScreen extends ConsumerStatefulWidget {
  const PosInventoryScreen({super.key});

  @override
  ConsumerState<PosInventoryScreen> createState() =>
      _PosInventoryScreenState();
}

class _PosInventoryScreenState extends ConsumerState<PosInventoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(dashboardSubTabProvider);
    _tabController = TabController(length: 3, vsync: this, initialIndex: initialTab.clamp(0, 2));
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(dashboardSubTabProvider.notifier).setSubTab(_tabController.index);
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
    final posState = ref.watch(posProvider);
    final posOnline = posState.error == null;

    // Sync from provider if changed externally
    ref.listen(dashboardSubTabProvider, (prev, next) {
      if (next != _tabController.index) {
        _tabController.animateTo(next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('POS / Inventory'),
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: posOnline
                    ? BrandColors.success.withValues(alpha: 0.12)
                    : BrandColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: posOnline
                          ? BrandColors.success
                          : BrandColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    posOnline ? 'POS Online' : 'POS Offline',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: posOnline
                          ? BrandColors.success
                          : BrandColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: const [
          NotificationBell(),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: BrandColors.primary,
          unselectedLabelColor: BrandColors.muted,
          indicatorColor: BrandColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.point_of_sale_rounded), text: 'Sales'),
            Tab(icon: Icon(Icons.inventory_2_rounded), text: 'Inventory'),
            Tab(icon: Icon(Icons.local_shipping_rounded), text: 'Procure'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          PosTab(),
          InventoryTab(),
          ProcurementTab(),
        ],
      ),
    );
  }
}
