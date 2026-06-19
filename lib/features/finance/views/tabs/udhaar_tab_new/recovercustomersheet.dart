part of '../udhaar_tab_new.dart';

class _RecoverCustomerSheet extends StatefulWidget {
  final WidgetRef ref;
  final _CustomerUdhaar group;

  const _RecoverCustomerSheet({required this.ref, required this.group});

  @override
  State<_RecoverCustomerSheet> createState() => _RecoverCustomerSheetState();
}

class _RecoverCustomerSheetState extends State<_RecoverCustomerSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalBalance = widget.group.totalBalance;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
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
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: BrandColors.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.finRecoverUdhaarFrom(widget.group.customerName),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 16),

          if (_error != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: BrandColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _error!,
                style: const TextStyle(
                  fontSize: 13,
                  color: BrandColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.finAmount,
              prefixText: '₹ ',
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
              helperText:
                  '${l10n.finBalanceLabel(totalBalance.toStringAsFixed(0))} · ${l10n.finPaymentOldestFirstNote}',
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: l10n.finConfirmRecovery,
              isLoading: false,
              onPressed: () {
                final amount = double.tryParse(_controller.text) ?? 0;
                if (amount <= 0) {
                  setState(() => _error = l10n.finEnterValidAmount);
                  return;
                }
                if (amount > totalBalance) {
                  setState(
                    () => _error = l10n.finAmountExceedsBalance(
                      totalBalance.toStringAsFixed(0),
                    ),
                  );
                  return;
                }
                // Settle in the background (oldest-first) so the shopkeeper
                // isn't blocked; the customer card shows live progress, a
                // success flash, or a retry banner if it fails.
                widget.ref
                    .read(financeProvider.notifier)
                    .recordCustomerRecovery(
                      widget.group.openOldestFirst,
                      amount,
                    );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
