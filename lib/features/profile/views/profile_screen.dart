import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../../subscription/models/subscription_model.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import '../providers/store_settings_provider.dart';
import '../../multistore/providers/rollup_provider.dart';
import '../../stores/views/store_switcher_sheet.dart';
import '../../../../core/vertical/vertical_config_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/language_selector.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final storeAsync = ref.watch(storeSettingsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.profProfile,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: userAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ListShimmer(itemCount: 5),
        ),
        error: (err, _) =>
            Center(child: Text(l10n.profErrorLoadingProfile(err.toString()))),
        data: (user) {
          if (user == null) {
            return Center(child: Text(l10n.profNoUserData));
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
                            loading: () => const ShimmerBox(
                              width: 100,
                              height: 14,
                              radius: 6,
                            ),
                            error: (_, _) => const Text(
                              'Lohiya Store',
                              style: TextStyle(
                                color: BrandColors.muted,
                                fontSize: 14,
                              ),
                            ),
                            data: (store) => Text(
                              store.name,
                              style: const TextStyle(
                                color: BrandColors.muted,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                      featureName: l10n.profCashflowSupport,
                      featureDescription: l10n.profCashflowSupportDesc,
                      featureIcon: Icons.account_balance_wallet_rounded,
                    );
                    return;
                  }
                  context.push('/profile/cashflow');
                },
              ),

              _SectionLabel(l10n.profSectionCustomers),
              _GroupCard(
                rows: [
                  _CompactRow(
                    icon: Icons.share_rounded,
                    label: l10n.profCustomerGrowth,
                    badge: ref.watch(subInfoProvider).canAccessReferral
                        ? null
                        : 'PRO',
                    onTap: () {
                      final sub = ref.read(subInfoProvider);
                      if (!sub.canAccessReferral) {
                        showPaywallSheet(
                          context,
                          featureName: l10n.profCustomerGrowth,
                          featureDescription: l10n.profCustomerGrowthDesc,
                          featureIcon: Icons.share_rounded,
                        );
                        return;
                      }
                      context.push('/profile/referral');
                    },
                  ),
                  _CompactRow(
                    icon: Icons.people_outline_rounded,
                    label: l10n.profCustomerRelations,
                    onTap: () => context.push('/profile/customers'),
                  ),
                  _CompactRow(
                    icon: Icons.location_city_rounded,
                    label: l10n.profAreaAssociations,
                    onTap: () => context.push('/profile/associations'),
                  ),
                ],
              ),

              // ── Operations — day-to-day running of the store ──────────────
              _SectionLabel(l10n.profSectionOperations),
              _GroupCard(
                rows: [
                  _CompactRow(
                    icon: Icons.badge_outlined,
                    label: l10n.profStaff,
                    onTap: () => context.push('/profile/staff'),
                  ),
                  _CompactRow(
                    icon: Icons.receipt_long_outlined,
                    label: l10n.profEstimatesReturns,
                    onTap: () => context.push('/profile/fulfilment'),
                  ),
                  _CompactRow(
                    icon: Icons.grid_view_rounded,
                    label: l10n.profStockRacks,
                    onTap: () => context.push('/profile/stock-racks'),
                  ),
                  // Job cards (alteration / repair / pre-order) are meaningless
                  // for a grocery kirana — gate them to the other verticals.
                  if (verticalConfigOf(ref).verticalCode != 'grocery')
                    _CompactRow(
                      icon: Icons.build_circle_outlined,
                      label: l10n.profJobCards,
                      onTap: () => context.push('/profile/job-cards'),
                    ),
                  if (verticalConfigOf(ref).has('warranty'))
                    _CompactRow(
                      icon: Icons.verified_user_outlined,
                      label: l10n.profWarranty,
                      onTap: () => context.push('/profile/warranty'),
                    ),
                  if (verticalConfigOf(ref).verticalCode != 'grocery')
                    _CompactRow(
                      icon: Icons.receipt_long_rounded,
                      label: l10n.profGstReport,
                      onTap: () => context.push('/profile/gst-report'),
                    ),
                ],
              ),

              // ── Sales & marketing — growing revenue ───────────────────────
              _SectionLabel(l10n.profSectionSalesMarketing),
              _GroupCard(
                rows: [
                  _CompactRow(
                    icon: Icons.shopping_basket_rounded,
                    label: l10n.profMyBaskets,
                    onTap: () => context.push('/profile/baskets'),
                  ),
                  _CompactRow(
                    icon: Icons.card_giftcard_rounded,
                    label: l10n.profLoyalty,
                    onTap: () => context.push('/profile/loyalty'),
                  ),
                  if (verticalConfigOf(ref).has('appointments'))
                    _CompactRow(
                      icon: Icons.event_note_rounded,
                      label: l10n.profServices,
                      onTap: () => context.push('/profile/services'),
                    ),
                ],
              ),

              // ── Analytics — understanding the numbers ─────────────────────
              _SectionLabel(l10n.profSectionAnalytics),
              _GroupCard(
                rows: [
                  _CompactRow(
                    icon: Icons.analytics_outlined,
                    label: l10n.profKpiSubscriptions,
                    onTap: () => context.push('/profile/kpis'),
                  ),
                  _CompactRow(
                    icon: Icons.history_rounded,
                    label: l10n.profTransactionHistory,
                    onTap: () => context.push('/profile/history'),
                  ),
                  if (ref
                          .watch(storeRollupProvider)
                          .asData
                          ?.value
                          .isMultiStore ??
                      false)
                    _CompactRow(
                      icon: Icons.compare_arrows_rounded,
                      label: l10n.profStoreComparison,
                      onTap: () => context.push('/profile/store-comparison'),
                    ),
                ],
              ),

              _SectionLabel(l10n.profSectionStoreAccount),
              _GroupCard(
                rows: [
                  _CompactRow(
                    icon: Icons.store_mall_directory_rounded,
                    label: l10n.profSwitchStore,
                    onTap: () => showStoreSwitcher(context, ref),
                  ),
                  _CompactRow(
                    icon: Icons.language_rounded,
                    label: l10n.profLanguage,
                    onTap: () => showLanguagePicker(context, ref),
                  ),
                  _CompactRow(
                    icon: Icons.storefront_rounded,
                    label: l10n.profStoreSettings,
                    onTap: () => context.push('/profile/store'),
                  ),
                  _CompactRow(
                    icon: Icons.tune_rounded,
                    label: l10n.profConfiguration,
                    onTap: () => context.push('/profile/config'),
                  ),
                  _CompactRow(
                    icon: Icons.lock_outline_rounded,
                    label: l10n.profPasswordSecurity,
                    onTap: () => context.push('/profile/password'),
                  ),
                ],
              ),

              _SectionLabel(l10n.profSectionPlanSupport),
              _GroupCard(
                rows: [
                  _CompactRow(
                    icon: Icons.workspace_premium_rounded,
                    label: l10n.profSubscriptionPlans,
                    onTap: () => context.push('/profile/subscription'),
                  ),
                  _CompactRow(
                    icon: Icons.school_rounded,
                    label: l10n.learnTitle,
                    onTap: () => context.push('/profile/learn'),
                  ),
                  _CompactRow(
                    icon: Icons.help_outline_rounded,
                    label: l10n.profHelpSupport,
                    onTap: () => context.push('/profile/support'),
                  ),
                ],
              ),

              if (user.role == 'admin') ...[
                _SectionLabel(l10n.profSectionAdmin),
                _GroupCard(
                  rows: [
                    _CompactRow(
                      icon: Icons.people_alt_rounded,
                      label: l10n.profUserActivity,
                      onTap: () => context.push('/profile/admin-activity'),
                    ),
                  ],
                ),
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
                  label: Text(
                    l10n.profSignOut,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
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
    final l10n = AppLocalizations.of(context);
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
              child: const Icon(
                Icons.account_balance_wallet_rounded,
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
                    l10n.profCashflowSupport,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.profCashflowBannerSubtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white54,
              size: 16,
            ),
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
                'Outlet AI by LohiyaAI',
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
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
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
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: BrandColors.muted,
              size: 18,
            ),
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
    final l10n = AppLocalizations.of(context);

    final Color color;
    final IconData icon;
    final String label;

    switch (sub.tier) {
      case SubTier.none:
        color = BrandColors.error;
        icon = Icons.warning_amber_rounded;
        label = l10n.profTrialExpired;
      case SubTier.pending:
        color = const Color(0xFFFF8C00);
        icon = Icons.hourglass_top_rounded;
        label = l10n.profAwaitingActivation;
      case SubTier.trial:
        final isProTrial = sub.trialTier == 'pro';
        color = isProTrial ? const Color(0xFF7C3AED) : const Color(0xFFFF8C00);
        icon = isProTrial
            ? Icons.workspace_premium_rounded
            : Icons.timer_outlined;
        final tierLabel = isProTrial ? l10n.profProTrial : l10n.profBasicTrial;
        label = sub.daysRemaining > 0
            ? l10n.profTrialDaysLeft(tierLabel, sub.daysRemaining)
            : l10n.profTrialActive(tierLabel);
      case SubTier.basic:
        color = BrandColors.primary;
        icon = Icons.star_rounded;
        label = l10n.profBasicPlan;
      case SubTier.pro:
        color = const Color(0xFF7C3AED);
        icon = Icons.workspace_premium_rounded;
        label = l10n.profProPlan;
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
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
