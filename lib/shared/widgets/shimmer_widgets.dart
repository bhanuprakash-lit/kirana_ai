// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A single shimmer-highlighted box (the building block for all skeletons).
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Full-page skeleton for the overview/dashboard tab.
///
/// Uses a Column (not ListView) because this widget is placed inside a
/// SliverToBoxAdapter → CustomScrollView, which gives it unbounded height.
/// A ListView inside unbounded height crashes ("Viewport given infinite height").
class OverviewShimmer extends StatelessWidget {
  const OverviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intelligence section title
            _ShimmerBox(h: 14, w: 110, r: 8),
            const SizedBox(height: 12),
            // Intelligence grid (2 rows × 3 cols)
            // GridView with shrinkWrap + NeverScrollable is safe inside Column.
            // Do NOT use double.infinity for child height — use a natural fill.
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                // Match the real intelligence grid: taller cells as font scales.
                childAspectRatio:
                    1.2 /
                    MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.4),
              ),
              itemCount: 6,
              itemBuilder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Today's performance title
            _ShimmerBox(h: 14, w: 150, r: 8),
            const SizedBox(height: 12),
            // Sales card
            _ShimmerBox(h: 100, r: 24),
            const SizedBox(height: 16),
            // KPI row — 3 equal tiles
            Row(
              children: [
                Expanded(child: _ShimmerBox(h: 80, r: 20)),
                const SizedBox(width: 12),
                Expanded(child: _ShimmerBox(h: 80, r: 20)),
                const SizedBox(width: 12),
                Expanded(child: _ShimmerBox(h: 80, r: 20)),
              ],
            ),
            const SizedBox(height: 16),
            // Store overview card
            _ShimmerBox(h: 120, r: 24),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double h;
  final double? w;
  final double r;
  const _ShimmerBox({required this.h, this.w, this.r = 12});

  @override
  Widget build(BuildContext context) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r),
    ),
  );
}

/// List skeleton: N shimmer rows (for orders, customers, etc.)
class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  const ListShimmer({super.key, this.itemCount = 6, this.itemHeight = 72});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

/// Card skeleton (single card placeholder).
class CardShimmer extends StatelessWidget {
  final double height;
  final double radius;
  const CardShimmer({super.key, this.height = 100, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF9FAFB),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
