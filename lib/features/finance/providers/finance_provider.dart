import 'package:flutter/foundation.dart';
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

/// Lifecycle of a background customer-recovery settlement.
enum RecoveryStatus { running, success, failed }

class RecoveryProgress {
  final int cleared;
  final int total;
  final RecoveryStatus status;

  /// Open entries still owing after a failure — replayed on retry so we never
  /// re-settle the dues that already went through.
  final List<UdhaarItem> pending;

  /// Amount still to apply across [pending] when retrying.
  final double remainingAmount;

  const RecoveryProgress(
    this.cleared,
    this.total, {
    this.status = RecoveryStatus.running,
    this.pending = const [],
    this.remainingAmount = 0,
  });
}

class RecoveryProgressNotifier extends Notifier<Map<int, RecoveryProgress>> {
  @override
  Map<int, RecoveryProgress> build() => {};

  void setProgress(int customerId, RecoveryProgress? p) {
    if (p == null) {
      final newState = Map.of(state);
      newState.remove(customerId);
      state = newState;
    } else {
      state = {...state, customerId: p};
    }
  }
}

final recoveryProgressProvider =
    NotifierProvider<RecoveryProgressNotifier, Map<int, RecoveryProgress>>(
      RecoveryProgressNotifier.new,
    );

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
    DateTime? dueDate,
  }) async {
    final client = ref.read(apiClientProvider);
    try {
      await client.post('/kirana/finance/udhaar/add', {
        'customer_name': name,
        'phone': phone,
        'amount': amount,
        if (dueDate != null) 'due_date': _isoDate(dueDate),
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
      // Keep dashboard in sync
      ref.invalidate(overviewProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Bulk recovery: applies [amount] across a customer's open dues oldest-first,
  /// posting to the per-khata recovery endpoint one due at a time. Runs in the
  /// background (the caller does not await it) and reports live state through
  /// [recoveryProgressProvider]: a running x/y progress, a brief success flash,
  /// or — if a post fails partway — a sticky failed state carrying the leftover
  /// dues/amount so the UI can offer a retry. Refreshes the list + dashboard on
  /// both the success and failure paths. [openOldestFirst] must be the
  /// customer's open (unsettled) entries sorted oldest-first.
  Future<void> recordCustomerRecovery(
    List<UdhaarItem> openOldestFirst,
    double amount,
  ) async {
    if (openOldestFirst.isEmpty) return;
    final customerId = openOldestFirst.first.customerId;

    // Pre-calculate total affected entries
    var remainingCalc = amount;
    int totalAffected = 0;
    for (final entry in openOldestFirst) {
      if (remainingCalc <= 0.001) break;
      final pay = remainingCalc < entry.balance ? remainingCalc : entry.balance;
      if (pay > 0) totalAffected++;
      remainingCalc -= pay;
    }

    if (totalAffected == 0) return;

    final progress = ref.read(recoveryProgressProvider.notifier);
    progress.setProgress(customerId, RecoveryProgress(0, totalAffected));

    final client = ref.read(apiClientProvider);
    var remaining = amount;
    int cleared = 0;
    int idx = 0;
    try {
      for (idx = 0; idx < openOldestFirst.length; idx++) {
        final entry = openOldestFirst[idx];
        if (remaining <= 0.001) break;
        final pay = remaining < entry.balance ? remaining : entry.balance;
        if (pay <= 0) continue;
        await client.post('/kirana/finance/udhaar/recovery', {
          'khata_id': entry.khataId,
          'amount': pay,
        });
        remaining -= pay;
        cleared++;
        progress.setProgress(
          customerId,
          RecoveryProgress(cleared, totalAffected),
        );
      }
      await refresh();
      ref.invalidate(overviewProvider);
      // Flash an "all dues cleared" confirmation, then auto-dismiss.
      progress.setProgress(
        customerId,
        RecoveryProgress(
          totalAffected,
          totalAffected,
          status: RecoveryStatus.success,
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        progress.setProgress(customerId, null);
      });
    } catch (e) {
      debugPrint('Customer recovery failed at $cleared/$totalAffected: $e');
      // Pull fresh balances (the dues already posted are settled), then keep a
      // sticky failed banner carrying the leftover so the user can retry.
      await refresh();
      ref.invalidate(overviewProvider);
      progress.setProgress(
        customerId,
        RecoveryProgress(
          cleared,
          totalAffected,
          status: RecoveryStatus.failed,
          pending: openOldestFirst.sublist(idx),
          remainingAmount: remaining,
        ),
      );
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

/// Formats a date as ISO `yyyy-mm-dd` for the backend's DATE columns (no time).
String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

final financeProvider = AsyncNotifierProvider<FinanceNotifier, FinanceData>(
  FinanceNotifier.new,
);
