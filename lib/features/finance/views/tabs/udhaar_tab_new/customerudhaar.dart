part of '../udhaar_tab_new.dart';

class _CustomerUdhaar {
  final int customerId;
  final String customerName;
  final String phone;
  final List<UdhaarItem> entries;

  _CustomerUdhaar({
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.entries,
  });

  /// Open (unsettled) debts, oldest-first — the order recovery is applied in.
  List<UdhaarItem> get openOldestFirst =>
      entries.where((e) => !e.isRecovered).toList()
        ..sort((a, b) => a.dateTaken.compareTo(b.dateTaken));

  /// All debts newest-first — the order they're listed in when expanded.
  List<UdhaarItem> get entriesNewestFirst =>
      List<UdhaarItem>.from(entries)
        ..sort((a, b) => b.dateTaken.compareTo(a.dateTaken));

  double get totalBalance => openOldestFirst.fold(0.0, (s, e) => s + e.balance);
  double get totalTaken => entries.fold(0.0, (s, e) => s + e.originalAmount);
  double get totalPaid => entries.fold(0.0, (s, e) => s + e.amountPaid);
  int get openCount => openOldestFirst.length;
  int get oldestDays => openOldestFirst.isEmpty
      ? 0
      : openOldestFirst
            .map((e) => e.daysPending)
            .reduce((a, b) => a > b ? a : b);
  bool get remindedToday => openOldestFirst.any((e) => e.remindedToday);
  bool get isSettled => openCount == 0;
  int? get oldestOpenKhataId =>
      openOldestFirst.isEmpty ? null : openOldestFirst.first.khataId;
}

