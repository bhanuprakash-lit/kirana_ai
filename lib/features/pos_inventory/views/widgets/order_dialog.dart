// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/pos_provider.dart';
import '../../providers/printer_provider.dart';
import '../order_details_screen.dart';
import '../../../finance/providers/finance_provider.dart';
import '../../../profile/models/customer_model.dart';
import '../../../profile/providers/customer_provider.dart';
import '../../../profile/providers/store_settings_provider.dart';

Future<void> showOrderDialog(BuildContext context, WidgetRef ref) async {
  final result = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _OrderBottomSheet(ref: ref),
  );

  if (result != null && context.mounted) {
    final autoPrint = result['auto_print'] as bool? ?? false;
    _showSuccessDialog(context, ref, result, autoPrint: autoPrint);
  } else {
    ref.read(posProvider.notifier).clearError();
  }
}

void _showSuccessDialog(
  BuildContext context,
  WidgetRef ref,
  Map<String, dynamic> order, {
  bool autoPrint = false,
}) {
  // Trigger auto-print immediately (non-blocking)
  if (autoPrint) {
    _triggerPrint(ref, order);
  }

  showDialog(
    context: context,
    builder: (dialogContext) => _SuccessDialog(order: order, parentRef: ref),
  );
}

/// Fire-and-forget receipt print (called after order confirmation).
Future<void> _triggerPrint(WidgetRef ref, Map<String, dynamic> order) async {
  try {
    final store = ref.read(storeSettingsProvider).value;
    final products = ref.read(posProvider).products;
    final receipt = PrinterNotifier.buildReceipt(
      order: order,
      store: store,
      products: products,
    );
    await ref.read(printerProvider.notifier).printOrder(receipt);
  } catch (_) {
    // Silent — user can retry from success dialog
  }
}

// ── Success dialog ────────────────────────────────────────────────────────────

class _SuccessDialog extends ConsumerWidget {
  final Map<String, dynamic> order;
  final WidgetRef parentRef;

  const _SuccessDialog({required this.order, required this.parentRef});

  Future<void> _printReceipt(BuildContext context, WidgetRef ref) async {
    final store = ref.read(storeSettingsProvider).value;
    final products = ref.read(posProvider).products;
    final receipt = PrinterNotifier.buildReceipt(
      order: order,
      store: store,
      products: products,
    );
    final ok = await ref.read(printerProvider.notifier).printOrder(receipt);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Receipt sent to printer' : 'Print failed — check printer',
        ),
        backgroundColor: ok ? BrandColors.success : BrandColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printerState = ref.watch(printerProvider);

    return AlertDialog(
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

          // ── Printer status micro-text ──────────────────────────────────
          if (printerState.status != PrinterStatus.noPrinterSaved) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.print_rounded,
                  size: 12,
                  color: printerState.statusColor,
                ),
                const SizedBox(width: 4),
                Text(
                  printerState.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: printerState.statusColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Print receipt button ─────────────────────────────────────
            OutlinedButton.icon(
              onPressed: () => _printReceipt(context, ref),
              icon: const Icon(Icons.print_rounded, size: 18),
              label: const Text(
                'Print Receipt',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                foregroundColor: BrandColors.primary,
                side: BorderSide(
                  color: BrandColors.primary.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // ── New sale button ──────────────────────────────────────────
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
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
            const SizedBox(height: 4),
            // ── View order details ───────────────────────────────────────
            TextButton(
              onPressed: () {
                final navigator = Navigator.of(context);
                navigator.pop(); // close dialog
                navigator.push(
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(order: order),
                  ),
                );
              },
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(36),
                foregroundColor: BrandColors.muted,
              ),
              child: const Text(
                'View Order Details',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Order bottom sheet ────────────────────────────────────────────────────────

class _OrderBottomSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _OrderBottomSheet({required this.ref});

  @override
  ConsumerState<_OrderBottomSheet> createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends ConsumerState<_OrderBottomSheet> {
  String _paymentMethod = 'cash';
  bool _autoPrint = true; // auto-print after order confirmation
  bool _placing = false;
  bool _success = false;
  String? _localError;
  int? _udhaarCustomerId;
  String? _udhaarCustomerName;
  String? _udhaarCustomerPhone;
  // Partial-udhaar slider — how much of the order goes on credit.
  // Initialised to the full order total when Udhaar is chosen.
  double _udhaarAmount = 0;

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(2)}';
  }

  /// Switches to Udhaar payment mode and auto-fills the customer if one is
  /// already selected on the POS screen.  Loads the customer list on demand
  /// so the picker never silently blocks on an empty list.
  Future<void> _onUdhaarSelected() async {
    final total = ref.read(posProvider).discountedSubtotal;
    setState(() {
      _paymentMethod = 'udhaar';
      _udhaarAmount = total; // default: full amount on credit
    });

    if (_udhaarCustomerId == null) {
      final posState = ref.read(posProvider);
      final selId = posState.selectedCustomerId;
      if (selId != null) {
        // Ensure customer list is loaded before trying to look up.
        var customers = ref.read(customerProvider).customers;
        if (customers.isEmpty && !ref.read(customerProvider).isLoading) {
          await ref.read(customerProvider.notifier).fetchCustomers();
          if (!mounted) return;
          customers = ref.read(customerProvider).customers;
        }
        final match = customers.where((c) => c.customerId == selId).firstOrNull;
        if (match != null && mounted) {
          setState(() {
            _udhaarCustomerId = match.customerId;
            _udhaarCustomerName = match.name;
            _udhaarCustomerPhone = match.phone;
          });
        }
      }
    }
  }

  Future<void> _confirm() async {
    if (_paymentMethod == 'udhaar' && _udhaarCustomerId == null) {
      setState(() => _localError = 'Please select a customer for Udhaar sale');
      return;
    }
    setState(() {
      _placing = true;
      _success = false;
      _localError = null;
    });
    final udhaarAmt = _paymentMethod == 'udhaar'
        ? _udhaarAmount.roundToDouble()
        : null;

    final result = await ref
        .read(posProvider.notifier)
        .placeOrder(paymentMethod: _paymentMethod, udhaarAmount: udhaarAmt);
    if (!mounted) return;
    if (result != null) {
      if (_paymentMethod == 'udhaar' && _udhaarCustomerPhone != null) {
        // Use the slider value — not the full order total — so the finance
        // ledger records only the credit portion.
        final creditAmount =
            udhaarAmt ?? (result['total_amount'] as num?)?.toDouble() ?? 0.0;
        // Only record udhaar if there's an actual credit amount (slider > 0).
        if (creditAmount > 0) {
          try {
            final client = ref.read(apiClientProvider);
            await client.post('/kirana/finance/udhaar/add', {
              'customer_name': _udhaarCustomerName ?? '',
              'phone': _udhaarCustomerPhone!,
              'amount': creditAmount,
            });
          } catch (_) {}
          ref.invalidate(financeProvider);
        }
      }
      setState(() {
        _placing = false;
        _success = true;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        final enriched = Map<String, dynamic>.from(result);
        enriched['auto_print'] = _autoPrint;
        // Persist the split so OrderDetailsScreen can show the breakdown
        // even in the same session before backend returns the fields.
        if (_paymentMethod == 'udhaar' && udhaarAmt != null) {
          final total = (result['total_amount'] as num?)?.toDouble() ?? 0.0;
          enriched['udhaar_amount'] = udhaarAmt;
          enriched['cash_paid'] = total - udhaarAmt;
        }
        Navigator.pop(context, enriched);
      }
    } else {
      setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posProvider);
    final cart = state.cart;
    final printerState = ref.watch(printerProvider);

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
          if (_placing ||
              _localError != null ||
              state.error != null ||
              _success)
            const SizedBox(height: 16),

          // ── Cart summary ──────────────────────────────────────────────────
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

          // ── Referral discount ─────────────────────────────────────────────
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

          // ── Grand total ───────────────────────────────────────────────────
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

          // ── Payment method ────────────────────────────────────────────────
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
                onTap: () => _onUdhaarSelected(),
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
            const SizedBox(height: 12),
            _UdhaarSplitSlider(
              total: state.discountedSubtotal,
              udhaarAmount: _udhaarAmount,
              onChanged: (v) => setState(() => _udhaarAmount = v),
              enabled: !_placing && !_success,
            ),
          ],

          // ── Auto-print toggle ─────────────────────────────────────────────
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: BrandColors.surfaceTint,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BrandColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.print_rounded,
                  size: 18,
                  color: _autoPrint
                      ? printerState.statusColor
                      : BrandColors.muted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Print receipt automatically',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: BrandColors.ink,
                        ),
                      ),
                      Text(
                        _autoPrint
                            ? (printerState.isConnected
                                  ? 'Will print after order is placed'
                                  : 'Printer: ${printerState.statusLabel}')
                            : 'Disabled — print manually from order details',
                        style: TextStyle(
                          fontSize: 11,
                          color: _autoPrint
                              ? printerState.statusColor
                              : BrandColors.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _autoPrint,
                  onChanged: _placing || _success
                      ? null
                      : (v) => setState(() => _autoPrint = v),
                  activeThumbColor: BrandColors.primary,
                  activeTrackColor: BrandColors.primary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
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
        // Trigger load if the list is empty and not already loading.
        // This prevents the sheet from silently doing nothing on first open.
        var current = customers;
        if (current.isEmpty && !ref.read(customerProvider).isLoading) {
          await ref.read(customerProvider.notifier).fetchCustomers();
          if (!context.mounted) return;
          current = ref.read(customerProvider).customers;
        }
        if (!context.mounted) return;
        final result = await showModalBottomSheet<Customer>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _UdhaarCustomerSheet(customers: current),
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

// ── Udhaar split slider ───────────────────────────────────────────────────────

class _UdhaarSplitSlider extends StatelessWidget {
  final double total;
  final double udhaarAmount;
  final ValueChanged<double> onChanged;
  final bool enabled;

  const _UdhaarSplitSlider({
    required this.total,
    required this.udhaarAmount,
    required this.onChanged,
    this.enabled = true,
  });

  static const _udhaarColor = Color(0xFFD97706); // amber-600

  String _fmt(double v) => '₹${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final cashNow = (total - udhaarAmount).clamp(0.0, total);
    final credit = udhaarAmount.clamp(0.0, total);
    // Step: nearest ₹1; cap divisions so the slider doesn't get sluggish.
    final divisions = total.round().clamp(2, 500);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: _udhaarColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _udhaarColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16, color: _udhaarColor),
              const SizedBox(width: 6),
              const Text(
                'How much goes on Udhaar?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: _udhaarColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Slider ───────────────────────────────────────────────────────
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _udhaarColor,
              thumbColor: _udhaarColor,
              overlayColor: _udhaarColor.withValues(alpha: 0.12),
              inactiveTrackColor: _udhaarColor.withValues(alpha: 0.18),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: credit,
              min: 0,
              max: total,
              divisions: divisions,
              onChanged: enabled ? (v) => onChanged(v.roundToDouble()) : null,
            ),
          ),

          // ── Min / max labels ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹0',
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
                Text(
                  _fmt(total),
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Cash / Udhaar breakdown pills ────────────────────────────────
          Row(
            children: [
              // Cash paid now
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: BrandColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: BrandColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cash now',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.success,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _fmt(cashNow),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: BrandColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // On Udhaar
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _udhaarColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _udhaarColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'On Udhaar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _udhaarColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _fmt(credit),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _udhaarColor,
                        ),
                      ),
                    ],
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

// ── Payment option chip ───────────────────────────────────────────────────────

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
