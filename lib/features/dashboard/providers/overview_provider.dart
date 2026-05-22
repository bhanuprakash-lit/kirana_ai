import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../models/overview_models.dart';

class OverviewNotifier extends AsyncNotifier<OverviewData> {
  @override
  Future<OverviewData> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<OverviewData> _fetch() async {
    final client = ref.read(apiClientProvider);
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;
    final today = _today();

    // Start all three in parallel, await typed results individually
    final storesFuture = client.get('/kirana/stores');
    final recoFuture = client.get('/kirana/stores/$storeId/recommendations');
    final salesFuture = client.posGet(
      '/pos/reports/daily-sales?date=$today&store_id=$storeId',
    );

    final storesJson = await storesFuture;
    final recoJson = await recoFuture;
    final salesJson = await salesFuture;

    final storesList = storesJson['stores'] as List<dynamic>;
    final storeJson =
        storesList.firstWhere(
              (s) => (s as Map<String, dynamic>)['store_id'] == storeId,
              orElse: () => storesList.first,
            )
            as Map<String, dynamic>;

    return OverviewData(
      store: StoreInfo.fromJson(storeJson),
      recommendations: RecommendationSummary.fromJson(
        recoJson['summary'] as Map<String, dynamic>,
      ),
      dailySales: salesJson != null ? DailySales.fromJson(salesJson) : null,
    );
  }

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

final overviewProvider =
    AsyncNotifierProvider.autoDispose<OverviewNotifier, OverviewData>(
      OverviewNotifier.new,
    );
