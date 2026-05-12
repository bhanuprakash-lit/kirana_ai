import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/brand_theme.dart';
import '../providers/customer_provider.dart';
import '../models/customer_model.dart';
import 'customer_management_screen.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final int customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerProvider);
    final customer = state.customers.firstWhere(
      (c) => c.customerId == customerId,
      orElse: () => Customer(customerId: customerId, name: 'Loading...', phone: ''),
    );

    final ordersAsync = ref.watch(customerOrdersProvider(customerId));
    final khataAsync = ref.watch(customerKhataProvider(customerId));

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Customer Details', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditCustomerSheet(context, ref, customer),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: BrandColors.error),
            onPressed: () => _confirmDelete(context, ref, customer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: BrandColors.surfaceTint,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: BrandColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    customer.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: BrandColors.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.phone,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: BrandColors.muted),
                  ),
                  if (customer.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      customer.email!,
                      style: const TextStyle(fontSize: 14, color: BrandColors.muted),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Balance',
                      value: khataAsync.when(
                        data: (khata) => '₹${(khata?['amount'] as num? ?? 0) - (khata?['amount_paid'] as num? ?? 0)}',
                        loading: () => '...',
                        error: (_, __) => 'N/A',
                      ),
                      icon: Icons.account_balance_wallet_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Spent',
                      value: ordersAsync.when(
                        data: (orders) {
                          final total = orders.fold<double>(0, (sum, o) => sum + (o['total_amount'] as num).toDouble());
                          return '₹${NumberFormat('#,##,###').format(total)}';
                        },
                        loading: () => '...',
                        error: (_, __) => 'N/A',
                      ),
                      icon: Icons.shopping_bag_outlined,
                      color: BrandColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Orders',
                      value: ordersAsync.when(
                        data: (orders) => orders.length.toString(),
                        loading: () => '...',
                        error: (_, __) => 'N/A',
                      ),
                      icon: Icons.receipt_long_outlined,
                      color: BrandColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Section
            _SectionHeader(title: 'Customer Info'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'Household Size', value: '${customer.householdSize} members', icon: Icons.group_outlined),
                  const Divider(height: 32),
                  _InfoRow(
                    label: 'Joined On', 
                    value: customer.createdAt != null ? DateFormat('MMM dd, yyyy').format(customer.createdAt!) : 'Unknown', 
                    icon: Icons.calendar_today_outlined
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Purchase History
            _SectionHeader(title: 'Purchase History'),
            ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No orders found for this customer.'),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _OrderListItem(order: order);
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(40),
                child: Text('Error loading orders: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCustomerSheet(BuildContext context, WidgetRef ref, Customer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerFormSheet(customer: customer),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer?'),
        content: Text('Are you sure you want to delete ${customer.name}? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(customerProvider.notifier).deleteCustomer(customer.customerId);
              if (context.mounted) {
                Navigator.pop(context); // pop dialog
                context.pop(); // pop detail screen
              }
            },
            child: const Text('Delete', style: TextStyle(color: BrandColors.error)),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: BrandColors.muted, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: BrandColors.muted, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: BrandColors.muted),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: BrandColors.muted, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: BrandColors.ink)),
          ],
        ),
      ],
    );
  }
}

class _OrderListItem extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderListItem({required this.order});

  @override
  Widget build(BuildContext context) {
    final dateStr = order['order_date'] as String;
    final date = DateTime.parse(dateStr).toLocal();
    final amount = (order['total_amount'] as num).toDouble();

    return InkWell(
      onTap: () => context.push('/pos-order-details', extra: order),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BrandColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order['order_id']}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(date),
                  style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '₹${amount.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: BrandColors.primary),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, size: 18, color: BrandColors.muted),
          ],
        ),
      ),
    );
  }
}
