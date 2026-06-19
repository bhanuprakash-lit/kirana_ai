part of '../udhaar_tab_new.dart';

class _AddUdhaarSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final TextEditingController nameController;
  final TextEditingController amountController;
  final TextEditingController phoneController;
  final Function(String, String) onContactPick;

  const _AddUdhaarSheet({
    required this.ref,
    required this.nameController,
    required this.amountController,
    required this.phoneController,
    required this.onContactPick,
  });

  @override
  ConsumerState<_AddUdhaarSheet> createState() => _AddUdhaarSheetState();
}

class _AddUdhaarSheetState extends ConsumerState<_AddUdhaarSheet> {
  bool _saving = false;
  bool _success = false;
  String? _error;
  Customer? _selectedCustomer;
  // Repayment deadline; defaults to 30 Jun 2026 (same default as the backend
  // backfill) and is editable.
  DateTime _dueDate = DateTime(2026, 6, 30);

  void _fillFromCustomer(Customer c) {
    setState(() {
      _selectedCustomer = c;
      widget.nameController.text = c.name;
      widget.phoneController.text = c.phone;
    });
  }

  void _clearCustomer() {
    setState(() {
      _selectedCustomer = null;
      widget.nameController.clear();
      widget.phoneController.clear();
    });
  }

  Future<void> _showCustomerPicker() async {
    final customers = ref.read(customerProvider).customers;
    if (customers.isEmpty) return;

    await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerPickerSheet(
        customers: customers,
        onSelected: (c) {
          Navigator.pop(context);
          _fillFromCustomer(c);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerProvider).customers;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: BrandColors.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.finAddNewUdhaar,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (!_saving && !_success)
                TextButton.icon(
                  onPressed: () async {
                    final contact = await ContactService.pickContact();
                    if (contact != null) {
                      setState(() {
                        _selectedCustomer = null;
                        widget.nameController.text = contact.name!.first
                            .toString();
                        if (contact.phones.isNotEmpty) {
                          final p = ContactService.formatPhone(
                            contact.phones.first.number,
                          );
                          widget.phoneController.text = p;
                          widget.onContactPick(widget.nameController.text, p);
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.contacts_rounded, size: 18),
                  label: Text(
                    l10n.finContacts,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Existing customer picker
          if (customers.isNotEmpty && !_saving && !_success) ...[
            GestureDetector(
              onTap: _selectedCustomer != null
                  ? _clearCustomer
                  : _showCustomerPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _selectedCustomer != null
                      ? BrandColors.primary.withValues(alpha: 0.06)
                      : BrandColors.surfaceTint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedCustomer != null
                        ? BrandColors.primary.withValues(alpha: 0.4)
                        : BrandColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedCustomer != null
                          ? Icons.check_circle_rounded
                          : Icons.person_search_rounded,
                      color: _selectedCustomer != null
                          ? BrandColors.primary
                          : BrandColors.muted,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _selectedCustomer != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedCustomer!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: BrandColors.ink,
                                  ),
                                ),
                                if (_selectedCustomer!.phone.isNotEmpty)
                                  Text(
                                    _selectedCustomer!.phone,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: BrandColors.muted,
                                    ),
                                  ),
                              ],
                            )
                          : Text(
                              l10n.finSelectExistingCustomer,
                              style: const TextStyle(
                                fontSize: 14,
                                color: BrandColors.muted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                    Icon(
                      _selectedCustomer != null
                          ? Icons.close_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: BrandColors.muted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    l10n.finOrEnterManually,
                    style: const TextStyle(
                      fontSize: 11,
                      color: BrandColors.muted,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 12),
          ],

          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            successMessage: l10n.finUdhaarRecorded,
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: widget.nameController,
            enabled: !_saving && !_success,
            decoration: InputDecoration(
              labelText: l10n.finCustomerName,
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.phoneController,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: l10n.finPhoneNumber,
              prefixIcon: const Icon(Icons.phone_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: widget.amountController,
            enabled: !_saving && !_success,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.finAmount,
              prefixText: '₹ ',
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
            ),
          ),
          const SizedBox(height: 16),
          // Repayment due date — when the customer promises to clear the dues.
          InkWell(
            onTap: (_saving || _success)
                ? null
                : () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime(2030, 12, 31),
                      helpText: l10n.finDueDateHint,
                    );
                    if (picked != null) setState(() => _dueDate = picked);
                  },
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.finDueDate,
                prefixIcon: const Icon(Icons.event_rounded),
              ),
              child: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: BrandColors.ink,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: l10n.finSaveUdhaar,
              isLoading: _saving,
              onPressed: _success
                  ? null
                  : () async {
                      final amount =
                          double.tryParse(widget.amountController.text) ?? 0;
                      if (widget.nameController.text.isEmpty ||
                          widget.phoneController.text.isEmpty ||
                          amount <= 0) {
                        setState(
                          () => _error = l10n.finEnterValidNamePhoneAmount,
                        );
                        return;
                      }

                      setState(() {
                        _saving = true;
                        _error = null;
                      });
                      try {
                        await widget.ref
                            .read(financeProvider.notifier)
                            .addUdhaar(
                              name: widget.nameController.text,
                              phone: widget.phoneController.text,
                              amount: amount,
                              dueDate: _dueDate,
                            );
                        if (mounted) {
                          setState(() {
                            _saving = false;
                            _success = true;
                          });
                          await Future.delayed(
                            const Duration(milliseconds: 600),
                          );
                          // ignore: use_build_context_synchronously
                          if (mounted) Navigator.pop(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            _saving = false;
                            _error = e.toString();
                          });
                        }
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}

