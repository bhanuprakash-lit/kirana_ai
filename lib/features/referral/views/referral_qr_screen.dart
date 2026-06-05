import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../profile/models/customer_model.dart';
import '../../profile/providers/customer_provider.dart';
import '../models/referral_models.dart';
import '../providers/referral_provider.dart';

// ── Step 1: Pick a customer ───────────────────────────────────────────────────

class ReferralQrScreen extends ConsumerStatefulWidget {
  final ReferralCampaign campaign;
  const ReferralQrScreen({super.key, required this.campaign});

  @override
  ConsumerState<ReferralQrScreen> createState() => _ReferralQrScreenState();
}

class _ReferralQrScreenState extends ConsumerState<ReferralQrScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  Customer? _selected;
  ReferralToken? _token;
  bool _loading = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectCustomer(Customer customer) async {
    setState(() {
      _selected = customer;
      _loading = true;
    });
    final token = await generateReferralToken(
      customerId: customer.customerId,
      campaignId: widget.campaign.campaignId,
    );
    if (mounted) {
      setState(() {
        _token = token;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final customersAsync = ref.watch(customerProvider);
    final customers = customersAsync.customers
        .where(
          (c) =>
              _query.isEmpty ||
              c.name.toLowerCase().contains(_query.toLowerCase()) ||
              (c.phone.contains(_query)),
        )
        .toList();

    if (_selected != null && _token != null) {
      return _QrView(
        customer: _selected!,
        campaign: widget.campaign,
        token: _token!,
        onBack: () => setState(() {
          _selected = null;
          _token = null;
        }),
      );
    }

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.mktGenerateQrTitle(widget.campaign.name),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: l10n.mktSearchCustomer,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CardShimmer(height: 80, radius: 20),
            )
          else
            Expanded(
              child: customers.isEmpty
                  ? Center(
                      child: Text(
                        l10n.mktNoCustomersFound,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: customers.length,
                      itemBuilder: (context, i) {
                        final c = customers[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: BrandColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: BrandColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          title: Text(
                            c.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(c.phone),
                          trailing: const Icon(
                            Icons.qr_code_2_rounded,
                            color: BrandColors.primary,
                          ),
                          onTap: () => _selectCustomer(c),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}

// ── Step 2: Show QR ───────────────────────────────────────────────────────────

class _QrView extends StatelessWidget {
  final Customer customer;
  final ReferralCampaign campaign;
  final ReferralToken token;
  final VoidCallback onBack;

  const _QrView({
    required this.customer,
    required this.campaign,
    required this.token,
    required this.onBack,
  });

  String get _qrData => 'KIRANA_REF:${token.tokenHash}';

  Future<void> _sendWhatsApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final phone = customer.phone.replaceAll(RegExp(r'\D'), '');
    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.mktNoPhoneForCustomer)));
      return;
    }
    final message = Uri.encodeComponent(
      l10n.mktReferralWhatsAppMessage(
        customer.name,
        token.tokenHash,
        campaign.referralDiscountPct.toStringAsFixed(0),
        campaign.milestoneEveryN,
      ),
    );
    final uri = Uri.parse('whatsapp://send?phone=91$phone&text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.mktWhatsAppNotInstalled)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          l10n.mktReferralQrCode,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Customer info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BrandColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      customer.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: BrandColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: BrandColors.ink,
                          ),
                        ),
                        Text(
                          customer.phone,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BrandColors.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: BrandColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            campaign.name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: BrandColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 28),

            // QR Code
            Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: BrandColors.ink.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: BrandColors.primary,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: BrandColors.ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.mktPercentOffForNewCustomers(
                          campaign.referralDiscountPct.toStringAsFixed(0),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: BrandColors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.mktMilestoneRewardLabel(
                          campaign.milestoneRewardPct.toStringAsFixed(0),
                          campaign.milestoneEveryN,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: 100.ms)
                .fadeIn()
                .scale(
                  begin: const Offset(0.9, 0.9),
                  curve: Curves.elasticOut,
                  duration: 600.ms,
                ),

            const SizedBox(height: 12),

            // Token code (copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: token.tokenHash));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.mktReferralCodeCopied)),
                );
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: BrandColors.surfaceTint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: BrandColors.muted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        token.tokenHash,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: BrandColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 28),

            // Actions
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _sendWhatsApp(context),
                icon: const Icon(Icons.send_rounded),
                label: Text(l10n.mktSendViaWhatsApp),
              ),
            ).animate(delay: 250.ms).fadeIn(),

            const SizedBox(height: 12),

            Text(
              l10n.mktQrScreenshotHint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ).animate(delay: 280.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}
