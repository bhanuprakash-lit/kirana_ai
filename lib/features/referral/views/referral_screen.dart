import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../models/referral_models.dart';
import '../providers/referral_provider.dart';
import 'create_campaign_sheet.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsync = ref.watch(referralCampaignsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.mktCustomerGrowth,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'referral_fab',
        onPressed: () => _showCreateSheet(context, ref),
        backgroundColor: BrandColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          l10n.mktNewCampaign,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: campaignsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ListShimmer(itemCount: 5),
        ),
        error: (e, _) =>
            Center(child: Text(l10n.mktErrorWithMessage(e.toString()))),
        data: (campaigns) => campaigns.isEmpty
            ? _buildEmpty(context, ref)
            : _buildList(context, ref, campaigns),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: BrandColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.share_rounded,
                size: 48,
                color: BrandColors.accent,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              l10n.mktNoCampaignsYet,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.mktReferralEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: BrandColors.muted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _showCreateSheet(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.mktCreateFirstCampaign),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<ReferralCampaign> campaigns,
  ) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: () => ref.read(referralCampaignsProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // ── How it works banner ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: BrandColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: BrandColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: BrandColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.mktReferralHowItWorks,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.primary,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          // ── Campaign cards ───────────────────────────────────────────────
          ...campaigns.asMap().entries.map(
            (e) =>
                _CampaignCard(
                      campaign: e.value,
                      onToggle: (v) => ref
                          .read(referralCampaignsProvider.notifier)
                          .toggleCampaign(e.value.campaignId, v),
                      onGenerateQr: () =>
                          _pickCustomerAndShowQr(context, ref, e.value),
                    )
                    .animate(delay: Duration(milliseconds: 80 * e.key))
                    .fadeIn()
                    .slideY(begin: 0.08, end: 0),
          ),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => CreateCampaignSheet(
        onCreated: () => ref.read(referralCampaignsProvider.notifier).refresh(),
      ),
    );
  }

  void _pickCustomerAndShowQr(
    BuildContext context,
    WidgetRef ref,
    ReferralCampaign campaign,
  ) {
    context.push('/profile/referral/qr', extra: campaign);
  }
}

// ── Campaign Card ─────────────────────────────────────────────────────────────

class _CampaignCard extends StatelessWidget {
  final ReferralCampaign campaign;
  final ValueChanged<bool> onToggle;
  final VoidCallback onGenerateQr;

  const _CampaignCard({
    required this.campaign,
    required this.onToggle,
    required this.onGenerateQr,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: campaign.isActive
                        ? BrandColors.accent.withValues(alpha: 0.1)
                        : BrandColors.surfaceTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.campaign_rounded,
                    size: 22,
                    color: campaign.isActive
                        ? BrandColors.accent
                        : BrandColors.muted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: BrandColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.mktCampaignSummary(
                          campaign.referralDiscountPct.toStringAsFixed(0),
                          campaign.milestoneRewardPct.toStringAsFixed(0),
                          campaign.milestoneEveryN,
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          color: BrandColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: campaign.isActive,
                  onChanged: onToggle,
                  activeThumbColor: BrandColors.success,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Stats + action
          // Stats + action
          // Stats + action (2x2 grid, symmetric)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.qr_code_rounded,
                        label: l10n.mktQrCodes,
                        value: '${campaign.tokenCount}',
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _Stat(
                          icon: Icons.people_rounded,
                          label: l10n.mktReferrals,
                          value: '${campaign.totalReferrals}',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        icon: Icons.block_rounded,
                        label: l10n.mktMaxPerPerson,
                        value: '${campaign.maxReferralsPerReferrer}',
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: campaign.isActive ? onGenerateQr : null,
                          icon: const Icon(Icons.qr_code_2_rounded, size: 16),
                          label: Text(
                            l10n.mktGenerateQr,
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            side: const BorderSide(color: BrandColors.primary),
                            foregroundColor: BrandColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextAlign textAlign;

  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: BrandColors.muted),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          textAlign: textAlign,
          style: const TextStyle(
            fontSize: 12,
            color: BrandColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
