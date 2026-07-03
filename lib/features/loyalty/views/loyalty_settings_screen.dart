import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/brand_theme.dart';
import '../models/loyalty_models.dart';
import '../providers/loyalty_provider.dart';
import 'coupon_manager_screen.dart';

class LoyaltySettingsScreen extends ConsumerStatefulWidget {
  const LoyaltySettingsScreen({super.key});

  @override
  ConsumerState<LoyaltySettingsScreen> createState() =>
      _LoyaltySettingsScreenState();
}

class _LoyaltySettingsScreenState extends ConsumerState<LoyaltySettingsScreen> {
  bool _active = false;
  final _earnCtrl = TextEditingController();
  final _redeemCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _earnCtrl.dispose();
    _redeemCtrl.dispose();
    _silverCtrl.dispose();
    _goldCtrl.dispose();
    super.dispose();
  }

  void _hydrate(LoyaltyConfig c) {
    if (_loaded) return;
    _active = c.isActive;
    _earnCtrl.text = c.pointsPer100.toStringAsFixed(
      c.pointsPer100 % 1 == 0 ? 0 : 2,
    );
    _redeemCtrl.text = (c.redeemPaisePerPoint / 100).toStringAsFixed(2);
    _silverCtrl.text = c.silverThreshold.toString();
    _goldCtrl.text = c.goldThreshold.toString();
    _loaded = true;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final cfg = LoyaltyConfig(
      isActive: _active,
      pointsPer100: double.tryParse(_earnCtrl.text.trim()) ?? 1,
      redeemPaisePerPoint:
          ((double.tryParse(_redeemCtrl.text.trim()) ?? 1) * 100).round(),
      silverThreshold: int.tryParse(_silverCtrl.text.trim()) ?? 500,
      goldThreshold: int.tryParse(_goldCtrl.text.trim()) ?? 2000,
    );
    try {
      await ref.read(loyaltyActionsProvider).saveConfig(cfg);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Loyalty settings saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncCfg = ref.watch(loyaltyConfigProvider);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: const Text('Loyalty & Offers')),
      body: asyncCfg.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (cfg) {
          _hydrate(cfg);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: BrandColors.border),
                ),
                child: SwitchListTile(
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                  title: const Text(
                    'Enable loyalty programme',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Customers earn points on every billed sale.',
                    style: TextStyle(fontSize: 12, color: BrandColors.muted),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _numField(
                _earnCtrl,
                'Points earned per ₹100 spent',
                helper: 'e.g. 1 → ₹500 bill earns 5 points',
              ),
              const SizedBox(height: 16),
              _numField(
                _redeemCtrl,
                'Value of 1 point (₹)',
                helper: 'e.g. 1 → 100 points = ₹100 off',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _numField(
                      _silverCtrl,
                      'Silver tier at (points)',
                      intOnly: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numField(
                      _goldCtrl,
                      'Gold tier at (points)',
                      intOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CouponManagerScreen(),
                  ),
                ),
                icon: const Icon(Icons.local_offer_outlined),
                label: const Text('Manage discount coupons'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  foregroundColor: BrandColors.primary,
                  side: const BorderSide(color: BrandColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
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
                      : const Text('Save settings'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _numField(
    TextEditingController c,
    String label, {
    String? helper,
    bool intOnly = false,
  }) => TextField(
    controller: c,
    keyboardType: intOnly
        ? TextInputType.number
        : const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(
        RegExp(intOnly ? r'^\d+' : r'^\d+\.?\d{0,2}'),
      ),
    ],
    decoration: InputDecoration(labelText: label, helperText: helper),
  );
}
