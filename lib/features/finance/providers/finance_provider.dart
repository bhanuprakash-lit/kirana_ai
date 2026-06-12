import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_client.dart';
import '../../dashboard/providers/overview_provider.dart';
import '../../profile/providers/customer_provider.dart';
import '../models/finance_models.dart';

class FinanceData {
  final FinanceStats stats;
  final List<UdhaarItem> udhaarList;

  const FinanceData({required this.stats, required this.udhaarList});
}

class FinanceNotifier extends AsyncNotifier<FinanceData> {
  @override
  Future<FinanceData> build() => _fetch();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<FinanceData> _fetch() async {
    final client = ref.read(apiClientProvider);

    final statsJsonFuture = client.get('/kirana/finance/overview');
    final udhaarJsonFuture = client.get(
      '/kirana/finance/udhaar?include_recovered=true',
    );

    final statsJson = await statsJsonFuture;
    final udhaarJson = await udhaarJsonFuture;

    final stats = FinanceStats.fromJson(statsJson as Map<String, dynamic>);
    final udhaarList = (udhaarJson as List)
        .map((item) => UdhaarItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return FinanceData(stats: stats, udhaarList: udhaarList);
  }

  Future<void> addUdhaar({
    required String name,
    required String phone,
    required double amount,
  }) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/finance/udhaar/add', {
        'customer_name': name,
        'phone': phone,
        'amount': amount,
      });
      // Invalidate customer list as this might create a new customer
      ref.invalidate(customerProvider);
      await refresh();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> recordRecovery(int khataId, double amount) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/finance/udhaar/recovery', {
        'khata_id': khataId,
        'amount': amount,
      });
      await refresh();
      // Invalidate the overview so the "Customer Dues" intelligence tile
      // reflects the updated pending-dues count immediately.
      ref.invalidate(overviewProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Records a single customer payment across their open khatas oldest-first:
  /// the amount fully clears the oldest debt, then rolls into the next, until
  /// it runs out. Posts to the same per-khata recovery endpoint without
  /// refreshing between calls, then refreshes once at the end so the list and
  /// stats update in a single pass. [openOldestFirst] must be the customer's
  /// open (unsettled) entries sorted oldest-first.
  Future<void> recordCustomerRecovery(
    List<UdhaarItem> openOldestFirst,
    double amount,
  ) async {
    final client = ref.read(apiClientProvider);
    try {
      var remaining = amount;
      for (final entry in openOldestFirst) {
        if (remaining <= 0.001) break;
        final pay = remaining < entry.balance ? remaining : entry.balance;
        if (pay <= 0) continue;
        await client.post('/kirana/finance/udhaar/recovery', {
          'khata_id': entry.khataId,
          'amount': pay,
        });
        remaining -= pay;
      }
      await refresh();
      // Keep the dashboard "Customer Dues" tile in sync (same as recordRecovery).
      ref.invalidate(overviewProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendReminder(int khataId) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/finance/udhaar/remind', {'khata_id': khataId});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncContacts(List<Map<String, String>> contacts) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/finance/customers/sync', contacts);
      // Invalidate customer list as this creates multiple customers
      ref.invalidate(customerProvider);
      await refresh();
    } catch (e) {
      rethrow;
    }
  }
}

final financeProvider = AsyncNotifierProvider<FinanceNotifier, FinanceData>(
  FinanceNotifier.new,
);
