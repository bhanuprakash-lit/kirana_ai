part of '../pos_tab_new.dart';

class _PosBottomBar extends ConsumerWidget {
  final VoidCallback onScan;
  final VoidCallback onVoice;
  final VoidCallback onHandwrite;

  const _PosBottomBar({
    required this.onScan,
    required this.onVoice,
    required this.onHandwrite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subInfo = ref.watch(subInfoProvider);
    final isPro = subInfo.effectiveTier == SubTier.pro;
    final limits = ref.watch(usageLimitsProvider).value;

    final voiceRemaining =
        limits?.voiceRemaining ?? kDailyLimits[kFeatureVoice]!;
    final handwriteRemaining =
        limits?.handwriteRemaining ?? kDailyLimits[kFeatureHandwrite]!;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BrandColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: _BottomAction(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan',
              color: BrandColors.primary,
              filled: true,
              onTap: onScan,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _BottomAction(
              icon: Icons.mic_rounded,
              label: isPro ? 'Voice $voiceRemaining' : 'Voice',
              color: isPro && voiceRemaining == 0
                  ? BrandColors.error
                  : BrandColors.primary,
              locked: !isPro,
              onTap: onVoice,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _BottomAction(
              icon: Icons.draw_rounded,
              label: isPro ? 'Write $handwriteRemaining' : 'Write',
              color: isPro && handwriteRemaining == 0
                  ? BrandColors.error
                  : BrandColors.purple,
              locked: !isPro,
              onTap: onHandwrite,
            ),
          ),
        ],
      ),
    );
  }
}

