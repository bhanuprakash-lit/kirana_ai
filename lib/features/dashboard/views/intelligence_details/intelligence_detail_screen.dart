import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../providers/intelligence_provider.dart';
import '../../models/recommendation_model.dart';

class IntelligenceDetailScreen extends ConsumerStatefulWidget {
  final String type;
  const IntelligenceDetailScreen({super.key, required this.type});

  @override
  ConsumerState<IntelligenceDetailScreen> createState() => _IntelligenceDetailScreenState();
}

class _IntelligenceDetailScreenState extends ConsumerState<IntelligenceDetailScreen> {
  String _searchQuery = '';

  String get _title {
    return {
      'stockout': 'Stockout Risk',
      'reorder': 'Reorder Required',
      'fast_moving': 'Fast Moving Items',
      'profit': 'High Profit Items',
    }[widget.type] ?? 'Intelligence Detail';
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(intelligenceProvider(widget.type));
    final sortMap = ref.watch(intelligenceSortProvider);
    final sortBy = sortMap[widget.type] ?? 'expected_profit';

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(_title, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(sortBy),
          Expanded(
            child: asyncData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => _ErrorView(
                message: err.toString(),
                onRetry: () => ref.invalidate(intelligenceProvider(widget.type)),
              ),
              data: (items) {
                final filtered = items.where((i) => 
                  i.productName.toLowerCase().contains(_searchQuery.toLowerCase().trim()) ||
                  i.categoryName.toLowerCase().contains(_searchQuery.toLowerCase().trim())
                ).toList();

                if (filtered.isEmpty) {
                  return _EmptyView(
                    query: _searchQuery,
                    onClear: () => setState(() => _searchQuery = ''),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(intelligenceProvider(widget.type)),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _RecommendationTile(item: filtered[index]),
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
              const Text('Sort by:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BrandColors.muted)),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Profit',
                selected: sortBy == 'expected_profit',
                onSelected: (s) {
                  ref.read(intelligenceSortProvider.notifier).setSort(widget.type, 'expected_profit');
                },
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: 'Demand',
                selected: sortBy == 'forecast_demand',
                onSelected: (s) {
                  ref.read(intelligenceSortProvider.notifier).setSort(widget.type, 'forecast_demand');
                },
              ),
              if (widget.type == 'stockout' || widget.type == 'reorder') ...[
                const SizedBox(width: 6),
                _FilterChip(
                  label: 'Risk',
                  selected: sortBy == 'stockout_probability',
                  onSelected: (s) {
                    ref.read(intelligenceSortProvider.notifier).setSort(widget.type, 'stockout_probability');
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

class _RecommendationTile extends StatelessWidget {
  final Recommendation item;
  const _RecommendationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(item.type);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.8)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.priority.toUpperCase(),
                        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ),
                    const Spacer(),
                    if (item.currentStock != null)
                      Text(
                        'Stock: ${item.currentStock!.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BrandColors.muted),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.productName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: BrandColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  item.categoryName,
                  style: const TextStyle(fontSize: 13, color: BrandColors.muted, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  item.message,
                  style: const TextStyle(fontSize: 13, color: BrandColors.ink, height: 1.4),
                ),
                if (item.expectedProfitImpact != null && item.expectedProfitImpact! > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.trending_up_rounded, size: 16, color: BrandColors.success),
                      const SizedBox(width: 6),
                      Text(
                        '₹${item.expectedProfitImpact!.toStringAsFixed(0)} expected profit impact',
                        style: const TextStyle(fontSize: 12, color: BrandColors.success, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(String type) {
    switch (type) {
      case 'stockout_risk': return BrandColors.error;
      case 'reorder_now': return BrandColors.accent;
      case 'fast_moving': return BrandColors.success;
      case 'profit_opportunity': return BrandColors.primary;
      default: return BrandColors.muted;
    }
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
          Icon(Icons.search_off_rounded, size: 48, color: BrandColors.muted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No items found' : 'No results for "$query"',
            style: const TextStyle(fontWeight: FontWeight.w700, color: BrandColors.muted),
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
            const Icon(Icons.cloud_off_rounded, size: 48, color: BrandColors.muted),
            const SizedBox(height: 16),
            const Text('Connection Error', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: BrandColors.muted)),
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

  const _FilterChip({required this.label, required this.selected, required this.onSelected});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }
}
