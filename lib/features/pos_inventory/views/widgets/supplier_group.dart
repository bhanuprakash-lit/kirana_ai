import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../models/procurement_models.dart';

/// PAI-6 / PAI-13 — collapse repeated supplier rows into one group.
///
/// Recent Purchases and Transaction History both listed every purchase order
/// as its own row, so a supplier you buy from weekly filled the screen with
/// its own name and the owner had to add up what was still owed by eye.
/// Grouping puts the name once, the outstanding amount on the header, and the
/// individual orders — with their **Mark as received** action — one tap away.
class SupplierPurchaseGroup {
  final int supplierId;
  final String supplierName;
  final List<PurchaseOrder> orders;

  const SupplierPurchaseGroup({
    required this.supplierId,
    required this.supplierName,
    required this.orders,
  });

  /// What's still owed this supplier across the listed orders.
  double get outstanding => orders
      .where((o) => o.paymentStatus.toLowerCase() != 'paid')
      .fold(0.0, (sum, o) => sum + o.totalAmount);

  double get total => orders.fold(0.0, (sum, o) => sum + o.totalAmount);

  /// Orders placed but not yet received — the ones with an action waiting.
  int get awaitingReceipt =>
      orders.where((o) => o.status == PurchaseStatus.ordered).length;

  DateTime get lastPurchase =>
      orders.map((o) => o.purchaseDate).reduce((a, b) => a.isAfter(b) ? a : b);
}

/// Groups orders by supplier, keeping the incoming (already sorted) order of
/// first appearance so the most recent supplier stays on top.
List<SupplierPurchaseGroup> groupPurchasesBySupplier(
  List<PurchaseOrder> orders,
) {
  final bySupplier = <int, List<PurchaseOrder>>{};
  final order = <int>[];
  for (final o in orders) {
    if (!bySupplier.containsKey(o.supplierId)) order.add(o.supplierId);
    bySupplier.putIfAbsent(o.supplierId, () => []).add(o);
  }
  return [
    for (final id in order)
      SupplierPurchaseGroup(
        supplierId: id,
        supplierName: bySupplier[id]!.first.supplierName,
        orders: bySupplier[id]!,
      ),
  ];
}

/// Expandable header for one supplier's purchases. The caller supplies how a
/// single order renders, so Recent Purchases and Transaction History can share
/// the grouping without sharing their row designs.
class SupplierGroupCard extends StatefulWidget {
  final SupplierPurchaseGroup group;
  final Widget Function(PurchaseOrder order) rowBuilder;

  /// Extra line under the supplier name (e.g. "3 purchases · last 12/7").
  final String subtitle;

  /// Right-hand summary — usually the outstanding amount.
  final Widget trailing;

  /// Starts open when there's an action waiting inside.
  final bool initiallyExpanded;

  const SupplierGroupCard({
    super.key,
    required this.group,
    required this.rowBuilder,
    required this.subtitle,
    required this.trailing,
    this.initiallyExpanded = false,
  });

  @override
  State<SupplierGroupCard> createState() => _SupplierGroupCardState();
}

class _SupplierGroupCardState extends State<SupplierGroupCard> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _open ? 0.25 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: BrandColors.muted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.group.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.trailing,
                ],
              ),
            ),
          ),
          if (_open) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                children: [
                  for (final o in widget.group.orders) widget.rowBuilder(o),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
