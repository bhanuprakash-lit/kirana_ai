import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/usage_limits_provider.dart';
import '../../../core/services/usage_limits_service.dart';
import '../../../core/theme/brand_theme.dart';

// ── Pack definitions ──────────────────────────────────────────────────────────

class _Pack {
  final String feature;
  final String emoji;
  final String name;
  final String desc;
  final int count;
  final int priceRs;

  const _Pack({
    required this.feature,
    required this.emoji,
    required this.name,
    required this.desc,
    required this.count,
    required this.priceRs,
  });
}

const _packs = [
  _Pack(
    feature: kFeatureInvoice,
    emoji: '📄',
    name: 'Invoice Pack',
    desc: 'Process 10 more supplier bills',
    count: 10,
    priceRs: 5,
  ),
  _Pack(
    feature: kFeatureVoice,
    emoji: '🎙️',
    name: 'Voice Pack',
    desc: 'Add 10 more audio/voice orders',
    count: 10,
    priceRs: 2,
  ),
  _Pack(
    feature: kFeatureHandwrite,
    emoji: '✍️',
    name: 'Handwriting Pack',
    desc: 'Scan 10 more handwritten notes',
    count: 10,
    priceRs: 3,
  ),
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
    setState(() => _buying = pack.feature);

    // ── Payment confirmation dialog ─────────────────────────────────────────
    // TODO: Replace with real Razorpay payment when backend endpoint is ready.
    // Endpoint: POST /kirana/credits/purchase  { pack_type, amount }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${pack.emoji} ${pack.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pack.desc),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.w600),
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
            const Text(
              'Credits do not expire — they roll over each day.',
              style: TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Pay ₹${pack.priceRs}'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await widget.ref
          .read(usageLimitsProvider.notifier)
          .addCredits(pack.feature, pack.count);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pack.count} ${pack.name} credits added!'),
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
          const Text(
            'Top Up Your Credits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Credits never expire — they roll over to tomorrow!',
            style: TextStyle(fontSize: 13, color: BrandColors.muted),
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
                  pack.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pack.desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pack.count} credits',
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
                      : const Text(
                          'Buy',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
