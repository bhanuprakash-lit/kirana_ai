import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../providers/finance_provider.dart';
import '../providers/smart_udhaar_provider.dart';

/// Smart Udhaar — open credit ranked by recovery risk, with a suggested action
/// and one-tap WhatsApp reminder. Replaces purely days-based chasing.
class SmartRemindersScreen extends ConsumerWidget {
  const SmartRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(smartUdhaarProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.finSmartReminders,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: BrandColors.error,
              ),
              const SizedBox(height: 12),
              Text(l10n.finCouldNotLoadReminders),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    ref.read(smartUdhaarProvider.notifier).refresh(),
                child: Text(l10n.finRetry),
              ),
            ],
          ),
        ),
        data: (list) => list.isEmpty
            ? const _Empty()
            : RefreshIndicator.adaptive(
                onRefresh: () =>
                    ref.read(smartUdhaarProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _RiskCard(item: list[i]),
                ),
              ),
      ),
    );
  }
}

Color _bandColor(String band) {
  switch (band) {
    case 'high':
      return BrandColors.error;
    case 'medium':
      return const Color(0xFFE87722);
    default:
      return BrandColors.success;
  }
}

class _RiskCard extends ConsumerStatefulWidget {
  final SmartUdhaar item;
  const _RiskCard({required this.item});

  @override
  ConsumerState<_RiskCard> createState() => _RiskCardState();
}

class _RiskCardState extends ConsumerState<_RiskCard> {
  bool _reminding = false;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  Widget build(BuildContext context) {
    final s = widget.item;
    final color = _bandColor(s.riskBand);
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: BrandColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${s.balance.toStringAsFixed(0)} · ${l10n.finDaysPending(s.daysPending)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.finRiskBadge(s.riskBand.toUpperCase()),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 15, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  s.suggestedAction,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.finLikelyToRecover(s.recoveryLikelihood),
            style: const TextStyle(fontSize: 11, color: BrandColors.muted),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: _reminding ? null : _remind,
              icon: _reminding
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.message_rounded, size: 15),
              label: Text(
                l10n.finSendReminder,
                style: const TextStyle(fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF25D366),
                side: const BorderSide(color: Color(0xFF25D366)),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _remind() async {
    setState(() => _reminding = true);
    try {
      await ref
          .read(financeProvider.notifier)
          .sendReminder(widget.item.khataId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.finReminderSentTo(widget.item.customerName)),
          backgroundColor: BrandColors.success,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.finCouldNotSendReminder),
          backgroundColor: BrandColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _reminding = false);
    }
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      children: [
        const SizedBox(height: 120),
        const Icon(
          Icons.verified_outlined,
          size: 64,
          color: BrandColors.success,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            l10n.finNoOpenUdhaar,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            l10n.finAllCreditSettled,
            style: const TextStyle(color: BrandColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
