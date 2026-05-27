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
  final int? orderId;        // linked POS order, if created from POS
  final String customerName;
  final String phone;
  final double originalAmount; // total credit extended at time of sale
  final double amountPaid;     // how much has been recovered so far
  final double balance;        // originalAmount - amountPaid
  final String status;         // open | pending | settled | overdue | written_off
  final DateTime dateTaken;
  final int daysPending;
  final bool isRecovered;

  const UdhaarItem({
    required this.khataId,
    required this.customerId,
    this.orderId,
    required this.customerName,
    required this.phone,
    required this.originalAmount,
    required this.amountPaid,
    required this.balance,
    required this.status,
    required this.dateTaken,
    required this.daysPending,
    this.isRecovered = false,
  });

  factory UdhaarItem.fromJson(Map<String, dynamic> j) {
    final bal = (j['balance'] as num?)?.toDouble() ?? 0.0;
    final status = j['status'] as String? ?? 'open';
    return UdhaarItem(
      khataId: j['khata_id'] as int,
      customerId: j['customer_id'] as int,
      orderId: j['order_id'] as int?,
      customerName: j['customer_name'] as String? ?? 'Unknown',
      phone: j['phone'] as String? ?? '',
      originalAmount: (j['original_amount'] as num?)?.toDouble() ?? bal,
      amountPaid: (j['amount_paid'] as num?)?.toDouble() ?? 0.0,
      balance: bal,
      status: status,
      dateTaken: parseAsUtc(j['date_taken'] as String?),
      daysPending: (j['days_pending'] as num?)?.toInt() ?? 0,
      isRecovered: status == 'settled' || bal <= 0,
    );
  }
}
