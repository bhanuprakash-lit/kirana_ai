import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/pos_provider.dart';
import '../../../finance/providers/finance_provider.dart';
import '../../../profile/models/customer_model.dart';
import '../../../profile/providers/customer_provider.dart';

Future<void> showOrderDialog(BuildContext context, WidgetRef ref) async {
  final result = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _OrderBottomSheet(ref: ref),
  );

  if (result != null && context.mounted) {
    _showSuccessDialog(context, result);
  }
}

void _showSuccessDialog(BuildContext context, Map<String, dynamic> order) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: BrandColors.success,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Order Placed!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order #${order['order_id']}',
            style: const TextStyle(
              color: BrandColors.muted,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${(order['total_amount'] as num?)?.toStringAsFixed(2) ?? '—'}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: BrandColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'New Sale',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}

class _OrderBottomSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _OrderBottomSheet({required this.ref});

  @override
  ConsumerState<_OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends ConsumerState<_OrderBottomSheet> {
  String _paymentMethod = 'cash';
  bool _placing = false;
  bool _success = false;
  String? _localError;
  int? _udhaarCustomerId;
  String? _udhaarCustomerName;
  String? _udhaarCustomerPhone;

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(2)}';
  }

  Future<void> _confirm() async {
    if (_paymentMethod == 'udhaar' && _udhaarCustomerId == null) {
      setState(() => _localError = 'Please select a customer for Udhaar sale');
      return;
    }
    setState(() { _placing = true; _success = false; _localError = null; });
    final result = await ref
        .read(posProvider.notifier)
        .placeOrder(paymentMethod: _paymentMethod);
    if (!mounted) return;
    if (result != null) {
      // If payment is Udhaar, also create a Khata entry
      if (_paymentMethod == 'udhaar' && _udhaarCustomerPhone != null) {
        try {
          final client = ref.read(apiClientProvider);
          final amount = (result['total_amount'] as num?)?.toDouble() ?? 0.0;
          await client.post('/kirana/finance/udhaar/add', {
            'customer_name': _udhaarCustomerName ?? '',
            'phone': _udhaarCustomerPhone!,
            'amount': amount,
          });
        } catch (_) {}
        // Refresh finance data so udhaar tab reflects the new entry
        ref.invalidate(financeProvider);
      }
      // Refresh overview stats after every order
      setState(() { _placing = false; _success = true; });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.pop(context, result);
    } else {
      setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posProvider);
    final cart = state.cart;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
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
          const Text(
            'Confirm Order',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 16),

          ActionStatusOverlay(
            isSaving: _placing,
            error: _localError ?? state.error,
            isSuccess: _success,
            successMessage: 'Order confirmed!',
          ),
          if (_placing || _localError != null || state.error != null || _success)
            const SizedBox(height: 16),

          // Cart summary
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cart.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.name} × ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _fmt(item.lineTotal),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: BrandColors.ink,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1),
          ),
          if (state.referralDiscountPct != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.muted,
                  ),
                ),
                Text(
                  _fmt(state.subtotal),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard_rounded,
                      size: 14,
                      color: BrandColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Referral Discount (${state.referralDiscountPct!.toStringAsFixed(0)}%)'
                      '${state.referralReferrerName != null ? " · ${state.referralReferrerName}" : ""}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: BrandColors.accent,
                      ),
                    ),
                  ],
                ),
                Text(
                  '-${_fmt(state.discountAmount)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: BrandColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.muted,
                ),
              ),
              Text(
                _fmt(state.discountedSubtotal),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Payment method
          const Text(
            'Payment Method',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _PaymentOption(
                icon: Icons.payments_rounded,
                label: 'Cash',
                value: 'cash',
                groupValue: _paymentMethod,
                enabled: !_placing && !_success,
                onTap: () => setState(() => _paymentMethod = 'cash'),
              ),
              const SizedBox(width: 12),
              _PaymentOption(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Udhaar',
                value: 'udhaar',
                groupValue: _paymentMethod,
                enabled: !_placing && !_success,
                onTap: () {
                  setState(() => _paymentMethod = 'udhaar');
                  // Auto-fill from POS-selected customer so user doesn't have to pick again
                  if (_udhaarCustomerId == null) {
                    final posState = ref.read(posProvider);
                    final selId = posState.selectedCustomerId;
                    if (selId != null) {
                      final match = ref.read(customerProvider).customers
                          .where((c) => c.customerId == selId)
                          .firstOrNull;
                      if (match != null) {
                        setState(() {
                          _udhaarCustomerId   = match.customerId;
                          _udhaarCustomerName = match.name;
                          _udhaarCustomerPhone = match.phone;
                        });
                      }
                    }
                  }
                },
              ),
              const SizedBox(width: 12),
              _PaymentOption(
                icon: Icons.qr_code_rounded,
                label: 'UPI',
                value: 'upi',
                groupValue: _paymentMethod,
                comingSoon: true,
                enabled: false,
                onTap: null,
              ),
            ],
          ),
          if (_paymentMethod == 'udhaar') ...[
            const SizedBox(height: 14),
            _UdhaarCustomerPicker(
              selectedId: _udhaarCustomerId,
              selectedName: _udhaarCustomerName,
              onSelected: (c) => setState(() {
                _udhaarCustomerId = c.customerId;
                _udhaarCustomerName = c.name;
                _udhaarCustomerPhone = c.phone;
              }),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: 'Place Order · ${_fmt(state.discountedSubtotal)}',
              isLoading: _placing,
              onPressed: _success ? null : _confirm,
            ),
          ),
        ],
      ),
    );
  }
}

class _UdhaarCustomerPicker extends ConsumerWidget {
  final int? selectedId;
  final String? selectedName;
  final ValueChanged<Customer> onSelected;

  const _UdhaarCustomerPicker({
    required this.selectedId,
    required this.selectedName,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerProvider).customers;

    return GestureDetector(
      onTap: () async {
        if (customers.isEmpty) return;
        final result = await showModalBottomSheet<Customer>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _UdhaarCustomerSheet(customers: customers),
        );
        if (result != null) onSelected(result);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selectedId != null
              ? BrandColors.error.withValues(alpha: 0.05)
              : BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selectedId != null
                ? BrandColors.error.withValues(alpha: 0.4)
                : BrandColors.error,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selectedId != null
                  ? Icons.person_rounded
                  : Icons.person_add_rounded,
              color: BrandColors.error,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: selectedId != null
                  ? Text(
                      selectedName ?? '—',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  : const Text(
                      'Select customer (required for Udhaar)',
                      style: TextStyle(
                        fontSize: 13,
                        color: BrandColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: BrandColors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _UdhaarCustomerSheet extends StatefulWidget {
  final List<Customer> customers;
  const _UdhaarCustomerSheet({required this.customers});

  @override
  State<_UdhaarCustomerSheet> createState() => _UdhaarCustomerSheetState();
}

class _UdhaarCustomerSheetState extends State<_UdhaarCustomerSheet> {
  final _ctrl = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.customers
        .where(
          (c) =>
              _q.isEmpty ||
              c.name.toLowerCase().contains(_q) ||
              c.phone.contains(_q),
        )
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, sc) => Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Customer for Udhaar',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _q = v.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone…',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No customers found',
                        style: TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.builder(
                      controller: sc,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: BrandColors.error.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: BrandColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            c.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: c.phone.isNotEmpty
                              ? Text(
                                  c.phone,
                                  style: const TextStyle(fontSize: 12),
                                )
                              : null,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.pop(context, c),
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

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String groupValue;
  final bool comingSoon;
  final bool enabled;
  final VoidCallback? onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.groupValue,
    this.comingSoon = false,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue && !comingSoon;
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? BrandColors.primary.withValues(alpha: 0.08)
                : BrandColors.surfaceTint.withValues(
                    alpha: enabled ? 1.0 : 0.5,
                  ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? BrandColors.primary
                  : BrandColors.border.withValues(alpha: enabled ? 1.0 : 0.5),
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: comingSoon || !enabled
                    ? BrandColors.muted.withValues(alpha: 0.6)
                    : (selected ? BrandColors.primary : BrandColors.ink),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: comingSoon || !enabled
                            ? BrandColors.muted.withValues(alpha: 0.6)
                            : BrandColors.ink,
                      ),
                    ),
                    if (comingSoon)
                      const Text(
                        'Coming soon',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: BrandColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
