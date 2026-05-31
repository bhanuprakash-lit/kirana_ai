import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../shared/widgets/action_widgets.dart';
import '../providers/near_expiry_provider.dart';

/// Expiry Loss Prevention — lists near-expiry batches and lets the owner clear
/// them with a markdown or write off spoiled units.
class NearExpiryScreen extends ConsumerWidget {
  const NearExpiryScreen({super.key});

  static const _windows = [3, 7, 14, 30];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(nearExpiryProvider);
    final notifier = ref.read(nearExpiryProvider.notifier);
    final activeDays = notifier.days;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Expiring Soon',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          // Window selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Text(
                  'Next',
                  style: TextStyle(color: BrandColors.muted, fontSize: 13),
                ),
                const SizedBox(width: 8),
                ..._windows.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$d days'),
                      selected: activeDays == d,
                      onSelected: (_) => notifier.setWindow(d),
                      selectedColor: BrandColors.primary.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: activeDays == d
                            ? BrandColors.primary
                            : BrandColors.muted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorState(
                onRetry: () => notifier.refresh(),
              ),
              data: (batches) => batches.isEmpty
                  ? const _EmptyState()
                  : RefreshIndicator(
                      onRefresh: () => notifier.refresh(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: batches.length,
                        itemBuilder: (_, i) => _BatchCard(batch: batches[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Urgency helpers ─────────────────────────────────────────────────────────

Color _urgencyColor(int daysLeft) {
  if (daysLeft < 0) return BrandColors.error;
  if (daysLeft <= 2) return BrandColors.error;
  if (daysLeft <= 5) return const Color(0xFFE87722); // orange
  return const Color(0xFFD97706); // amber
}

String _urgencyLabel(int daysLeft) {
  if (daysLeft < 0) return 'Expired';
  if (daysLeft == 0) return 'Expires today';
  if (daysLeft == 1) return 'Expires tomorrow';
  return 'Expires in $daysLeft days';
}

// ── Batch card ────────────────────────────────────────────────────────────────

class _BatchCard extends ConsumerWidget {
  final NearExpiryBatch batch;
  const _BatchCard({required this.batch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _urgencyColor(batch.daysLeft);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batch.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: BrandColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${batch.qtyInStock} ${batch.unit ?? 'units'} in stock'
                        '${batch.batchNo != null ? ' · ${batch.batchNo}' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _urgencyLabel(batch.daysLeft),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _stat(
                  'At risk',
                  '₹${batch.valueAtRisk.toStringAsFixed(0)}',
                  BrandColors.error,
                ),
                const SizedBox(width: 16),
                if (batch.hasMarkdown)
                  _stat(
                    'Marked down',
                    '₹${batch.markedDownPrice.toStringAsFixed(0)}  (-${batch.markdownPct.toStringAsFixed(0)}%)',
                    BrandColors.success,
                  )
                else
                  _stat(
                    'Price',
                    '₹${batch.price.toStringAsFixed(0)}',
                    BrandColors.ink,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openMarkdownSheet(context, ref, batch),
                    icon: const Icon(Icons.sell_outlined, size: 16),
                    label: Text(
                      batch.hasMarkdown ? 'Change markdown' : 'Mark down',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BrandColors.primary,
                      side: const BorderSide(color: BrandColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openWasteSheet(context, ref, batch),
                    icon: const Icon(Icons.delete_sweep_outlined, size: 16),
                    label: const Text(
                      'Record waste',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: BrandColors.error,
                      side: BorderSide(color: BrandColors.error.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: BrandColors.muted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Markdown sheet ────────────────────────────────────────────────────────────

Future<void> _openMarkdownSheet(
  BuildContext context,
  WidgetRef ref,
  NearExpiryBatch batch,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _MarkdownSheet(batch: batch),
  );
}

class _MarkdownSheet extends ConsumerStatefulWidget {
  final NearExpiryBatch batch;
  const _MarkdownSheet({required this.batch});

  @override
  ConsumerState<_MarkdownSheet> createState() => _MarkdownSheetState();
}

class _MarkdownSheetState extends ConsumerState<_MarkdownSheet> {
  late double _pct;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _pct = widget.batch.markdownPct > 0
        ? widget.batch.markdownPct
        : widget.batch.suggestedMarkdownPct;
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.batch.price;
    final newPrice = price * (1 - _pct / 100);
    final options = <double>{
      widget.batch.suggestedMarkdownPct,
      10,
      25,
      40,
    }.where((v) => v > 0).toList()
      ..sort();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mark down ${widget.batch.productName}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Clearance discount to sell before expiry',
            style: const TextStyle(fontSize: 13, color: BrandColors.muted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final v in options)
                ChoiceChip(
                  label: Text(
                    v == widget.batch.suggestedMarkdownPct
                        ? '${v.toStringAsFixed(0)}% (suggested)'
                        : '${v.toStringAsFixed(0)}%',
                  ),
                  selected: (_pct - v).abs() < 0.01,
                  onSelected: (_) => setState(() => _pct = v),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Custom', style: TextStyle(color: BrandColors.muted)),
              Expanded(
                child: Slider(
                  value: _pct.clamp(0, 90),
                  max: 90,
                  divisions: 18,
                  label: '${_pct.toStringAsFixed(0)}%',
                  onChanged: (v) => setState(() => _pct = v.roundToDouble()),
                ),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  '${_pct.toStringAsFixed(0)}%',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BrandColors.surfaceTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: BrandColors.muted,
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, size: 16),
                Text(
                  '₹${newPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: BrandColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: LoadingButton(
              label: 'Apply markdown',
              isLoading: _saving,
              onPressed: _saving ? null : _apply,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _apply() async {
    setState(() => _saving = true);
    final ok = await ref
        .read(nearExpiryProvider.notifier)
        .applyMarkdown(widget.batch.batchId, _pct);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Markdown applied' : 'Could not apply markdown'),
        backgroundColor: ok ? BrandColors.success : BrandColors.error,
      ),
    );
  }
}

// ── Waste sheet ───────────────────────────────────────────────────────────────

Future<void> _openWasteSheet(
  BuildContext context,
  WidgetRef ref,
  NearExpiryBatch batch,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _WasteSheet(batch: batch),
  );
}

class _WasteSheet extends ConsumerStatefulWidget {
  final NearExpiryBatch batch;
  const _WasteSheet({required this.batch});

  @override
  ConsumerState<_WasteSheet> createState() => _WasteSheetState();
}

class _WasteSheetState extends ConsumerState<_WasteSheet> {
  late int _units;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _units = widget.batch.qtyInStock;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write off ${widget.batch.productName}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            'Removes spoiled units from stock and records the loss.',
            style: TextStyle(fontSize: 13, color: BrandColors.muted),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepBtn(Icons.remove, () {
                if (_units > 1) setState(() => _units--);
              }),
              SizedBox(
                width: 80,
                child: Text(
                  '$_units',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _stepBtn(Icons.add, () {
                if (_units < widget.batch.qtyInStock) setState(() => _units++);
              }),
            ],
          ),
          Center(
            child: Text(
              'of ${widget.batch.qtyInStock} in stock',
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: LoadingButton(
              label: 'Record waste',
              isLoading: _saving,
              onPressed: _saving ? null : _apply,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(backgroundColor: BrandColors.surfaceTint),
    );
  }

  Future<void> _apply() async {
    setState(() => _saving = true);
    final ok = await ref
        .read(nearExpiryProvider.notifier)
        .recordWaste(widget.batch.batchId, _units);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? '$_units units written off' : 'Could not record waste'),
        backgroundColor: ok ? BrandColors.ink : BrandColors.error,
      ),
    );
  }
}

// ── Empty / error states ────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 120),
        Icon(Icons.check_circle_outline_rounded, size: 64, color: BrandColors.success),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Nothing expiring soon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(height: 6),
        Center(
          child: Text(
            'Perishable batches nearing expiry will show up here.',
            style: TextStyle(color: BrandColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: BrandColors.error),
          const SizedBox(height: 12),
          const Text('Could not load expiry data'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
