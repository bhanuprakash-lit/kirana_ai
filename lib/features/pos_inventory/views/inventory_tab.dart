// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../core/vertical/vertical_config_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/inventory_item.dart';
import '../models/pending_inventory_item.dart';
import '../providers/inventory_provider.dart';
import '../providers/near_expiry_provider.dart';
import '../providers/price_memory_provider.dart';
import '../providers/ml_flags_provider.dart';
import 'near_expiry_screen.dart';
import 'price_memory_screen.dart';
// import 'widgets/add_product_sheet.dart';
import 'widgets/add_product_sheet_new.dart';
import 'widgets/barcode_scanner_overlay.dart';
import 'widgets/edit_product_sheet.dart';

class InventoryTab extends ConsumerStatefulWidget {
  const InventoryTab({super.key});

  @override
  ConsumerState<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends ConsumerState<InventoryTab> {
  final _searchCtrl = TextEditingController();
  String? _selectedCategory;
  String? _selectedFlag; // AI-tag (ML flag) filter, null = all
  String _searchQuery = '';
  bool _isExpanded = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerOverlay()),
    );
    if (barcode == null || !mounted) return;

    final data = ref.read(inventoryProvider).value;
    if (data == null) return;

    final item = data.items.where((i) => i.barcode == barcode).firstOrNull;

    if (item != null) {
      _showEditProduct(item);
    } else {
      if (mounted) showAddProductSheet(context, ref, initialBarcode: barcode);
    }
  }

  void _showEditProduct(InventoryItem item) {
    showEditProductSheet(context, ref, item);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncData = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_product_fab',
        onPressed: () => showAddProductSheet(context, ref),
        backgroundColor: BrandColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: asyncData.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ListShimmer(itemCount: 8),
        ),
        error: (err, _) => _ErrorView(
          message: err.toString(),
          onRetry: () => ref.read(inventoryProvider.notifier).refresh(),
        ),
        data: (data) {
          if (data.items.isEmpty) {
            return _EmptyInventory(
              onAdd: () => showAddProductSheet(context, ref),
              title: verticalConfigOf(ref).copy(
                'empty_inventory',
                AppLocalizations.of(context).invNoInventoryYet,
              ),
            );
          }

          // Only show categories that actually have items in this store's inventory
          final categories =
              data.items
                  .map((i) => i.categoryName)
                  .whereType<String>()
                  .toSet()
                  .toList()
                ..sort();

          // AI tags (ML flags) per product — same source as the per-item chips.
          final mlFlags =
              ref.watch(inventoryFlagsProvider).asData?.value ??
              const <int, List<String>>{};
          // Only offer tag filters for flags that actually occur in this store.
          final availableFlags = [
            for (final f in _flagOrder)
              if (data.items.any(
                (it) => (mlFlags[it.productId] ?? const []).contains(f),
              ))
                f,
          ];

          final q = _searchQuery.toLowerCase().trim();
          final filteredItems = data.items.where((item) {
            final matchesCategory =
                _selectedCategory == null ||
                item.categoryName == _selectedCategory;
            final matchesFlag =
                _selectedFlag == null ||
                (mlFlags[item.productId] ?? const []).contains(_selectedFlag);
            final matchesSearch =
                q.isEmpty ||
                item.name.toLowerCase().contains(q) ||
                (item.categoryName?.toLowerCase().contains(q) ?? false) ||
                (item.brand?.toLowerCase().contains(q) ?? false);
            return matchesCategory && matchesFlag && matchesSearch;
          }).toList();

          final Map<String, List<InventoryItem>> filteredGrouped = {};
          for (final item in filteredItems) {
            final cat = item.categoryName ?? l10n.invUncategorised;
            filteredGrouped.putIfAbsent(cat, () => []).add(item);
          }

          final nearExpiryCount = ref.watch(nearExpiryCountProvider);
          final missingPriceCount = ref.watch(missingPriceCountProvider);

          return RefreshIndicator.adaptive(
            onRefresh: () => ref.read(inventoryProvider.notifier).refresh(),
            color: BrandColors.primary,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            decoration: InputDecoration(
                              hintText: l10n.invSearchItemsOrCategories,
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 20,
                                color: BrandColors.muted,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear_rounded,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: BrandColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: BrandColors.border,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _scanBarcode,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: BrandColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (nearExpiryCount > 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
                      child: _NearExpiryBanner(
                        count: nearExpiryCount,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NearExpiryScreen(),
                          ),
                        ),
                      ),
                    ),
                  ),

                if (missingPriceCount > 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 2),
                      child: _MissingPriceBanner(
                        count: missingPriceCount,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PriceMemoryScreen(),
                          ),
                        ),
                      ),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final allCategories = ['All', ...categories];
                        final initialCount = constraints.maxWidth > 400 ? 6 : 4;

                        final displayCategories = _isExpanded
                            ? allCategories
                            : allCategories.take(initialCount).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 0,
                              children: [
                                for (final cat in displayCategories)
                                  _CategoryChip(
                                    label: cat == 'All' ? l10n.invAll : cat,
                                    isSelected: cat == 'All'
                                        ? _selectedCategory == null
                                        : _selectedCategory == cat,
                                    onTap: () => setState(() {
                                      _selectedCategory = cat == 'All'
                                          ? null
                                          : cat;
                                      // Collapse the expanded chip list once a
                                      // category is picked.
                                      _isExpanded = false;
                                    }),
                                  ),

                                if (!_isExpanded &&
                                    allCategories.length > initialCount)
                                  _ViewMoreChip(
                                    label: l10n.invViewMore(
                                      allCategories.length - initialCount,
                                    ),
                                    onTap: () =>
                                        setState(() => _isExpanded = true),
                                  ),
                              ],
                            ),
                            if (_isExpanded)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      setState(() => _isExpanded = false),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_up_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    l10n.invShowLess,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: BrandColors.primary,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // ── AI tag filters (ML flags) ────────────────────────────
                if (availableFlags.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 4,
                              right: 6,
                              bottom: 8,
                            ),
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 15,
                              color: BrandColors.muted,
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                for (final f in availableFlags)
                                  _FlagChip(
                                    flag: f,
                                    isSelected: _selectedFlag == f,
                                    onTap: () => setState(() {
                                      _selectedFlag = _selectedFlag == f
                                          ? null
                                          : f;
                                    }),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Pending (optimistic) items ───────────────────────────
                if (data.pendingItems.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _PendingTile(
                          pending: data.pendingItems[i],
                          onRetry:
                              data.pendingItems[i].status ==
                                  PendingStatus.failed
                              ? () => ref
                                    .read(inventoryProvider.notifier)
                                    .retryPending(data.pendingItems[i].tempId)
                              : null,
                        ),
                        childCount: data.pendingItems.length,
                      ),
                    ),
                  ),

                if (filteredItems.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        l10n.invNoMatchesFound,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    ),
                  )
                else
                  for (final entry in filteredGrouped.entries) ...[
                    if (_selectedCategory == null)
                      SliverToBoxAdapter(
                        child: _CategoryHeader(
                          name: entry.key,
                          count: entry.value.length,
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => _InventoryTile(
                            item: entry.value[i],
                            mlFlags:
                                mlFlags[entry.value[i].productId] ?? const [],
                            onTap: () => _showEditProduct(entry.value[i]),
                          ),
                          childCount: entry.value.length,
                        ),
                      ),
                    ),
                  ],
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ), // FAB clearance
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NearExpiryBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NearExpiryBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const amber = Color(0xFFE87722);
    return Material(
      color: amber.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: amber, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.invNearExpiryBanner(count),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: amber),
            ],
          ),
        ),
      ),
    );
  }
}

// ── AI tags (ML flags) — shared metadata used by per-item chips + filters ─────

const _flagOrder = <String>[
  'fast_moving',
  'reorder_now',
  'stockout_risk',
  'dead_stock',
  'profit_opportunity',
];

const _flagMeta = <String, (IconData, Color)>{
  'fast_moving': (Icons.trending_up_rounded, BrandColors.success),
  'reorder_now': (Icons.refresh_rounded, BrandColors.accent),
  'stockout_risk': (Icons.warning_amber_rounded, BrandColors.error),
  'dead_stock': (Icons.snooze_rounded, Color(0xFFB08D57)),
  'profit_opportunity': (Icons.stars_rounded, BrandColors.primary),
};

String _flagLabel(AppLocalizations l10n, String flag) {
  switch (flag) {
    case 'fast_moving':
      return l10n.invFlagFast;
    case 'reorder_now':
      return l10n.invFlagReorder;
    case 'stockout_risk':
      return l10n.invFlagLowStock;
    case 'dead_stock':
      return l10n.invFlagDead;
    case 'profit_opportunity':
      return l10n.invFlagProfit;
    default:
      return flag;
  }
}

/// A selectable filter chip for one AI tag (ML flag), coloured per tag.
class _FlagChip extends StatelessWidget {
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _FlagChip({
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final meta = _flagMeta[flag];
    final color = meta?.$2 ?? BrandColors.primary;
    final icon = meta?.$1 ?? Icons.auto_awesome_rounded;
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 14, color: isSelected ? Colors.white : color),
        label: Text(_flagLabel(l10n, flag)),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: color,
        backgroundColor: color.withValues(alpha: 0.08),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? color : color.withValues(alpha: 0.4),
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      ),
    );
  }
}

/// Renders every ML flag an item carries (fast moving, reorder, etc.) as chips.
class _MlFlagChips extends StatelessWidget {
  final List<String> flags;
  const _MlFlagChips({required this.flags});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // De-dup while preserving order; map unknown types out.
    final seen = <String>{};
    final chips = <Widget>[];
    for (final f in flags) {
      final m = _flagMeta[f];
      if (m == null || !seen.add(f)) continue;
      chips.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: m.$2.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(m.$1, size: 10, color: m.$2),
              const SizedBox(width: 3),
              Text(
                _flagLabel(l10n, f),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: m.$2,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 4, runSpacing: 4, children: chips);
  }
}

class _MissingPriceBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _MissingPriceBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: BrandColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.price_change_outlined,
                color: BrandColors.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.invMissingPriceBanner(count),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: BrandColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: BrandColors.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : BrandColors.ink,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? BrandColors.primary : BrandColors.border,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      ),
    );
  }
}

class _ViewMoreChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ViewMoreChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: onTap,
        backgroundColor: BrandColors.surfaceTint,
        labelStyle: const TextStyle(
          color: BrandColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: BrandColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String name;
  final int count;
  const _CategoryHeader({required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: BrandColors.muted,
              ),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(
              color: BrandColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;
  final List<String> mlFlags;
  const _InventoryTile({
    required this.item,
    required this.onTap,
    this.mlFlags = const [],
  });

  Color _categoryColor(String? cat) {
    final c = cat?.toLowerCase() ?? '';
    if (c.contains('staple') || c.contains('grain')) return Colors.amber;
    if (c.contains('dairy')) return Colors.lightBlue;
    if (c.contains('drink') || c.contains('beverage')) return Colors.teal;
    if (c.contains('snack')) return Colors.deepPurple;
    if (c.contains('care') || c.contains('soap')) return Colors.pink;
    if (c.contains('clean')) return Colors.green;
    if (c.contains('veg')) return Colors.lightGreen;
    if (c.contains('fruit')) return Colors.red;
    if (c.contains('medic')) return Colors.indigo;
    return BrandColors.primary;
  }

  IconData _categoryIcon(String? cat) {
    final c = cat?.toLowerCase() ?? '';
    if (c.contains('staple') || c.contains('grain') || c.contains('rice')) {
      return Icons.grain_rounded;
    }
    if (c.contains('dairy') || c.contains('milk') || c.contains('curd')) {
      return Icons.egg_alt_rounded;
    }
    if (c.contains('drink') || c.contains('beverage') || c.contains('juice')) {
      return Icons.local_drink_rounded;
    }
    if (c.contains('snack') || c.contains('biscuit') || c.contains('chip')) {
      return Icons.cookie_rounded;
    }
    if (c.contains('care') || c.contains('soap') || c.contains('hygiene')) {
      return Icons.spa_rounded;
    }
    if (c.contains('clean') || c.contains('deterg')) {
      return Icons.cleaning_services_rounded;
    }
    if (c.contains('veg')) return Icons.eco_rounded;
    if (c.contains('fruit')) return Icons.apple_rounded;
    if (c.contains('medic') || c.contains('pharma')) {
      return Icons.medication_rounded;
    }
    return Icons.inventory_2_rounded;
  }

  Widget _iconBox(Color catColor) => Container(
    width: 40,
    height: 40,
    color: catColor.withValues(alpha: 0.1),
    child: Icon(_categoryIcon(item.categoryName), color: catColor, size: 20),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catColor = _categoryColor(item.categoryName);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.imageUrl != null
              ? Image.network(
                  item.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => _iconBox(catColor),
                )
              : _iconBox(catColor),
        ),
        title: Text(
          item.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: BrandColors.ink,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    '₹${item.price.toStringAsFixed(0)} / ${item.isLoose ? (item.unit ?? l10n.invUnitFallback) : l10n.invUnitFallback}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: BrandColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    l10n.invStockLabel(item.stockLabel),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: item.isOutOfStock
                          ? BrandColors.error
                          : item.isLowStock
                          ? BrandColors.accent
                          : BrandColors.muted,
                      fontWeight: item.isLowStock || item.isOutOfStock
                          ? FontWeight.w700
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (mlFlags.isNotEmpty) ...[
              const SizedBox(height: 4),
              _MlFlagChips(flags: mlFlags),
            ],
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: BrandColors.muted,
          size: 20,
        ),
      ),
    );
  }
}

// ── Pending tile ──────────────────────────────────────────────────────────────

class _PendingTile extends StatelessWidget {
  final PendingInventoryItem pending;
  final VoidCallback? onRetry;
  const _PendingTile({required this.pending, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failed = pending.status == PendingStatus.failed;
    final accent = failed ? BrandColors.error : BrandColors.primary;

    return GestureDetector(
      onTap: onRetry,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: failed
              ? BrandColors.error.withValues(alpha: 0.05)
              : BrandColors.primary.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accent.withValues(alpha: failed ? 0.35 : 0.2),
          ),
        ),
        child: ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          leading: SizedBox(
            width: 40,
            height: 40,
            child: failed
                ? Icon(Icons.cloud_off_rounded, color: accent, size: 22)
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: BrandColors.primary,
                    ),
                  ),
          ),
          title: Text(
            pending.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: BrandColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            failed ? l10n.invSyncFailedTapRetry : l10n.invSyncingToServer,
            style: TextStyle(
              fontSize: 12,
              color: accent,
              fontWeight: failed ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          trailing: failed
              ? Icon(Icons.refresh_rounded, color: accent, size: 20)
              : null,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EmptyInventory extends StatelessWidget {
  final VoidCallback onAdd;
  final String title;
  const _EmptyInventory({required this.onAdd, required this.title});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: BrandColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: BrandColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.invNoInventoryHint,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.invAddFirstProduct),
            ),
          ],
        ),
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
    final l10n = AppLocalizations.of(context);
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
            Text(
              l10n.invCouldNotLoadInventory,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.invRetry),
            ),
          ],
        ),
      ),
    );
  }
}
