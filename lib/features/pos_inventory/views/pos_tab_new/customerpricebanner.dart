part of '../pos_tab_new.dart';

class _CustomerPriceBanner extends ConsumerWidget {
  const _CustomerPriceBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posProvider);
    // Count items actually in the cart that have a special price — not the
    // customer's whole saved list, which would over-count items that aren't here.
    final count = state.customerPricedCartCount;
    if (count == 0) return const SizedBox.shrink();
    final name = state.selectedCustomerName?.trim().isNotEmpty == true
        ? state.selectedCustomerName!.trim()
        : 'This customer';
    final notifier = ref.read(posProvider.notifier);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: BrandColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sell_rounded, size: 18, color: BrandColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.3,
                  color: BrandColors.ink,
                ),
                children: [
                  TextSpan(text: '$name has special prices on '),
                  TextSpan(
                    text: '$count item${count > 1 ? 's' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          TextButton(
            onPressed: notifier.dismissCustomerPrices,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              foregroundColor: BrandColors.muted,
            ),
            child: const Text(
              'Ignore',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 4),
          FilledButton(
            onPressed: notifier.applyCustomerPrices,
            style: FilledButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: BrandColors.accent,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
