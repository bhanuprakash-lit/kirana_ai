import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/subscription_model.dart';
import '../providers/iap_provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/trial_countdown_widget.dart';

/// Legal links required on the subscription purchase page (App Store
/// guideline 3.1.2(c) — must be functional and persistently available).
const String kPrivacyPolicyUrl = 'https://lohiyaai.com/outlet/privacy.html';
const String kTermsOfUseUrl =
    'https://lohiyaai.com/outlet/terms-and-conditions.html';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subAsync = ref.watch(subscriptionProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.subSubscriptionAndPlans,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: subAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: ListShimmer(itemCount: 4, itemHeight: 80),
        ),
        error: (e, _) =>
            Center(child: Text(l10n.subErrorWithDetail(e.toString()))),
        data: (info) => _SubscriptionBody(info: info),
      ),
    );
  }
}

// ── Subscription body ─────────────────────────────────────────────────────────

class _SubscriptionBody extends ConsumerStatefulWidget {
  final SubscriptionInfo info;
  const _SubscriptionBody({required this.info});

  @override
  ConsumerState<_SubscriptionBody> createState() => _SubscriptionBodyState();
}

class _SubscriptionBodyState extends ConsumerState<_SubscriptionBody> {
  bool _isProcessing = false;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void initState() {
    super.initState();
    // Listen to IAP errors and show snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(iapProvider, (prev, next) {
        if (next.error != null && next.error != prev?.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: BrandColors.error,
            ),
          );
          ref.read(iapProvider.notifier).clearError();
        }
        if (mounted) setState(() => _isProcessing = next.isProcessing);
      });
    });
  }

  Future<void> _startPayment(String tier) async {
    await ref.read(iapProvider.notifier).purchase(tier);
  }

  Future<void> _cancelSubscription() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_l10n.subCancelSubscriptionTitle),
        content: Text(_l10n.subCancelSubscriptionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_l10n.subKeepPlan),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: BrandColors.error),
            child: Text(_l10n.subCancelSubscription),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref.read(subscriptionProvider.notifier).cancelSubscription();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_l10n.subSubscriptionCancelled)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_l10n.subCancelFailed(e.toString())),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final info = widget.info;
    final basicFeatures = [
      l10n.subFeaturePosSales,
      l10n.subFeatureInventoryTracking,
      l10n.subFeatureFinanceUdhaar,
      l10n.subFeatureKpiInsights,
      l10n.subFeatureCustomerRelations,
      l10n.subFeatureAiRecommendations,
    ];
    final proOnlyFeatures = [
      l10n.subFeatureAllKpiCategories,
      l10n.subFeatureVendorProcurement,
      l10n.subFeatureCashflowSupport,
      l10n.subFeatureCustomerGrowth,
    ];
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          children: [
            // Current plan card
            _CurrentPlanCard(info: info),
            const SizedBox(height: 24),

            Text(
              l10n.subChooseYourPlan,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: BrandColors.muted,
              ),
            ),
            const SizedBox(height: 12),

            _PlanCard(
              name: 'Basic',
              price: '₹${(info.basicPrice ?? 200).toStringAsFixed(0)}',
              period: l10n.subPerMonth,
              dailyPrice: '₹${((info.basicPrice ?? 200) / 30).round()}',
              color: BrandColors.primary,
              icon: Icons.star_rounded,
              isCurrentPlan: info.tier == SubTier.basic,
              isTrialPlan:
                  info.tier == SubTier.trial && info.trialTier == 'basic',
              features: basicFeatures,
              lockedFeatures: proOnlyFeatures,
              onUpgrade: _isProcessing ? null : () => _startPayment('basic'),
            ),
            const SizedBox(height: 12),
            _PlanCard(
              name: 'Pro',
              price: '₹${(info.proPrice ?? 500).toStringAsFixed(0)}',
              period: l10n.subPerMonth,
              dailyPrice: '₹${((info.proPrice ?? 500) / 30).round()}',
              color: const Color(0xFF7C3AED),
              icon: Icons.workspace_premium_rounded,
              isCurrentPlan: info.tier == SubTier.pro,
              isTrialPlan:
                  info.tier == SubTier.trial && info.trialTier == 'pro',
              isBestValue: true,
              features: [...basicFeatures, ...proOnlyFeatures],
              onUpgrade: _isProcessing ? null : () => _startPayment('pro'),
            ),
            const SizedBox(height: 20),

            // Cancel button (only for paid plans)
            if (info.tier.isPaid) ...[
              OutlinedButton(
                onPressed: _cancelSubscription,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: BrandColors.error),
                  foregroundColor: BrandColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(l10n.subCancelSubscription),
              ),
              const SizedBox(height: 16),
            ],

            // Restore purchases (for reinstalls)
            TextButton(
              onPressed: () =>
                  ref.read(iapProvider.notifier).restorePurchases(),
              child: Text(
                l10n.subRestorePurchases,
                style: const TextStyle(color: BrandColors.muted, fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),

            // Auto-renewal disclosure + Terms/Privacy links (App Store 3.1.2c).
            const _LegalFooter(),
            const SizedBox(height: 16),

            // Contact
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: BrandColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.subNeedHelp,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.subReachWhatsApp,
                    style: const TextStyle(
                      color: BrandColors.muted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _contactWhatsApp,
                      icon: const Icon(Icons.chat_rounded, size: 16),
                      label: Text(l10n.subWhatsAppSupport),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        if (_isProcessing)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Future<void> _contactWhatsApp() async {
    final msg = _l10n.subWhatsAppHelpMessage;
    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(msg)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Current plan card ─────────────────────────────────────────────────────────

class _CurrentPlanCard extends StatelessWidget {
  final SubscriptionInfo info;
  const _CurrentPlanCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _color(info.tier);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon(info.tier), color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                l10n.subCurrentPlanLabel(
                  info.tier.displayName(trialTier: info.trialTier),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              if (info.isTrial)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: TrialCountdownWidget(),
                ),
            ],
          ),
          if (info.tier.isPaid) ...[
            const SizedBox(height: 8),
            Text(
              info.displayPriceLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Color _color(SubTier t) {
    switch (t) {
      case SubTier.none:
        return BrandColors.muted;
      case SubTier.pending:
        return const Color(0xFFFF8C00);
      case SubTier.trial:
        return info.trialTier == 'pro'
            ? BrandColors.purple
            : BrandColors.primary;
      case SubTier.basic:
        return BrandColors.primary;
      case SubTier.pro:
        return const Color(0xFF7C3AED);
    }
  }

  IconData _icon(SubTier t) {
    switch (t) {
      case SubTier.none:
        return Icons.block_rounded;
      case SubTier.pending:
        return Icons.hourglass_top_rounded;
      case SubTier.trial:
        return info.trialTier == 'pro'
            ? Icons.workspace_premium_rounded
            : Icons.timer_outlined;
      case SubTier.basic:
        return Icons.star_rounded;
      case SubTier.pro:
        return Icons.workspace_premium_rounded;
    }
  }
}

// ── Plan card ─────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String name, price, period;
  final Color color;
  final IconData icon;
  final bool isCurrentPlan, isTrialPlan, isBestValue;
  final List<String> features, lockedFeatures;
  final VoidCallback? onUpgrade;

  final String dailyPrice;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.period,
    required this.dailyPrice,
    required this.color,
    required this.icon,
    required this.isCurrentPlan,
    required this.features,
    this.lockedFeatures = const [],
    this.isTrialPlan = false,
    this.isBestValue = false,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isCurrentPlan || isTrialPlan) ? color : BrandColors.border,
          width: (isCurrentPlan || isTrialPlan) ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
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
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: BrandColors.ink,
                            ),
                          ),
                          if (isBestValue) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.subBest,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: price,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: color,
                              ),
                            ),
                            TextSpan(
                              text: period,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        l10n.subJustPerDay(dailyPrice),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                ...features.map((f) => _Row(f, color, true)),
                if (lockedFeatures.isNotEmpty)
                  ...lockedFeatures.map(
                    (f) => _Row(f, BrandColors.muted, false),
                  ),
                const SizedBox(height: 14),
                if (isTrialPlan) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: color),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n.subTrialPlanNotice,
                            style: TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                SizedBox(
                  width: double.infinity,
                  child: isCurrentPlan
                      ? OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                          ),
                          label: Text(l10n.subCurrentPlan),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        )
                      : isTrialPlan
                      ? ElevatedButton.icon(
                          onPressed: onUpgrade,
                          icon: const Icon(Icons.lock_open_rounded, size: 16),
                          label: Text(l10n.subUpgradeToKeepAccess(name)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: onUpgrade,
                          icon: const Icon(Icons.payment_rounded, size: 16),
                          label: Text(l10n.subPayAndActivate(name)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ── Legal footer (auto-renewal disclosure + Terms/Privacy) ────────────────────

class _LegalFooter extends StatelessWidget {
  const _LegalFooter();

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const muted = TextStyle(color: BrandColors.muted, fontSize: 11, height: 1.5);
    final link = TextStyle(
      color: BrandColors.primary,
      fontSize: 11,
      height: 1.5,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    return Column(
      children: [
        const Text(
          'Subscriptions are billed monthly and renew automatically until '
          'cancelled. Your subscription can be managed and cancelled anytime '
          'in your device account settings.',
          textAlign: TextAlign.center,
          style: muted,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _open(kTermsOfUseUrl),
              child: Text('Terms of Use', style: link),
            ),
            const Text('   •   ', style: muted),
            GestureDetector(
              onTap: () => _open(kPrivacyPolicyUrl),
              child: Text('Privacy Policy', style: link),
            ),
          ],
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final Color color;
  final bool included;
  const _Row(this.label, this.color, this.included);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: included ? BrandColors.ink : BrandColors.muted,
                fontWeight: included ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
