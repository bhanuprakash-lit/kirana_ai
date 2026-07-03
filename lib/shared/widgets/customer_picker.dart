import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/profile/models/customer_model.dart';
import '../../features/profile/providers/customer_provider.dart';

/// Shared customer selector. Search the store's customers or add a new one
/// inline (name + phone); returns the chosen [Customer], or null if dismissed.
///
/// Use this everywhere a record links to a customer instead of free-typing a
/// name — keeps the customer list the single source of truth (no typo'd
/// duplicates) and captures a phone number at the same time.
Future<Customer?> showCustomerPicker(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<Customer>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CustomerPicker(),
  );
}

class _CustomerPicker extends ConsumerStatefulWidget {
  const _CustomerPicker();

  @override
  ConsumerState<_CustomerPicker> createState() => _CustomerPickerState();
}

class _CustomerPickerState extends ConsumerState<_CustomerPicker> {
  final _searchCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _query = '';
  bool _adding = false;
  bool _saving = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final created = await ref
        .read(customerProvider.notifier)
        .createAndReturn(name, phone);
    if (!mounted) return;
    setState(() => _saving = false);
    if (created != null) Navigator.pop(context, created);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(customerProvider).customers;
    final q = _query.toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all
              .where(
                (c) => c.name.toLowerCase().contains(q) || c.phone.contains(q),
              )
              .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollCtrl) => Container(
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.posSelectCustomer,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(() => _adding = !_adding),
                      icon: Icon(
                        _adding ? Icons.close_rounded : Icons.person_add_alt_1,
                        size: 18,
                      ),
                      label: Text(
                        _adding ? l10n.posCommonCancel : l10n.posAddNewCustomer,
                      ),
                    ),
                  ],
                ),
              ),
              if (_adding)
                _AddForm(
                  nameCtrl: _nameCtrl,
                  phoneCtrl: _phoneCtrl,
                  saving: _saving,
                  onSave: _save,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: l10n.finSearchByNameOrPhone,
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: BrandColors.muted,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.posNoCustomersFound,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final c = filtered[i];
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: BrandColors.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Text(
                                c.name.isNotEmpty
                                    ? c.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: BrandColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              c.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: c.phone.isNotEmpty
                                ? Text(
                                    c.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: BrandColors.muted,
                                    ),
                                  )
                                : null,
                            onTap: () => Navigator.pop(context, c),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final bool saving;
  final VoidCallback onSave;

  const _AddForm({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Column(
        children: [
          TextField(
            controller: nameCtrl,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.posCustomerName,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.posPhoneNumber,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: saving ? null : onSave,
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.posSaveAndSelect),
            ),
          ),
        ],
      ),
    );
  }
}
