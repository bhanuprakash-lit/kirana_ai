import 'package:kirana_ai/core/utils/date_utils.dart';

class FinanceStats {
  final double monthlySalesAmount;
  final int monthlySkuCount;
  final double totalUdhaarPending;
  final double totalUdhaarRecovered;
  final int udhaarCustomerCount;

  const FinanceStats({
    required this.monthlySalesAmount,
    required this.monthlySkuCount,
    required this.totalUdhaarPending,
    required this.totalUdhaarRecovered,
    required this.udhaarCustomerCount,
  });

  factory FinanceStats.fromJson(Map<String, dynamic> j) => FinanceStats(
    monthlySalesAmount:
        (j['monthly_sales']?['amount'] as num?)?.toDouble() ?? 0.0,
    monthlySkuCount: (j['monthly_sales']?['sku_count'] as num?)?.toInt() ?? 0,
    totalUdhaarPending:
        (j['udhaar_stats']?['total_pending'] as num?)?.toDouble() ?? 0.0,
    totalUdhaarRecovered:
        (j['udhaar_stats']?['total_recovered'] as num?)?.toDouble() ?? 0.0,
    udhaarCustomerCount:
        (j['udhaar_stats']?['customer_count'] as num?)?.toInt() ?? 0,
  );
}

class UdhaarItem {
  final int khataId;
  final int customerId;
  final String customerName;
  final String phone;
  final double balance;
  final DateTime dateTaken;
  final int daysPending;
  final bool isRecovered;

  const UdhaarItem({
    required this.khataId,
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.balance,
    required this.dateTaken,
    required this.daysPending,
    this.isRecovered = false,
  });

  factory UdhaarItem.fromJson(Map<String, dynamic> j) => UdhaarItem(
    khataId: j['khata_id'] as int,
    customerId: j['customer_id'] as int,
    customerName: j['customer_name'] as String? ?? 'Unknown',
    phone: j['phone'] as String? ?? '',
    balance: (j['balance'] as num?)?.toDouble() ?? 0.0,
    dateTaken: parseAsUtc(j['date_taken'] as String?),
    daysPending: (j['days_pending'] as num?)?.toInt() ?? 0,
    isRecovered: ((j['balance'] as num?) ?? 0) <= 0,
  );
}
