import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';
import '../models/store_model.dart';

class StoreSettingsNotifier extends AsyncNotifier<StoreProfile> {
  @override
  Future<StoreProfile> build() => _fetch();

  Future<StoreProfile> _fetch() async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;

    final res = await client.get('/kirana/stores');
    final stores = (res['stores'] as List).cast<Map<String, dynamic>>();
    final myStore = stores.firstWhere((s) => s['store_id'] == storeId);

    return StoreProfile.fromJson(myStore);
  }

  Future<void> updateStore(StoreProfile profile) async {
    final client = ref.read(apiClientProvider);
    try {
      final res = await client.patch('/kirana/stores/${profile.storeId}', profile.toJson());
      state = AsyncValue.data(StoreProfile.fromJson(res));
      
      // Update local storage if name changed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('store_name', profile.name);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final storeSettingsProvider = AsyncNotifierProvider<StoreSettingsNotifier, StoreProfile>(StoreSettingsNotifier.new);
