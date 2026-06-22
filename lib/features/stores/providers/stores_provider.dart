import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../../core/vertical/vertical_config_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/user_store.dart';

// Store-scoped providers refreshed when the active store changes, so the whole
// UI re-renders for the new store + vertical. Imported here on purpose: the
// switch is the one place that must drop every store's cached data.
import '../../pos_inventory/providers/pos_provider.dart';
import '../../pos_inventory/providers/inventory_provider.dart';
import '../../dashboard/providers/kpi_provider.dart';
import '../../dashboard/providers/overview_provider.dart';
import '../../profile/providers/store_settings_provider.dart';
import '../../profile/providers/customer_provider.dart';
import '../../finance/providers/finance_provider.dart';
import '../../loyalty/providers/loyalty_provider.dart';
import '../../subscription/providers/subscription_provider.dart';

/// The owner's stores (active one flagged). Refreshed after add/switch.
final myStoresProvider = FutureProvider<List<UserStore>>((ref) async {
  final data = await ref.read(apiClientProvider).get('/kirana/my-stores');
  final list = (data is Map ? data['stores'] : null) as List<dynamic>? ?? [];
  return list
      .whereType<Map>()
      .map((e) => UserStore.fromJson(e.cast<String, dynamic>()))
      .toList();
});

class StoreActions {
  StoreActions(this.ref);
  final Ref ref;
  ApiClient get _c => ref.read(apiClientProvider);

  /// Switch the active store: backend pointer + local store_id + drop caches.
  Future<void> switchStore(int storeId) async {
    await _c.post('/kirana/stores/switch', {'store_id': storeId});
    await _setActiveLocal(storeId);
    // POS JWT has a baked-in store_id → re-mint it for the new active store.
    await ref.read(authRepositoryProvider).refreshPosToken();
    _refreshStoreScope();
  }

  /// Create a new store for this owner and switch to it. Returns its id.
  Future<int> addStore({
    required String storeName,
    required String storeType,
    required String verticalCode,
    String? city,
  }) async {
    final res = await _c.post('/kirana/stores/add', {
      'store_name': storeName,
      'store_type': storeType,
      'vertical_code': verticalCode,
      'city': city,
      'make_active': true,
    });
    final sid = ((res is Map ? res['store_id'] : null) as num).toInt();
    await _setActiveLocal(sid);
    await ref.read(authRepositoryProvider).refreshPosToken();
    _refreshStoreScope();
    return sid;
  }

  Future<void> _setActiveLocal(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('store_id', storeId);
  }

  /// Drop every store-scoped cache so the UI rebuilds for the new store. The
  /// vertical config drives feature gating (tabs/fields), so it's first.
  void _refreshStoreScope() {
    ref.invalidate(verticalConfigProvider);
    ref.invalidate(subscriptionProvider); // each store has its own plan/trial
    ref.invalidate(myStoresProvider);
    ref.invalidate(posProvider);
    ref.invalidate(inventoryProvider);
    ref.invalidate(kpiCardsProvider);
    ref.invalidate(visibleKpisProvider);
    ref.invalidate(overviewProvider);
    ref.invalidate(storeSettingsProvider);
    ref.invalidate(customerProvider);
    ref.invalidate(financeProvider);
    ref.invalidate(loyaltyConfigProvider);
  }
}

final storeActionsProvider = Provider<StoreActions>(StoreActions.new);
