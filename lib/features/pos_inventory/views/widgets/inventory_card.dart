import 'package:flutter/material.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../models/inventory_item.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  const InventoryCard({super.key, required this.item});

  Color get _stockColor {
    if (item.isOutOfStock) return BrandColors.error;
    if (item.isLowStock) return BrandColors.accent;
    return BrandColors.success;
  }

  String get _stockLabel {
    if (item.isOutOfStock) return 'Out of stock';
    if (item.isLowStock) return '${item.stockQuantity} — low';
    return '${item.stockQuantity} in stock';
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

  Widget _iconBox(Color catColor) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: catColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(_categoryIcon(item.categoryName), size: 18, color: catColor),
      );

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColor(item.categoryName);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color accent top
            Container(height: 3, color: catColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image / icon row + badge
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.imageUrl != null
                              ? Image.network(
                                  item.imageUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      _iconBox(catColor),
                                )
                              : _iconBox(catColor),
                        ),
                        const Spacer(),
                        if (item.isFastMoving)
                          _Badge(
                            icon: Icons.diamond_rounded,
                            label: 'Fast',
                            color: BrandColors.success,
                          )
                        else if (item.isDeadStock)
                          _Badge(
                            icon: Icons.snooze_rounded,
                            label: 'Slow',
                            color: const Color(0xFFB08D57), // bronze
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Product name
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.brand != null || item.weightLabel != null)
                      Text(
                        [item.brand, item.weightLabel]
                            .whereType<String>()
                            .join(' · '),
                        style: const TextStyle(
                          fontSize: 10,
                          color: BrandColors.muted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                    const Divider(height: 1),
                    const SizedBox(height: 6),
                    // Stock indicator + expiry inline
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _stockColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            _stockLabel,
                            style: TextStyle(
                              fontSize: 10,
                              color: _stockColor,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.expiryDate != null)
                          _ExpiryBadge(expiryDate: item.expiryDate!),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: BrandColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Divider(height: 1),
                    const SizedBox(height: 4),
                    // Intelligence row
                    if (item.barcode != null)
                      _InfoRow(
                        icon: Icons.qr_code_rounded,
                        label: 'Barcode',
                        value: item.barcode!,
                      ),
                    _InfoRow(
                      icon: Icons.sell_rounded,
                      label: 'Sold today',
                      value: '${item.soldToday}',
                    ),
                    if (item.reorderQty != null)
                      _InfoRow(
                        icon: Icons.refresh_rounded,
                        label: 'Reorder',
                        value: '${item.reorderQty} units',
                      ),
                    if (item.prob7Day != null)
                      _InfoRow(
                        icon: Icons.warning_amber_rounded,
                        label: '7d risk',
                        value: '${(item.prob7Day! * 100).toStringAsFixed(0)}%',
                        valueColor: item.prob7Day! > 0.6
                            ? BrandColors.error
                            : item.prob7Day! > 0.3
                            ? BrandColors.accent
                            : BrandColors.success,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  final String expiryDate;
  const _ExpiryBadge({required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    DateTime? exp;
    try {
      exp = DateTime.parse(expiryDate);
    } catch (_) {
      return const SizedBox.shrink();
    }
    final days = exp.difference(DateTime.now()).inDays;
    final Color color;
    if (days <= 3) {
      color = BrandColors.error;
    } else if (days <= 7) {
      color = BrandColors.accent;
    } else {
      color = BrandColors.success;
    }
    final label = days <= 0
        ? 'Expired'
        : days == 1
            ? '1d'
            : '${days}d';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_rounded, size: 8, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w800,
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
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 9, color: BrandColors.muted),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 9, color: BrandColors.muted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: valueColor ?? BrandColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
