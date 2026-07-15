import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../models/store_model.dart';
import '../providers/store_settings_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/locale/locale_provider.dart';

class StoreSettingsScreen extends ConsumerStatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  ConsumerState<StoreSettingsScreen> createState() =>
      _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends ConsumerState<StoreSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _typeCtrl;
  late TextEditingController _footfallCtrl;
  late TextEditingController _budgetCtrl;
  late TextEditingController _dailyBudgetCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _regionCtrl;
  late TextEditingController _cityCtrl;

  // F1 — current vertical (switchable post-setup).
  String _verticalCode = 'grocery';
  static const _verticals = <String>[
    'grocery',
    'apparel',
    'footwear',
    'electronics',
    'optical',
    'services',
    'general',
  ];

  // V0.5 — store-level GST registration (drives the GST report row).
  bool _gstEnabled = false;

  bool _isSaving = false;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _typeCtrl = TextEditingController();
    _footfallCtrl = TextEditingController();
    _budgetCtrl = TextEditingController();
    _dailyBudgetCtrl = TextEditingController();
    _locationCtrl = TextEditingController();
    _regionCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
  }

  void _initFields(StoreProfile p) {
    if (_nameCtrl.text.isEmpty) {
      _nameCtrl.text = p.name;
      _typeCtrl.text = p.type;
      _footfallCtrl.text = p.footfall.toString();
      _budgetCtrl.text = p.budget.toStringAsFixed(0);
      _dailyBudgetCtrl.text = p.dailyBudget.toStringAsFixed(0);
      _locationCtrl.text = p.location ?? '';
      _regionCtrl.text = p.region ?? '';
      _cityCtrl.text = p.city ?? '';
      if (p.verticalCode != null && _verticals.contains(p.verticalCode)) {
        _verticalCode = p.verticalCode!;
      }
      _gstEnabled = p.gstEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProfile = ref.watch(storeSettingsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.profStoreSettings),
        actions: [
          if (!_isSaving)
            TextButton(
              onPressed: _save,
              child: Text(
                l10n.profSave,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: BrandColors.primary,
                ),
              ),
            ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: asyncProfile.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(24),
          child: ListShimmer(itemCount: 5, itemHeight: 60),
        ),
        error: (err, _) => Center(child: Text(l10n.profError(err.toString()))),
        data: (p) {
          _initFields(p);
          final bool isFootfallLocked = p.footfall > 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(l10n.profBasicInformation),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _nameCtrl,
                    l10n.profStoreName,
                    Icons.storefront_rounded,
                  ),
                  _buildTextField(
                    _typeCtrl,
                    l10n.profStoreType,
                    Icons.category_rounded,
                  ),
                  // F1 — switch the coarse vertical (changes which features show).
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField<String>(
                      initialValue: _verticalCode,
                      decoration: InputDecoration(
                        labelText: l10n.profBusinessVertical,
                        prefixIcon: const Icon(
                          Icons.dashboard_customize_rounded,
                          size: 20,
                          color: BrandColors.muted,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: BrandColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: BrandColors.border,
                          ),
                        ),
                      ),
                      items: _verticals
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(v[0].toUpperCase() + v.substring(1)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _verticalCode = v ?? 'grocery'),
                    ),
                  ),
                  // V0.5 — GST registration is a store fact, not a vertical
                  // trait: a registered kirana files GST too. Turning this on
                  // shows the GST report on the profile screen.
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BrandColors.border),
                    ),
                    child: SwitchListTile.adaptive(
                      value: _gstEnabled,
                      onChanged: (v) => setState(() => _gstEnabled = v),
                      title: Text(
                        l10n.profGstRegistered,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.profGstRegisteredHint,
                        style: const TextStyle(
                          fontSize: 12,
                          color: BrandColors.muted,
                        ),
                      ),
                      secondary: const Icon(
                        Icons.receipt_long_rounded,
                        size: 20,
                        color: BrandColors.muted,
                      ),
                      activeThumbColor: BrandColors.primary,
                    ),
                  ),

                  const SizedBox(height: 32),
                  _sectionHeader(l10n.profBusinessIntelligence),
                  const SizedBox(height: 8),
                  Text(
                    isFootfallLocked
                        ? l10n.profFootfallAutoComputed
                        : l10n.profProvideInitialValues,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _footfallCtrl,
                    l10n.profAvgDailyFootfall,
                    Icons.people_rounded,
                    keyboardType: TextInputType.number,
                    readOnly: isFootfallLocked,
                    helperText: isFootfallLocked
                        ? l10n.profAiAutoUpdating
                        : null,
                  ),
                  _buildTextField(
                    _budgetCtrl,
                    l10n.profMonthlyStockBudget,
                    Icons.account_balance_wallet_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _dailyBudgetCtrl,
                    l10n.profDailyExpenseBuffer,
                    Icons.payments_rounded,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 32),
                  _sectionHeader(l10n.profLocationDetails),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _locationCtrl,
                    l10n.profCityArea,
                    Icons.location_on_rounded,
                  ),
                  _buildTextField(
                    _cityCtrl,
                    l10n.profCity,
                    Icons.location_city_rounded,
                    optional: true,
                  ),
                  _buildTextField(
                    _regionCtrl,
                    l10n.profStateRegion,
                    Icons.map_rounded,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? helperText,
    bool optional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Icon(icon, size: 20, color: BrandColors.muted),
          filled: true,
          fillColor: readOnly ? BrandColors.surfaceTint : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: BrandColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: BrandColors.border),
          ),
        ),
        validator: optional
            ? null
            : (v) => (v == null || v.isEmpty) ? _l10n.profRequired : null,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final current = ref.read(storeSettingsProvider).value!;
      final updated = StoreProfile(
        storeId: current.storeId,
        name: _nameCtrl.text,
        type: _typeCtrl.text,
        footfall: int.tryParse(_footfallCtrl.text) ?? 0,
        budget: double.tryParse(_budgetCtrl.text) ?? 0.0,
        dailyBudget: double.tryParse(_dailyBudgetCtrl.text) ?? 0.0,
        location: _locationCtrl.text,
        region: _regionCtrl.text,
        city: _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
        verticalCode: _verticalCode,
        gstEnabled: _gstEnabled,
      );

      await ref.read(storeSettingsProvider.notifier).updateStore(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_l10n.profSettingsSaved),
            backgroundColor: BrandColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_l10n.profFailedToSave(e.toString())),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _typeCtrl.dispose();
    _footfallCtrl.dispose();
    _budgetCtrl.dispose();
    _dailyBudgetCtrl.dispose();
    _locationCtrl.dispose();
    _regionCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }
}
