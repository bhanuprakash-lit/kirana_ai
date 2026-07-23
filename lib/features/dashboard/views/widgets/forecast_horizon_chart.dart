import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// What the bars measure. Every one of these is already carried on the
/// per-horizon page the screen fetches, so switching metric costs nothing.
enum ForecastMetric { revenue, units, skus, stockouts }

extension ForecastMetricX on ForecastMetric {
  String label(AppLocalizations l10n) => switch (this) {
    ForecastMetric.revenue => l10n.forecastMetricRevenue,
    ForecastMetric.units => l10n.forecastMetricUnits,
    ForecastMetric.skus => l10n.forecastMetricSkus,
    ForecastMetric.stockouts => l10n.forecastMetricStockouts,
  };

  Color get color => switch (this) {
    ForecastMetric.revenue => BrandColors.accent,
    ForecastMetric.units => BrandColors.success,
    ForecastMetric.skus => BrandColors.primary,
    ForecastMetric.stockouts => BrandColors.error,
  };
}

/// One horizon's value for the selected metric.
class ForecastBar {
  final int horizonDays;
  final String label;
  final double value;

  /// False while that horizon is still loading or failed — drawn as a ghost
  /// bar rather than a zero, because a zero here reads as "no sales expected".
  final bool hasData;

  const ForecastBar({
    required this.horizonDays,
    required this.label,
    required this.value,
    this.hasData = true,
  });
}

/// Horizon-over-horizon bar chart.
///
/// This replaces scrolling a 100-row product list to answer "how much am I
/// selling next week" — the list is still there, one tap away, but the shape of
/// the forecast is readable at a glance.
///
/// Hand-rolled rather than pulling in a charting package: six bars with a
/// tap target and a value label is less code than configuring one, and it
/// avoids a dependency for a single screen.
class ForecastHorizonChart extends StatelessWidget {
  final List<ForecastBar> bars;
  final ForecastMetric metric;
  final int selectedHorizon;
  final ValueChanged<int> onSelect;

  /// Formats a bar's value for its label — currency for revenue, plain counts
  /// otherwise.
  final String Function(ForecastMetric, double) format;

  const ForecastHorizonChart({
    super.key,
    required this.bars,
    required this.metric,
    required this.selectedHorizon,
    required this.onSelect,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maxValue = bars
        .where((b) => b.hasData)
        .fold<double>(0, (m, b) => b.value > m ? b.value : m);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              metric.label(l10n),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
          SizedBox(
            height: 168,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bar in bars)
                  Expanded(
                    child: _Bar(
                      bar: bar,
                      // An all-zero forecast must not divide by zero; it draws
                      // as a row of floor-height bars instead.
                      fraction: maxValue > 0 ? bar.value / maxValue : 0,
                      color: metric.color,
                      isSelected: bar.horizonDays == selectedHorizon,
                      valueLabel: bar.hasData
                          ? format(metric, bar.value)
                          : '—',
                      onTap: () => onSelect(bar.horizonDays),
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

class _Bar extends StatelessWidget {
  final ForecastBar bar;
  final double fraction;
  final Color color;
  final bool isSelected;
  final String valueLabel;
  final VoidCallback onTap;

  const _Bar({
    required this.bar,
    required this.fraction,
    required this.color,
    required this.isSelected,
    required this.valueLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Keep a sliver of bar for tiny non-zero values so a real number never
    // renders as nothing at all.
    final h = bar.hasData
        ? (fraction.clamp(0.0, 1.0) * 108) + (bar.value > 0 ? 6 : 2)
        : 6.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                valueLabel,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? color : BrandColors.muted,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              height: h,
              decoration: BoxDecoration(
                color: bar.hasData
                    ? color.withValues(alpha: isSelected ? 1 : 0.32)
                    : BrandColors.border,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                  bottom: Radius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                bar.label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? BrandColors.ink : BrandColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Metric selector. Scrolls horizontally so adding a metric later can't
/// overflow the row — the mistake PAI-10 was filed for.
class ForecastMetricChips extends StatelessWidget {
  final ForecastMetric selected;
  final ValueChanged<ForecastMetric> onSelect;

  const ForecastMetricChips({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        children: [
          for (final m in ForecastMetric.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(m.label(l10n)),
                selected: m == selected,
                onSelected: (_) => onSelect(m),
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: m == selected ? Colors.white : BrandColors.ink,
                ),
                selectedColor: m.color,
                backgroundColor: Colors.white,
                showCheckmark: false,
                side: BorderSide(
                  color: m == selected ? m.color : BrandColors.border,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
