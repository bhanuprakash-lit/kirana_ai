import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/shared/widgets/notification_bell.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/pos_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import 'inventory_tab.dart';
import 'pos_tab.dart';
import 'tabs/procurement_tab.dart';
import '../../dashboard/views/dashboard_screen.dart';

class PosInventoryScreen extends ConsumerStatefulWidget {
  const PosInventoryScreen({super.key});

  @override
  ConsumerState<PosInventoryScreen> createState() => _PosInventoryScreenState();
}

class _PosInventoryScreenState extends ConsumerState<PosInventoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(dashboardSubTabProvider);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialTab.clamp(0, 2),
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref
            .read(dashboardSubTabProvider.notifier)
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
        actions: const [NotificationBell(), SizedBox(width: 8)],
        bottom: TabBar(
          controller: _tabController,
          labelColor: BrandColors.primary,
          unselectedLabelColor: BrandColors.muted,
          indicatorColor: BrandColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.point_of_sale_rounded), text: 'Billing'),
            Tab(icon: Icon(Icons.inventory_2_rounded), text: 'Stock'),
            Tab(icon: Icon(Icons.local_shipping_rounded), text: 'Purchase'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const PosTab(),
          const InventoryTab(),
          // Gate: only Pro users see Procurement
          Consumer(
            builder: (ctx, ref, _) {
              final sub = ref.watch(subInfoProvider);
              if (sub.canAccessVendorManagement) return const ProcurementTab();
              return _ProGateTab(
                title: 'Purchase & Suppliers',
                description:
                    'Create purchase orders, manage your suppliers, and track what you owe them — all in one place.',
                icon: Icons.local_shipping_rounded,
                onUpgrade: () => showPaywallSheet(
                  ctx,
                  featureName: 'Purchase & Suppliers',
                  featureDescription:
                      'Manage purchase orders and suppliers. Track payments to distributors. Available on the Pro plan.',
                  featureIcon: Icons.local_shipping_rounded,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Pro gate placeholder tab ───────────────────────────────────────────────────

class _ProGateTab extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onUpgrade;

  const _ProGateTab({
    required this.title,
    required this.description,
    required this.icon,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: const Color(0xFF7C3AED)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PRO ONLY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BrandColors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: BrandColors.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: const Text('Upgrade to Pro  ₹500/mo · just ₹17/day'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
