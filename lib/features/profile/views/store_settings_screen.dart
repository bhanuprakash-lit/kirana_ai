import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/brand_theme.dart';
import '../models/store_model.dart';
import '../providers/store_settings_provider.dart';

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

  bool _isSaving = false;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncProfile = ref.watch(storeSettingsProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Store Settings'),
        actions: [
          if (!_isSaving)
            TextButton(
              onPressed: _save,
              child: const Text(
                'SAVE',
                style: TextStyle(
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
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
                  _sectionHeader('Basic Information'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _nameCtrl,
                    'Store Name',
                    Icons.storefront_rounded,
                  ),
                  _buildTextField(
                    _typeCtrl,
                    'Store Type (e.g. Kirana, Supermarket)',
                    Icons.category_rounded,
                  ),

                  const SizedBox(height: 32),
                  _sectionHeader('Business Intelligence'),
                  const SizedBox(height: 8),
                  Text(
                    isFootfallLocked
                        ? 'Average footfall is automatically computed based on your sales.'
                        : 'Provide initial values to help our AI optimize your business.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _footfallCtrl,
                    'Avg Daily Footfall',
                    Icons.people_rounded,
                    keyboardType: TextInputType.number,
                    readOnly: isFootfallLocked,
                    helperText: isFootfallLocked ? 'AI Auto-Updating' : null,
                  ),
                  _buildTextField(
                    _budgetCtrl,
                    'Monthly Stock Budget',
                    Icons.account_balance_wallet_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    _dailyBudgetCtrl,
                    'Daily Expense Buffer',
                    Icons.payments_rounded,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 32),
                  _sectionHeader('Location Details'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _locationCtrl,
                    'City / Area',
                    Icons.location_on_rounded,
                  ),
                  _buildTextField(
                    _regionCtrl,
                    'State / Region',
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
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
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
      );

      await ref.read(storeSettingsProvider.notifier).updateStore(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved successfully!'),
            backgroundColor: BrandColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
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
    super.dispose();
  }
}
