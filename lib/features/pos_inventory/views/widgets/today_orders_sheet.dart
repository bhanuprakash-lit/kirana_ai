// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../providers/pos_provider.dart';
import '../../providers/printer_provider.dart';
import '../../../profile/providers/store_settings_provider.dart';
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

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

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
      // Backend sends UTC without 'Z' — must append it before parsing.
      var s = dateStr;
      if (s.isNotEmpty && !s.endsWith('Z') && !s.contains('+')) s += 'Z';
      final dt = DateTime.parse(s).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }

  Future<void> _printOrder(Map<String, dynamic> order) async {
    final store = await ref.read(storeSettingsProvider.future);
    final products = ref.read(posProvider).products;
    final receipt = PrinterNotifier.buildReceipt(
      order: order,
      store: store,
      products: products,
    );
    final ok = await ref.read(printerProvider.notifier).printOrder(receipt);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_l10n.posPrintFailedCheckConnection),
          backgroundColor: BrandColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final printerState = ref.watch(printerProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => GestureDetector(
        onTap: () {}, // prevent sheet dismissal on internal taps
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
                            l10n.posTodaysOrders,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: BrandColors.ink,
                            ),
                          ),
                          if (_orders != null)
                            Text(
                              l10n.posTransactionsSoFar(_orders!.length),
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
                      child: Row(
                        children: [
                          Text(
                            l10n.posViewAll,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 18),
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
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: ListShimmer(itemCount: 5),
                      )
                    : _orders == null || _orders!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: const BoxDecoration(
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
                            Text(
                              l10n.posNoOrdersToday,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: BrandColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.posSalesAppearHere,
                              style: const TextStyle(
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
                                    // Icon
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
                                    // Order info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.posOrderNumber(
                                              '${o['order_id']}',
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                              color: BrandColors.ink,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            l10n.posOrderMeta(
                                              _timeOf(date),
                                              payment,
                                              status.toUpperCase(),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: BrandColors.muted,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Amount + Print button
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _fmt(amount),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            color: BrandColors.success,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        // ── Print button ─────────────────
                                        GestureDetector(
                                          onTap: () => _printOrder(o),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: printerState.isConnected
                                                  ? BrandColors.primary
                                                        .withValues(alpha: 0.08)
                                                  : BrandColors.surfaceTint,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: printerState.isConnected
                                                    ? BrandColors.primary
                                                          .withValues(
                                                            alpha: 0.3,
                                                          )
                                                    : BrandColors.border,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.print_rounded,
                                                  size: 12,
                                                  color:
                                                      printerState.isConnected
                                                      ? BrandColors.primary
                                                      : BrandColors.muted,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  l10n.posPrint,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        printerState.isConnected
                                                        ? BrandColors.primary
                                                        : BrandColors.muted,
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
