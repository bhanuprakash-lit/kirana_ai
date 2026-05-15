import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/brand_theme.dart';
import '../providers/pos_provider.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posState = ref.watch(posProvider);
    final items = (order['items'] as List<dynamic>?) ?? [];
    final total = (order['total_amount'] as num?)?.toDouble() ?? 0;
    final status = order['order_status'] as String? ?? 'completed';
    final paymentMethod = order['payment_method'] as String? ?? 'Cash';
    final date = order['order_date'] as String? ?? '';
    final customerId = order['customer_id'] as int?;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text('Order Details', style: const TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: BrandColors.ink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Card
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
                          'Order #${order['order_id']}',
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
                      label: 'Payment',
                      value: paymentMethod.toUpperCase(),
                      icon: Icons.payments_outlined,
                    ),
                    _InfoTile(
                      label: 'Total Amount',
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
                      const Icon(Icons.person_outline_rounded, size: 18, color: BrandColors.muted),
                      const SizedBox(width: 8),
                      Text(
                        'Customer ID: $customerId',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 28),
          const Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 20, color: BrandColors.primary),
              SizedBox(width: 8),
              Text(
                'Items Summary',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: BrandColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
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
                  
                  final product = posState.products.where((p) => p.productId == productId).firstOrNull;
                  final productName = product?.name ?? 'Product #$productId';
                  final unit = product?.unit ?? 'unit';

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
                          child: const Icon(Icons.shopping_bag_outlined, color: BrandColors.primary, size: 22),
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
                                '${qty.toStringAsFixed(qty == qty.toInt() ? 0 : 2)} $unit x ${_fmt(price)}',
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
          // Total Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: BrandColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Paid',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
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
          ),
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
    final color = status.toLowerCase() == 'completed' ? BrandColors.success : BrandColors.warning;
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
