part of '../pos_tab_new.dart';

class _PosBottomBar extends ConsumerWidget {
  final VoidCallback onScan;
  final VoidCallback onVoice;
  final VoidCallback onHandwrite;
  final VoidCallback onAppointments;
  final VoidCallback onPrescription;

  const _PosBottomBar({
    required this.onScan,
    required this.onVoice,
    required this.onHandwrite,
    required this.onAppointments,
    required this.onPrescription,
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

    // Per-vertical swaps (tester feedback): surface appointment booking and
    // prescriptions where Voice/Write don't fit the trade.
    final vc = verticalConfigOf(ref);
    final showAppointments = vc.has('appointments');
    final showPrescription = vc.verticalCode == 'optical';

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
          // Slot 2 — Appointments (services verticals) else Voice.
          Expanded(
            child: showAppointments
                ? _BottomAction(
                    icon: Icons.event_available_rounded,
                    label: 'Appointments',
                    color: BrandColors.primary,
                    onTap: onAppointments,
                  )
                : _BottomAction(
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
          // Slot 3 — Prescription (optical) else Write.
          Expanded(
            child: showPrescription
                ? _BottomAction(
                    icon: Icons.visibility_rounded,
                    label: 'Prescription',
                    color: BrandColors.purple,
                    onTap: onPrescription,
                  )
                : _BottomAction(
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
