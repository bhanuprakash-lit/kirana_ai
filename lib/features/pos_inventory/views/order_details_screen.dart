// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../core/services/api_client.dart';
import '../../auth/repositories/auth_repository.dart' show ApiException;
import '../../../l10n/generated/app_localizations.dart';
import '../providers/pos_provider.dart';
import '../providers/printer_provider.dart';
import 'widgets/return_sheet.dart';
import '../../profile/providers/customer_provider.dart';
import '../../profile/providers/store_settings_provider.dart';

/// Tester #4 — serials/IMEIs registered against this order, shown on the bill.
final _orderSerialsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, int>((ref, orderId) async {
      final data = await ref
          .read(apiClientProvider)
          .get('/kirana/serials?order_id=$orderId');
      final list =
          (data is Map ? data['serials'] : null) as List<dynamic>? ?? [];
      return list
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    });

/// Bill section listing each serial/IMEI sold on the order, its product and
/// warranty-until date. Renders nothing when the order has no serials.
class _OrderSerialsCard extends ConsumerWidget {
  final int orderId;
  const _OrderSerialsCard({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_orderSerialsProvider(orderId));
    final serials = async.asData?.value ?? const [];
    if (serials.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.qr_code_2_rounded,
                size: 18,
                color: BrandColors.primary,
              ),
              SizedBox(width: 8),
              Text(
                'Serials / IMEI',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final s in serials)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['serial_no']?.toString() ?? '—',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${s['product_name'] ?? 'Product'}'
                    '${s['warranty_until'] != null ? '  ·  warranty till ${s['warranty_until']}' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Returns recorded against this order (unified sales_return history).
final _orderReturnsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, int>((ref, orderId) async {
      final data = await ref
          .read(apiClientProvider)
          .get('/kirana/sales-returns?order_id=$orderId');
      final list =
          (data is Map ? data['returns'] : null) as List<dynamic>? ?? [];
      return list
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    });

/// Bill section showing any return/exchange recorded on this order — so the
/// owner sees at a glance that (part of) the bill came back. Renders nothing
/// when the order has no returns.
class _OrderReturnsCard extends ConsumerWidget {
  final int orderId;
  const _OrderReturnsCard({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final returns =
        ref.watch(_orderReturnsProvider(orderId)).asData?.value ?? const [];
    if (returns.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE87722).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE87722).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_return_rounded,
                size: 18,
                color: Color(0xFFE87722),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.fulReturnsOnOrder,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final r in returns)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                [
                  if (r['is_exchange'] == true)
                    l10n.fulExchange
                  else
                    '${l10n.fulRefund} ₹${(r['refund_amount'] as num?)?.toStringAsFixed(0) ?? "0"}',
                  ((r['items'] as List<dynamic>? ?? const [])
                      .whereType<Map>()
                      .map((i) => '${i['qty']}× ${i['name'] ?? '—'}')
                      .join(', ')),
                ].where((s) => s.isNotEmpty).join('  ·  '),
                style: const TextStyle(fontSize: 12.5, height: 1.4),
              ),
            ),
        ],
      ),
    );
  }
}

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

          // ── Voice consent (udhaar orders) ─────────────────────────────────
          if (paymentMethod.toLowerCase() == 'udhaar' &&
              widget.order['order_id'] != null) ...[
            const SizedBox(height: 16),
            _ConsentCard(orderId: (widget.order['order_id'] as num).toInt()),
          ],

          // ── Serials / IMEI billed on this order (tester #4) ───────────────
          if (widget.order['order_id'] != null) ...[
            const SizedBox(height: 16),
            _OrderSerialsCard(
              orderId: (widget.order['order_id'] as num).toInt(),
            ),
          ],

          // ── Returns recorded against this order ──────────────────────────
          if (widget.order['order_id'] != null) ...[
            const SizedBox(height: 16),
            _OrderReturnsCard(
              orderId: (widget.order['order_id'] as num).toInt(),
            ),
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

          // ── GST breakup (only when the bill has taxable items) ────────────
          _GstBreakupCard(order: widget.order, total: total),

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
              onPressed: () async {
                await showReturnSheet(context, ref, widget.order);
                // Refresh the "returns on this bill" card.
                final oid = (widget.order['order_id'] as num?)?.toInt();
                if (oid != null) ref.invalidate(_orderReturnsProvider(oid));
              },
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

// ── GST breakup card ──────────────────────────────────────────────────────────

/// F3 — shows the tax component of the bill (GST is inclusive in retail prices,
/// so this is informational and does not change the total). Renders nothing for
/// non-taxable bills (e.g. grocery). CGST/SGST split assumes intra-state supply,
/// matching the GST Report.
class _GstBreakupCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final double total;

  const _GstBreakupCard({required this.order, required this.total});

  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final tax = (order['tax_amount'] as num?)?.toDouble() ?? 0;
    if (tax <= 0) return const SizedBox.shrink();
    final taxable =
        (order['taxable_amount'] as num?)?.toDouble() ?? (total - tax);
    final half = tax / 2;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 18,
                    color: BrandColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'GST breakup',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: BrandColors.ink,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'incl. in price',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.muted.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),
              _row('Taxable value', _fmt(taxable)),
              const SizedBox(height: 10),
              _row('CGST', _fmt(half)),
              const SizedBox(height: 10),
              _row('SGST', _fmt(half)),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _row('Total GST', _fmt(tax), bold: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: bold ? BrandColors.ink : BrandColors.muted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            color: BrandColors.ink,
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

// ── Voice consent card ────────────────────────────────────────────────────────

/// Shows the udhaar voice-consent status for an order: whether a clip was
/// recorded, whether the in-house model has analysed it yet, and (once analysed)
/// the speaker-match score + extracted terms. A 404 means none was recorded.
class _ConsentCard extends ConsumerStatefulWidget {
  final int orderId;
  const _ConsentCard({required this.orderId});

  @override
  ConsumerState<_ConsentCard> createState() => _ConsentCardState();
}

class _ConsentCardState extends ConsumerState<_ConsentCard> {
  bool _loading = true;
  Map<String, dynamic>? _data;
  bool _none = false;

  // Playback of the stored clip (fetched once via the authed proxy, then
  // played from memory).
  final AudioPlayer _player = AudioPlayer();
  Uint8List? _audioBytes;
  bool _playing = false;
  bool _loadingAudio = false;

  static const _color = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
    _load();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_playing) {
      await _player.pause();
      if (mounted) setState(() => _playing = false);
      return;
    }
    final url = _data?['audio_url'] as String?;
    if (url == null) return;
    try {
      if (_audioBytes == null) {
        setState(() => _loadingAudio = true);
        final bytes = await ref.read(apiClientProvider).getBytes(url);
        _audioBytes = Uint8List.fromList(bytes);
        if (mounted) setState(() => _loadingAudio = false);
      }
      await _player.play(BytesSource(_audioBytes!));
      if (mounted) setState(() => _playing = true);
    } catch (_) {
      if (mounted) setState(() => _loadingAudio = false);
    }
  }

  Future<void> _load() async {
    try {
      final res = await ref
          .read(apiClientProvider)
          .get('/kirana/finance/udhaar/consent/${widget.orderId}');
      if (mounted) {
        setState(() {
          _data = res as Map<String, dynamic>;
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _none = e.statusCode == 404;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    Widget body;
    if (_loading) {
      body = Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: _color),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.finConsentSectionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: BrandColors.ink,
            ),
          ),
        ],
      );
    } else if (_none || _data == null) {
      body = Row(
        children: [
          const Icon(Icons.mic_off_rounded, size: 18, color: BrandColors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.finConsentNone,
              style: const TextStyle(fontSize: 13, color: BrandColors.muted),
            ),
          ),
        ],
      );
    } else {
      final status = _data!['status'] as String? ?? 'pending';
      final analyzed = status == 'analyzed' || status == 'verified';
      final match = (_data!['voice_match_score'] as num?)?.toDouble();
      final promised = _data!['promised_date'] as String?;
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.record_voice_over_rounded,
                size: 18,
                color: _color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.finConsentSectionTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              // Play / pause the stored clip.
              _PlayButton(
                playing: _playing,
                loading: _loadingAudio,
                color: _color,
                onTap: _togglePlay,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Status on its own line so the descriptive label has room.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (analyzed ? BrandColors.success : _color).withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  analyzed ? Icons.verified_rounded : Icons.cloud_done_rounded,
                  size: 12,
                  color: analyzed ? BrandColors.success : _color,
                ),
                const SizedBox(width: 4),
                Text(
                  analyzed
                      ? l10n.finConsentStatusAnalyzed
                      : l10n.finConsentStatusPending,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: analyzed ? BrandColors.success : _color,
                  ),
                ),
              ],
            ),
          ),
          if (analyzed && match != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.finConsentMatchScore((match * 100).toStringAsFixed(0)),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: BrandColors.ink,
              ),
            ),
          ],
          if (promised != null && promised.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              l10n.finDueBy(promised),
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ],
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.18)),
      ),
      child: body,
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool playing;
  final bool loading;
  final Color color;
  final VoidCallback onTap;

  const _PlayButton({
    required this.playing,
    required this.loading,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: loading
            ? Padding(
                padding: const EdgeInsets.all(9),
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            : Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: color,
                size: 20,
              ),
      ),
    );
  }
}
