import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/store/store_scope.dart';
import '../../../core/services/api_client.dart';
import '../models/category_group.dart';

/// Per-store category groups (G7).
///
/// Watches [storeScopeProvider] so switching stores refetches — groups are
/// per store, and showing the previous store's grouping over this store's
/// stock is exactly the data-bleed class of bug.
final categoryGroupsProvider = FutureProvider<CategoryGroupSet>((ref) async {
  ref.watch(storeScopeProvider);
  try {
    final d = await ref.read(apiClientProvider).get('/kirana/category-groups');
    if (d is Map) return CategoryGroupSet.fromJson(d.cast<String, dynamic>());
  } catch (_) {
    // Grouping is a view over the inventory the user already has. If it can't
    // load, the flat category list still works — never block the screen on it.
  }
  return const CategoryGroupSet();
});

/// Mutations. Each returns after invalidating, so callers just await.
class CategoryGroupActions {
  final Ref _ref;
  CategoryGroupActions(this._ref);

  ApiClient get _api => _ref.read(apiClientProvider);

  Future<void> create(String name, List<int> categoryIds) async {
    await _api.post('/kirana/category-groups', {
      'name': name,
      'category_ids': categoryIds,
    });
    _ref.invalidate(categoryGroupsProvider);
  }

  Future<void> rename(int groupId, String name) async {
    await _api.patch('/kirana/category-groups/$groupId', {'name': name});
    _ref.invalidate(categoryGroupsProvider);
  }

  Future<void> setCategories(int groupId, List<int> categoryIds) async {
    await _api.patch('/kirana/category-groups/$groupId', {
      'category_ids': categoryIds,
    });
    _ref.invalidate(categoryGroupsProvider);
  }

  Future<void> delete(int groupId) async {
    await _api.delete('/kirana/category-groups/$groupId');
    _ref.invalidate(categoryGroupsProvider);
  }

  Future<void> resetToDefaults() async {
    await _api.post('/kirana/category-groups/reset', const {});
    _ref.invalidate(categoryGroupsProvider);
  }
}

final categoryGroupActionsProvider = Provider<CategoryGroupActions>(
  CategoryGroupActions.new,
);
