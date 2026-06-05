import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/pos_provider.dart';
import 'order_details_screen.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  List<Map<String, dynamic>>? _orders;
  bool _loading = true;

  // Filters
  String? _status;
  String? _paymentMethod;
  DateTime? _startDate;
  DateTime? _endDate;
  double? _minAmount;
  double? _maxAmount;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final orders = await ref
        .read(posProvider.notifier)
        .fetchAllOrders(
          limit: 100,
          status: _status,
          paymentMethod: _paymentMethod,
          startDate: _startDate,
          endDate: _endDate,
          minAmount: _minAmount,
          maxAmount: _maxAmount,
        );
    if (mounted) {
      setState(() {
        _orders = orders;
        _loading = false;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      _status = null;
      _paymentMethod = null;
      _startDate = null;
      _endDate = null;
      _minAmount = null;
      _maxAmount = null;
    });
    _load();
  }

  // String _fmt(double v) => '₹${v.toStringAsFixed(2)}';

  String _formatDate(String dateStr) {
    try {
      // Backend sends UTC without 'Z' — must append it before parsing.
      var s = dateStr;
      if (s.isNotEmpty && !s.endsWith('Z') && !s.contains('+')) s += 'Z';
      final dt = DateTime.parse(s).toLocal();
      return DateFormat('dd MMM, hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.posTransactionHistory,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color:
                  (_status != null ||
                      _paymentMethod != null ||
                      _startDate != null ||
                      _endDate != null)
                  ? BrandColors.primary
                  : BrandColors.ink,
            ),
            onPressed: _showFilterSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (_status != null || _paymentMethod != null || _startDate != null)
            _ActiveFiltersBar(
              status: _status,
              payment: _paymentMethod,
              date: _startDate,
              onClear: _resetFilters,
            ),
          Expanded(
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: ListShimmer(itemCount: 8),
                  )
                : _orders == null || _orders!.isEmpty
                ? _EmptyHistory(onReset: _resetFilters)
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _orders!.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final o = _orders![i];
                        final amount =
                            (o['total_amount'] as num?)?.toDouble() ?? 0;
                        final date = o['order_date'] as String? ?? '';
                        final payment =
                            o['payment_method'] as String? ?? 'Cash';
                        final status =
                            o['order_status'] as String? ?? 'completed';

                        return _OrderTile(
                          orderId: o['order_id'].toString(),
                          amount: amount,
                          dateStr: _formatDate(date),
                          payment: payment,
                          status: status,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OrderDetailsScreen(order: o),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        currentStatus: _status,
        currentPayment: _paymentMethod,
        startDate: _startDate,
        endDate: _endDate,
        onApply: (status, payment, start, end) {
          setState(() {
            _status = status;
            _paymentMethod = payment;
            _startDate = start;
            _endDate = end;
          });
          _load();
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final String orderId;
  final double amount;
  final String dateStr;
  final String payment;
  final String status;
  final VoidCallback onTap;

  const _OrderTile({
    required this.orderId,
    required this.amount,
    required this.dateStr,
    required this.payment,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = status.toLowerCase() == 'completed'
        ? BrandColors.success
        : BrandColors.warning;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: BrandColors.border.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_rounded, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.posOrderNumber(orderId),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dateStr · ${payment.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: BrandColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveFiltersBar extends StatelessWidget {
  final String? status;
  final String? payment;
  final DateTime? date;
  final VoidCallback onClear;

  const _ActiveFiltersBar({
    this.status,
    this.payment,
    this.date,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            l10n.posFilters,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: BrandColors.muted,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (status != null) _FilterChip(label: status!.toUpperCase()),
                  if (payment != null)
                    _FilterChip(label: payment!.toUpperCase()),
                  if (date != null)
                    _FilterChip(label: DateFormat('dd MMM').format(date!)),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            child: Text(
              l10n.posClearAllFilters,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: BrandColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: BrandColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final VoidCallback onReset;
  const _EmptyHistory({required this.onReset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_rounded, size: 64, color: BrandColors.muted),
          const SizedBox(height: 20),
          Text(
            l10n.posNoTransactions,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.posTryAdjustFilters,
            style: const TextStyle(color: BrandColors.muted),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: BrandColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.posResetFilters),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final String? currentStatus;
  final String? currentPayment;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(String?, String?, DateTime?, DateTime?) onApply;

  const _FilterSheet({
    this.currentStatus,
    this.currentPayment,
    this.startDate,
    this.endDate,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _status;
  String? _payment;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _status = widget.currentStatus;
    _payment = widget.currentPayment;
    _start = widget.startDate;
    _end = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.posFilterTransactions,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 24),

          Text(
            l10n.posPaymentStatus,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ChoiceChip(
                label: l10n.posFilterAll,
                selected: _status == null,
                onSelected: (_) => setState(() => _status = null),
              ),
              const SizedBox(width: 8),
              _ChoiceChip(
                label: l10n.posStatusCompleted,
                selected: _status == 'completed',
                onSelected: (_) => setState(() => _status = 'completed'),
              ),
              const SizedBox(width: 8),
              _ChoiceChip(
                label: l10n.posStatusPending,
                selected: _status == 'pending',
                onSelected: (_) => setState(() => _status = 'pending'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text(
            l10n.posPaymentMethod,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ChoiceChip(
                  label: l10n.posFilterAll,
                  selected: _payment == null,
                  onSelected: (_) => setState(() => _payment = null),
                ),
                const SizedBox(width: 8),
                _ChoiceChip(
                  label: l10n.posPayCash,
                  selected: _payment == 'cash',
                  onSelected: (_) => setState(() => _payment = 'cash'),
                ),
                const SizedBox(width: 8),
                _ChoiceChip(
                  label: l10n.posPayUpi,
                  selected: _payment == 'upi',
                  onSelected: (_) => setState(() => _payment = 'upi'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            l10n.posDateRange,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDateRange,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: BrandColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: BrandColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _start == null
                        ? l10n.posSelectDateRange
                        : '${DateFormat('dd MMM').format(_start!)} - ${DateFormat('dd MMM').format(_end!)}',
                    style: TextStyle(
                      color: _start == null
                          ? BrandColors.muted
                          : BrandColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_status, _payment, _start, _end);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.posApplyFilters,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: _start != null
          ? DateTimeRange(start: _start!, end: _end!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: BrandColors.primary,
              onPrimary: Colors.white,
              onSurface: BrandColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _start = picked.start;
        _end = picked.end.add(
          const Duration(hours: 23, minutes: 59, seconds: 59),
        );
      });
    }
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: BrandColors.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : BrandColors.ink,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      backgroundColor: BrandColors.surfaceTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      showCheckmark: false,
    );
  }
}
