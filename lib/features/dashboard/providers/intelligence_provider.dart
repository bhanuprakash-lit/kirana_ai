import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';
import '../../../core/store/store_scope.dart';
import '../models/recommendation_model.dart';

class IntelligenceSortNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => {};

  String getSort(String type) => state[type] ?? 'expected_profit';

  void setSort(String type, String sortBy) {
    state = {...state, type: sortBy};
  }
}

final intelligenceSortProvider =
    NotifierProvider<IntelligenceSortNotifier, Map<String, String>>(
      IntelligenceSortNotifier.new,
    );

final intelligenceProvider = FutureProvider.family<List<Recommendation>, String>((
  ref,
  type,
) async {
  ref.watch(storeScopeProvider); // refetch when the active store changes
  final sortMap = ref.watch(intelligenceSortProvider);
  final sortBy = sortMap[type] ?? 'expected_profit';

  final client = ref.read(apiClientProvider);
  final prefs = await SharedPreferences.getInstance();
  final storeId = prefs.getInt('store_id') ?? 1;

  // Map internal type to backend recommendation_type
  final recoType = {
    'stockout': 'stockout_risk',
    'reorder': 'reorder_now',
    'fast_moving': 'fast_moving',
    'profit': 'profit_opportunity',
  }[type];

  if (recoType == null) {
    return [];
  }

  // top_n defaults to 5 on the backend; the detail screen wants the full list,
  // so request a high cap. (The overview strip uses a separate endpoint.)
  final res = await client.get(
    '/kirana/recommendations?store_id=$storeId&recommendation_type=$recoType&sort_by=$sortBy&top_n=500',
  );
  final List<dynamic> results = res['results'] as List<dynamic>;
  return results.map((j) => Recommendation.fromJson(j)).toList();
});
