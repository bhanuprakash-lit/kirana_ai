import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/locale/locale_provider.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/action_widgets.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../../pos_inventory/models/pos_product.dart';
import '../../pos_inventory/providers/pos_provider.dart';
import '../models/basket_model.dart';
import '../providers/basket_provider.dart';

class BasketsScreen extends ConsumerWidget {
  const BasketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(basketProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.mktMyBaskets,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showCreateSheet(context, ref),
          ),
        ],
      ),
      body: asyncData.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: ListShimmer(itemCount: 5),
        ),
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
              Text(
                l10n.mktCouldNotLoadBaskets,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.mktPullDownToRetry,
                style: const TextStyle(color: BrandColors.muted),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(basketProvider),
                child: Text(l10n.mktRetry),
              ),
            ],
          ),
        ),
        data: (baskets) => baskets.isEmpty
            ? _buildEmpty(context, ref)
            : RefreshIndicator.adaptive(
                onRefresh: () => ref.read(basketProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: baskets.length,
                  itemBuilder: (_, i) => _BasketCard(
                    basket: baskets[i],
                    onDelete: () => _confirmDelete(context, ref, baskets[i]),
                    onAlert: () => _sendAlert(context, ref, baskets[i]),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'baskets_fab',
        onPressed: () => _showCreateSheet(context, ref),
        backgroundColor: BrandColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          l10n.mktNewBasket,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_basket_outlined,
              size: 72,
              color: BrandColors.border,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.mktNoBasketsYet,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.mktBasketsEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: BrandColors.muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _showCreateSheet(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.mktCreateFirstBasket),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateBasketSheet(),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Basket basket) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mktDeleteBasketTitle),
        content: Text(l10n.mktDeleteBasketConfirm(basket.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.mktCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(basketProvider.notifier)
                    .deleteBasket(basket.basketId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.mktBasketDeleted)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.mktCouldNotDeleteBasket),
                      backgroundColor: BrandColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              l10n.mktDelete,
              style: const TextStyle(color: BrandColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendAlert(
    BuildContext context,
    WidgetRef ref,
    Basket basket,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mktSendWhatsAppAlertTitle),
        content: Text(l10n.mktSendWhatsAppAlertConfirm(basket.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.mktCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.mktSend),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      final res = await ref
          .read(basketProvider.notifier)
          .alertCustomers(basket.basketId);
      if (context.mounted) {
        final sent = (res['sent'] as num?)?.toInt() ?? 0;
        final total = (res['total'] as num?)?.toInt() ?? 0;
        String msg;
        Color bg;
        if (sent > 0) {
          msg = l10n.mktWhatsAppAlertSent(sent, total);
          bg = BrandColors.success;
        } else if (total == 0) {
          msg = l10n.mktNoCustomersWithPhone;
          bg = BrandColors.muted;
        } else {
          msg = l10n.mktWhatsAppNotActiveYet(total);
          bg = const Color(0xFFE87722);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: bg,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.mktAlertFailed(e.toString())),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }
}

// ── Basket card ───────────────────────────────────────────────────────────────

class _BasketCard extends StatelessWidget {
  final Basket basket;
  final VoidCallback onDelete;
  final VoidCallback onAlert;

  const _BasketCard({
    required this.basket,
    required this.onDelete,
    required this.onAlert,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isExpired = basket.isExpired;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              basket.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: isExpired
                                    ? BrandColors.muted
                                    : BrandColors.ink,
                              ),
                            ),
                          ),
                          if (isExpired) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: BrandColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.mktExpired,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: BrandColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (basket.description != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          basket.description!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (basket.price != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: BrandColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '₹${basket.price!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: BrandColors.primary,
                      ),
                    ),
                  ),
              ],
            ),

            if (basket.items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: basket.items
                    .map(
                      (item) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: BrandColors.surfaceTint,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: BrandColors.border),
                        ),
                        child: Text(
                          '${item.productName ?? l10n.mktItem} × ${item.qty.toStringAsFixed(item.qty == item.qty.roundToDouble() ? 0 : 1)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: BrandColors.ink,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],

            if (basket.validFrom != null || basket.validTo != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: BrandColors.muted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    [
                      if (basket.validFrom != null)
                        l10n.mktFromDate(basket.validFrom!),
                      if (basket.validTo != null)
                        l10n.mktToDate(basket.validTo!),
                    ].join('  ·  '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isExpired ? null : onAlert,
                    icon: const Icon(Icons.message_rounded, size: 16),
                    label: Text(
                      l10n.mktAlertCustomers,
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF25D366),
                      side: const BorderSide(color: Color(0xFF25D366)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: BrandColors.error,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: BrandColors.error.withValues(alpha: 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

// ── Selected item for basket creation ────────────────────────────────────────

class _SelectedItem {
  final int productId;
  final String productName;
  final double price;
  final TextEditingController qtyCtrl;

  _SelectedItem({
    required this.productId,
    required this.productName,
    required this.price,
  }) : qtyCtrl = TextEditingController(text: '1');

  void dispose() => qtyCtrl.dispose();
}

// ── Create Basket Sheet ───────────────────────────────────────────────────────

class _CreateBasketSheet extends ConsumerStatefulWidget {
  const _CreateBasketSheet();

  @override
  ConsumerState<_CreateBasketSheet> createState() => _CreateBasketSheetState();
}

class _CreateBasketSheetState extends ConsumerState<_CreateBasketSheet> {
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _items = <_SelectedItem>[];

  String? _validFrom;
  String? _validTo;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? now : now.add(const Duration(days: 7)),
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null || !mounted) return;
    final label =
        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    setState(() {
      if (isFrom)
        _validFrom = label;
      else
        _validTo = label;
    });
  }

  Future<void> _showProductPicker() async {
    final products = ref.read(posProvider).products;
    if (products.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.mktNoProductsInInventory)));
      return;
    }
    final alreadyAdded = _items.map((i) => i.productId).toSet();
    final available = products
        .where((p) => !alreadyAdded.contains(p.productId))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.mktAllProductsAdded)));
      return;
    }

    final picked = await showModalBottomSheet<PosProduct>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductPickerSheet(products: available),
    );

    if (picked == null || !mounted) return;
    setState(() {
      _items.add(
        _SelectedItem(
          productId: picked.productId,
          productName: picked.displayName,
          price: picked.price,
        ),
      );
    });
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = _l10n.mktBasketNameRequired);
      return;
    }
    if (_items.isEmpty) {
      setState(() => _error = _l10n.mktAddAtLeastOneProduct);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final items = _items
        .map(
          (i) => {
            'product_id': i.productId,
            'product_name': i.productName,
            'qty': double.tryParse(i.qtyCtrl.text) ?? 1.0,
          },
        )
        .toList();

    try {
      await ref.read(basketProvider.notifier).createBasket({
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim().isNotEmpty
            ? _descCtrl.text.trim()
            : null,
        'price': _priceCtrl.text.isNotEmpty
            ? double.tryParse(_priceCtrl.text)
            : null,
        'valid_from': _validFrom,
        'valid_to': _validTo,
        'items': items,
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = e.toString();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: BrandColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.mktNewBasket,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            l10n.mktSave,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: BrandColors.error,
                    fontSize: 13,
                  ),
                ),
              ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(20),
                children: [
                  // Name
                  TextField(
                    controller: _nameCtrl,
                    enabled: !_saving,
                    decoration: InputDecoration(
                      labelText: l10n.mktBasketNameLabel,
                      hintText: l10n.mktBasketNameHint,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Description
                  TextField(
                    controller: _descCtrl,
                    enabled: !_saving,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: l10n.mktDescriptionOptional,
                      hintText: l10n.mktDescriptionHint,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Bundle price
                  TextField(
                    controller: _priceCtrl,
                    enabled: !_saving,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.mktBundlePriceOptional,
                      prefixText: '₹ ',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Validity dates
                  Text(
                    l10n.mktValidity,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      color: BrandColors.muted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _saving ? null : () => _pickDate(isFrom: true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BrandColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 16,
                                  color: BrandColors.muted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _validFrom ?? l10n.mktFromDateLabel,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _validFrom != null
                                        ? BrandColors.ink
                                        : BrandColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: _saving
                              ? null
                              : () => _pickDate(isFrom: false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BrandColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.event_rounded,
                                  size: 16,
                                  color: BrandColors.muted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _validTo ?? l10n.mktToDateLabel,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _validTo != null
                                        ? BrandColors.ink
                                        : BrandColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Products
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.mktProducts,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            color: BrandColors.muted,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: _saving ? null : _showProductPicker,
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: Text(l10n.mktAddProduct),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (_items.isEmpty)
                    GestureDetector(
                      onTap: _saving ? null : _showProductPicker,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BrandColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: BrandColors.muted,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.mktTapToPickProducts,
                              style: const TextStyle(
                                color: BrandColors.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    for (int i = 0; i < _items.length; i++) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: BrandColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _items[i].productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: BrandColors.ink,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    l10n.mktPricePerUnit(
                                      _items[i].price.toStringAsFixed(0),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: BrandColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _items[i].qtyCtrl,
                                enabled: !_saving,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,1}'),
                                  ),
                                ],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: l10n.mktQty,
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(() {
                                      _items[i].dispose();
                                      _items.removeAt(i);
                                    }),
                              icon: const Icon(
                                Icons.remove_circle_outline_rounded,
                                color: BrandColors.error,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: LoadingButton(
                      label: l10n.mktCreateBasket,
                      isLoading: _saving,
                      onPressed: _saving ? null : _save,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product picker sheet ──────────────────────────────────────────────────────

class _ProductPickerSheet extends StatefulWidget {
  final List<PosProduct> products;
  const _ProductPickerSheet({required this.products});

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = widget.products.where((p) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          (p.brand?.toLowerCase().contains(q) ?? false);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: BrandColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.mktSelectProduct,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: l10n.mktSearchProducts,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: BrandColors.muted,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        l10n.mktNoProductsFound,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          title: Text(
                            p.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            '${p.priceLabel} · Stock: ${p.stockLabel}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: BrandColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.mktAdd,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          onTap: () => Navigator.pop(context, p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
