import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../finance/providers/finance_provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer_model.dart';

class CustomerManagementScreen extends ConsumerStatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  ConsumerState<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends ConsumerState<CustomerManagementScreen> {
  bool _isSyncing = false;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(customerProvider.notifier).setSearchQuery('');
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerProvider);
    final customers = ref.read(customerProvider.notifier).filteredCustomers;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Customer Management', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            IconButton(
              tooltip: 'Sync Contacts',
              icon: const Icon(Icons.sync_rounded),
              onPressed: _handleSyncContacts,
            ),
          IconButton(
            tooltip: 'Refresh List',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(customerProvider.notifier).fetchCustomers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomerSheet(context, ref),
        backgroundColor: BrandColors.primary,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text('Add Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            color: Colors.white,
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => ref.read(customerProvider.notifier).setSearchQuery(v),
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                prefixIcon: const Icon(Icons.search_rounded, color: BrandColors.muted),
                filled: true,
                fillColor: BrandColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: BrandColors.error),
                    const SizedBox(height: 16),
                    Text(state.error!, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => ref.read(customerProvider.notifier).fetchCustomers(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (customers.isEmpty)
            const Expanded(child: Center(child: Text('No customers found.')))
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: customers.length,
                separatorBuilder: (_,_) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return _CustomerCard(customer: customer);
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSyncContacts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sync Contacts?'),
        content: const Text('This will import your phone contacts into your customer list. Regular customers will be matched by phone number.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sync Now')),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSyncing = true);
    try {
      final contacts = await ContactService.getAllContacts();
      final syncList = <Map<String, String>>[];
      
      for (final c in contacts) {
        if (c.phones.isNotEmpty) {
          final phone = c.phones.first.number;
          syncList.add({
            'name': c.displayName as String,
            'phone': ContactService.formatPhone(phone),
          });
        }
      }

      if (syncList.isNotEmpty) {
        await ref.read(financeProvider.notifier).syncContacts(syncList);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Synced ${syncList.length} contacts successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  void _showAddCustomerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CustomerFormSheet(),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/profile/customers/${customer.customerId}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BrandColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: BrandColors.ink.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: BrandColors.surfaceTint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: BrandColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.phone,
                    style: const TextStyle(color: BrandColors.muted, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: BrandColors.muted),
          ],
        ),
      ),
    );
  }
}

class CustomerFormSheet extends ConsumerStatefulWidget {
  final Customer? customer;
  const CustomerFormSheet({super.key, this.customer});

  @override
  ConsumerState<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends ConsumerState<CustomerFormSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _householdController = TextEditingController(text: '4');
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _phoneController.text = widget.customer!.phone;
      _emailController.text = widget.customer!.email ?? '';
      _householdController.text = widget.customer!.householdSize.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.customer == null ? 'Add New Customer' : 'Edit Customer',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address (Optional)',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _householdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Household Size',
              prefixIcon: Icon(Icons.group_outlined),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSaving 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Save Customer', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill name and phone')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    final data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text.isEmpty ? null : _emailController.text,
      'household_size': int.tryParse(_householdController.text) ?? 4,
    };

    bool success;
    if (widget.customer == null) {
      success = await ref.read(customerProvider.notifier).createCustomer(data);
    } else {
      success = await ref.read(customerProvider.notifier).updateCustomer(widget.customer!.customerId, data);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer saved successfully')),
        );
      }
    }
  }
}
