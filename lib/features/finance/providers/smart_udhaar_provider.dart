import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/api_client.dart';

/// An open udhaar entry scored by recovery risk (for Smart Reminders).
class SmartUdhaar {
  final int khataId;
  final int? customerId;
  final String customerName;
  final String? phone;
  final double balance;
  final String? dateTaken;
  final int daysPending;
  final int riskScore; // 0-100, higher = more at risk
  final String riskBand; // low | medium | high
  final int recoveryLikelihood; // 0-100
  final String suggestedAction;

  const SmartUdhaar({
    required this.khataId,
    this.customerId,
    required this.customerName,
    this.phone,
    required this.balance,
    this.dateTaken,
    required this.daysPending,
    required this.riskScore,
    required this.riskBand,
    required this.recoveryLikelihood,
    required this.suggestedAction,
  });

  factory SmartUdhaar.fromJson(Map<String, dynamic> j) => SmartUdhaar(
    khataId: (j['khata_id'] as num).toInt(),
    customerId: (j['customer_id'] as num?)?.toInt(),
    customerName: j['customer_name'] as String? ?? 'Customer',
    phone: j['phone'] as String?,
    balance: (j['balance'] as num?)?.toDouble() ?? 0,
    dateTaken: j['date_taken'] as String?,
    daysPending: (j['days_pending'] as num?)?.toInt() ?? 0,
    riskScore: (j['risk_score'] as num?)?.toInt() ?? 0,
    riskBand: j['risk_band'] as String? ?? 'low',
    recoveryLikelihood: (j['recovery_likelihood'] as num?)?.toInt() ?? 0,
    suggestedAction: j['suggested_action'] as String? ?? '',
  );
}

class SmartUdhaarNotifier extends AsyncNotifier<List<SmartUdhaar>> {
  @override
  Future<List<SmartUdhaar>> build() => _fetch();

  Future<List<SmartUdhaar>> _fetch() async {
    final client = ref.read(apiClientProvider);
    final res = await client.get('/kirana/finance/udhaar/smart');
    final list = (res['udhaar'] as List? ?? const [])
        .cast<Map<String, dynamic>>();
    return list.map(SmartUdhaar.fromJson).toList();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_fetch);
  }
}

final smartUdhaarProvider =
    AsyncNotifierProvider<SmartUdhaarNotifier, List<SmartUdhaar>>(
      SmartUdhaarNotifier.new,
    );

/// Count of high-risk udhaar entries (for the udhaar-tab banner).
final highRiskUdhaarCountProvider = Provider<int>((ref) {
  return ref
      .watch(smartUdhaarProvider)
      .maybeWhen(
        data: (list) => list.where((u) => u.riskBand == 'high').length,
        orElse: () => 0,
      );
});
