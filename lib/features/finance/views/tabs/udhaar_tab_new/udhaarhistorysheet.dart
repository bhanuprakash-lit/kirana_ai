part of '../udhaar_tab_new.dart';

class _UdhaarHistorySheet extends StatefulWidget {
  final WidgetRef ref;
  final UdhaarItem item;
  const _UdhaarHistorySheet({required this.ref, required this.item});

  @override
  State<_UdhaarHistorySheet> createState() => _UdhaarHistorySheetState();
}

class _UdhaarHistorySheetState extends State<_UdhaarHistorySheet> {
  List<Map<String, dynamic>> _payments = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final client = widget.ref.read(apiClientProvider);
      final res =
          await client.get(
                '/kirana/finance/udhaar/${widget.item.khataId}/history',
              )
              as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _payments = (res['payments'] as List).cast<Map<String, dynamic>>();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: BrandColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.finRecoveryHistory,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          widget.item.customerName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: BrandColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      l10n.finBalanceLabel(
                        widget.item.balance.toStringAsFixed(0),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: BrandColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: ListShimmer(itemCount: 4, itemHeight: 60),
                    )
                  : _error != null
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: BrandColors.error),
                      ),
                    )
                  : _payments.isEmpty
                  ? Center(
                      child: Text(
                        l10n.finNoRecoveriesYet,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.separated(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: _payments.length,
                      separatorBuilder: (context2, index2) =>
                          const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = _payments[i];
                        final amount = (p['amount'] as num?)?.toDouble() ?? 0.0;
                        final paidAt = p['paid_at'] as String?;
                        final dt = paidAt != null
                            ? DateTime.tryParse(paidAt)?.toLocal()
                            : null;
                        final dateLabel = dt != null
                            ? '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                            : '—';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: BrandColors.success.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_downward_rounded,
                                  color: BrandColors.success,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.finRecoveryNumber(
                                        _payments.length - i,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      dateLabel,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: BrandColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '+ ₹${amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: BrandColors.success,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
