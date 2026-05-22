import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/api_client.dart';
import '../../../core/theme/brand_theme.dart';
import '../../pos_inventory/views/pos_inventory_screen.dart';
import '../../finance/views/finance_screen.dart';
import '../../auth/providers/user_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../support/providers/notification_provider.dart';
import 'tabs/overview_tab.dart';

// ── Tab providers ─────────────────────────────────────────────────────────────

class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void switchTab(int index) => state = index;
}

final dashboardTabProvider = NotifierProvider<TabNotifier, int>(
  TabNotifier.new,
);

class SubTabNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setSubTab(int index) => state = index;
}

final dashboardSubTabProvider = NotifierProvider<SubTabNotifier, int>(
  SubTabNotifier.new,
);

// Drives which Finance sub-tab (0=Udhaar, 1=Distributor) to show.
final financeSubTabProvider = NotifierProvider<SubTabNotifier, int>(
  () => SubTabNotifier(),
);

// ── Dashboard ─────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  DateTime? _foregroundStart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).init();
      ref.read(userProvider.notifier).refresh();
      _initSubscription();
      _handlePendingNotification();
      // Record initial foreground event
      _trackEvent('foreground');
      _foregroundStart = DateTime.now();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _foregroundStart = DateTime.now();
        _trackEvent('foreground');
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        final dur = _foregroundStart != null
            ? DateTime.now().difference(_foregroundStart!).inSeconds
            : null;
        _foregroundStart = null;
        _trackEvent('background', durationSec: dur);
        break;
      default:
        break;
    }
  }

  void _trackEvent(String event, {int? durationSec}) {
    Future.microtask(() async {
      try {
        final client = ref.read(apiClientProvider);
        final body = <String, dynamic>{'event': event};
        if (durationSec != null) body['duration_sec'] = durationSec;
        await client.post('/kirana/tracking/app-event', body);
      } catch (_) {}
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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => _buildDashboard(currentTab),
      data: (sub) {
        if (sub.isPending)
          return _PendingActivationScreen(
            onRefresh: () => ref.read(subscriptionProvider.notifier).refresh(),
          );
        if (sub.isExpired)
          return _UpgradeWall(
            onRefresh: () => ref.read(subscriptionProvider.notifier).refresh(),
          );
        if (!sub.hasAppAccess) return const _RequestTrialScreen();
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
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Khata',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Billing',
          ),
        ],
      ),
    );
  }
}

// ── Request trial screen ──────────────────────────────────────────────────────

class _RequestTrialScreen extends ConsumerStatefulWidget {
  const _RequestTrialScreen();

  @override
  ConsumerState<_RequestTrialScreen> createState() =>
      _RequestTrialScreenState();
}

class _RequestTrialScreenState extends ConsumerState<_RequestTrialScreen> {
  String _selectedTier = 'basic';
  bool _loading = false;

  Future<void> _request() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(subscriptionProvider.notifier)
          .requestTrial(tier: _selectedTier);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: BrandColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.store_mall_directory_rounded,
                    size: 40,
                    color: BrandColors.primary,
                  ),
                ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Kirana AI',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 8),
              const Text(
                'Choose a plan to trial free. Our team will activate it shortly.',
                style: TextStyle(
                  fontSize: 14,
                  color: BrandColors.muted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 28),

              const Text(
                'SELECT YOUR TRIAL PLAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                  color: BrandColors.muted,
                ),
              ),
              const SizedBox(height: 12),

              _TierCard(
                tier: 'basic',
                selected: _selectedTier == 'basic',
                onTap: () => setState(() => _selectedTier = 'basic'),
                color: BrandColors.primary,
                icon: Icons.star_rounded,
                price: '₹200/mo',
                features: const [
                  'POS & Sales Management',
                  'Inventory Tracking',
                  'Finance & Udhaar',
                  'KPI Insights (3 per category)',
                  'AI Recommendations',
                ],
              ).animate().fadeIn(delay: 250.ms),
              const SizedBox(height: 10),

              _TierCard(
                tier: 'pro',
                selected: _selectedTier == 'pro',
                onTap: () => setState(() => _selectedTier = 'pro'),
                color: const Color(0xFF7C3AED),
                icon: Icons.workspace_premium_rounded,
                price: '₹500/mo',
                badge: 'ALL FEATURES',
                features: const [
                  'Everything in Basic',
                  'All KPI Categories (unlimited)',
                  'Vendor & Procurement Management',
                  'Cashflow Support (up to ₹10L)',
                  'Customer Growth Engine',
                ],
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _request,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    'Request ${_selectedTier == 'pro' ? 'Pro' : 'Basic'} Trial',
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: _selectedTier == 'pro'
                        ? const Color(0xFF7C3AED)
                        : BrandColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Sign in to a different account',
                    style: TextStyle(color: BrandColors.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final String tier;
  final bool selected;
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  final String price;
  final String? badge;
  final List<String> features;

  const _TierCard({
    required this.tier,
    required this.selected,
    required this.onTap,
    required this.color,
    required this.icon,
    required this.price,
    required this.features,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? color : BrandColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio indicator
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? color : BrandColors.border,
                  width: 2,
                ),
                color: selected ? color : Colors.transparent,
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: color),
                      const SizedBox(width: 6),
                      Text(
                        '${tier[0].toUpperCase()}${tier.substring(1)} Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: selected ? color : BrandColors.ink,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: color,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              f,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 44,
                  color: Color(0xFFFF8C00),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),
              const Text(
                'Trial Request Received!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your trial activation is being reviewed by our team. You\'ll receive a notification on your device as soon as it\'s approved — usually within a few hours.',
                style: TextStyle(
                  fontSize: 15,
                  color: BrandColors.muted,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFF8C00).withValues(alpha: 0.2),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      color: Color(0xFFFF8C00),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Make sure notifications are enabled so you don\'t miss the activation alert.',
                        style: TextStyle(
                          fontSize: 13,
                          color: BrandColors.ink,
                          height: 1.4,
                        ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 44,
                  color: Color(0xFF7C3AED),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 28),
              const Text(
                'Free Trial Ended',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your free trial has ended. Choose a plan to continue using Kirana AI and keep growing your store.',
                style: TextStyle(
                  fontSize: 15,
                  color: BrandColors.muted,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              _UpgradeOption(
                title: 'Basic',
                price: '₹200/mo',
                dailyPrice: '₹7/day',
                color: BrandColors.primary,
                icon: Icons.star_rounded,
                features: const [
                  'POS & Inventory',
                  'Finance & KPIs',
                  'AI Recommendations',
                ],
                onTap: () => context.push('/profile/subscription'),
              ),
              const SizedBox(height: 12),
              _UpgradeOption(
                title: 'Pro',
                price: '₹500/mo',
                dailyPrice: '₹17/day',
                color: const Color(0xFF7C3AED),
                icon: Icons.workspace_premium_rounded,
                isBest: true,
                features: const [
                  'Everything in Basic',
                  'Vendor Management',
                  'Cashflow + Referrals',
                ],
                onTap: () => context.push('/profile/subscription'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onRefresh,
                child: const Text('Already subscribed? Refresh'),
              ),
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

  const _UpgradeOption({
    required this.title,
    required this.price,
    required this.dailyPrice,
    required this.color,
    required this.icon,
    required this.features,
    required this.onTap,
    this.isBest = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: isBest ? 0.5 : 0.2),
            width: isBest ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      if (isBest) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'BEST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    features.take(2).join(' · '),
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  'just $dailyPrice',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
