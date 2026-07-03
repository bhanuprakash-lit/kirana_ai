part of '../pos_tab_new.dart';

class _SmartAssortmentHints extends ConsumerStatefulWidget {
  const _SmartAssortmentHints();

  @override
  ConsumerState<_SmartAssortmentHints> createState() =>
      _SmartAssortmentHintsState();
}

class _SmartAssortmentHintsState extends ConsumerState<_SmartAssortmentHints> {
  bool _expanded = true;
  bool _visible = false;
  Timer? _collapseTimer;

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  /// Keep the suggestions visible for 5 seconds, then auto-collapse.
  void _startCollapseTimer() {
    _collapseTimer?.cancel();
    _collapseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _expanded = false);
    });
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _startCollapseTimer();
    } else {
      _collapseTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posProvider);
    final cart = state.cart;

    final cartIds = cart.map((e) => e.product.productId).toSet();
    final suggestions = (cart.isEmpty || state.products.isEmpty)
        ? const <PosProduct>[]
        : state.products
              .where((p) => !cartIds.contains(p.productId))
              .take(5)
              .toList();

    if (suggestions.isEmpty) {
      // Reset so the strip re-opens (and re-times) the next time it appears.
      _visible = false;
      _collapseTimer?.cancel();
      return const SizedBox.shrink();
    }

    // Suggestions just became visible — open it and start the 5s auto-collapse.
    if (!_visible) {
      _visible = true;
      _expanded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startCollapseTimer();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: BrandColors.primary,
                ),
                const SizedBox(width: 6),
                const Text(
                  'FREQUENTLY BOUGHT TOGETHER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 18,
                    color: BrandColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: !_expanded
              ? const SizedBox(width: double.infinity)
              : SizedBox(
                  height: 64,
                  // Scrolling the suggestions also keeps the strip alive.
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) {
                      _startCollapseTimer();
                      return false;
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, index) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final p = suggestions[i];
                        return InkWell(
                              onTap: () {
                                ref.read(posProvider.notifier).addToCart(p);
                                // Interacting keeps the strip alive another 5s.
                                _startCollapseTimer();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: BrandColors.border),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: BrandColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add_rounded,
                                        size: 12,
                                        color: BrandColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: BrandColors.ink,
                                          ),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          '₹${p.price.toStringAsFixed(1)}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: BrandColors.muted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 100 * i))
                            .slideX(begin: 0.2, end: 0);
                      },
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
