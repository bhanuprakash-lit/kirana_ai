import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../models/forecast_model.dart';

typedef _ItemsArgs = ({int storeId, int horizonDays});

final forecastSummaryProvider = FutureProvider.autoDispose
    .family<ForecastSummary, int>((ref, storeId) async {
      final client = ref.read(apiClientProvider);
      final json = await client.get(
        '/kirana/forecast/summary?store_id=$storeId',
      );
      return ForecastSummary.fromJson(json as Map<String, dynamic>);
    });

final forecastItemsProvider = FutureProvider.autoDispose
    .family<ForecastItemsPage, _ItemsArgs>((ref, args) async {
      final client = ref.read(apiClientProvider);
      final json = await client.get(
        '/kirana/forecast/items?store_id=${args.storeId}&horizon_days=${args.horizonDays}&top_n=100',
      );
      return ForecastItemsPage.fromJson(json as Map<String, dynamic>);
    });

/// Resolves the active store_id from SharedPreferences — same source of truth
/// used by overview_provider.dart.
Future<int> resolveStoreId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('store_id') ?? 1;
}
