import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../providers/pos_provider.dart';
import '../order_details_screen.dart';

void showTodayOrdersSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: _TodayOrdersSheet(ref: ref),
    ),
  );
}

class _TodayOrdersSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _TodayOrdersSheet({required this.ref});

  @override
  ConsumerState<_TodayOrdersSheet> createState() => _TodayOrdersSheetState();
}

class _TodayOrdersSheetState extends ConsumerState<_TodayOrdersSheet> {
  List<Map<String, dynamic>>? _orders;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final orders = await ref.read(posProvider.notifier).fetchTodayOrders();
    if (mounted) {
      setState(() {
        _orders = orders;
        _loading = false;
      });
    }
  }

  String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  String _timeOf(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => GestureDetector(
        onTap: () {}, // Prevent taps on the sheet itself from dismissing it
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: BrandColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
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
                            "Today's Orders",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: BrandColors.ink,
                            ),
                          ),
                          if (_orders != null)
                            Text(
                              '${_orders!.length} transactions so far',
                              style: const TextStyle(
                                fontSize: 13,
                                color: BrandColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push('/pos-history');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: BrandColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Icon(Icons.chevron_right_rounded, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _orders == null || _orders!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: BrandColors.surfaceTint,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.inbox_rounded,
                                size: 48,
                                color: BrandColors.muted,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No orders today yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: BrandColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sales transactions will appear here',
                              style: TextStyle(
                                fontSize: 13,
                                color: BrandColors.muted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                        itemCount: _orders!.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final o = _orders![i];
                          final amount =
                              (o['total_amount'] as num?)?.toDouble() ?? 0;
                          final status =
                              o['order_status'] as String? ?? 'completed';
                          final date = o['order_date'] as String? ?? '';
                          final payment =
                              o['payment_method'] as String? ?? 'Cash';

                          return Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OrderDetailsScreen(order: o),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: BrandColors.border.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: BrandColors.success.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.receipt_rounded,
                                        color: BrandColors.success,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order #${o['order_id']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                              color: BrandColors.ink,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_timeOf(date)} · $payment · ${status.toUpperCase()}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: BrandColors.muted,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _fmt(amount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: BrandColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
