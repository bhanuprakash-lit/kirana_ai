import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../providers/forecast_provider.dart';

class ForecastStrip extends ConsumerWidget {
  final int storeId;
  const ForecastStrip({super.key, required this.storeId});

  String _fmt(double v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(forecastSummaryProvider(storeId));
    final l10n = AppLocalizations.of(context);

    return async.maybeWhen(
      data: (summary) {
        final h = summary.tomorrow;
        if (h == null || h.predictedUnits < 1) return const SizedBox.shrink();
        final count = h.predictedUnits.round();
        final revenue = h.revenue;

        return InkWell(
          onTap: () => context.push(
            '/forecast-items',
            extra: {'store_id': storeId, 'horizon_days': 1},
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  BrandColors.success.withValues(alpha: 0.07),
                  BrandColors.success.withValues(alpha: 0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: BrandColors.success.withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: BrandColors.success.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: BrandColors.success.withValues(alpha: 0.12),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: BrandColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.forecastSectionLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: BrandColors.success,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.forecastStripCount(count),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.ink,
                          height: 1.4,
                        ),
                      ),
                      if (revenue > 0) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.forecastStripEst(_fmt(revenue)),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: BrandColors.success,
                      size: 22,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.forecastStripViewAll,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: BrandColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
