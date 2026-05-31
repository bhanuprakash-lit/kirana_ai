import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Smart Reminders',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: BrandColors.error),
              const SizedBox(height: 12),
              const Text('Could not load reminders'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(smartUdhaarProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (list) => list.isEmpty
            ? const _Empty()
            : RefreshIndicator(
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

  @override
  Widget build(BuildContext context) {
    final s = widget.item;
    final color = _bandColor(s.riskBand);

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
                      '₹${s.balance.toStringAsFixed(0)} · ${s.daysPending} days pending',
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
                  '${s.riskBand.toUpperCase()} RISK',
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
            '~${s.recoveryLikelihood}% likely to recover',
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
              label: const Text('Send reminder', style: TextStyle(fontSize: 13)),
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
      await ref.read(financeProvider.notifier).sendReminder(widget.item.khataId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder sent to ${widget.item.customerName}'),
          backgroundColor: BrandColors.success,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not send reminder'),
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
    return ListView(
      children: const [
        SizedBox(height: 120),
        Icon(Icons.verified_outlined, size: 64, color: BrandColors.success),
        SizedBox(height: 16),
        Center(
          child: Text(
            'No open udhaar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(height: 6),
        Center(
          child: Text(
            'All credit is settled. Nice and clean!',
            style: TextStyle(color: BrandColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
