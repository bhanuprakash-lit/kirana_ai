import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../providers/intelligence_provider.dart';
import '../../models/recommendation_model.dart';
import '../../../pos_inventory/providers/procurement_provider.dart';
import '../dashboard_screen.dart';

class IntelligenceDetailScreen extends ConsumerStatefulWidget {
  final String type;
  const IntelligenceDetailScreen({super.key, required this.type});

  @override
  ConsumerState<IntelligenceDetailScreen> createState() =>
      _IntelligenceDetailScreenState();
}

class _IntelligenceDetailScreenState
    extends ConsumerState<IntelligenceDetailScreen> {
  String _searchQuery = '';

  String get _title {
    return {
          'stockout': 'Stockout Risk',
          'reorder': 'Reorder Required',
          'fast_moving': 'Fast Moving Items',
          'profit': 'High Profit Items',
        }[widget.type] ??
        'Intelligence Detail';
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(intelligenceProvider(widget.type));
    final sortMap = ref.watch(intelligenceSortProvider);
    final sortBy = sortMap[widget.type] ?? 'expected_profit';

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(sortBy),
          Expanded(
            child: asyncData.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(20),
                child: ListShimmer(itemCount: 6),
              ),
              error: (err, _) => _ErrorView(
                message: err.toString(),
                onRetry: () =>
                    ref.invalidate(intelligenceProvider(widget.type)),
              ),
              data: (items) {
                final filtered = items
                    .where(
                      (i) =>
                          i.productName.toLowerCase().contains(
                            _searchQuery.toLowerCase().trim(),
                          ) ||
                          i.categoryName.toLowerCase().contains(
                            _searchQuery.toLowerCase().trim(),
                          ),
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return _EmptyView(
                    query: _searchQuery,
                    onClear: () => setState(() => _searchQuery = ''),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(intelligenceProvider(widget.type)),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _RecommendationTile(item: filtered[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(String sortBy) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search_rounded),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              filled: true,
              fillColor: BrandColors.surfaceTint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.muted,
                ),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Profit',
                selected: sortBy == 'expected_profit',
                onSelected: (s) {
                  ref
                      .read(intelligenceSortProvider.notifier)
                      .setSort(widget.type, 'expected_profit');
                },
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: 'Demand',
                selected: sortBy == 'forecast_demand',
                onSelected: (s) {
                  ref
                      .read(intelligenceSortProvider.notifier)
                      .setSort(widget.type, 'forecast_demand');
                },
              ),
              if (widget.type == 'stockout' || widget.type == 'reorder') ...[
                const SizedBox(width: 6),
                _FilterChip(
                  label: 'Risk',
                  selected: sortBy == 'stockout_probability',
                  onSelected: (s) {
                    ref
                        .read(intelligenceSortProvider.notifier)
                        .setSort(widget.type, 'stockout_probability');
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationTile extends ConsumerWidget {
  final Recommendation item;
  const _RecommendationTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getColor(item.type);
    final days = item.daysToStockout;
    final prob = item.stockoutProbability;
    final reorder = item.reorderQty;
    final isUrgent = item.type == 'stockout_risk' || item.type == 'reorder_now';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.priority.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                if (item.currentStock != null)
                  Text(
                    'Stock: ${item.currentStock!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.muted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Product name + category ──────────────────────────────────────
            Text(
              item.productName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.categoryName,
              style: const TextStyle(
                fontSize: 13,
                color: BrandColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),

            // ── Stockout timeline bar ────────────────────────────────────────
            if (days != null && days < 60) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Stock runway',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                            Text(
                              days <= 0
                                  ? 'OUT OF STOCK'
                                  : '~${days.toStringAsFixed(0)} days left',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: days <= 3
                                    ? BrandColors.error
                                    : days <= 7
                                    ? Colors.orange
                                    : BrandColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (days / 30).clamp(0.0, 1.0),
                            backgroundColor: BrandColors.border,
                            color: days <= 3
                                ? BrandColors.error
                                : days <= 7
                                ? Colors.orange
                                : BrandColors.success,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            // ── Stats row: probability + reorder qty ────────────────────────
            if (prob != null || reorder != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (prob != null) ...[
                    _StatChip(
                      label: 'Stockout risk',
                      value: '${(prob * 100).toStringAsFixed(0)}%',
                      color: prob >= 0.7
                          ? BrandColors.error
                          : prob >= 0.4
                          ? Colors.orange
                          : BrandColors.success,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (reorder != null && reorder > 0)
                    _StatChip(
                      label: 'Reorder qty',
                      value: '${reorder.toStringAsFixed(0)} units',
                      color: BrandColors.primary,
                    ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Message ──────────────────────────────────────────────────────
            Text(
              item.message,
              style: const TextStyle(
                fontSize: 13,
                color: BrandColors.ink,
                height: 1.4,
              ),
            ),

            if (item.expectedProfitImpact != null &&
                item.expectedProfitImpact! > 0) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    size: 16,
                    color: BrandColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '₹${item.expectedProfitImpact!.toStringAsFixed(0)} estimated weekly profit impact',
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],

            // ── Action button for reorder/stockout items ─────────────────────
            if (isUrgent && reorder != null && reorder > 0) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Pre-fill the purchase order with this product + suggested
                    // qty, then jump to the procurement tab (tab 2, sub-tab 2).
                    ref.read(purchasePrefillProvider.notifier).set(
                          PurchasePrefill(
                            productId: item.skuId,
                            productName: item.productName,
                            qty: reorder.round(),
                          ),
                        );
                    Navigator.of(context).pop();
                    ref.read(dashboardTabProvider.notifier).switchTab(2);
                    ref.read(dashboardSubTabProvider.notifier).setSubTab(2);
                  },
                  icon: Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 16,
                    color: color,
                  ),
                  label: Text(
                    'Create Purchase Order · ${reorder.toStringAsFixed(0)} units',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getColor(String type) {
    switch (type) {
      case 'stockout_risk':
        return BrandColors.error;
      case 'reorder_now':
        return BrandColors.accent;
      case 'fast_moving':
        return BrandColors.success;
      case 'profit_opportunity':
        return BrandColors.primary;
      default:
        return BrandColors.muted;
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  const _EmptyView({required this.query, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: BrandColors.muted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No items found' : 'No results for "$query"',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: BrandColors.muted,
            ),
          ),
          if (query.isNotEmpty)
            TextButton(onPressed: onClear, child: const Text('Clear search')),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: BrandColors.muted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Connection Error',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: BrandColors.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : BrandColors.ink,
        fontWeight: FontWeight.w700,
        fontSize: 11,
      ),
      backgroundColor: BrandColors.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }
}
