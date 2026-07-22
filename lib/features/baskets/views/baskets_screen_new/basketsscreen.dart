part of '../baskets_screen_new.dart';

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
          // Surface the real Meta/template error, unless it's an operator-side
          // failure the owner can't act on (expired token → friendly copy).
          msg = friendlyErrorOrNull(l10n, err) ?? l10n.mktAlertFailed(err);
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
            content: Text(
              friendlyErrorOrNull(l10n, e) ?? l10n.mktAlertFailed(_msg(e)),
            ),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }
}
