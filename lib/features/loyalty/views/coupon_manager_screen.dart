import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/loyalty_provider.dart';

class CouponManagerScreen extends ConsumerWidget {
  const CouponManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(couponsProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: const Text('Discount Coupons')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New coupon'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (coupons) {
          if (coupons.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No coupons yet. Create one to offer discounts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BrandColors.muted)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: coupons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final c = coupons[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: BrandColors.border),
                ),
                child: ListTile(
                  title: Text(c.code,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(
                    '${c.discountType == "percent" ? "${c.value.toStringAsFixed(0)}% off" : "₹${c.value.toStringAsFixed(0)} off"}'
                    '${c.minOrder > 0 ? " · min ₹${c.minOrder.toStringAsFixed(0)}" : ""}'
                    '${c.usageLimit != null ? " · used ${c.usedCount}/${c.usageLimit}" : " · used ${c.usedCount}"}',
                    style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                  ),
                  trailing: Switch(
                    value: c.isActive,
                    onChanged: (v) =>
                        ref.read(loyaltyActionsProvider).toggleCoupon(c.couponId, v),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openEditor(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CouponEditor(),
    );
  }
}

class _CouponEditor extends ConsumerStatefulWidget {
  const _CouponEditor();

  @override
  ConsumerState<_CouponEditor> createState() => _CouponEditorState();
}

class _CouponEditorState extends ConsumerState<_CouponEditor> {
  final _codeCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();
  final _limitCtrl = TextEditingController();
  String _type = 'percent';
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _valueCtrl.dispose();
    _minCtrl.dispose();
    _maxCtrl.dispose();
    _limitCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final code = _codeCtrl.text.trim();
    final value = double.tryParse(_valueCtrl.text.trim());
    if (code.isEmpty || value == null || value <= 0) {
      setState(() => _error = 'Enter a code and a positive value');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(loyaltyActionsProvider).createCoupon({
        'code': code,
        'discount_type': _type,
        'value': value,
        'min_order': double.tryParse(_minCtrl.text.trim()) ?? 0,
        if (_maxCtrl.text.trim().isNotEmpty)
          'max_discount': double.tryParse(_maxCtrl.text.trim()),
        if (_limitCtrl.text.trim().isNotEmpty)
          'usage_limit': int.tryParse(_limitCtrl.text.trim()),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New coupon',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          TextField(
            controller: _codeCtrl,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(labelText: 'Coupon code (e.g. SAVE10)'),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'percent', label: Text('% off')),
              ButtonSegment(value: 'flat', label: Text('₹ off')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _num(_valueCtrl, _type == 'percent' ? 'Percent' : 'Amount ₹'),
              ),
              const SizedBox(width: 12),
              Expanded(child: _num(_minCtrl, 'Min order ₹')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (_type == 'percent')
                Expanded(child: _num(_maxCtrl, 'Max discount ₹')),
              if (_type == 'percent') const SizedBox(width: 12),
              Expanded(child: _num(_limitCtrl, 'Usage limit', intOnly: true)),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: BrandColors.error)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Create coupon'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _num(TextEditingController c, String label, {bool intOnly = false}) =>
      TextField(
        controller: c,
        keyboardType: intOnly
            ? TextInputType.number
            : const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(intOnly ? r'^\d+' : r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(labelText: label),
      );
}
