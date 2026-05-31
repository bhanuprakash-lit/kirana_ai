import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/pos_provider.dart';

/// Records a customer return/exchange against a past order.
/// Resaleable units go back to inventory; damaged units are sent to the
/// Return-to-Vendor ledger.
Future<void> showReturnSheet(
  BuildContext context,
  WidgetRef ref,
  Map<String, dynamic> order,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReturnSheet(order: order),
  );
}

class _ReturnLine {
  final int productId;
  final String name;
  final double orderedQty;
  int returnQty = 0;
  bool resaleable = true;

  _ReturnLine({
    required this.productId,
    required this.name,
    required this.orderedQty,
  });
}

class _ReturnSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> order;
  const _ReturnSheet({required this.order});

  @override
  ConsumerState<_ReturnSheet> createState() => _ReturnSheetState();
}

class _ReturnSheetState extends ConsumerState<_ReturnSheet> {
  late final List<_ReturnLine> _lines;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final products = ref.read(posProvider).products;
    final items = (widget.order['items'] as List<dynamic>?) ?? const [];
    _lines = items.map((raw) {
      final item = raw as Map<String, dynamic>;
      final pid = (item['product_id'] as num?)?.toInt() ?? 0;
      final qty = (item['quantity'] as num?)?.toDouble() ?? 0;
      final product = products.where((p) => p.productId == pid).firstOrNull;
      return _ReturnLine(
        productId: pid,
        name: product?.name ?? 'Product #$pid',
        orderedQty: qty,
      );
    }).toList();
  }

  bool get _hasReturns => _lines.any((l) => l.returnQty > 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BrandColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: BrandColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Return / Exchange',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  'Order #${widget.order['order_id']} · pick items to return',
                  style: const TextStyle(fontSize: 13, color: BrandColors.muted),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              itemCount: _lines.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _lineTile(_lines[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: LoadingButton(
                label: 'Record return',
                isLoading: _saving,
                onPressed: (_hasReturns && !_saving) ? _submit : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineTile(_ReturnLine line) {
    final maxQty = line.orderedQty.floor();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              _stepBtn(Icons.remove, line.returnQty > 0, () {
                setState(() => line.returnQty--);
              }),
              SizedBox(
                width: 34,
                child: Text(
                  '${line.returnQty}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              _stepBtn(Icons.add, line.returnQty < maxQty, () {
                setState(() => line.returnQty++);
              }),
            ],
          ),
          Text(
            'bought ${maxQty == line.orderedQty ? maxQty : line.orderedQty} ',
            style: const TextStyle(fontSize: 11, color: BrandColors.muted),
          ),
          if (line.returnQty > 0)
            Row(
              children: [
                const Text(
                  'Back to shelf',
                  style: TextStyle(fontSize: 12, color: BrandColors.muted),
                ),
                Switch.adaptive(
                  value: line.resaleable,
                  onChanged: (v) => setState(() => line.resaleable = v),
                  activeThumbColor: BrandColors.success,
                ),
                Text(
                  line.resaleable ? 'Resaleable' : 'Damaged → vendor',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: line.resaleable
                        ? BrandColors.success
                        : const Color(0xFFE87722),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, bool enabled, VoidCallback onTap) {
    return IconButton.filledTonal(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 18),
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(backgroundColor: BrandColors.surfaceTint),
    );
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    final items = _lines
        .where((l) => l.returnQty > 0)
        .map((l) => {
              'product_id': l.productId,
              'qty': l.returnQty,
              'resaleable': l.resaleable,
            })
        .toList();
    try {
      final client = ref.read(apiClientProvider);
      final res = await client.post('/kirana/returns', {
        'order_id': widget.order['order_id'],
        'items': items,
      });
      // Stock changed — refresh inventory + POS catalog.
      ref.invalidate(inventoryProvider);
      ref.read(posProvider.notifier).reloadProducts();
      if (!mounted) return;
      Navigator.pop(context);
      final restocked = (res['restocked_units'] as num?)?.toInt() ?? 0;
      final toVendor = (res['to_vendor_units'] as num?)?.toInt() ?? 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Return recorded — $restocked back to shelf'
            '${toVendor > 0 ? ', $toVendor to vendor' : ''}',
          ),
          backgroundColor: BrandColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not record return'),
          backgroundColor: BrandColors.error,
        ),
      );
    }
  }
}
