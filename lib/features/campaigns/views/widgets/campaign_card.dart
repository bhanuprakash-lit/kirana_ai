import 'package:flutter/material.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../models/campaign_model.dart';

// ── Campaign Card (shown in POS empty state) ──────────────────────────────────

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onAddAll;
  final int index;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onAddAll,
    required this.index,
  });

  static const _typeColors = <String, Color>{
    'morning':  Color(0xFFF59E0B),
    'monthly':  Color(0xFF3B82F6),
    'school':   Color(0xFF10B981),
    'weekend':  Color(0xFF8B5CF6),
    'festival': Color(0xFFEF4444),
    'general':  Color(0xFF6B7280),
  };

  Color get _color => _typeColors[campaign.campaignType] ?? BrandColors.primary;

  @override
  Widget build(BuildContext context) {
    final stocked = campaign.stockedItems;
    final allAvailable = campaign.availableCount == campaign.totalItems;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _color.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Text(campaign.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign.name,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _color)),
                        Text(campaign.description,
                            style: const TextStyle(fontSize: 11, color: BrandColors.muted),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  // Availability pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: allAvailable
                          ? Colors.green.withValues(alpha: 0.12)
                          : Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${campaign.availableCount}/${campaign.totalItems}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: allAvailable ? Colors.green.shade700 : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Items preview ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: campaign.items.take(5).map((item) => _ItemChip(
                  label: item.product?.name ?? item.displayName,
                  inStock: item.inStock,
                  color: _color,
                )).toList(),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (campaign.totalPrice > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${campaign.totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _color),
                        ),
                        const Text('est. total', style: TextStyle(fontSize: 11, color: BrandColors.muted)),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: ElevatedButton.icon(
                      onPressed: stocked.isEmpty ? null : onAddAll,
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                      label: const Text('Add All'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CampaignDetailSheet(campaign: campaign, onAddAll: onAddAll),
    );
  }
}

// ── Item chip ─────────────────────────────────────────────────────────────────

class _ItemChip extends StatelessWidget {
  final String label;
  final bool inStock;
  final Color color;
  const _ItemChip({required this.label, required this.inStock, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: inStock ? color.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: inStock ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            inStock ? Icons.check_circle_rounded : Icons.remove_circle_outline_rounded,
            size: 10,
            color: inStock ? color : BrandColors.muted,
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: inStock ? color : BrandColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Campaign detail bottom sheet ──────────────────────────────────────────────

class CampaignDetailSheet extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onAddAll;
  const CampaignDetailSheet({super.key, required this.campaign, required this.onAddAll});

  static const _typeColors = <String, Color>{
    'morning':  Color(0xFFF59E0B),
    'monthly':  Color(0xFF3B82F6),
    'school':   Color(0xFF10B981),
    'weekend':  Color(0xFF8B5CF6),
    'festival': Color(0xFFEF4444),
    'general':  Color(0xFF6B7280),
  };

  Color get _color => _typeColors[campaign.campaignType] ?? BrandColors.primary;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(color: BrandColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  Text(campaign.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _color)),
                        Text(campaign.description,
                            style: const TextStyle(fontSize: 13, color: BrandColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Items list
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: campaign.items.length,
                itemBuilder: (_, i) {
                  final item = campaign.items[i];
                  final p = item.product;
                  return ListTile(
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: item.inStock ? _color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item.inStock ? Icons.check_rounded : Icons.close_rounded,
                        color: item.inStock ? _color : BrandColors.muted,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      p?.name ?? item.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: item.inStock ? BrandColors.ink : BrandColors.muted,
                      ),
                    ),
                    subtitle: item.inStock && p != null
                        ? Text('Stock: ${p.stockQuantity.toStringAsFixed(0)} ${p.unit ?? 'pcs'}  ·  ₹${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12))
                        : Text('Not in stock', style: TextStyle(fontSize: 12, color: Colors.red.shade400)),
                    trailing: item.inStock && p != null
                        ? Text('₹${p.price.toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.w800, color: _color))
                        : null,
                  );
                },
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
              child: Column(
                children: [
                  if (campaign.totalPrice > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Estimated Total', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Text('₹${campaign.totalPrice.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _color)),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: campaign.stockedItems.isEmpty ? null : () {
                        Navigator.pop(context);
                        onAddAll();
                      },
                      icon: const Icon(Icons.add_shopping_cart_rounded),
                      label: Text(
                        campaign.stockedItems.isEmpty
                            ? 'No items in stock'
                            : 'Add ${campaign.availableCount} Available Items to Cart',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        backgroundColor: _color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
