part of '../pos_tab_new.dart';

class _SetCustomerPriceSheet extends StatefulWidget {
  final PosProduct product;
  final String customerName;
  final bool hasPin;
  final double initial;

  const _SetCustomerPriceSheet({
    required this.product,
    required this.customerName,
    required this.hasPin,
    required this.initial,
  });

  @override
  State<_SetCustomerPriceSheet> createState() => _SetCustomerPriceSheetState();
}

class _SetCustomerPriceSheetState extends State<_SetCustomerPriceSheet> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final v = widget.initial;
    _ctrl = TextEditingController(
      text: v > 0
          ? (v == v.roundToDouble()
                ? v.toStringAsFixed(0)
                : v.toStringAsFixed(2))
          : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final price = double.tryParse(_ctrl.text.trim());
    if (price == null || price < 0) return;
    Navigator.pop(context, _CustomerPriceEditAction.set(price));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Price for ${widget.customerName}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.product.displayName}  ·  catalog ₹${widget.product.price.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12.5, color: BrandColors.muted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ctrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: 'Enter price',
                filled: true,
                fillColor: BrandColors.surfaceTint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.hasPin)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(
                        context,
                        const _CustomerPriceEditAction.remove(),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Remove'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: BrandColors.error,
                        side: const BorderSide(color: BrandColors.error),
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                if (widget.hasPin) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: BrandColors.accent,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text(
                      'Save price',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
