import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_client.dart';
import '../models/campaign_model.dart';

class CampaignNotifier extends AsyncNotifier<List<Campaign>> {
  @override
  Future<List<Campaign>> build() => _fetch();

  Future<List<Campaign>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final prefs  = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id') ?? 1;
    try {
      final res = await client.get(
        '/kirana/campaigns/recommended?store_id=$storeId&limit=3',
      ) as Map<String, dynamic>;
      return (res['campaigns'] as List)
          .map((e) => Campaign.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final campaignProvider =
    AsyncNotifierProvider<CampaignNotifier, List<Campaign>>(
  CampaignNotifier.new,
);
