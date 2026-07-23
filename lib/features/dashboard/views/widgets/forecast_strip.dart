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

    final summary = async.asData?.value;

    // Deliberately not `when(error:)`. Riverpod 3 retries a failed provider, so
    // a summary that 503s (the state before the model has ever trained) sits in
    // AsyncLoading *carrying* an error and never reaches AsyncError — the error
    // branch would almost never run. Key off hasError instead.
    if (summary == null) {
      // Nothing at all on the very first fetch: a placeholder that appears and
      // is instantly replaced reads as a glitch. Once it has failed, say so.
      if (async.isLoading && !async.hasError) return const SizedBox.shrink();
      return _ForecastNotReady(storeId: storeId, l10n: l10n);
    }

    return Builder(
      builder: (context) {
        final h = summary.tomorrow;
        // A quiet or not-yet-trained forecast used to hide this card entirely.
        // That was wrong twice over: it vanished with no explanation, and this
        // card is the *only* route to the forecast screen, so hiding it made a
        // working screen unreachable. Degrade to a muted "still learning" state
        // that still navigates.
        if (h == null || h.predictedUnits < 1) {
          return _ForecastNotReady(storeId: storeId, l10n: l10n);
        }
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
    );
  }
}

/// Shown when there is no usable forecast yet — no history, or the model
/// hasn't been trained. Still tappable, because the forecast screen explains
/// itself better than an absent card does.
class _ForecastNotReady extends StatelessWidget {
  final int storeId;
  final AppLocalizations l10n;

  const _ForecastNotReady({required this.storeId, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        '/forecast-items',
        extra: {'store_id': storeId, 'horizon_days': 1},
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(22, 12, 22, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timeline_rounded,
                color: BrandColors.muted,
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
                      color: BrandColors.muted,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.forecastNotReadyTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.forecastNotReadyHint,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: BrandColors.muted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: BrandColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
