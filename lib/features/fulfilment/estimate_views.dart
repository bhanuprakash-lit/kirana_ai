import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/core/vertical/nav_preset.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/api_client.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../dashboard/views/dashboard_screen.dart';
import '../pos_inventory/providers/pos_provider.dart';
import '../profile/models/customer_model.dart';
import '../../shared/widgets/customer_picker.dart';
import '../../shared/widgets/product_picker.dart';
import 'fulfilment.dart' show estimatesProvider;

/// An estimate line being edited. [productId] is set when picked from the
/// catalog (so Convert-to-sale can add it to the cart); free-typed lines keep
/// productId null.
class _Line {
  int? productId;
  final TextEditingController name;
  final TextEditingController qty;
  final TextEditingController price;
  _Line({String name = '', String qty = '1', String price = ''})
    : name = TextEditingController(text: name),
      qty = TextEditingController(text: qty),
      price = TextEditingController(text: price);
  void dispose() {
    name.dispose();
    qty.dispose();
    price.dispose();
  }

  double get lineTotal =>
      (double.tryParse(qty.text.trim()) ?? 0) *
      (double.tryParse(price.text.trim()) ?? 0);
}

/// Create a new estimate: pick a customer, add catalog/free-text lines, set an
/// optional validity date. Returns true if saved.
Future<bool?> showEstimateEditor(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _EstimateEditor(),
  );
}

class _EstimateEditor extends ConsumerStatefulWidget {
  const _EstimateEditor();
  @override
  ConsumerState<_EstimateEditor> createState() => _EstimateEditorState();
}

class _EstimateEditorState extends ConsumerState<_EstimateEditor> {
  final List<_Line> _lines = [_Line()];
  Customer? _customer;
  DateTime? _validUntil;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  double get _total => _lines.fold(0, (s, l) => s + l.lineTotal);

  Future<void> _pickProductFor(_Line line) async {
    final p = await showProductPicker(context, ref);
    if (p == null) return;
    setState(() {
      line.productId = p.productId;
      line.name.text = p.displayName;
      if (line.price.text.trim().isEmpty) {
        line.price.text = p.price.toStringAsFixed(
          p.price.truncateToDouble() == p.price ? 0 : 2,
        );
      }
    });
  }

  Future<void> _save() async {
    final items = _lines
        .where(
          (l) =>
              l.name.text.trim().isNotEmpty &&
              (double.tryParse(l.qty.text.trim()) ?? 0) > 0,
        )
        .map(
          (l) => {
            if (l.productId != null) 'product_id': l.productId,
            'name': l.name.text.trim(),
            'quantity': double.tryParse(l.qty.text.trim()) ?? 1,
            'unit_price': double.tryParse(l.price.text.trim()) ?? 0,
          },
        )
        .toList();
    if (items.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).estAddOneItem);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(apiClientProvider).post('/kirana/estimates', {
        if (_customer != null) ...{
          'customer_id': _customer!.customerId,
          'customer_name': _customer!.name,
        },
        if (_validUntil != null)
          'valid_until':
              '${_validUntil!.year.toString().padLeft(4, '0')}-${_validUntil!.month.toString().padLeft(2, '0')}-${_validUntil!.day.toString().padLeft(2, '0')}',
        'items': items,
      });
      ref.invalidate(estimatesProvider);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _saving = false;
        _error = AppLocalizations.of(context).estSaveFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(
            color: BrandColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Text(
                      l10n.estNewEstimate,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${_total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: BrandColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: sc,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    // Customer
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final c = await showCustomerPicker(context, ref);
                        if (c != null) setState(() => _customer = c);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.estCustomerOptional,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                        ),
                        child: Text(
                          _customer?.name ?? l10n.estSelectCustomer,
                          style: TextStyle(
                            color: _customer == null
                                ? BrandColors.muted
                                : BrandColors.ink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (int i = 0; i < _lines.length; i++)
                      _lineCard(_lines[i], i),
                    const SizedBox(height: 4),
                    TextButton.icon(
                      onPressed: () => setState(() => _lines.add(_Line())),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text(l10n.estAddItem),
                    ),
                    const SizedBox(height: 8),
                    // Validity
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate:
                              _validUntil ??
                              DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (d != null) setState(() => _validUntil = d);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.estValidUntil,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.event_rounded),
                        ),
                        child: Text(
                          _validUntil == null
                              ? l10n.estNoExpiry
                              : '${_validUntil!.day}/${_validUntil!.month}/${_validUntil!.year}',
                          style: TextStyle(
                            color: _validUntil == null
                                ? BrandColors.muted
                                : BrandColors.ink,
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: BrandColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.estSaveEstimate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lineCard(_Line line, int i) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: line.name,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l10n.estItemName,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.estPickFromCatalog,
                icon: const Icon(Icons.search_rounded, size: 20),
                onPressed: () => _pickProductFor(line),
              ),
              if (_lines.length > 1)
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: BrandColors.muted,
                  ),
                  onPressed: () => setState(() {
                    line.dispose();
                    _lines.removeAt(i);
                  }),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: line.qty,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l10n.estQty,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: line.price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l10n.estUnitPrice,
                    prefixText: '₹ ',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Detail ────────────────────────────────────────────────────────────────

/// Estimate detail: items + status transitions + convert-to-sale + share.
Future<void> showEstimateDetail(
  BuildContext context,
  WidgetRef ref,
  int estimateId,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EstimateDetail(estimateId: estimateId),
  );
}

class _EstimateDetail extends ConsumerStatefulWidget {
  final int estimateId;
  const _EstimateDetail({required this.estimateId});
  @override
  ConsumerState<_EstimateDetail> createState() => _EstimateDetailState();
}

class _EstimateDetailState extends ConsumerState<_EstimateDetail> {
  Map<String, dynamic>? _est;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await ref
        .read(apiClientProvider)
        .get('/kirana/estimates/${widget.estimateId}');
    if (mounted && d is Map) {
      setState(() => _est = d.cast<String, dynamic>());
    }
  }

  Future<void> _setStatus(String status) async {
    setState(() => _busy = true);
    try {
      await ref.read(apiClientProvider).patch(
        '/kirana/estimates/${widget.estimateId}',
        {'status': status},
      );
      ref.invalidate(estimatesProvider);
      await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Convert to sale: prefill the POS cart from the estimate's catalog lines,
  /// mark it accepted, and jump to the billing tab to complete the sale.
  Future<void> _convert() async {
    final l10n = AppLocalizations.of(context);
    final items = (_est?['items'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .toList();
    final products = ref.read(posProvider).products;
    int added = 0;
    int skipped = 0;
    final pos = ref.read(posProvider.notifier);
    for (final it in items) {
      final pid = (it['product_id'] as num?)?.toInt();
      final product = pid == null
          ? null
          : products.where((p) => p.productId == pid).firstOrNull;
      if (product == null) {
        skipped++;
        continue;
      }
      pos.addToCart(
        product,
        qty: (it['quantity'] as num?)?.toDouble() ?? 1,
        unitPriceOverride: (it['unit_price'] as num?)?.toDouble(),
      );
      added++;
    }
    await _setStatus('accepted');
    if (!mounted) return;
    // Land on the POS billing tab with the cart populated.
    switchToNavTab(ref, NavTabId.billing);
    ref.read(dashboardSubTabProvider.notifier).setSubTab(0);
    Navigator.of(context)
      ..pop() // detail sheet
      ..maybePop(); // fulfilment screen (return to dashboard)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          skipped == 0
              ? '$added ${l10n.estAddedToBill}'
              : '$added ${l10n.estAddedToBill} · $skipped ${l10n.estSkippedNotInCatalog}',
        ),
        backgroundColor: BrandColors.success,
      ),
    );
  }

  Future<void> _share() async {
    final est = _est;
    if (est == null) return;
    final l10n = AppLocalizations.of(context);
    final items = (est['items'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .toList();
    final lines = items
        .map(
          (i) =>
              '• ${i['name']}  x${_trim(i['quantity'])}  ₹${_trim(i['unit_price'])}',
        )
        .join('\n');
    final total = (est['total'] as num?)?.toStringAsFixed(0) ?? '0';
    final msg =
        '${l10n.estShareHeading}\n$lines\n\n${l10n.estShareTotal}: ₹$total';
    final phone = (est['customer_phone'] ?? '').toString().replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    final url = Uri.parse(
      phone.isNotEmpty
          ? 'https://wa.me/$phone?text=${Uri.encodeComponent(msg)}'
          : 'https://wa.me/?text=${Uri.encodeComponent(msg)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static String _trim(Object? q) {
    final v = (q as num?)?.toDouble() ?? 0;
    return v.truncateToDouble() == v ? '${v.toInt()}' : '$v';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final est = _est;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(
            color: BrandColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: est == null
              ? const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: BrandColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: sc,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  est['customer_name']?.toString() ??
                                      l10n.estWalkIn,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Text(
                                '#${est['estimate_id']}',
                                style: const TextStyle(
                                  color: BrandColors.muted,
                                ),
                              ),
                            ],
                          ),
                          if (est['valid_until'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '${l10n.estValidUntil}: ${est['valid_until']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: BrandColors.muted,
                                ),
                              ),
                            ),
                          const SizedBox(height: 14),
                          for (final i
                              in (est['items'] as List<dynamic>? ?? const [])
                                  .whereType<Map>())
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${i['name']}  ·  x${_trim(i['quantity'])}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${_trim((((i['quantity'] as num?) ?? 0) * ((i['unit_price'] as num?) ?? 0)))}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.estTotal,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '₹${(est['total'] as num?)?.toStringAsFixed(0) ?? "0"}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: BrandColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.estStatus,
                            style: const TextStyle(
                              fontSize: 12,
                              color: BrandColors.muted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: ['draft', 'sent', 'accepted', 'rejected']
                                .map(
                                  (s) => ChoiceChip(
                                    label: Text(
                                      _statusLabel(l10n, s),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    selected: est['status'] == s,
                                    onSelected: _busy
                                        ? null
                                        : (_) => _setStatus(s),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        MediaQuery.of(context).viewInsets.bottom + 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _share,
                              icon: const Icon(Icons.share_rounded, size: 18),
                              label: Text(l10n.estShare),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _busy ? null : _convert,
                              icon: const Icon(
                                Icons.point_of_sale_rounded,
                                size: 18,
                              ),
                              label: Text(l10n.estConvert),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, String s) => switch (s) {
    'draft' => l10n.estStatusDraft,
    'sent' => l10n.estStatusSent,
    'accepted' => l10n.estStatusAccepted,
    'rejected' => l10n.estStatusRejected,
    _ => s,
  };
}
