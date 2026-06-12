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
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import '../models/basket_model.dart';
import '../models/basket_tier_config.dart';
import '../providers/basket_provider.dart';
import 'basket_tier_config_screen.dart';

/// Localized tier name (Bronze/Silver/Gold/Platinum kept as proper nouns).
String tierLabel(AppLocalizations l10n, String? tier) {
  switch (tier) {
    case 'bronze':
      return l10n.mktTierBronze;
    case 'silver':
      return l10n.mktTierSilver;
    case 'gold':
      return l10n.mktTierGold;
    case 'platinum':
      return l10n.mktTierPlatinum;
    default:
      return '';
  }
}

class BasketsScreen extends ConsumerWidget {
  const BasketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // Baskets are an entirely Pro-tier feature.
    final canAccess = ref.watch(subInfoProvider).canAccessBaskets;
    if (!canAccess) {
      return Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(
          title: Text(
            l10n.mktMyBaskets,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: _BasketsProGate(
          onUpgrade: () => showPaywallSheet(
            context,
            featureName: l10n.mktMyBaskets,
            featureDescription: l10n.mktBasketsProDesc,
            featureIcon: Icons.shopping_basket_rounded,
          ),
        ),
      );
    }

    final asyncData = ref.watch(basketProvider);
    final showArchived = ref.watch(basketProvider.notifier).includeArchived;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.mktMyBaskets,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: l10n.mktTierSettings,
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BasketTierConfigScreen()),
            ),
          ),
          IconButton(
            tooltip: showArchived ? l10n.mktHideArchived : l10n.mktShowArchived,
            icon: Icon(
              showArchived ? Icons.unarchive_rounded : Icons.archive_outlined,
            ),
            onPressed: () => ref
                .read(basketProvider.notifier)
                .setIncludeArchived(!showArchived),
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
                    onEdit: () => _showSheet(context, ref, basket: baskets[i]),
                    onArchive: () => _archive(context, ref, baskets[i]),
                    onRestore: () => _restore(context, ref, baskets[i]),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'baskets_fab',
        onPressed: () => _showSheet(context, ref),
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
              onPressed: () => _showSheet(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.mktCreateFirstBasket),
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, WidgetRef ref, {Basket? basket}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BasketSheet(existing: basket),
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

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Basket basket,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(basketProvider.notifier).archiveBasket(basket.basketId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.mktBasketArchived)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.mktSomethingWentWrong),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    Basket basket,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(basketProvider.notifier).restoreBasket(basket.basketId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.mktBasketRestored)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.mktSomethingWentWrong),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
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
        final err = res['error'] as String?;
        String msg;
        Color bg;
        if (sent > 0) {
          msg = l10n.mktWhatsAppAlertSent(sent, total);
          bg = BrandColors.success;
        } else if (total == 0) {
          msg = l10n.mktNoCustomersWithPhone;
          bg = BrandColors.muted;
        } else if (err != null && err.isNotEmpty) {
          // Surface the real Meta/template error instead of a vague message.
          msg = l10n.mktAlertFailed(err);
          bg = BrandColors.error;
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
            content: Text(l10n.mktAlertFailed(_msg(e))),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }
}

String _msg(Object e) {
  final s = e.toString();
  return s.startsWith('Exception: ') ? s.substring(11) : s;
}

// ── Basket card ───────────────────────────────────────────────────────────────

class _BasketCard extends StatelessWidget {
  final Basket basket;
  final VoidCallback onDelete;
  final VoidCallback onAlert;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onRestore;

  const _BasketCard({
    required this.basket,
    required this.onDelete,
    required this.onAlert,
    required this.onEdit,
    required this.onArchive,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isExpired = basket.isExpired;
    final isArchived = basket.isArchived;
    final dimmed = isExpired || isArchived;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isArchived ? BrandColors.surfaceTint : Colors.white,
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
                          if (basket.tier != null) ...[
                            _TierBadge(tier: basket.tier!),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              basket.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: dimmed
                                    ? BrandColors.muted
                                    : BrandColors.ink,
                              ),
                            ),
                          ),
                          if (isArchived) ...[
                            const SizedBox(width: 8),
                            _Pill(
                              text: l10n.mktArchived,
                              color: BrandColors.muted,
                            ),
                          ] else if (isExpired) ...[
                            const SizedBox(width: 8),
                            _Pill(
                              text: l10n.mktExpired,
                              color: BrandColors.error,
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
                if (basket.price != null) _PriceBlock(basket: basket),
              ],
            ),

            if (basket.savings != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.sell_rounded,
                    size: 13,
                    color: BrandColors.success,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    l10n.mktYouSave(
                      basket.savings!.toStringAsFixed(0),
                      (basket.discountPct ?? 0).toStringAsFixed(0),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: BrandColors.success,
                    ),
                  ),
                ],
              ),
            ],

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
            if (isArchived)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRestore,
                      icon: const Icon(Icons.unarchive_rounded, size: 16),
                      label: Text(l10n.mktRestore),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _DeleteButton(onDelete: onDelete),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: (isExpired || basket.alertedToday)
                          ? null
                          : onAlert,
                      icon: const Icon(Icons.message_rounded, size: 16),
                      label: Text(
                        basket.alertedToday
                            ? l10n.mktAlertedToday
                            : l10n.mktAlertCustomers,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        side: const BorderSide(color: Color(0xFF25D366)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: l10n.mktEdit,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: BrandColors.surfaceTint,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, size: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (v) {
                      if (v == 'archive') onArchive();
                      if (v == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(Icons.archive_outlined, size: 18),
                            const SizedBox(width: 10),
                            Text(l10n.mktArchive),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: BrandColors.error,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.mktDelete,
                              style: const TextStyle(color: BrandColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  final Basket basket;
  const _PriceBlock({required this.basket});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = basket.savings != null && basket.grossTotal != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasDiscount)
          Text(
            '₹${basket.grossTotal!.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              color: BrandColors.muted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    );
  }
}

class _TierBadge extends StatelessWidget {
  final String tier;
  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = TierStyle.of(tier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 12, color: style.color),
          const SizedBox(width: 3),
          Text(
            tierLabel(l10n, tier),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: style.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  const _DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onDelete,
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: BrandColors.error,
        size: 20,
      ),
      style: IconButton.styleFrom(
        backgroundColor: BrandColors.error.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    double qty = 1,
  }) : qtyCtrl = TextEditingController(
         text: qty == qty.roundToDouble()
             ? qty.toStringAsFixed(0)
             : qty.toString(),
       );

  double get qty => double.tryParse(qtyCtrl.text) ?? 1.0;
  double get lineTotal => price * qty;

  void dispose() => qtyCtrl.dispose();
}

// ── Create / Edit Basket Sheet ────────────────────────────────────────────────

class _BasketSheet extends ConsumerStatefulWidget {
  final Basket? existing;
  const _BasketSheet({this.existing});

  @override
  ConsumerState<_BasketSheet> createState() => _BasketSheetState();
}

class _BasketSheetState extends ConsumerState<_BasketSheet> {
  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  final _items = <_SelectedItem>[];

  String? _validFrom;
  String? _validTo;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final b = widget.existing;
    _nameCtrl = TextEditingController(text: b?.name ?? '');
    _descCtrl = TextEditingController(text: b?.description ?? '');
    _validFrom = b?.validFrom;
    _validTo = b?.validTo;
    if (b != null) {
      // Map saved items back to selected items, resolving current prices.
      final products = ref.read(posProvider).products;
      for (final it in b.items) {
        final matches = products
            .where((x) => x.productId == it.productId)
            .toList();
        final p = matches.isNotEmpty ? matches.first : null;
        _items.add(
          _SelectedItem(
            productId: it.productId,
            productName: it.productName ?? p?.displayName ?? _l10n.mktItem,
            price: p?.price ?? 0,
            qty: it.qty,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  double get _grossTotal => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

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
      if (isFrom) {
        _validFrom = label;
      } else {
        _validTo = label;
      }
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
            'qty': i.qty,
          },
        )
        .toList();

    final payload = {
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim().isNotEmpty
          ? _descCtrl.text.trim()
          : null,
      'valid_from': _validFrom,
      'valid_to': _validTo,
      'items': items,
    };

    try {
      final notifier = ref.read(basketProvider.notifier);
      if (_isEdit) {
        await notifier.updateBasket(widget.existing!.basketId, payload);
      } else {
        await notifier.createBasket(payload);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = _msg(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final configAsync = ref.watch(basketTierConfigProvider);
    final config = configAsync.asData?.value ?? BasketTierConfig.defaults;

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
                      _isEdit ? l10n.mktEditBasket : l10n.mktNewBasket,
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
                  const SizedBox(height: 20),

                  // Auto-priced tier preview
                  _TierPreview(grossTotal: _grossTotal, config: config),
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
                        child: _DateField(
                          icon: Icons.calendar_today_rounded,
                          caption: l10n.mktFromDateLabel,
                          value: _validFrom,
                          placeholder: l10n.mktSelectDate,
                          onTap: _saving ? null : () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateField(
                          icon: Icons.event_rounded,
                          caption: l10n.mktToDateLabel,
                          value: _validTo,
                          placeholder: l10n.mktSelectDate,
                          onTap: _saving
                              ? null
                              : () => _pickDate(isFrom: false),
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
                                onChanged: (_) => setState(() {}),
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
                      label: _isEdit
                          ? l10n.mktSaveChanges
                          : l10n.mktCreateBasket,
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

/// Live, read-only preview of the tier + auto-discount for the current items.
class _TierPreview extends StatelessWidget {
  final double grossTotal;
  final BasketTierConfig config;
  const _TierPreview({required this.grossTotal, required this.config});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (grossTotal <= 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BrandColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              size: 18,
              color: BrandColors.muted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.mktAddItemsForPrice,
                style: const TextStyle(fontSize: 13, color: BrandColors.muted),
              ),
            ),
          ],
        ),
      );
    }
    final tier = config.tierFor(grossTotal);
    final finalPrice = config.priceFor(grossTotal);
    final savings = grossTotal - finalPrice;
    final style = TierStyle.of(tier.name);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: style.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(style.icon, size: 18, color: style.color),
              const SizedBox(width: 8),
              Text(
                l10n.mktTierBasketLabel(tierLabel(l10n, tier.name)),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: style.color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.mktPctOff(tier.discountPct.toStringAsFixed(0)),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: style.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _priceCol(
                l10n.mktItemsTotal,
                '₹${grossTotal.toStringAsFixed(0)}',
                BrandColors.muted,
                false,
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: BrandColors.muted,
              ),
              _priceCol(
                l10n.mktBundlePrice,
                '₹${finalPrice.toStringAsFixed(0)}',
                BrandColors.primary,
                true,
              ),
              const Spacer(),
              if (savings > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.mktSaveAmount(savings.toStringAsFixed(0)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: BrandColors.success,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceCol(String label, String value, Color color, bool bold) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: BrandColors.muted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final IconData icon;
  final String caption;
  final String? value;
  final String placeholder;
  final VoidCallback? onTap;
  const _DateField({
    required this.icon,
    required this.caption,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSet = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: const TextStyle(
            fontSize: 11,
            color: BrandColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BrandColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: BrandColors.muted),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    value ?? placeholder,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSet ? BrandColors.ink : BrandColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Pro gate ──────────────────────────────────────────────────────────────────

class _BasketsProGate extends StatelessWidget {
  final VoidCallback onUpgrade;
  const _BasketsProGate({required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const purple = Color(0xFF7C3AED);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_rounded,
                size: 48,
                color: purple,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.posProOnly,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.mktBasketsProTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BrandColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.mktBasketsProDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: BrandColors.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: Text(l10n.posUpgradeToProDay),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
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
