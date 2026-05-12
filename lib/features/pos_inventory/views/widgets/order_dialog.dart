import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/pos_provider.dart';

Future<void> showOrderDialog(
    BuildContext context, WidgetRef ref) async {
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
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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
            child: const Icon(Icons.check_rounded,
                color: BrandColors.success, size: 48),
          ),
          const SizedBox(height: 24),
          const Text(
            'Order Placed!',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Order #${order['order_id']}',
            style: const TextStyle(color: BrandColors.muted, fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${(order['total_amount'] as num?)?.toStringAsFixed(2) ?? '—'}',
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.w900,
                color: BrandColors.ink),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('New Sale', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
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

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(2)}';
  }

  Future<void> _confirm() async {
    final subtotal = ref.read(posProvider).subtotal;
    setState(() {
      _placing = true;
      _success = false;
    });
    final result = await ref.read(posProvider.notifier).placeOrder(
          paymentMethod: _paymentMethod,
        );
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _placing = false;
        _success = true;
      });
      final Map<String, dynamic> mutableResult = Map.from(result);
      if ((mutableResult['total_amount'] as num? ?? 0) == 0) {
        mutableResult['total_amount'] = subtotal;
      }
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.pop(context, mutableResult);
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
          const Text('Confirm Order',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w900, color: BrandColors.ink)),
          const SizedBox(height: 16),
          
          ActionStatusOverlay(
            isSaving: _placing,
            error: state.error,
            isSuccess: _success,
            successMessage: 'Order confirmed!',
          ),
          if (_placing || state.error != null || _success) const SizedBox(height: 16),

          // Cart summary
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cart.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.name} × ${item.quantity}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BrandColors.ink),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _fmt(item.lineTotal),
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14, color: BrandColors.ink),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: BrandColors.muted)),
              Text(
                _fmt(state.subtotal),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.success),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Payment method
          const Text('Payment Method',
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 14, color: BrandColors.ink)),
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: 'Place Order · ${_fmt(state.subtotal)}',
              isLoading: _placing,
              onPressed: _success ? null : _confirm,
            ),
          ),
        ],
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
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? BrandColors.primary.withValues(alpha: 0.08)
                : BrandColors.surfaceTint.withValues(alpha: enabled ? 1.0 : 0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  selected ? BrandColors.primary : BrandColors.border.withValues(alpha: enabled ? 1.0 : 0.5),
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 20,
                  color: comingSoon || !enabled
                      ? BrandColors.muted.withValues(alpha: 0.6)
                      : (selected
                          ? BrandColors.primary
                          : BrandColors.ink)),
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
                              : BrandColors.ink),
                    ),
                    if (comingSoon)
                      const Text('Coming soon',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: BrandColors.muted)),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded,
                    size: 18, color: BrandColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
