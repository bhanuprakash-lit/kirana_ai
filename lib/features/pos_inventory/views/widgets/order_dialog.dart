// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../core/tutorial/tutorial_controller.dart';
import '../../../../core/tutorial/tutorial_keys.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/pos_provider.dart';
import '../../providers/printer_provider.dart';
import '../../../staff/staff_provider.dart';
import '../order_details_screen.dart';
import 'basket_savings_banner.dart';
import 'pos_deeplink_section.dart';
import '../../../finance/providers/finance_provider.dart';
import '../../../finance/views/consent_recorder_sheet.dart';
import '../../../profile/models/customer_model.dart';
import '../../../profile/providers/customer_provider.dart';
import '../../../loyalty/providers/loyalty_provider.dart';
import '../../../profile/providers/store_settings_provider.dart';
import '../../../subscription/models/subscription_model.dart';
import '../../../subscription/providers/subscription_provider.dart';

Future<void> showOrderDialog(BuildContext context, WidgetRef ref) async {
  final result = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _OrderBottomSheet(ref: ref),
  );

  if (result != null && context.mounted) {
    // Getting-started checklist + guided first-sale flow: a real bill exists.
    ref
        .read(tutorialProvider.notifier)
        .onSaleCompleted(result['payment_method'] as String?);
    // Pro + udhaar → capture the customer's spoken consent while they're still
    // at the counter. The clip uploads via a persistent background queue, so
    // this step is quick and skippable and never blocks the sale.
    final isPro = ref.read(subInfoProvider).effectiveTier == SubTier.pro;
    if (isPro &&
        result['payment_method'] == 'udhaar' &&
        result['order_id'] != null) {
      final recorded = await showConsentRecorderSheet(
        context,
        ref,
        orderId: (result['order_id'] as num?)?.toInt(),
        customerId: (result['customer_id'] as num?)?.toInt(),
        total: (result['total_amount'] as num?)?.toDouble(),
        udhaar:
            (result['udhaar_amount'] as num?)?.toDouble() ??
            (result['total_amount'] as num?)?.toDouble(),
        promisedDate: result['due_date'] as String?,
      );
      if (recorded == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).finConsentSaved),
            backgroundColor: BrandColors.success,
            duration: const Duration(milliseconds: 1800),
          ),
        );
      }
    }
    if (context.mounted) {
      final autoPrint = result['auto_print'] as bool? ?? false;
      _showSuccessDialog(context, ref, result, autoPrint: autoPrint);
    }
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
    final store = await ref.read(storeSettingsProvider.future);
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
    final l10n = AppLocalizations.of(context);
    final store = await ref.read(storeSettingsProvider.future);
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
        content: Text(ok ? l10n.posReceiptSent : l10n.posPrintFailedCheck),
        backgroundColor: ok ? BrandColors.success : BrandColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
          Text(
            l10n.posOrderPlaced,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.posOrderNumber('${order['order_id']}'),
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
              label: Text(
                l10n.posPrintReceipt,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
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
              child: Text(
                l10n.posNewSale,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
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
              child: Text(
                l10n.posViewOrderDetails,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
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
  int? _billedByStaffId; // M5 — staff member who billed this order (optional)
  String? _udhaarCustomerName;
  // Partial-udhaar slider — how much of the order goes on credit.
  // Initialised to the full order total when Udhaar is chosen.
  double _udhaarAmount = 0;
  // Repayment deadline for the credit. Defaults to a month from today and
  // is editable by the shopkeeper.
  DateTime _udhaarDueDate = DateTime.now().add(const Duration(days: 30));

  // Manual whole-bill discount typed at checkout (e.g. 2% goodwill on a
  // random cart). Percent or flat ₹; applied after coupon/points. Nothing
  // extra is persisted — the discounted grand total is what's recorded.
  final _discountCtrl = TextEditingController();
  bool _discountIsPct = true;
  double _discountInput = 0;

  // M1 — coupon + points redeemed at checkout.
  final _couponCtrl = TextEditingController();
  int? _couponId;
  double _couponDiscount = 0;
  String? _couponMsg;
  bool _couponOk = false;
  double _redeemPoints = 0;
  double _redeemValue = 0;

  // POS deep-links (M4/M7/M9) — serials, appointment, membership, job card.
  final PosDeepLinks _deepLinks = PosDeepLinks();

  @override
  void dispose() {
    _couponCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  /// ₹ value of the manual whole-bill discount, computed on the bill after
  /// referral/coupon/points and capped so the total can't go negative.
  double _manualDiscountValue(PosState state) {
    if (_discountInput <= 0) return 0;
    final base = (state.discountedSubtotal - _couponDiscount - _redeemValue)
        .clamp(0, double.infinity)
        .toDouble();
    final v = _discountIsPct ? base * _discountInput / 100 : _discountInput;
    return v.clamp(0, base).toDouble();
  }

  /// Bill after referral discount, coupon, redeemed points and manual
  /// discount, plus any billed appointment charge (O2).
  double _effectiveTotal(PosState state) =>
      (state.discountedSubtotal -
              _couponDiscount -
              _redeemValue -
              _manualDiscountValue(state) +
              _deepLinks.appointmentCharge)
          .clamp(0, double.infinity)
          .toDouble();

  Future<void> _applyCoupon() async {
    final code = _couponCtrl.text.trim();
    if (code.isEmpty) return;
    final base = ref.read(posProvider).discountedSubtotal - _redeemValue;
    try {
      final res = await ref
          .read(loyaltyActionsProvider)
          .validateCoupon(code, base);
      if (!mounted) return;
      setState(() {
        if (res['valid'] == true) {
          _couponOk = true;
          _couponId = (res['coupon_id'] as num?)?.toInt();
          _couponDiscount = (res['discount'] as num?)?.toDouble() ?? 0;
          _couponMsg = '−${_fmt(_couponDiscount)} applied';
        } else {
          _couponOk = false;
          _couponId = null;
          _couponDiscount = 0;
          _couponMsg = (res['reason'] ?? 'Invalid coupon').toString();
        }
      });
    } catch (e) {
      if (mounted) setState(() => _couponMsg = 'Could not check coupon');
    }
  }

  Widget _buildLoyaltySection(PosState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Coupon code',
                  isDense: true,
                  prefixIcon: Icon(Icons.local_offer_outlined, size: 18),
                ),
              ),
            ),
            TextButton(onPressed: _applyCoupon, child: const Text('Apply')),
          ],
        ),
        if (_couponMsg != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 2),
            child: Text(
              _couponMsg!,
              style: TextStyle(
                fontSize: 12,
                color: _couponOk ? BrandColors.success : BrandColors.error,
              ),
            ),
          ),
        if (state.selectedCustomerId != null)
          _pointsRedeemTile(state.selectedCustomerId!, state),
      ],
    );
  }

  Widget _pointsRedeemTile(int customerId, PosState state) {
    return Consumer(
      builder: (context, ref, _) {
        final loyalty = ref
            .watch(customerLoyaltyProvider(customerId))
            .asData
            ?.value;
        final cfg = ref.watch(loyaltyConfigProvider).asData?.value;
        if (loyalty == null || cfg == null || loyalty.points <= 0) {
          return const SizedBox.shrink();
        }
        final billBeforePoints = (state.discountedSubtotal - _couponDiscount)
            .clamp(0, double.infinity)
            .toDouble();
        final maxValue = loyalty.redeemValue < billBeforePoints
            ? loyalty.redeemValue
            : billBeforePoints;
        final maxPoints = cfg.redeemPaisePerPoint > 0
            ? maxValue * 100 / cfg.redeemPaisePerPoint
            : 0.0;
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          value: _redeemPoints > 0,
          onChanged: maxPoints <= 0
              ? null
              : (v) => setState(() {
                  if (v == true) {
                    _redeemPoints = double.parse(maxPoints.toStringAsFixed(0));
                    _redeemValue = double.parse(
                      (_redeemPoints * cfg.redeemPaisePerPoint / 100)
                          .toStringAsFixed(2),
                    );
                  } else {
                    _redeemPoints = 0;
                    _redeemValue = 0;
                  }
                }),
          title: Text(
            'Redeem ${loyalty.points.toStringAsFixed(0)} points (${_fmt(maxValue)})',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${loyalty.tier} tier',
            style: const TextStyle(fontSize: 11, color: BrandColors.muted),
          ),
        );
      },
    );
  }

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(2)}';
  }

  /// Switches to Udhaar payment mode and auto-fills the customer if one is
  /// already selected on the POS screen.  Loads the customer list on demand
  /// so the picker never silently blocks on an empty list.
  Future<void> _onUdhaarSelected() async {
    final total = _effectiveTotal(ref.read(posProvider));
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
          });
        }
      }
    }
  }

  /// Optional "who billed this?" selector — only appears when the store has
  /// active staff. Setting it lets the Staff screen show sales + commission per
  /// person. Renders nothing (and stays null) for solo shops.
  Widget _buildBilledBySelector() {
    final l10n = AppLocalizations.of(context);
    final staff = ref.watch(staffListProvider).asData?.value ?? const [];
    if (staff.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<int?>(
        initialValue: _billedByStaffId,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: l10n.staffBilledBy,
          prefixIcon: const Icon(Icons.badge_outlined, size: 20),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [
          DropdownMenuItem<int?>(value: null, child: Text(l10n.staffNotSet)),
          ...staff.map(
            (m) => DropdownMenuItem<int?>(
              value: m.staffId,
              child: Text(m.name, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
        onChanged: (v) => setState(() => _billedByStaffId = v),
      ),
    );
  }

  Future<void> _confirm() async {
    if (_paymentMethod == 'udhaar' && _udhaarCustomerId == null) {
      setState(() => _localError = _l10n.posSelectCustomerForUdhaar);
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

    // Tester #4 — flatten the per-line serials into {serial_no, product_id,
    // variant_id} so each IMEI links to the exact phone it was billed against.
    final cart = ref.read(posProvider).cart;
    final serialItems = <Map<String, dynamic>>[];
    for (final line in cart) {
      for (final sn in (_deepLinks.serialsByLine[line.lineKey] ?? const [])) {
        if (sn.trim().isEmpty) continue;
        serialItems.add({
          'serial_no': sn.trim(),
          'product_id': line.product.productId,
          if (line.variantId != null) 'variant_id': line.variantId,
        });
      }
    }

    final result = await ref
        .read(posProvider.notifier)
        .placeOrder(
          paymentMethod: _paymentMethod,
          udhaarAmount: udhaarAmt,
          // Attribute udhaar orders to the chosen customer so the backend
          // (pos/crud.create_order) creates the single khata ledger entry,
          // linked to this order. No separate /finance/udhaar/add call — that
          // was producing a duplicate, unlinked khata row.
          customerId: _paymentMethod == 'udhaar' ? _udhaarCustomerId : null,
          udhaarDueDate: _paymentMethod == 'udhaar' ? _udhaarDueDate : null,
          couponId: _couponOk ? _couponId : null,
          couponDiscount: _couponOk ? _couponDiscount : 0,
          redeemPoints: _redeemPoints,
          redeemValue: _redeemValue,
          manualDiscount: _manualDiscountValue(ref.read(posProvider)),
          // POS deep-links (M4/M7/M9)
          serialItems: serialItems.isEmpty ? null : serialItems,
          membershipId: _deepLinks.membershipId,
          appointmentId: _deepLinks.appointmentId,
          jobCardId: _deepLinks.jobCardId,
          extraCharge: _deepLinks.appointmentCharge,
          staffId: _billedByStaffId,
        );
    if (!mounted) return;
    if (result != null) {
      // Refresh the Finance tab so the auto-created udhaar balance shows now.
      if (_paymentMethod == 'udhaar') {
        ref.invalidate(financeProvider);
      }
      setState(() {
        _placing = false;
        _success = true;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        final enriched = Map<String, dynamic>.from(result);
        // Auto-print only means something with a live printer connection.
        enriched['auto_print'] =
            _autoPrint && ref.read(printerProvider).isConnected;
        enriched['payment_method'] = _paymentMethod;
        // Persist the split so OrderDetailsScreen can show the breakdown
        // even in the same session before backend returns the fields.
        if (_paymentMethod == 'udhaar' && udhaarAmt != null) {
          final total = (result['total_amount'] as num?)?.toDouble() ?? 0.0;
          enriched['udhaar_amount'] = udhaarAmt;
          enriched['cash_paid'] = total - udhaarAmt;
        }
        // Carry the udhaar customer + due date so the post-sale voice-consent
        // step can attach them to the clip.
        if (_paymentMethod == 'udhaar') {
          enriched['customer_id'] = _udhaarCustomerId;
          enriched['due_date'] =
              '${_udhaarDueDate.year.toString().padLeft(4, '0')}-${_udhaarDueDate.month.toString().padLeft(2, '0')}-${_udhaarDueDate.day.toString().padLeft(2, '0')}';
        }
        Navigator.pop(context, enriched);
      }
    } else {
      setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(posProvider);
    final cart = state.cart;
    final printerState = ref.watch(printerProvider);

    // Guided first-sale flow: explain the payment choices (this is where the
    // owner learns Udhaar = pay later → Khata), then point at the button that
    // completes his first bill.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final c = ref.read(tutorialProvider.notifier);
      if (!c.shouldShow(Tut.fsPayment, flow: Tut.flowFirstSale)) return;
      // Short delay only — the overlay itself waits for the sheet's entrance
      // animation to settle, and firing early beats a fast tap on the real
      // confirm button (which would pop the sheet under the tour).
      Future.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        showTutorialSegment(
          context,
          ref,
          id: Tut.fsPayment,
          flow: Tut.flowFirstSale,
          steps: [
            TutStep(
              targetKey: TutorialKeys.payMethods,
              title: l10n.tutFsPaymentTitle,
              body: l10n.tutFsPaymentBody,
            ),
            TutStep(
              targetKey: TutorialKeys.payConfirm,
              title: l10n.tutFsConfirmTitle,
              body: l10n.tutFsConfirmBody,
              align: ContentAlign.top,
            ),
          ],
          nextLabel: l10n.tutNext,
          doneLabel: l10n.tutDone,
          skipLabel: l10n.tutSkip,
        );
      });
    });

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
      // Cap the sheet height and scroll the body so adding the udhaar fields
      // (customer, split slider, due date) never overflows or forces the sheet
      // to take over the whole screen.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.posConfirmOrder,
                      style: const TextStyle(
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
                      successMessage: l10n.posOrderConfirmed,
                    ),
                    if (_placing ||
                        _localError != null ||
                        state.error != null ||
                        _success)
                      const SizedBox(height: 16),

                    // ── Cart summary ──────────────────────────────────────────────────
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),

                    // ── Referral discount ─────────────────────────────────────────────
                    if (state.referralDiscountPct != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.posSubtotal,
                            style: const TextStyle(
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
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.card_giftcard_rounded,
                                  size: 14,
                                  color: BrandColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    l10n.posReferralDiscount(
                                      state.referralDiscountPct!
                                          .toStringAsFixed(0),
                                      state.referralReferrerName != null
                                          ? " · ${state.referralReferrerName}"
                                          : "",
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: BrandColors.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
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

                    // ── M1: Coupon & points redeem (loyalty active only) ──────────────
                    if (ref
                            .watch(loyaltyConfigProvider)
                            .asData
                            ?.value
                            .isActive ??
                        false) ...[
                      _buildLoyaltySection(state),
                      const SizedBox(height: 10),
                    ],

                    // ── POS deep-links (M4/M7/M9), gated by vertical ──────────────────
                    PosDeepLinkSection(
                      customerId: state.selectedCustomerId,
                      links: _deepLinks,
                      onChanged: () => setState(() {}),
                    ),

                    // ── Billed by (M5) — attributes sales + commission to staff ───────
                    _buildBilledBySelector(),

                    // ── Custom discount — % or ₹ off the whole bill ───────────────────
                    Row(
                      children: [
                        const Icon(
                          Icons.discount_outlined,
                          size: 16,
                          color: BrandColors.muted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _discountCtrl,
                            enabled: !_placing && !_success,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: l10n.posCustomDiscount,
                              hintText: '0',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (v) => setState(
                              () => _discountInput = double.tryParse(v) ?? 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ToggleButtons(
                          isSelected: [_discountIsPct, !_discountIsPct],
                          onPressed: _placing || _success
                              ? null
                              : (i) =>
                                    setState(() => _discountIsPct = i == 0),
                          borderRadius: BorderRadius.circular(10),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          children: const [Text('%'), Text('₹')],
                        ),
                        if (_manualDiscountValue(state) > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '−${_fmt(_manualDiscountValue(state))}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: BrandColors.success,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Billed appointment charge (O2) ────────────────────────────────
                    if (_deepLinks.appointmentCharge > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                size: 14,
                                color: BrandColors.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Appointment',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: BrandColors.muted,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '+${_fmt(_deepLinks.appointmentCharge)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: BrandColors.ink,
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
                        Expanded(
                          child: Text(
                            l10n.posGrandTotal,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: BrandColors.muted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _fmt(_effectiveTotal(state)),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: BrandColors.success,
                          ),
                        ),
                      ],
                    ),

                    // ── Bundle savings breakdown ──────────────────────────────────────
                    if (state.appliedBasketName != null) ...[
                      const SizedBox(height: 12),
                      BasketSavingsBanner(
                        name: state.appliedBasketName!,
                        gross: state.basketGross,
                        savings: state.basketSavings,
                      ),
                    ],
                    const SizedBox(height: 28),

                    // ── Payment method ────────────────────────────────────────────────
                    Text(
                      l10n.posPaymentMethod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: BrandColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      key: TutorialKeys.payMethods,
                      children: [
                        _PaymentOption(
                          icon: Icons.payments_rounded,
                          label: l10n.posPayCash,
                          value: 'cash',
                          groupValue: _paymentMethod,
                          enabled: !_placing && !_success,
                          onTap: () => setState(() => _paymentMethod = 'cash'),
                        ),
                        const SizedBox(width: 12),
                        _PaymentOption(
                          icon: Icons.account_balance_wallet_outlined,
                          label: l10n.posPayUdhaar,
                          value: 'udhaar',
                          groupValue: _paymentMethod,
                          enabled: !_placing && !_success,
                          onTap: () => _onUdhaarSelected(),
                        ),
                        const SizedBox(width: 12),
                        _PaymentOption(
                          icon: Icons.qr_code_rounded,
                          label: l10n.posPayUpi,
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
                        }),
                      ),
                      const SizedBox(height: 12),
                      _UdhaarSplitSlider(
                        total: _effectiveTotal(state),
                        udhaarAmount: _udhaarAmount,
                        onChanged: (v) => setState(() => _udhaarAmount = v),
                        enabled: !_placing && !_success,
                      ),
                      const SizedBox(height: 12),
                      _UdhaarDueDatePicker(
                        dueDate: _udhaarDueDate,
                        enabled: !_placing && !_success,
                        onPick: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _udhaarDueDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 1),
                            ),
                            lastDate: DateTime(2030, 12, 31),
                            helpText: l10n.posUdhaarDueDateHint,
                          );
                          if (picked != null) {
                            setState(() => _udhaarDueDate = picked);
                          }
                        },
                      ),
                    ],

                    // ── Auto-print toggle ─────────────────────────────────────────────
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
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
                            color: _autoPrint && printerState.isConnected
                                ? printerState.statusColor
                                : BrandColors.muted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.posPrintAutomatically,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: BrandColors.ink,
                                  ),
                                ),
                                Text(
                                  !printerState.isConnected
                                      ? l10n.posConnectPrinterToEnable
                                      : _autoPrint
                                      ? l10n.posWillPrintAfter
                                      : l10n.posAutoPrintDisabled,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _autoPrint && printerState.isConnected
                                        ? printerState.statusColor
                                        : BrandColors.muted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            // Off (and locked) until a Bluetooth printer is
                            // actually connected — printing without one can't
                            // work, so don't pretend it will.
                            value: _autoPrint && printerState.isConnected,
                            onChanged:
                                _placing ||
                                    _success ||
                                    !printerState.isConnected
                                ? null
                                : (v) => setState(() => _autoPrint = v),
                            activeThumbColor: BrandColors.primary,
                            activeTrackColor: BrandColors.primary.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    SizedBox(
                      key: TutorialKeys.payConfirm,
                      width: double.infinity,
                      height: 56,
                      child: LoadingButton(
                        label: l10n.posPlaceOrderAmount(
                          _fmt(_effectiveTotal(state)),
                        ),
                        isLoading: _placing,
                        onPressed: _success ? null : _confirm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    final l10n = AppLocalizations.of(context);
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
                  : Text(
                      l10n.posSelectCustomerRequired,
                      style: const TextStyle(
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
    final l10n = AppLocalizations.of(context);
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
                  Text(
                    l10n.posSelectCustomerForUdhaarTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _q = v.toLowerCase()),
                    decoration: InputDecoration(
                      hintText: l10n.posSearchNameOrPhoneHint,
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
                  ? Center(
                      child: Text(
                        l10n.posNoCustomersFound,
                        style: const TextStyle(color: BrandColors.muted),
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

// ── Udhaar due-date picker ────────────────────────────────────────────────────

class _UdhaarDueDatePicker extends StatelessWidget {
  final DateTime dueDate;
  final bool enabled;
  final VoidCallback onPick;

  const _UdhaarDueDatePicker({
    required this.dueDate,
    required this.onPick,
    this.enabled = true,
  });

  static const _udhaarColor = Color(0xFFD97706); // amber-600

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = dueDate.toLocal();
    final label = '${d.day}/${d.month}/${d.year}';
    return InkWell(
      onTap: enabled ? onPick : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _udhaarColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _udhaarColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_rounded, size: 18, color: _udhaarColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.posUdhaarDueDate,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.muted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.edit_calendar_rounded,
              size: 18,
              color: _udhaarColor,
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
    final l10n = AppLocalizations.of(context);
    final cashNow = (total - udhaarAmount).clamp(0.0, total);
    final credit = udhaarAmount.clamp(0.0, total);
    // Step: nearest ₹1; cap divisions so the slider doesn't get sluggish.
    final divisions = total.round().clamp(2, 500);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: _udhaarColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _udhaarColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + live udhaar amount on one line (keeps it compact).
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 15, color: _udhaarColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.posHowMuchUdhaar,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: _udhaarColor,
                  ),
                ),
              ),
              Text(
                _fmt(credit),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: _udhaarColor,
                ),
              ),
            ],
          ),

          // Slim slider — height-capped so it doesn't eat vertical space.
          SizedBox(
            height: 30,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _udhaarColor,
                thumbColor: _udhaarColor,
                overlayColor: _udhaarColor.withValues(alpha: 0.12),
                inactiveTrackColor: _udhaarColor.withValues(alpha: 0.18),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: credit,
                min: 0,
                max: total,
                divisions: divisions,
                onChanged: enabled ? (v) => onChanged(v.roundToDouble()) : null,
              ),
            ),
          ),

          // Single compact breakdown line: cash now vs on udhaar.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.posCashNow}: ${_fmt(cashNow)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.success,
                ),
              ),
              Text(
                '${l10n.posOnUdhaar}: ${_fmt(credit)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _udhaarColor,
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
    final l10n = AppLocalizations.of(context);
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
                      Text(
                        l10n.posComingSoon,
                        style: const TextStyle(
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
