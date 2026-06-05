import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/providers/usage_limits_provider.dart';
import '../../../core/services/usage_limits_service.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

// ── Pack definitions ──────────────────────────────────────────────────────────

class _Pack {
  final String feature;
  final String emoji;
  final int count;
  final int priceRs;

  const _Pack({
    required this.feature,
    required this.emoji,
    required this.count,
    required this.priceRs,
  });

  String name(AppLocalizations l10n) {
    switch (feature) {
      case kFeatureInvoice:
        return l10n.subInvoicePack;
      case kFeatureVoice:
        return l10n.subVoicePack;
      case kFeatureHandwrite:
        return l10n.subHandwritingPack;
    }
    return '';
  }

  String desc(AppLocalizations l10n) {
    switch (feature) {
      case kFeatureInvoice:
        return l10n.subInvoicePackDesc;
      case kFeatureVoice:
        return l10n.subVoicePackDesc;
      case kFeatureHandwrite:
        return l10n.subHandwritingPackDesc;
    }
    return '';
  }
}

const _packs = [
  _Pack(feature: kFeatureInvoice, emoji: '📄', count: 10, priceRs: 5),
  _Pack(feature: kFeatureVoice, emoji: '🎙️', count: 10, priceRs: 2),
  _Pack(feature: kFeatureHandwrite, emoji: '✍️', count: 10, priceRs: 3),
];

// ── Entry point ───────────────────────────────────────────────────────────────

Future<void> showCreditsPurchaseSheet(
  BuildContext context,
  WidgetRef ref, {
  String? highlightFeature,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _CreditsPurchaseSheet(ref: ref, highlightFeature: highlightFeature),
  );
}

// ── Sheet ─────────────────────────────────────────────────────────────────────

class _CreditsPurchaseSheet extends StatefulWidget {
  final WidgetRef ref;
  final String? highlightFeature;
  const _CreditsPurchaseSheet({required this.ref, this.highlightFeature});

  @override
  State<_CreditsPurchaseSheet> createState() => _CreditsPurchaseSheetState();
}

class _CreditsPurchaseSheetState extends State<_CreditsPurchaseSheet> {
  String? _buying;

  Future<void> _purchase(_Pack pack) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _buying = pack.feature);

    // ── Payment confirmation dialog ─────────────────────────────────────────
    // TODO: Replace with real Razorpay payment when backend endpoint is ready.
    // Endpoint: POST /kirana/credits/purchase  { pack_type, amount }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${pack.emoji} ${pack.name(l10n)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pack.desc(l10n)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.subPrice,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹${pack.priceRs}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: BrandColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.subCreditsRollOverDaily,
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.subCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.subPayAmount(pack.priceRs)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await widget.ref
          .read(usageLimitsProvider.notifier)
          .addCredits(pack.feature, pack.count);
      final l10nAfter = lookupAppLocalizations(widget.ref.read(localeProvider));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10nAfter.subCreditsAdded(pack.count, pack.name(l10nAfter)),
            ),
            backgroundColor: BrandColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) setState(() => _buying = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Text(
            l10n.subTopUpCredits,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.subCreditsNeverExpire,
            style: const TextStyle(fontSize: 13, color: BrandColors.muted),
          ),
          const SizedBox(height: 20),

          // Packs
          for (final pack in _packs) ...[
            _PackCard(
              pack: pack,
              highlighted: pack.feature == widget.highlightFeature,
              buying: _buying == pack.feature,
              onBuy: _buying != null ? null : () => _purchase(pack),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// ── Pack card ─────────────────────────────────────────────────────────────────

class _PackCard extends StatelessWidget {
  final _Pack pack;
  final bool highlighted;
  final bool buying;
  final VoidCallback? onBuy;

  const _PackCard({
    required this.pack,
    required this.highlighted,
    required this.buying,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted
            ? BrandColors.primary.withValues(alpha: 0.04)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted
              ? BrandColors.primary.withValues(alpha: 0.4)
              : BrandColors.border,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(pack.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pack.name(l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pack.desc(l10n),
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.subCreditsCount(pack.count),
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${pack.priceRs}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: BrandColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: onBuy,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: buying
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.subBuy,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
