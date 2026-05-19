import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../../subscription/models/subscription_model.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import '../providers/store_settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final storeAsync = ref.watch(storeSettingsProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading profile: $err')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data found.'));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              const SizedBox(height: 24),
              // User Info Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.ink.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BrandColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/logos/logo.png'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: BrandColors.ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          storeAsync.when(
                            loading: () => const SizedBox(height: 14, width: 100, child: LinearProgressIndicator()),
                            error: (_, _) => const Text('Lohiya Store', style: TextStyle(color: BrandColors.muted, fontSize: 14)),
                            data: (store) => Text(store.name, style: const TextStyle(color: BrandColors.muted, fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 6),
                          // Compact subscription badge
                          const _SubscriptionBadge(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Settings Options
              _CashflowBanner(
                onTap: () {
                  final sub = ref.read(subInfoProvider);
                  if (!sub.canAccessCashflow) {
                    showPaywallSheet(
                      context,
                      featureName: 'Cashflow Support',
                      featureDescription: 'Apply for ₹50K – ₹10L business finance with tailored repayment plans.',
                      featureIcon: Icons.account_balance_wallet_rounded,
                    );
                    return;
                  }
                  context.push('/profile/cashflow');
                },
              ),

              const _SectionLabel('Customers'),
              _GroupCard(rows: [
                _CompactRow(
                  icon: Icons.share_rounded,
                  label: 'Customer Growth',
                  badge: ref.watch(subInfoProvider).canAccessReferral ? null : 'PRO',
                  onTap: () {
                    final sub = ref.read(subInfoProvider);
                    if (!sub.canAccessReferral) {
                      showPaywallSheet(context,
                          featureName: 'Customer Growth',
                          featureDescription: 'Build a referral engine — let your happy customers bring in new ones automatically.',
                          featureIcon: Icons.share_rounded);
                      return;
                    }
                    context.push('/profile/referral');
                  },
                ),
                _CompactRow(
                  icon: Icons.people_outline_rounded,
                  label: 'Customer Relations',
                  onTap: () => context.push('/profile/customers'),
                ),
                _CompactRow(
                  icon: Icons.location_city_rounded,
                  label: 'Area Associations',
                  onTap: () => context.push('/profile/associations'),
                ),
              ]),

              const _SectionLabel('Analytics'),
              _GroupCard(rows: [
                _CompactRow(
                  icon: Icons.analytics_outlined,
                  label: 'KPI Subscriptions',
                  onTap: () => context.push('/profile/kpis'),
                ),
                _CompactRow(
                  icon: Icons.history_rounded,
                  label: 'Transaction History',
                  onTap: () => context.push('/profile/history'),
                ),
                _CompactRow(
                  icon: Icons.shopping_basket_rounded,
                  label: 'My Baskets',
                  onTap: () => context.push('/profile/baskets'),
                ),
              ]),

              const _SectionLabel('Store & Account'),
              _GroupCard(rows: [
                _CompactRow(
                  icon: Icons.storefront_rounded,
                  label: 'Store Settings',
                  onTap: () => context.push('/profile/store'),
                ),
                _CompactRow(
                  icon: Icons.tune_rounded,
                  label: 'Configuration',
                  onTap: () => context.push('/profile/config'),
                ),
                _CompactRow(
                  icon: Icons.lock_outline_rounded,
                  label: 'Password & Security',
                  onTap: () => context.push('/profile/password'),
                ),
              ]),

              const _SectionLabel('Plan & Support'),
              _GroupCard(rows: [
                _CompactRow(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Subscription & Plans',
                  onTap: () => context.push('/profile/subscription'),
                ),
                _CompactRow(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () => context.push('/profile/support'),
                ),
              ]),

              if (user.role == 'admin') ...[
                const _SectionLabel('Admin'),
                _GroupCard(rows: [
                  _CompactRow(
                    icon: Icons.people_alt_rounded,
                    label: 'User Activity',
                    onTap: () => context.push('/profile/admin-activity'),
                  ),
                ]),
              ],

              const _ProfileFooter(),
              // Logout Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    ref.invalidate(onboardingProvider);
                    await ref.read(authRepositoryProvider).clearSession();
                    if (context.mounted) context.go('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    side: const BorderSide(
                      color: BrandColors.error,
                      width: 1.5,
                    ),
                    foregroundColor: BrandColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _CashflowBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _CashflowBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A3A5C), Color(0xFF243B6B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cashflow Support',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15)),
                  SizedBox(height: 2),
                  Text('Apply for ₹50K – ₹10L business finance',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final version = snap.hasData
            ? 'v${snap.data!.version}+${snap.data!.buildNumber}'
            : '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Image.asset('assets/logos/foreground.png', width: 36, height: 36),
              const SizedBox(height: 6),
              const Text(
                'Kirana AI by LohiyaAI',
                style: TextStyle(
                  fontSize: 12,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              if (version.isNotEmpty)
                Text(
                  version,
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 6),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: BrandColors.muted,
            letterSpacing: 1.1,
          ),
        ),
      );
}

class _GroupCard extends StatelessWidget {
  final List<_CompactRow> rows;
  const _GroupCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              const Divider(height: 1, indent: 52, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _CompactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  const _CompactRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: BrandColors.surfaceTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: BrandColors.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: BrandColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Subscription banner in profile ────────────────────────────────────────────

// Compact badge shown inside the profile info card
class _SubscriptionBadge extends ConsumerWidget {
  const _SubscriptionBadge();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subInfoProvider);

    final Color color;
    final IconData icon;
    final String label;

    switch (sub.tier) {
      case SubTier.none:
        color = BrandColors.error;
        icon = Icons.warning_amber_rounded;
        label = 'Trial Expired';
      case SubTier.pending:
        color = const Color(0xFFFF8C00);
        icon = Icons.hourglass_top_rounded;
        label = 'Awaiting Activation';
      case SubTier.trial:
        final isProTrial = sub.trialTier == 'pro';
        color = isProTrial ? const Color(0xFF7C3AED) : const Color(0xFFFF8C00);
        icon = isProTrial ? Icons.workspace_premium_rounded : Icons.timer_outlined;
        final tierLabel = isProTrial ? 'Pro Trial' : 'Basic Trial';
        label = sub.daysRemaining > 0 ? '$tierLabel · ${sub.daysRemaining}d left' : '$tierLabel Active';
      case SubTier.basic:
        color = BrandColors.primary;
        icon = Icons.star_rounded;
        label = 'Basic Plan';
      case SubTier.pro:
        color = const Color(0xFF7C3AED);
        icon = Icons.workspace_premium_rounded;
        label = 'Pro Plan';
    }

    return GestureDetector(
      onTap: () => context.push('/profile/subscription'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

