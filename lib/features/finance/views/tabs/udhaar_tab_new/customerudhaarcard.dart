part of '../udhaar_tab_new.dart';

class _CustomerUdhaarCard extends ConsumerStatefulWidget {
  final _CustomerUdhaar group;
  const _CustomerUdhaarCard({required this.group});

  @override
  ConsumerState<_CustomerUdhaarCard> createState() =>
      _CustomerUdhaarCardState();
}

class _CustomerUdhaarCardState extends ConsumerState<_CustomerUdhaarCard> {
  bool _expanded = false;

  void _openHistory(UdhaarItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UdhaarHistorySheet(ref: ref, item: item),
    );
  }

  void _openRecover() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecoverCustomerSheet(ref: ref, group: widget.group),
    );
  }

  Future<void> _remind() async {
    final khataId = widget.group.oldestOpenKhataId;
    if (khataId == null) return;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(financeProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await notifier.sendReminder(khataId);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.finWhatsappReminderSent),
          backgroundColor: BrandColors.success,
        ),
      );
      await notifier.refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.finFailedSendReminder(e.toString()))),
      );
    }
  }

  /// Background-settlement banner shown at the top of the card while a
  /// customer's dues are being cleared, and after it finishes/fails.
  Widget _buildRecoveryBanner(
    AppLocalizations l10n,
    _CustomerUdhaar g,
    RecoveryProgress p,
  ) {
    const radius = BorderRadius.vertical(top: Radius.circular(15));
    switch (p.status) {
      case RecoveryStatus.running:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: radius,
              child: LinearProgressIndicator(
                value: p.total > 0 ? p.cleared / p.total : null,
                backgroundColor: BrandColors.surfaceTint,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  BrandColors.success,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                children: [
                  const Icon(Icons.sync, size: 14, color: BrandColors.success),
                  const SizedBox(width: 4),
                  Text(
                    l10n.finClearingDuesProgress(p.cleared, p.total),
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case RecoveryStatus.success:
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: BrandColors.success.withValues(alpha: 0.1),
            borderRadius: radius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: BrandColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.finDuesCleared(p.total),
                style: const TextStyle(
                  fontSize: 12,
                  color: BrandColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case RecoveryStatus.failed:
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: BrandColors.error.withValues(alpha: 0.08),
            borderRadius: radius,
          ),
          padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 16,
                color: BrandColors.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.finDuesClearFailed(p.cleared, p.total),
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => ref
                    .read(financeProvider.notifier)
                    .recordCustomerRecovery(p.pending, p.remainingAmount),
                style: TextButton.styleFrom(
                  foregroundColor: BrandColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  l10n.finRetry,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => ref
                    .read(recoveryProgressProvider.notifier)
                    .setProgress(g.customerId, null),
                icon: const Icon(Icons.close_rounded, size: 16),
                color: BrandColors.muted,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final g = widget.group;
    final accent = _urgencyColor(g.oldestDays);
    final progressMap = ref.watch(recoveryProgressProvider);
    final progress = progressMap[g.customerId];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (progress != null) _buildRecoveryBanner(l10n, g, progress),
          // ── Collapsed header (always visible, tap to expand) ──────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: accent.withValues(alpha: 0.1),
                    child: Text(
                      g.customerName.isNotEmpty
                          ? g.customerName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (g.phone.isNotEmpty)
                          Text(
                            g.phone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.finOpenDuesSummary(g.openCount, g.oldestDays),
                          style: TextStyle(
                            fontSize: 12,
                            color: accent,
                            fontWeight: FontWeight.w600,
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
                        '₹${g.totalBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: BrandColors.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: BrandColors.muted,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded body ─────────────────────────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ExpandedBody(
              group: g,
              onRecover: _openRecover,
              onRemind: _remind,
              onOpenHistory: _openHistory,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

