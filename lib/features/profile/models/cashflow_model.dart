class CashflowStatus {
  final bool hasRequest;
  final int? requestId;
  final String? status;
  final double? amount;
  final String? selectedBank;
  final String? createdAt;

  const CashflowStatus({
    required this.hasRequest,
    this.requestId,
    this.status,
    this.amount,
    this.selectedBank,
    this.createdAt,
  });

  factory CashflowStatus.fromJson(Map<String, dynamic> json) => CashflowStatus(
        hasRequest: json['has_request'] as bool? ?? false,
        requestId: json['request_id'] as int?,
        status: json['status'] as String?,
        amount: (json['amount'] as num?)?.toDouble(),
        selectedBank: json['selected_bank'] as String?,
        createdAt: json['created_at'] as String?,
      );

  static const empty = CashflowStatus(hasRequest: false);
}
