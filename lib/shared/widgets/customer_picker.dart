import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../features/profile/models/customer_model.dart';
import '../../features/profile/providers/customer_provider.dart';
import '../../features/profile/views/customer_management_screen.dart'
    show CustomerFormSheet;

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
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  /// "Add new" opens the SAME full customer form used everywhere else
  /// (name, phone, area, birthday …); the created customer is returned
  /// as this picker's selection.
  Future<void> _addNew() async {
    final created = await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CustomerFormSheet(),
    );
    if (created != null && mounted) Navigator.pop(context, created);
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
                      onPressed: _addNew,
                      icon: const Icon(Icons.person_add_alt_1, size: 18),
                      label: Text(l10n.posAddNewCustomer),
                    ),
                  ],
                ),
              ),
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

