import 'package:kirana_ai/core/utils/date_utils.dart';

class FinanceStats {
  final double monthlySalesAmount;
  final int monthlySkuCount;
  // Credit *given this month* — the correct numerator for the credit-vs-sales
  // ratio (NOT all-time outstanding, which the ratio used to misuse).
  final double monthlyCreditAmount;
  final double totalUdhaarPending;
  final double totalUdhaarRecovered;
  final int udhaarCustomerCount;

  const FinanceStats({
    required this.monthlySalesAmount,
    required this.monthlySkuCount,
    required this.monthlyCreditAmount,
    required this.totalUdhaarPending,
    required this.totalUdhaarRecovered,
    required this.udhaarCustomerCount,
  });

  factory FinanceStats.fromJson(Map<String, dynamic> j) => FinanceStats(
    monthlySalesAmount:
        (j['monthly_sales']?['amount'] as num?)?.toDouble() ?? 0.0,
    monthlySkuCount: (j['monthly_sales']?['sku_count'] as num?)?.toInt() ?? 0,
    monthlyCreditAmount:
        (j['monthly_sales']?['credit_amount'] as num?)?.toDouble() ?? 0.0,
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
  final int? orderId; // linked POS order, if created from POS
  final String customerName;
  final String phone;
  final double originalAmount; // total credit extended at time of sale
  final double amountPaid; // how much has been recovered so far
  final double balance; // originalAmount - amountPaid
  final String status; // open | pending | settled | overdue | written_off
  final DateTime dateTaken;
  // When the customer is expected to repay. Backend now stores this; older
  // pending rows are backfilled to 30 Jun 2026.
  final DateTime? dueDate;
  final int daysPending;
  final bool isRecovered;

  /// Server-tracked: this customer already got a WhatsApp reminder today.
  /// Used to disable the Remind button (one reminder per customer per day).
  final bool remindedToday;

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
    this.dueDate,
    required this.daysPending,
    this.isRecovered = false,
    this.remindedToday = false,
  });

  /// The repayment date to show. Falls back to 30 Jun 2026 for unsettled rows
  /// that predate the due-date feature and have no stored date.
  DateTime? get effectiveDueDate {
    if (dueDate != null) return dueDate;
    final settled = status == 'settled' || balance <= 0;
    return settled ? null : DateTime(2026, 6, 30);
  }

  factory UdhaarItem.fromJson(Map<String, dynamic> j) {
    final bal = (j['balance'] as num?)?.toDouble() ?? 0.0;
    final status = j['status'] as String? ?? 'open';
    final dueRaw = j['due_date'] as String?;
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
      dueDate: (dueRaw != null && dueRaw.isNotEmpty)
          ? parseAsUtc(dueRaw)
          : null,
      daysPending: (j['days_pending'] as num?)?.toInt() ?? 0,
      isRecovered: status == 'settled' || bal <= 0,
      remindedToday: j['reminded_today'] as bool? ?? false,
    );
  }
}
