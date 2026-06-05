import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kirana_ai/core/theme/brand_theme.dart';
import 'package:kirana_ai/l10n/generated/app_localizations.dart';
import 'package:kirana_ai/features/pos_inventory/models/procurement_models.dart';
import 'package:kirana_ai/features/pos_inventory/providers/procurement_provider.dart';
import 'package:kirana_ai/shared/widgets/shimmer_widgets.dart';
// import '../../pos_inventory/providers/pos_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.psetAllHistory,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: BrandColors.primary,
          unselectedLabelColor: BrandColors.muted,
          indicatorColor: BrandColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: l10n.psetTabPurchases),
            Tab(text: l10n.psetTabPosOrders),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_PurchaseHistoryList(), _PosOrderHistorySummary()],
      ),
    );
  }
}

class _PurchaseHistoryList extends ConsumerWidget {
  const _PurchaseHistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(procurementProvider);
    final l10n = AppLocalizations.of(context);

    return asyncData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: ListShimmer(itemCount: 6),
      ),
      error: (err, _) =>
          Center(child: Text(l10n.psetErrorWith(err.toString()))),
      data: (data) {
        if (data.purchases.isEmpty) {
          return Center(child: Text(l10n.psetNoPurchaseHistory));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: data.purchases.length,
          itemBuilder: (ctx, index) {
            final p = data.purchases[index];
            return _PurchaseTile(order: p);
          },
        );
      },
    );
  }
}

class _PurchaseTile extends ConsumerWidget {
  final PurchaseOrder order;
  const _PurchaseTile({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(order.purchaseDate.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.supplierName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${order.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      (order.status.name == 'received'
                              ? BrandColors.success
                              : Colors.orange)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: order.status.name == 'received'
                        ? BrandColors.success
                        : Colors.orange,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showPurchaseDetails(context, ref),
                child: Text(l10n.psetViewBill),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPurchaseDetails(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dateStr = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(order.purchaseDate.toLocal());

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => FutureBuilder<List<PurchaseItem>>(
        future: ref
            .read(procurementProvider.notifier)
            .fetchPurchaseItems(order.purchaseId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: ListShimmer(itemCount: 3, itemHeight: 56),
            );
          }
          final items = snapshot.data ?? [];
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.psetPurchaseDetails,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.psetFromSupplier(order.supplierName),
                  style: const TextStyle(color: BrandColors.muted),
                ),
                const Divider(height: 32),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.productName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.psetQtyTimes(
                            item.quantity.toStringAsFixed(0),
                            item.costPrice.toStringAsFixed(0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.psetTotalAmount,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PosOrderHistorySummary extends ConsumerWidget {
  const _PosOrderHistorySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: BrandColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.point_of_sale_rounded,
              size: 64,
              color: BrandColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.psetSalesTxnHistory,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.psetSalesTxnDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 220,
            height: 54,
            child: ElevatedButton(
              onPressed: () => context.push('/pos-history'),
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.psetOpenSalesHistory,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
