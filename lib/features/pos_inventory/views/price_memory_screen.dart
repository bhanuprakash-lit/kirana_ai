import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/price_memory_provider.dart';

/// AI Price Memory — products with no selling price, with a one-tap suggested
/// price (your last price, else MRP) so nothing sells at ₹0.
class PriceMemoryScreen extends ConsumerWidget {
  const PriceMemoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(priceMemoryProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Missing Prices',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: BrandColors.error,
              ),
              const SizedBox(height: 12),
              const Text('Could not load prices'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    ref.read(priceMemoryProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (list) => list.isEmpty
            ? const _Empty()
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(priceMemoryProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _PriceCard(item: list[i]),
                ),
              ),
      ),
    );
  }
}

class _PriceCard extends ConsumerStatefulWidget {
  final MissingPrice item;
  const _PriceCard({required this.item});

  @override
  ConsumerState<_PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends ConsumerState<_PriceCard> {
  late final TextEditingController _ctrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.item.suggestedPrice;
    _ctrl = TextEditingController(
      text: s != null ? s.toStringAsFixed(s == s.roundToDouble() ? 0 : 2) : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.item;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.productName,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: BrandColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${s.stock} ${s.unit ?? 'units'} in stock · currently ₹0',
            style: const TextStyle(fontSize: 12, color: BrandColors.muted),
          ),
          if (s.suggestionSource != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.psychology_outlined,
                  size: 15,
                  color: BrandColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Suggested ₹${s.suggestedPrice!.toStringAsFixed(0)} (${s.suggestionSource})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: BrandColors.primary,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixText: '₹ ',
                    labelText: 'Selling price',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 80,
                  maxWidth: 100,
                  minHeight: 40,
                ),
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Set'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final price = double.tryParse(_ctrl.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid price')));
      return;
    }
    setState(() => _saving = true);
    final ok = await ref
        .read(priceMemoryProvider.notifier)
        .applyPrice(widget.item.productId, price, mrp: widget.item.mrp);
    if (!mounted) return;
    if (!ok) setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? '${widget.item.productName} priced ₹${price.toStringAsFixed(0)}'
              : 'Could not set price',
        ),
        backgroundColor: ok ? BrandColors.success : BrandColors.error,
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 120),
        Icon(Icons.price_check_rounded, size: 64, color: BrandColors.success),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Every product is priced',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(height: 6),
        Center(
          child: Text(
            'Nothing is selling at ₹0. Good going!',
            style: TextStyle(color: BrandColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
