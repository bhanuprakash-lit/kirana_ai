import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/forecast_model.dart';
import '../providers/forecast_provider.dart';

class ForecastItemsScreen extends ConsumerStatefulWidget {
  final int storeId;
  final int initialHorizon;

  const ForecastItemsScreen({
    super.key,
    required this.storeId,
    this.initialHorizon = 1,
  });

  @override
  ConsumerState<ForecastItemsScreen> createState() =>
      _ForecastItemsScreenState();
}

class _ForecastItemsScreenState extends ConsumerState<ForecastItemsScreen> {
  late int _horizonDays;

  static const _horizons = [1, 3, 5, 7, 14, 30];

  @override
  void initState() {
    super.initState();
    _horizonDays = widget.initialHorizon;
  }

  String _horizonLabel(AppLocalizations l10n, int days) {
    switch (days) {
      case 1:
        return l10n.forecastHorizonTomorrow;
      case 3:
        return l10n.forecastHorizon3d;
      case 5:
        return l10n.forecastHorizon5d;
      case 7:
        return l10n.forecastHorizon7d;
      case 14:
        return l10n.forecastHorizon14d;
      default:
        return l10n.forecastHorizon30d;
    }
  }

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Watch all horizons at build time — they all pre-fetch simultaneously
    // and are cached by Riverpod, so chip switching is instant.
    final allAsync = {
      for (final h in _horizons)
        h: ref.watch(
          forecastItemsProvider((storeId: widget.storeId, horizonDays: h)),
        ),
    };
    final async = allAsync[_horizonDays]!;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        backgroundColor: BrandColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.forecastScreenTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _HorizonChips(
            selected: _horizonDays,
            horizons: _horizons,
            labelFn: (d) => _horizonLabel(l10n, d),
            onSelect: (d) => setState(() => _horizonDays = d),
          ),
          Expanded(
            child: async.when(
              loading: () => const _ListShimmer(),
              error: (_, _) => _EmptyState(message: l10n.forecastNoData),
              data: (page) {
                if (page.items.isEmpty) {
                  return _EmptyState(message: l10n.forecastNoData);
                }
                return RefreshIndicator.adaptive(
                  onRefresh: () => ref.refresh(
                    forecastItemsProvider((
                      storeId: widget.storeId,
                      horizonDays: _horizonDays,
                    )).future,
                  ),
                  color: BrandColors.success,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: page.items.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return _SummaryHeader(
                          page: page,
                          fmt: _fmt,
                          l10n: l10n,
                        );
                      }
                      return _ForecastItemTile(
                        item: page.items[i - 1],
                        horizonDays: _horizonDays,
                        fmt: _fmt,
                        l10n: l10n,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Horizon chips ─────────────────────────────────────────────────────────────

class _HorizonChips extends StatelessWidget {
  final int selected;
  final List<int> horizons;
  final String Function(int) labelFn;
  final void Function(int) onSelect;

  const _HorizonChips({
    required this.selected,
    required this.horizons,
    required this.labelFn,
    required this.onSelect,
  });

  String _chipLabel(int days) {
    if (days == 1) return labelFn(days); // "Tomorrow"
    return days.toString(); // "3", "5", "7", "14", "30"
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: horizons.map((d) {
              final isSelected = d == selected;
              return GestureDetector(
                onTap: () => onSelect(d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(
                    horizontal: d == 1 ? 14 : 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _chipLabel(d),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? BrandColors.primary : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 6),
          const Text(
            'days',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary header ────────────────────────────────────────────────────────────

class _SummaryHeader extends StatelessWidget {
  final ForecastItemsPage page;
  final String Function(double) fmt;
  final AppLocalizations l10n;

  const _SummaryHeader({
    required this.page,
    required this.fmt,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          _StatCol(
            icon: Icons.inventory_2_outlined,
            value: page.totalItems.toString(),
            label: 'Items',
            color: BrandColors.primary,
          ),
          _Divider(),
          _StatCol(
            icon: Icons.trending_up_rounded,
            value: page.totalPredictedUnits.round().toString(),
            label: 'Total units',
            color: BrandColors.success,
          ),
          _Divider(),
          _StatCol(
            icon: Icons.currency_rupee_rounded,
            value: fmt(page.totalPredictedRevenue),
            label: l10n.forecastRevLabel,
            color: BrandColors.accent,
          ),
          if (page.itemsAtOosRisk > 0) ...[
            _Divider(),
            _StatCol(
              icon: Icons.warning_amber_rounded,
              value: page.itemsAtOosRisk.toString(),
              label: l10n.forecastOosWarning,
              color: BrandColors.error,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCol({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: BrandColors.muted,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: BrandColors.border);
}

// ── Item tile ─────────────────────────────────────────────────────────────────

class _ForecastItemTile extends StatelessWidget {
  final ForecastItem item;
  final int horizonDays;
  final String Function(double) fmt;
  final AppLocalizations l10n;

  const _ForecastItemTile({
    required this.item,
    required this.horizonDays,
    required this.fmt,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final predictedLabel = item.predictedUnits < 1
        ? '< 1 unit'
        : '${item.predictedUnits.round()} units';
    final unitsRange =
        '${item.predictedUnitsLow.round()}–${item.predictedUnitsHigh.round()}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.willOosInWindow
              ? BrandColors.error.withValues(alpha: 0.3)
              : BrandColors.border.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.willOosInWindow)
              Container(height: 3, color: BrandColors.error)
            else if (item.isFastMoving)
              Container(height: 3, color: BrandColors.success),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: BrandColors.ink,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.willOosInWindow) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: BrandColors.error.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: BrandColors.error.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      size: 10,
                                      color: BrandColors.error,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      l10n.forecastOosWarning,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: BrandColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.categoryName,
                          style: const TextStyle(
                            fontSize: 11,
                            color: BrandColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _Chip(
                              icon: Icons.bar_chart_rounded,
                              label: predictedLabel,
                              sublabel: unitsRange,
                              color: BrandColors.primary,
                            ),
                            const SizedBox(width: 8),
                            _Chip(
                              icon: Icons.currency_rupee_rounded,
                              label: fmt(item.predictedRevenue),
                              sublabel: l10n.forecastRevLabel,
                              color: BrandColors.success,
                            ),
                            if (item.daysOfSupply < horizonDays * 1.2 &&
                                item.currentStock > 0) ...[
                              const SizedBox(width: 8),
                              _Chip(
                                icon: Icons.inventory_2_outlined,
                                label: '${item.daysOfSupply.round()} days',
                                sublabel: l10n.forecastWhyStockDays,
                                color: item.willOosInWindow
                                    ? BrandColors.error
                                    : BrandColors.accent,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showWhySheet(context),
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: BrandColors.muted,
                    ),
                    tooltip: l10n.forecastWhyTitle,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWhySheet(BuildContext context) {
    final avgStr = item.avgDailyDemand < 1
        ? item.avgDailyDemand.toStringAsFixed(2)
        : item.avgDailyDemand.toStringAsFixed(1);
    final unitsStr = item.predictedUnits.round().toString();
    final daysStr = horizonDays.toString();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _WhySheet(
        item: item,
        l10n: l10n,
        avgStr: avgStr,
        daysStr: daysStr,
        unitsStr: unitsStr,
        fmt: fmt,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _Chip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                sublabel,
                style: const TextStyle(
                  fontSize: 9,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Why bottom sheet ──────────────────────────────────────────────────────────

class _WhySheet extends StatelessWidget {
  final ForecastItem item;
  final AppLocalizations l10n;
  final String avgStr;
  final String daysStr;
  final String unitsStr;
  final String Function(double) fmt;

  const _WhySheet({
    required this.item,
    required this.l10n,
    required this.avgStr,
    required this.daysStr,
    required this.unitsStr,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: BrandColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.forecastWhyTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: BrandColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.productName,
            style: const TextStyle(
              fontSize: 13,
              color: BrandColors.muted,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.show_chart_rounded,
            label: l10n.forecastWhyAvgDaily,
            value: '$avgStr units/day',
            color: BrandColors.primary,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.inventory_2_outlined,
            label: l10n.forecastWhyStockDays,
            value: item.daysOfSupply >= 999
                ? 'Stock OK'
                : '${item.daysOfSupply.round()} days',
            color: item.willOosInWindow
                ? BrandColors.error
                : BrandColors.success,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.warning_amber_rounded,
            label: l10n.forecastWhyOosRisk,
            value: '${item.stockoutRiskPct.round()}%',
            color: item.stockoutRiskPct > 50
                ? BrandColors.error
                : item.stockoutRiskPct > 25
                ? BrandColors.accent
                : BrandColors.success,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BrandColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: BrandColors.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 16,
                  color: BrandColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.forecastWhyExplain(avgStr, daysStr, unitsStr),
                    style: const TextStyle(
                      fontSize: 13,
                      color: BrandColors.ink,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
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
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
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
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: BrandColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Loading / empty states ────────────────────────────────────────────────────

class _ListShimmer extends StatelessWidget {
  const _ListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => const ListShimmer(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: BrandColors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: BrandColors.muted,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
