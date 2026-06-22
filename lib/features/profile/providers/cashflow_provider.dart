import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/store/store_scope.dart';
import '../../auth/repositories/auth_repository.dart';
import '../models/cashflow_model.dart';

final cashflowStatusProvider =
    AsyncNotifierProvider<CashflowNotifier, CashflowStatus>(
      CashflowNotifier.new,
    );

class CashflowNotifier extends AsyncNotifier<CashflowStatus> {
  @override
  Future<CashflowStatus> build() async {
    ref.watch(storeScopeProvider); // rebuild when the active store changes
    return _fetchStatus();
  }

  Future<CashflowStatus> _fetchStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id');
    if (storeId == null) return CashflowStatus.empty;

    final token = await AuthRepository().getToken();
    if (token == null) return CashflowStatus.empty;

    final res = await http.get(
      Uri.parse(
        '${AppConfig.apiBaseUrl}/kirana/cashflow/status?store_id=$storeId',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return CashflowStatus.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
    }
    return CashflowStatus.empty;
  }

  Future<Map<String, dynamic>> submitRequest({
    required double amount,
    required String selectedBank,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storeId = prefs.getInt('store_id');
    if (storeId == null) throw Exception('Store not found');

    final token = await AuthRepository().getToken();
    if (token == null) throw Exception('Not authenticated');

    final res = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/kirana/cashflow/request'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'store_id': storeId,
        'amount_requested': amount,
        'selected_bank': selectedBank,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      state = const AsyncValue.loading();
      state = AsyncValue.data(await _fetchStatus());
      return data;
    }
    final err = jsonDecode(res.body);
    throw Exception(err['detail'] ?? 'Request failed');
  }
}
