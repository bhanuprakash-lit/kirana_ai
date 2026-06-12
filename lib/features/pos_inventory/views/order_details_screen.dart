// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/pos_provider.dart';
import '../providers/printer_provider.dart';
import 'widgets/return_sheet.dart';
import '../../profile/providers/customer_provider.dart';
import '../../profile/providers/store_settings_provider.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  String _formatDate(String dateStr) {
    try {
      // Backend sends UTC without 'Z' — append it so Dart parses as UTC,
      // then toLocal() correctly converts to IST (same fix as fetchTodayOrders).
      var s = dateStr;
      if (s.isNotEmpty && !s.endsWith('Z') && !s.contains('+')) s += 'Z';
      final dt = DateTime.parse(s).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _printReceipt(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final store = await ref.read(storeSettingsProvider.future);
    final products = ref.read(posProvider).products;
    final receipt = PrinterNotifier.buildReceipt(
      order: widget.order,
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final posState = ref.watch(posProvider);
    final printerState = ref.watch(printerProvider);
    final customerState = ref.watch(customerProvider);
    final items = (widget.order['items'] as List<dynamic>?) ?? [];
    final total = (widget.order['total_amount'] as num?)?.toDouble() ?? 0;
    final status = widget.order['order_status'] as String? ?? 'completed';
    final paymentMethod = widget.order['payment_method'] as String? ?? 'Cash';
    final date = widget.order['order_date'] as String? ?? '';
    final customerId = widget.order['customer_id'] as int?;
    // Look up full customer record so we can show name + phone instead of raw ID.
    final customer = customerId != null
        ? customerState.customers
              .where((c) => c.customerId == customerId)
              .firstOrNull
        : null;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.posOrderDetails,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: BrandColors.ink,
        actions: [
          // Quick print from app bar
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: l10n.posPrintReceipt,
            onPressed: () => _printReceipt(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Header card ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: BrandColors.ink.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.posOrderNumber('${widget.order['order_id']}'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(date),
                          style: const TextStyle(
                            color: BrandColors.muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    _StatusBadge(status: status),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoTile(
                      label: l10n.posPaymentLabel,
                      value: paymentMethod.toLowerCase() == 'udhaar'
                          ? l10n.posPayUdhaar
                          : paymentMethod.toUpperCase(),
                      icon: paymentMethod.toLowerCase() == 'udhaar'
                          ? Icons.account_balance_wallet_outlined
                          : Icons.payments_outlined,
                      valueColor: paymentMethod.toLowerCase() == 'udhaar'
                          ? const Color(0xFFD97706)
                          : null,
                    ),
                    _InfoTile(
                      label: l10n.posTotalAmount,
                      value: _fmt(total),
                      icon: Icons.account_balance_wallet_outlined,
                      valueColor: BrandColors.success,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
                if (customerId != null) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: BrandColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 18,
                          color: BrandColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer?.name ??
                                  l10n.posCustomerNumber('$customerId'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: BrandColors.ink,
                              ),
                            ),
                            if (customer?.phone.isNotEmpty == true)
                              Text(
                                customer!.phone,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: BrandColors.muted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── Basket attribution (only for basket-sourced orders) ───────────
          if (widget.order['basket_name'] != null) ...[
            const SizedBox(height: 16),
            _BasketAttributionCard(order: widget.order, l10n: l10n),
          ],

          const SizedBox(height: 28),
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: BrandColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.posItemsSummary,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: BrandColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Items ─────────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: BrandColors.ink.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: BrandColors.border.withValues(alpha: 0.5),
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final productId = item['product_id'] as int?;
                  final qty = (item['quantity'] as num?)?.toDouble() ?? 0;
                  final price = (item['unit_price'] as num?)?.toDouble() ?? 0;
                  final lineTotal = qty * price;

                  final product = posState.products
                      .where((p) => p.productId == productId)
                      .firstOrNull;
                  final productName =
                      product?.name ?? l10n.posProductNumber('$productId');
                  final unit = product?.unit ?? l10n.posUnitFallback;

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: BrandColors.surfaceTint,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: BrandColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: BrandColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${qty.toStringAsFixed(qty == qty.toInt() ? 0 : 2)} $unit × ${_fmt(price)}',
                                style: const TextStyle(
                                  color: BrandColors.muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _fmt(lineTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: BrandColors.ink,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Total / payment breakdown card ────────────────────────────────
          _PaymentSummaryCard(
            order: widget.order,
            total: total,
            paymentMethod: paymentMethod,
            l10n: l10n,
          ),

          // ── Print receipt button ──────────────────────────────────────────
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _printReceipt(context),
              icon: Icon(
                Icons.print_rounded,
                size: 18,
                color: printerState.isConnected
                    ? BrandColors.primary
                    : BrandColors.muted,
              ),
              label: Text(
                printerState.isConnected
                    ? l10n.posPrintReceipt
                    : l10n.posPrintReceiptStatus(printerState.statusLabel),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: printerState.isConnected
                      ? BrandColors.primary
                      : BrandColors.muted,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: printerState.isConnected
                      ? BrandColors.primary.withValues(alpha: 0.5)
                      : BrandColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // ── Return / exchange ─────────────────────────────────────────────
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => showReturnSheet(context, ref, widget.order),
              icon: const Icon(
                Icons.assignment_return_outlined,
                size: 18,
                color: BrandColors.muted,
              ),
              label: Text(
                l10n.posReturnExchange,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: BrandColors.ink,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: BrandColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.toLowerCase() == 'completed'
        ? BrandColors.success
        : BrandColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final CrossAxisAlignment crossAxisAlignment;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: BrandColors.muted),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: BrandColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: valueColor ?? BrandColors.ink,
          ),
        ),
      ],
    );
  }
}

// ── Payment summary card ──────────────────────────────────────────────────────

class _PaymentSummaryCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final double total;
  final String paymentMethod;
  final AppLocalizations l10n;

  const _PaymentSummaryCard({
    required this.order,
    required this.total,
    required this.paymentMethod,
    required this.l10n,
  });

  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final isUdhaar = paymentMethod.toLowerCase() == 'udhaar';

    // Partial udhaar: udhaar_amount present, positive, and less than total.
    final udhaarAmt = (order['udhaar_amount'] as num?)?.toDouble();
    final cashPaid = (order['cash_paid'] as num?)?.toDouble();
    final isPartial =
        isUdhaar &&
        udhaarAmt != null &&
        udhaarAmt > 0 &&
        cashPaid != null &&
        cashPaid > 0 &&
        udhaarAmt < total;

    if (isPartial) {
      // ── Split payment breakdown ──────────────────────────────────────────
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFD97706).withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: BrandColors.ink.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.posSplitPayment,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD97706),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _fmt(total),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: BrandColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),
            // Cash row
            _SplitRow(
              icon: Icons.payments_rounded,
              label: l10n.posCashPaidNow,
              amount: _fmt(cashPaid),
              color: BrandColors.success,
            ),
            const SizedBox(height: 10),
            // Udhaar row
            _SplitRow(
              icon: Icons.account_balance_wallet_outlined,
              label: l10n.posOnUdhaarCredit,
              amount: _fmt(udhaarAmt),
              color: const Color(0xFFD97706),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BrandColors.surfaceTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: BrandColors.muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.posUdhaarRecordedNote,
                      style: const TextStyle(
                        fontSize: 11,
                        color: BrandColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── Full udhaar or cash (existing solid card) ────────────────────────────
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isUdhaar ? const Color(0xFFD97706) : BrandColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUdhaar ? l10n.posUdhaarSale : l10n.posTotalPaid,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (isUdhaar)
                Text(
                  l10n.posRecordedAsCredit,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          Text(
            _fmt(total),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Basket attribution card ───────────────────────────────────────────────────

class _BasketAttributionCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final AppLocalizations l10n;

  const _BasketAttributionCard({required this.order, required this.l10n});

  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final name = order['basket_name'] as String? ?? '';
    final gross = (order['basket_gross'] as num?)?.toDouble();
    final savings = (order['basket_savings'] as num?)?.toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: BrandColors.success.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: BrandColors.ink.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: BrandColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shopping_basket_rounded,
                  size: 18,
                  color: BrandColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.posBoughtAsBasket,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: BrandColors.muted,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: BrandColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (gross != null || (savings != null && savings > 0)) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),
            if (gross != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.posBasketValue,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.ink,
                    ),
                  ),
                  Text(
                    _fmt(gross),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.ink,
                    ),
                  ),
                ],
              ),
            if (savings != null && savings > 0) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.posCustomerSaved,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.success,
                    ),
                  ),
                  Text(
                    '− ${_fmt(savings)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: BrandColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SplitRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  const _SplitRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: BrandColors.ink,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }
}
