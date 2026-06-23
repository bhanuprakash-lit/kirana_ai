import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/basket_tier_config.dart';
import '../providers/basket_provider.dart';
// import 'baskets_screen.dart' show tierLabel;
import 'baskets_screen_new.dart' show tierLabel;

class BasketTierConfigScreen extends ConsumerStatefulWidget {
  const BasketTierConfigScreen({super.key});

  @override
  ConsumerState<BasketTierConfigScreen> createState() =>
      _BasketTierConfigScreenState();
}

class _BasketTierConfigScreenState
    extends ConsumerState<BasketTierConfigScreen> {
  BasketTierConfig? _draft;
  bool _dirty = false;
  bool _saving = false;

  // Controllers for the 3 editable boundaries + 4 discounts.
  final _maxCtrls = <TextEditingController>[];
  final _discCtrls = <TextEditingController>[];

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  void _init(BasketTierConfig cfg) {
    if (_draft != null) return;
    _draft = cfg;
    for (final t in cfg.tiers) {
      _maxCtrls.add(
        TextEditingController(
          text: t.max == null ? '' : t.max!.toStringAsFixed(0),
        ),
      );
      _discCtrls.add(
        TextEditingController(
          text: t.discountPct.toStringAsFixed(t.discountPct % 1 == 0 ? 0 : 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _maxCtrls) {
      c.dispose();
    }
    for (final c in _discCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  BasketTierConfig _rebuild() {
    final base = _draft!;
    final tiers = <BasketTier>[];
    for (var i = 0; i < base.tiers.length; i++) {
      final isTop = i == base.tiers.length - 1;
      tiers.add(
        BasketTier(
          name: base.tiers[i].name,
          max: isTop ? null : double.tryParse(_maxCtrls[i].text),
          discountPct: double.tryParse(_discCtrls[i].text) ?? 0,
        ),
      );
    }
    return BasketTierConfig(tiers: tiers);
  }

  void _onChanged() {
    setState(() {
      _draft = _rebuild();
      _dirty = true;
    });
  }

  Future<void> _save() async {
    final cfg = _rebuild();
    if (!cfg.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.mktTierRangeInvalid),
          backgroundColor: BrandColors.error,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final existing = await ref
          .read(basketTierConfigProvider.notifier)
          .save(cfg);
      setState(() {
        _dirty = false;
        _saving = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.mktTiersSaved),
          backgroundColor: BrandColors.success,
        ),
      );
      if (existing > 0) {
        await _offerRecompute(existing);
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_l10n.mktSomethingWentWrong),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }

  Future<void> _offerRecompute(int count) async {
    final l10n = _l10n;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.mktRecomputeTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(l10n.mktRecomputeBody(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.mktKeepAsIs),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.mktRecompute),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    try {
      final updated = await ref.read(basketProvider.notifier).retier();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.mktBasketsRecomputed(updated))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.mktSomethingWentWrong),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(basketTierConfigProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.mktTierConfigTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: async.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: ListShimmer(itemCount: 4, itemHeight: 80),
        ),
        error: (e, _) =>
            Center(child: Text(l10n.mktErrorWithMessage(e.toString()))),
        data: (cfg) {
          _init(cfg);
          final d = _draft!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: BrandColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: BrandColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.mktTierConfigIntro,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: BrandColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < d.tiers.length; i++)
                _TierRow(
                  tier: d.tiers[i],
                  isTop: i == d.tiers.length - 1,
                  lowerBound: i == 0
                      ? 0
                      : (double.tryParse(_maxCtrls[i - 1].text) ?? 0),
                  maxCtrl: _maxCtrls[i],
                  discCtrl: _discCtrls[i],
                  onChanged: _onChanged,
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: _draft == null
          ? null
          : AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _dirty ? 90 : 0,
              child: _dirty
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                l10n.mktSaveTiers,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
    );
  }
}

class _TierRow extends StatelessWidget {
  final BasketTier tier;
  final bool isTop;
  final double lowerBound;
  final TextEditingController maxCtrl;
  final TextEditingController discCtrl;
  final VoidCallback onChanged;

  const _TierRow({
    required this.tier,
    required this.isTop,
    required this.lowerBound,
    required this.maxCtrl,
    required this.discCtrl,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = TierStyle.of(tier.name);
    final lower = lowerBound + (lowerBound > 0 ? 1 : 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(style.icon, size: 18, color: style.color),
              ),
              const SizedBox(width: 10),
              Text(
                tierLabel(l10n, tier.name),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: style.color,
                ),
              ),
              const Spacer(),
              Text(
                isTop
                    ? l10n.mktAboveAmount(lower.toStringAsFixed(0))
                    : l10n.mktRangeAmount(
                        lower.toStringAsFixed(0),
                        (double.tryParse(maxCtrl.text) ?? 0).toStringAsFixed(0),
                      ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (!isTop)
                Expanded(
                  child: TextField(
                    controller: maxCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => onChanged(),
                    decoration: InputDecoration(
                      labelText: l10n.mktUpToLabel,
                      prefixText: '₹ ',
                      isDense: true,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.mktTopTierHint,
                      style: const TextStyle(
                        fontSize: 13,
                        color: BrandColors.muted,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: discCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,1}'),
                    ),
                  ],
                  onChanged: (_) => onChanged(),
                  decoration: InputDecoration(
                    labelText: l10n.mktDiscountLabel,
                    suffixText: '%',
                    isDense: true,
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
