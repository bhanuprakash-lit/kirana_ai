import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../auth/repositories/auth_repository.dart';
import '../models/referral_models.dart';

// ── Campaign provider ─────────────────────────────────────────────────────────

final referralCampaignsProvider =
    AsyncNotifierProvider<ReferralCampaignNotifier, List<ReferralCampaign>>(
      ReferralCampaignNotifier.new,
    );

class ReferralCampaignNotifier extends AsyncNotifier<List<ReferralCampaign>> {
  @override
  Future<List<ReferralCampaign>> build() => _fetch();

  Future<List<ReferralCampaign>> _fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id');
    if (storeId == null) return [];
    final token = await AuthRepository().getToken();
    if (token == null) return [];

    final res = await http.get(
      Uri.parse(
        '${AppConfig.apiBaseUrl}/kirana/referral/campaigns?store_id=$storeId',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['campaigns'] as List)
          .map((e) => ReferralCampaign.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<bool> createCampaign({
    required String name,
    required double referralDiscountPct,
    required int milestoneEveryN,
    required double milestoneRewardPct,
    int maxReferralsPerReferrer = 50,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id');
    if (storeId == null) return false;
    final token = await AuthRepository().getToken();
    if (token == null) return false;

    final res = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/kirana/referral/campaigns'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'store_id': storeId,
        'name': name,
        'referral_discount_pct': referralDiscountPct,
        'milestone_every_n': milestoneEveryN,
        'milestone_reward_pct': milestoneRewardPct,
        'max_referrals_per_referrer': maxReferralsPerReferrer,
      }),
    );
    if (res.statusCode == 200) {
      await refresh();
      return true;
    }
    return false;
  }

  Future<bool> toggleCampaign(int campaignId, bool isActive) async {
    final token = await AuthRepository().getToken();
    if (token == null) return false;

    final res = await http.patch(
      Uri.parse(
        '${AppConfig.apiBaseUrl}/kirana/referral/campaigns/$campaignId/toggle?is_active=$isActive',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      await refresh();
      return true;
    }
    return false;
  }
}

// ── Token / QR generation ─────────────────────────────────────────────────────

Future<ReferralToken?> generateReferralToken({
  required int customerId,
  required int campaignId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final storeId = prefs.getInt('store_id');
  if (storeId == null) return null;
  final token = await AuthRepository().getToken();
  if (token == null) return null;

  final res = await http.post(
    Uri.parse('${AppConfig.apiBaseUrl}/kirana/referral/token'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'store_id': storeId,
      'customer_id': customerId,
      'campaign_id': campaignId,
    }),
  );
  if (res.statusCode == 200) {
    return ReferralToken.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
  return null;
}

// ── Token preview (before phone entry) ───────────────────────────────────────

Future<TokenInfo?> fetchTokenInfo(String tokenHash) async {
  final token = await AuthRepository().getToken();
  if (token == null) return null;

  final res = await http.get(
    Uri.parse(
      '${AppConfig.apiBaseUrl}/kirana/referral/token-info?token=$tokenHash',
    ),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return TokenInfo.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
  return null;
}

// ── Referral scan processing ──────────────────────────────────────────────────

Future<ReferralScanResult> processReferralScan({
  required String tokenHash,
  required String newCustomerPhone,
  String newCustomerName = '',
  int? orderId,
}) async {
  final token = await AuthRepository().getToken();
  if (token == null) throw Exception('Not authenticated');

  final res = await http.post(
    Uri.parse('${AppConfig.apiBaseUrl}/kirana/referral/scan'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'token_hash': tokenHash,
      'new_customer_phone': newCustomerPhone,
      'new_customer_name': newCustomerName,
      'order_id': ?orderId,
    }),
  );
  if (res.statusCode == 200) {
    return ReferralScanResult.fromJson(
      jsonDecode(res.body) as Map<String, dynamic>,
    );
  }
  final err = jsonDecode(res.body) as Map<String, dynamic>;
  throw Exception(err['detail'] ?? 'Scan failed');
}

// ── Vouchers ──────────────────────────────────────────────────────────────────

Future<List<ReferralVoucher>> fetchVouchers(int customerId, int storeId) async {
  final token = await AuthRepository().getToken();
  if (token == null) return [];

  final res = await http.get(
    Uri.parse(
      '${AppConfig.apiBaseUrl}/kirana/referral/vouchers?customer_id=$customerId&store_id=$storeId',
    ),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['vouchers'] as List)
        .map((e) => ReferralVoucher.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return [];
}

Future<bool> useVoucher(int voucherId, {int? orderId}) async {
  final token = await AuthRepository().getToken();
  if (token == null) return false;

  final res = await http.post(
    Uri.parse('${AppConfig.apiBaseUrl}/kirana/referral/vouchers/use'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'voucher_id': voucherId, 'order_id': ?orderId}),
  );
  return res.statusCode == 200;
}
