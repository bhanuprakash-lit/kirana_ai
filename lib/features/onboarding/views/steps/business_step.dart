import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/brand_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../providers/onboarding_provider.dart';

/// Stable store-type codes (sent to the backend) paired with their localized
/// label, resolved at build time. The stored value is always the code, so
/// translating the label can never break the backend mapping.
/// PAI-2 — "General Store", "Provision Store" and "Fruits & Vegetables" were
/// removed: the first duplicated "Kirana / General Stores" and the others are
/// the same grocery behaviour under different names, which only made the list
/// harder to pick from. "Others" stays, so an unlisted trade still has a home.
List<({String code, String label})> _businessTypes(AppLocalizations l10n) => [
  (code: 'kirana', label: l10n.businessTypeKirana),
  (code: 'supermarket', label: l10n.businessTypeSupermarket),
  (code: 'mini_supermarket', label: l10n.businessTypeMiniSupermarket),
  (code: 'bakery', label: l10n.businessTypeBakery),
  (code: 'apparel', label: l10n.businessTypeApparel),
  (code: 'boutique', label: l10n.businessTypeBoutique),
  (code: 'footwear', label: l10n.businessTypeFootwear),
  (code: 'sports_fitness', label: l10n.businessTypeSportsFitness),
  (code: 'cosmetics', label: l10n.businessTypeCosmetics),
  (code: 'mono_brand', label: l10n.businessTypeMonoBrand),
  (code: 'electronics', label: l10n.businessTypeElectronics),
  (code: 'optical', label: l10n.businessTypeOptical),
  (code: 'salon', label: l10n.businessTypeSalon),
  (code: 'stationery', label: l10n.businessTypeStationery),
  (code: 'fancy_gift', label: l10n.businessTypeFancyGift),
  (code: 'other', label: l10n.businessTypeOthers),
];

/// PAI-3 — a mono-brand outlet can sell clothing, phones or cosmetics, so one
/// fixed vertical is wrong in every direction. Asking what they sell keeps
/// `store_type` as `mono_brand` while `vertical_code` carries the behaviour.
List<({String vertical, String label})> _monoBrandTrades(
  AppLocalizations l10n,
) => [
  (vertical: 'apparel', label: l10n.monoTradeClothing),
  (vertical: 'footwear', label: l10n.monoTradeFootwear),
  (vertical: 'electronics', label: l10n.monoTradeElectronics),
  (vertical: 'cosmetics', label: l10n.monoTradeCosmetics),
  (vertical: 'general', label: l10n.monoTradeOther),
];

class BusinessStep extends ConsumerStatefulWidget {
  const BusinessStep({super.key});

  @override
  ConsumerState<BusinessStep> createState() => _BusinessStepState();
}

class _BusinessStepState extends ConsumerState<BusinessStep> {
  final _formKey = GlobalKey<FormState>();
  final _ownerCtrl = TextEditingController();
  final _storeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _footfallCtrl = TextEditingController(text: '40');
  final _budgetCtrl = TextEditingController();
  String? _selectedType;

  @override
  void dispose() {
    _ownerCtrl.dispose();
    _storeCtrl.dispose();
    _emailCtrl.dispose();
    _footfallCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  /// Which trade a mono-brand store is in; drives `vertical_code`.
  String? _monoTrade;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.updateData(
      ref
          .read(onboardingProvider)
          .data
          .copyWith(
            ownerName: _ownerCtrl.text.trim(),
            storeName: _storeCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            businessType: _selectedType!,
            monoBrandVertical: _selectedType == 'mono_brand'
                ? _monoTrade
                : null,
            footfall: int.tryParse(_footfallCtrl.text) ?? 40,
            budget: double.tryParse(_budgetCtrl.text.trim()),
          ),
    );
    notifier.goToStep(3);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.businessTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 8),
            Text(
              l10n.businessSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate(delay: 50.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 32),
            BrandTextField(
                  controller: _ownerCtrl,
                  label: l10n.businessOwnerLabel,
                  hint: l10n.businessOwnerHint,
                  autofocus: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.businessOwnerRequired
                      : null,
                )
                .animate(delay: 100.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            BrandTextField(
                  controller: _storeCtrl,
                  label: l10n.businessStoreLabel,
                  hint: l10n.businessStoreHint,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.businessStoreRequired
                      : null,
                )
                .animate(delay: 150.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            BrandTextField(
                  controller: _emailCtrl,
                  label: l10n.businessEmailLabel,
                  hint: l10n.businessEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return l10n.businessEmailRequired;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) {
                      return l10n.businessEmailInvalid;
                    }
                    return null;
                  },
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.businessTypeLabel,
                  ),
                  hint: Text(l10n.businessTypeHint),
                  isExpanded: true,
                  items: _businessTypes(l10n)
                      .map(
                        (t) => DropdownMenuItem(
                          value: t.code,
                          child: Text(t.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedType = v;
                    if (v != 'mono_brand') _monoTrade = null;
                  }),
                  validator: (v) =>
                      v == null ? l10n.businessTypeRequired : null,
                )
                .animate(delay: 250.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            if (_selectedType == 'mono_brand') ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _monoTrade,
                decoration: InputDecoration(
                  labelText: l10n.monoTradeLabel,
                  helperText: l10n.monoTradeHelper,
                ),
                hint: Text(l10n.monoTradeHint),
                isExpanded: true,
                items: _monoBrandTrades(l10n)
                    .map(
                      (t) => DropdownMenuItem(
                        value: t.vertical,
                        child: Text(t.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _monoTrade = v),
                validator: (v) =>
                    v == null ? l10n.monoTradeRequired : null,
              ).animate().fadeIn(duration: 300.ms),
            ],
            const SizedBox(height: 16),
            TextFormField(
                  controller: _footfallCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.businessFootfallLabel,
                    hintText: l10n.businessFootfallHint,
                    suffixText: l10n.businessFootfallSuffix,
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 1) return l10n.businessFootfallInvalid;
                    return null;
                  },
                )
                .animate(delay: 300.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            TextFormField(
                  controller: _budgetCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: l10n.businessBudgetLabel,
                    hintText: l10n.businessBudgetHint,
                    prefixText: '₹ ',
                    helperText: l10n.businessBudgetHelper,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null; // optional
                    final n = double.tryParse(v.trim());
                    if (n == null || n < 0) return l10n.businessBudgetInvalid;
                    return null;
                  },
                )
                .animate(delay: 325.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 36),
            PrimaryButton(
              label: l10n.commonContinue,
              onPressed: _submit,
            ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
