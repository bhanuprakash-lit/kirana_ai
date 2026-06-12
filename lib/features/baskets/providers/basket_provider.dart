import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/basket_model.dart';
import '../models/basket_tier_config.dart';

class BasketNotifier extends AsyncNotifier<List<Basket>> {
  bool _includeArchived = false;
  bool get includeArchived => _includeArchived;

  @override
  Future<List<Basket>> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> setIncludeArchived(bool value) async {
    _includeArchived = value;
    await refresh();
  }

  Future<List<Basket>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.get('/kirana/baskets?include_archived=$_includeArchived')
            as Map<String, dynamic>;
    return (res['baskets'] as List)
        .cast<Map<String, dynamic>>()
        .map(Basket.fromJson)
        .toList();
  }

  Future<void> createBasket(Map<String, dynamic> data) async {
    final client = ref.read(apiClientProvider);
    await client.post('/kirana/baskets', data);
    await refresh();
  }

  Future<void> updateBasket(int basketId, Map<String, dynamic> data) async {
    final client = ref.read(apiClientProvider);
    await client.put('/kirana/baskets/$basketId', data);
    await refresh();
  }

  Future<void> deleteBasket(int basketId) async {
    final client = ref.read(apiClientProvider);
    await client.delete('/kirana/baskets/$basketId');
    await refresh();
  }

  Future<void> archiveBasket(int basketId) async {
    final client = ref.read(apiClientProvider);
    await client.post('/kirana/baskets/$basketId/archive', {});
    await refresh();
  }

  Future<void> restoreBasket(int basketId) async {
    final client = ref.read(apiClientProvider);
    await client.post('/kirana/baskets/$basketId/restore', {});
    await refresh();
  }

  /// Recompute tier/price for all baskets under the current config.
  Future<int> retier() async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.post('/kirana/baskets/retier', {}) as Map<String, dynamic>;
    await refresh();
    return (res['updated'] as num?)?.toInt() ?? 0;
  }

  Future<Map<String, dynamic>> alertCustomers(int basketId) async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.post('/kirana/baskets/$basketId/alert', {})
            as Map<String, dynamic>;
    await refresh(); // pick up the new alerted-today state
    return res;
  }
}

final basketProvider = AsyncNotifierProvider<BasketNotifier, List<Basket>>(
  BasketNotifier.new,
);

// ── Tier config ───────────────────────────────────────────────────────────────

class BasketTierConfigNotifier extends AsyncNotifier<BasketTierConfig> {
  @override
  Future<BasketTierConfig> build() async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.get('/kirana/basket-tier-config') as Map<String, dynamic>;
    return BasketTierConfig.fromJson(res['config'] as Map<String, dynamic>);
  }

  /// Saves the config; returns the number of existing baskets the owner may
  /// optionally recompute (tiers freeze at creation otherwise).
  Future<int> save(BasketTierConfig config) async {
    final client = ref.read(apiClientProvider);
    final res =
        await client.put('/kirana/basket-tier-config', {
              'config': config.toJson(),
            })
            as Map<String, dynamic>;
    state = AsyncData(
      BasketTierConfig.fromJson(res['config'] as Map<String, dynamic>),
    );
    return (res['existing_baskets'] as num?)?.toInt() ?? 0;
  }
}

final basketTierConfigProvider =
    AsyncNotifierProvider<BasketTierConfigNotifier, BasketTierConfig>(
      BasketTierConfigNotifier.new,
    );
