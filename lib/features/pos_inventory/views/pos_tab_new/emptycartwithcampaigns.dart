part of '../pos_tab_new.dart';

class _EmptyCartWithCampaigns extends ConsumerWidget {
  final bool hasPosError;
  final String? errorMsg;
  final void Function(campaign_card_lib.Campaign) onAddCampaign;
  final void Function(campaign_card_lib.Campaign) onSaveCampaignAsBasket;
  final void Function(Basket) onAddBasket;

  const _EmptyCartWithCampaigns({
    required this.hasPosError,
    required this.onAddCampaign,
    required this.onSaveCampaignAsBasket,
    required this.onAddBasket,
    this.errorMsg,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (hasPosError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: BrandColors.muted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'POS Offline',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                errorMsg ?? 'Could not connect to POS.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    final campaignsAsync = ref.watch(campaignProvider);
    final basketsAsync = ref.watch(basketProvider);
    final posProducts = ref.watch(posProvider).products;
    // Baskets are Pro-only — basic users see campaigns but no saved baskets
    // and no "Save as Basket".
    final canUseBaskets = ref.watch(subInfoProvider).canAccessBaskets;

    return campaignsAsync.when(
      loading: () => const _EmptyCartHint(),
      error: (_, _) => const _EmptyCartHint(),
      data: (campaigns) {
        final activeBaskets = canUseBaskets
            ? (basketsAsync.value
                      ?.where((b) => b.isActive2 && b.items.isNotEmpty)
                      .toList() ??
                  [])
            : <Basket>[];

        if (campaigns.isEmpty && activeBaskets.isEmpty) {
          // Keep it pull-to-refreshable even though there's nothing to scroll.
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const _EmptyCartHint(),
              ),
            ),
          );
        }

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          children: [
            // ── Single unified header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Near Commerce',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.muted,
                      letterSpacing: 0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => ref.read(campaignProvider.notifier).refresh(),
                    child: const Text(
                      'Refresh AI',
                      style: TextStyle(
                        fontSize: 12,
                        color: BrandColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── User baskets first ─────────────────────────────────────────
            for (final basket in activeBaskets)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PosBasketCard(
                  basket: basket,
                  posProducts: posProducts,
                  onAddToCart: () => onAddBasket(basket),
                ),
              ),

            // ── AI campaigns after ─────────────────────────────────────────
            for (int i = 0; i < campaigns.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CampaignCard(
                  campaign: campaigns[i],
                  index: i,
                  onAddAll: () => onAddCampaign(campaigns[i]),
                  onSaveAsBasket: canUseBaskets
                      ? () => onSaveCampaignAsBasket(campaigns[i])
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

