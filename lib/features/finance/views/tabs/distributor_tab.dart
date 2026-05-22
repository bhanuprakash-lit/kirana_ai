import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/pos_inventory/models/procurement_models.dart';
import 'package:kirana_ai/features/pos_inventory/providers/procurement_provider.dart';
import '../../../../core/theme/brand_theme.dart';

// ── Date helpers ──────────────────────────────────────────────────────────────

bool _isToday(DateTime d) {
  final now = DateTime.now();
  return d.year == now.year && d.month == now.month && d.day == now.day;
}

bool _isWithinNextDays(DateTime d, int days) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(d.year, d.month, d.day);
  final diff = target.difference(today).inDays;
  return diff > 0 && diff <= days;
}

bool _isOverdue(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return DateTime(d.year, d.month, d.day).isBefore(today);
}

bool _withinLastDays(DateTime d, int days) {
  final now = DateTime.now();
  return now.difference(d).inDays <= days && now.difference(d).inDays >= 0;
}

String _dayLabel(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(d.year, d.month, d.day);
  final diff = target.difference(today).inDays;
  if (diff == 1) return 'Tomorrow';
  if (diff == 0) return 'Today';
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${weekdays[d.weekday - 1]} ${d.day}/${d.month}';
}

// ── Main widget ───────────────────────────────────────────────────────────────

class DistributorTab extends ConsumerWidget {
  const DistributorTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(procurementProvider);

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (data) {
        final unpaid = data.purchases.where((p) => p.paymentStatus != 'paid').toList();
        final paid   = data.purchases.where((p) => p.paymentStatus == 'paid').toList();

        // Buckets
        final overdue   = unpaid.where((p) => p.dueDate != null && _isOverdue(p.dueDate!)).toList()
          ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
        final dueToday  = unpaid.where((p) => p.dueDate != null && _isToday(p.dueDate!)).toList();
        final next7     = unpaid.where((p) => p.dueDate != null && _isWithinNextDays(p.dueDate!, 7)).toList()
          ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
        final paidLast7 = paid.where((p) => _withinLastDays(p.purchaseDate, 7)).toList()
          ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

        // Summary numbers
        final totalDue      = unpaid.fold(0.0, (s, p) => s + p.totalAmount);
        final todayDue      = dueToday.fold(0.0, (s, p) => s + p.totalAmount);
        final next7Due      = next7.fold(0.0, (s, p) => s + p.totalAmount);
        final paid7Total    = paidLast7.fold(0.0, (s, p) => s + p.totalAmount);

        return RefreshIndicator(
          onRefresh: () => ref.read(procurementProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              // ── Summary card ──────────────────────────────────────────────
              _SummaryCard(
                totalDue: totalDue,
                todayDue: todayDue,
                next7Due: next7Due,
                paid7Total: paid7Total,
              ),
              const SizedBox(height: 24),

              // ── Overdue ───────────────────────────────────────────────────
              if (overdue.isNotEmpty) ...[
                _SectionHeader(
                  label: 'Overdue',
                  count: overdue.length,
                  color: BrandColors.error,
                  icon: Icons.warning_rounded,
                ),
                const SizedBox(height: 10),
                ...overdue.map((p) => _PaymentTile(order: p, isOverdue: true)),
                const SizedBox(height: 20),
              ],

              // ── Due Today ─────────────────────────────────────────────────
              if (dueToday.isNotEmpty) ...[
                _SectionHeader(
                  label: 'Due Today',
                  count: dueToday.length,
                  color: Colors.orange,
                  icon: Icons.today_rounded,
                ),
                const SizedBox(height: 10),
                ...dueToday.map((p) => _PaymentTile(order: p)),
                const SizedBox(height: 20),
              ],

              // ── Next 7 Days ───────────────────────────────────────────────
              if (next7.isNotEmpty) ...[
                _SectionHeader(
                  label: 'Next 7 Days',
                  count: next7.length,
                  color: BrandColors.primary,
                  icon: Icons.date_range_rounded,
                ),
                const SizedBox(height: 10),
                ...next7.map((p) => _PaymentTile(order: p, showDayLabel: true)),
                const SizedBox(height: 20),
              ],

              // ── No upcoming payments ───────────────────────────────────────
              if (overdue.isEmpty && dueToday.isEmpty && next7.isEmpty) ...[
                _EmptyBanner(
                  icon: Icons.check_circle_rounded,
                  color: BrandColors.success,
                  message: 'No pending payments in the next 7 days',
                ),
                const SizedBox(height: 20),
              ],

              // ── Paid last 7 days ──────────────────────────────────────────
              _SectionHeader(
                label: 'Paid Last 7 Days',
                count: paidLast7.length,
                color: BrandColors.success,
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(height: 10),
              if (paidLast7.isEmpty)
                _EmptyBanner(
                  icon: Icons.receipt_long_outlined,
                  color: BrandColors.muted,
                  message: 'No payments recorded in the last 7 days',
                )
              else
                ...paidLast7.map((p) => _PaidTile(order: p)),

              const SizedBox(height: 24),

              // ── Suppliers (read-only) ─────────────────────────────────────
              _SectionHeader(
                label: 'Suppliers',
                count: data.suppliers.length,
                color: BrandColors.muted,
                icon: Icons.business_rounded,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: BrandColors.surfaceTint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: BrandColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: BrandColors.muted),
                    SizedBox(width: 8),
                    Text('Add or edit suppliers in the Purchase tab',
                        style: TextStyle(fontSize: 12, color: BrandColors.muted)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (data.suppliers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: Text('No suppliers yet.', style: TextStyle(color: BrandColors.muted))),
                )
              else
                ...data.suppliers.map((s) => _SupplierTile(supplier: s)),
            ],
          ),
        );
      },
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final double totalDue;
  final double todayDue;
  final double next7Due;
  final double paid7Total;

  const _SummaryCard({
    required this.totalDue,
    required this.todayDue,
    required this.next7Due,
    required this.paid7Total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          const Text('Total Outstanding', style: TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          Text(
            '₹${totalDue.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _MetricChip(label: 'Today', value: '₹${todayDue.toStringAsFixed(0)}', color: Colors.orange)),
              const SizedBox(width: 10),
              Expanded(child: _MetricChip(label: 'Next 7 Days', value: '₹${next7Due.toStringAsFixed(0)}', color: const Color(0xFF60A5FA))),
              const SizedBox(width: 10),
              Expanded(child: _MetricChip(label: 'Paid (7d)', value: '₹${paid7Total.toStringAsFixed(0)}', color: const Color(0xFF4ADE80))),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MetricChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _SectionHeader({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(width: 6),
        if (count > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$count', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }
}

// ── Empty banner ──────────────────────────────────────────────────────────────

class _EmptyBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  const _EmptyBanner({required this.icon, required this.color, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

// ── Pending payment tile ──────────────────────────────────────────────────────

class _PaymentTile extends ConsumerWidget {
  final PurchaseOrder order;
  final bool isOverdue;
  final bool showDayLabel;

  const _PaymentTile({
    required this.order,
    this.isOverdue = false,
    this.showDayLabel = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isOverdue ? BrandColors.error.withValues(alpha: 0.3) : BrandColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                // Left: supplier + date label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.notes_rounded, size: 12, color: BrandColors.muted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(order.notes ?? 'Stock Purchase',
                                style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      if (order.dueDate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isOverdue ? Icons.error_outline_rounded : Icons.schedule_rounded,
                              size: 12,
                              color: isOverdue ? BrandColors.error : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isOverdue
                                  ? 'Overdue since ${order.dueDate!.day}/${order.dueDate!.month}'
                                  : showDayLabel
                                      ? 'Due ${_dayLabel(order.dueDate!)}'
                                      : 'Due today',
                              style: TextStyle(
                                fontSize: 11,
                                color: isOverdue ? BrandColors.error : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Right: amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: isOverdue ? BrandColors.error : BrandColors.ink,
                      ),
                    ),
                    Text('to pay', style: TextStyle(fontSize: 10, color: BrandColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _showDetails(context, ref),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.muted,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Details', style: TextStyle(fontSize: 13)),
                ),
              ),
              Container(width: 1, height: 28, color: BrandColors.border),
              Expanded(
                child: TextButton(
                  onPressed: () => ref.read(procurementProvider.notifier).markAsPaid(order.purchaseId),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Mark Paid ✓', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, WidgetRef ref) {
    // Fetch once before showing — prevents future recreation on every builder rebuild
    final itemsFuture =
        ref.read(procurementProvider.notifier).fetchPurchaseItems(order.purchaseId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => FutureBuilder<List<PurchaseItem>>(
          future: itemsFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
            }
            final items = snapshot.data ?? [];
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              children: [
                // Drag handle
                Center(child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(order.supplierName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Purchase on ${order.purchaseDate.day}/${order.purchaseDate.month}/${order.purchaseDate.year}',
                    style: const TextStyle(color: BrandColors.muted, fontSize: 13)),
                const Divider(height: 28),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('No items found.', style: TextStyle(color: BrandColors.muted)),
                  )
                else
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productName,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                  Text('${item.quantity.toStringAsFixed(0)} × ₹${item.costPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
                                ],
                              ),
                            ),
                            Text('₹${(item.quantity * item.costPrice).toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      )),
                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('₹${order.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: BrandColors.error)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Paid tile (last 7 days) ───────────────────────────────────────────────────

class _PaidTile extends StatelessWidget {
  final PurchaseOrder order;
  const _PaidTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: BrandColors.success.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: BrandColors.success, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.supplierName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                Text(
                  '${order.purchaseDate.day}/${order.purchaseDate.month}/${order.purchaseDate.year}  ·  ${order.notes ?? 'Stock Purchase'}',
                  style: const TextStyle(fontSize: 11, color: BrandColors.muted),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '₹${order.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: BrandColors.success),
          ),
        ],
      ),
    );
  }
}

// ── Supplier read-only tile ───────────────────────────────────────────────────

class _SupplierTile extends StatelessWidget {
  final Supplier supplier;
  const _SupplierTile({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: BrandColors.primary.withValues(alpha: 0.1),
            child: const Icon(Icons.business_rounded, color: BrandColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(supplier.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                if (supplier.phone != null)
                  Text(supplier.phone!,
                      style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
              ],
            ),
          ),
          if (supplier.category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: BrandColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(supplier.category!,
                  style: const TextStyle(
                      fontSize: 10, color: BrandColors.primary, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}
