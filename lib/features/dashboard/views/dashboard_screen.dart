import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/brand_theme.dart';
import '../../pos_inventory/views/pos_inventory_screen.dart';
import '../../finance/views/finance_screen.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../support/providers/notification_provider.dart';
import 'tabs/overview_tab.dart';

// ── Tab providers ─────────────────────────────────────────────────────────────

class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void switchTab(int index) => state = index;
}

final dashboardTabProvider = NotifierProvider<TabNotifier, int>(TabNotifier.new);

class SubTabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setSubTab(int index) => state = index;
}

final dashboardSubTabProvider =
    NotifierProvider<SubTabNotifier, int>(SubTabNotifier.new);

// Drives which Finance sub-tab (0=Udhaar, 1=Distributor) to show.
final financeSubTabProvider =
    NotifierProvider<SubTabNotifier, int>(() => SubTabNotifier());

// ── Dashboard ─────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).init();
      _initSubscription();
      _handlePendingNotification();
    });
  }

  void _handlePendingNotification() {
    final route = consumePendingAction();
    if (route != null && mounted) {
      // Small delay so the dashboard finishes building before navigating
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) context.push(route);
      });
    }
  }

  Future<void> _initSubscription() async {
    await ref.read(subscriptionProvider.future);
    if (mounted) {
      await ref.read(subscriptionProvider.notifier).checkTrialAlerts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final subAsync = ref.watch(subscriptionProvider);
    final currentTab = ref.watch(dashboardTabProvider);

    return subAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => _buildDashboard(currentTab),
      data: (sub) {
        if (sub.isPending) return _PendingActivationScreen(onRefresh: () => ref.read(subscriptionProvider.notifier).refresh());
        if (sub.isExpired) return _UpgradeWall(onRefresh: () => ref.read(subscriptionProvider.notifier).refresh());
        if (!sub.hasAppAccess) return _RequestTrialScreen(onRequest: () => ref.read(subscriptionProvider.notifier).requestTrial());
        return _buildDashboard(currentTab);
      },
    );
  }

  Widget _buildDashboard(int currentTab) {
    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: const [OverviewTab(), FinanceScreen(), PosInventoryScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: (i) =>
            ref.read(dashboardTabProvider.notifier).switchTab(i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Overview'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Finance'),
          NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), selectedIcon: Icon(Icons.point_of_sale_rounded), label: 'POS'),
        ],
      ),
    );
  }
}

// ── Request trial screen ──────────────────────────────────────────────────────

class _RequestTrialScreen extends StatelessWidget {
  final Future<void> Function() onRequest;
  const _RequestTrialScreen({required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.store_mall_directory_rounded, size: 44, color: BrandColors.primary),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),
              const Text('Welcome to Kirana AI', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: BrandColors.ink), textAlign: TextAlign.center).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              const Text('Request your free trial to get started. Our team will activate your account shortly.', style: TextStyle(fontSize: 15, color: BrandColors.muted, height: 1.6), textAlign: TextAlign.center).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 36),
              _FeaturePill(icon: Icons.point_of_sale_rounded, label: 'POS & Inventory'),
              const SizedBox(height: 8),
              _FeaturePill(icon: Icons.analytics_rounded, label: 'AI Recommendations & KPIs'),
              const SizedBox(height: 8),
              _FeaturePill(icon: Icons.account_balance_wallet_rounded, label: 'Finance & Udhaar Management'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRequest,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Request Free Trial'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: BrandColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Sign in to a different account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: BrandColors.primary),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BrandColors.ink)),
        ],
      ),
    );
  }
}

// ── Pending activation screen ─────────────────────────────────────────────────

class _PendingActivationScreen extends StatelessWidget {
  final VoidCallback onRefresh;
  const _PendingActivationScreen({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded, size: 44, color: Color(0xFFFF8C00)),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),
              const Text('Trial Request Received!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: BrandColors.ink), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text(
                'Your trial activation is being reviewed by our team. You\'ll receive a notification on your device as soon as it\'s approved — usually within a few hours.',
                style: TextStyle(fontSize: 15, color: BrandColors.muted, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF8C00).withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.notifications_active_rounded, color: Color(0xFFFF8C00), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Make sure notifications are enabled so you don\'t miss the activation alert.',
                        style: TextStyle(fontSize: 13, color: BrandColors.ink, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Check Status'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upgrade wall ──────────────────────────────────────────────────────────────

class _UpgradeWall extends ConsumerWidget {
  final VoidCallback onRefresh;
  const _UpgradeWall({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded, size: 44, color: Color(0xFF7C3AED)),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),
              const Text('Free Trial Ended', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: BrandColors.ink), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text('Your free trial has ended. Choose a plan to continue using Kirana AI and keep growing your store.', style: TextStyle(fontSize: 15, color: BrandColors.muted, height: 1.6), textAlign: TextAlign.center),
              const SizedBox(height: 36),
              _UpgradeOption(title: 'Basic', price: '₹200/mo', dailyPrice: '₹7/day', color: BrandColors.primary, icon: Icons.star_rounded, features: const ['POS & Inventory', 'Finance & KPIs', 'AI Recommendations'], onTap: () => context.push('/profile/subscription')),
              const SizedBox(height: 12),
              _UpgradeOption(title: 'Pro', price: '₹500/mo', dailyPrice: '₹17/day', color: const Color(0xFF7C3AED), icon: Icons.workspace_premium_rounded, isBest: true, features: const ['Everything in Basic', 'Vendor Management', 'Cashflow + Referrals'], onTap: () => context.push('/profile/subscription')),
              const SizedBox(height: 20),
              TextButton(onPressed: onRefresh, child: const Text('Already subscribed? Refresh')),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpgradeOption extends StatelessWidget {
  final String title, price, dailyPrice;
  final Color color;
  final IconData icon;
  final List<String> features;
  final bool isBest;
  final VoidCallback onTap;

  const _UpgradeOption({required this.title, required this.price, required this.dailyPrice, required this.color, required this.icon, required this.features, required this.onTap, this.isBest = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: isBest ? 0.5 : 0.2), width: isBest ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    if (isBest) ...[const SizedBox(width: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)), child: const Text('BEST', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)))],
                  ]),
                  Text(features.take(2).join(' · '), style: const TextStyle(fontSize: 11, color: BrandColors.muted), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
                Text('just $dailyPrice', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.65))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
