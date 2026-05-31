import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/brand_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../providers/onboarding_provider.dart';

const _businessTypes = [
  'Grocery Store (Kirana)',
  'General Store',
  'Provision Store',
  'Fruits & Vegetables',
  'Medical / Pharmacy',
  'Stationery & Books',
  'Others',
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
            footfall: int.tryParse(_footfallCtrl.text) ?? 40,
            budget: double.tryParse(_budgetCtrl.text.trim()),
          ),
    );
    notifier.goToStep(3);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about\nyour store',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 8),
            Text(
              'Help us personalise your experience.',
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate(delay: 50.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 32),
            BrandTextField(
                  controller: _ownerCtrl,
                  label: "Owner's full name",
                  hint: 'e.g. Ramesh Kumar',
                  autofocus: true,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                )
                .animate(delay: 100.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            BrandTextField(
                  controller: _storeCtrl,
                  label: 'Store name',
                  hint: 'e.g. Sri Lakshmi Stores',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Store name is required'
                      : null,
                )
                .animate(delay: 150.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            BrandTextField(
                  controller: _emailCtrl,
                  label: 'Email address',
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Email is required';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(labelText: 'Business type'),
                  hint: const Text('Select your store type'),
                  isExpanded: true,
                  items: _businessTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedType = v),
                  validator: (v) =>
                      v == null ? 'Please select your business type' : null,
                )
                .animate(delay: 250.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            TextFormField(
                  controller: _footfallCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Estimated daily customers',
                    hintText: 'e.g. 40',
                    suffixText: 'customers/day',
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 1) return 'Enter a valid number';
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
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Monthly sales target (optional)',
                    hintText: 'e.g. 150000',
                    prefixText: '₹ ',
                    helperText: 'Used to track daily progress. You can change it later.',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null; // optional
                    final n = double.tryParse(v.trim());
                    if (n == null || n < 0) return 'Enter a valid amount';
                    return null;
                  },
                )
                .animate(delay: 325.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 36),
            PrimaryButton(
              label: 'Continue',
              onPressed: _submit,
            ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
