import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../models/basket_model.dart';

class BasketNotifier extends AsyncNotifier<List<Basket>> {
  @override
  Future<List<Basket>> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<Basket>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/kirana/baskets') as Map<String, dynamic>;
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

  Future<void> deleteBasket(int basketId) async {
    final client = ref.read(apiClientProvider);
    await client.delete('/kirana/baskets/$basketId');
    await refresh();
  }

  Future<Map<String, dynamic>> alertCustomers(int basketId) async {
    final client = ref.read(apiClientProvider);
    return await client.post('/kirana/baskets/$basketId/alert', {})
        as Map<String, dynamic>;
  }
}

final basketProvider = AsyncNotifierProvider<BasketNotifier, List<Basket>>(
  BasketNotifier.new,
);
