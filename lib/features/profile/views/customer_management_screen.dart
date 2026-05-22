import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/contact_service.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../finance/providers/finance_provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer_model.dart';

// ── Segment metadata ──────────────────────────────────────────────────────────

const _kSegments = [
  _SegmentMeta('regular', 'Regular', Icons.star_rounded, Color(0xFF059669)),
  _SegmentMeta(
    'occasional',
    'Occasional',
    Icons.calendar_month_rounded,
    Color(0xFF0891B2),
  ),
  _SegmentMeta('impulse', 'Impulse', Icons.bolt_rounded, Color(0xFFEA580C)),
  _SegmentMeta('bulk', 'Bulk', Icons.inventory_2_rounded, Color(0xFF7C3AED)),
  _SegmentMeta(
    'credit',
    'Credit',
    Icons.account_balance_wallet_rounded,
    Color(0xFFDC2626),
  ),
  _SegmentMeta(
    'inactive',
    'Inactive',
    Icons.bedtime_rounded,
    Color(0xFF6B7280),
  ),
];

class _SegmentMeta {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  const _SegmentMeta(this.id, this.label, this.icon, this.color);
}

// ── Screen ────────────────────────────────────────────────────────────────────

class CustomerManagementScreen extends ConsumerStatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  ConsumerState<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState
    extends ConsumerState<CustomerManagementScreen> {
  bool _isSyncing = false;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(customerProvider.notifier).setSearchQuery('');
        ref.read(customerProvider.notifier).setSegment(null);
      }
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
    final notifier = ref.read(customerProvider.notifier);
    final customers = notifier.filteredCustomers;

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Customer Relations',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
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
            onPressed: () => notifier.fetchCustomers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomerSheet(context, ref),
        backgroundColor: BrandColors.primary,
        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
        label: const Text(
          'Add Customer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          // Search + Chips header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => notifier.setSearchQuery(v),
                  decoration: InputDecoration(
                    hintText: 'Search by name or phone...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: BrandColors.muted,
                    ),
                    filled: true,
                    fillColor: BrandColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _kSegments.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final seg = _kSegments[i];
                      final isSelected = state.selectedSegment == seg.id;
                      final count = state.customers
                          .where((c) => c.segments.contains(seg.id))
                          .length;
                      return _SegmentChip(
                        meta: seg,
                        count: count,
                        isSelected: isSelected,
                        onTap: () =>
                            notifier.setSegment(isSelected ? null : seg.id),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
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
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: BrandColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(state.error!, textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => notifier.fetchCustomers(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (customers.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 56,
                      color: BrandColors.muted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.selectedSegment != null
                          ? 'No ${state.selectedSegment} customers'
                          : 'No customers found.',
                      style: const TextStyle(
                        color: BrandColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                itemCount: customers.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
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
        content: const Text(
          'This will import your phone contacts into your customer list. Regular customers will be matched by phone number.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sync Now'),
          ),
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
            SnackBar(
              content: Text('Synced ${syncList.length} contacts successfully!'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
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

// ── Segment chip ──────────────────────────────────────────────────────────────

class _SegmentChip extends StatelessWidget {
  final _SegmentMeta meta;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentChip({
    required this.meta,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected ? meta.color : meta.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? meta.color : meta.color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              meta.icon,
              size: 14,
              color: isSelected ? Colors.white : meta.color,
            ),
            const SizedBox(width: 6),
            Text(
              meta.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : meta.color,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                '($count)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white70
                      : meta.color.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Customer card ─────────────────────────────────────────────────────────────

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final segs = customer.segments;
    final isInactive = segs.contains('inactive');
    final primarySeg = _primarySegment(segs);
    final segMeta = primarySeg != null
        ? _kSegments.firstWhere(
            (s) => s.id == primarySeg,
            orElse: () => _kSegments.first,
          )
        : null;

    return Container(
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
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                context.push('/profile/customers/${customer.customerId}'),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: segMeta != null
                          ? segMeta.color.withValues(alpha: 0.1)
                          : BrandColors.surfaceTint,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        customer.name.isNotEmpty
                            ? customer.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: segMeta?.color ?? BrandColors.primary,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          customer.phone,
                          style: const TextStyle(
                            color: BrandColors.muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (segs.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            children: segs.map((s) {
                              final m = _kSegments.firstWhere(
                                (x) => x.id == s,
                                orElse: () => _kSegments.first,
                              );
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: m.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  m.label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: m.color,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: BrandColors.muted,
                  ),
                ],
              ),
            ),
          ),

          // WhatsApp re-engagement button for inactive customers
          if (isInactive)
            InkWell(
              onTap: () => _sendWhatsAppReengagement(customer),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366).withValues(alpha: 0.06),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: BrandColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.chat_rounded,
                      size: 16,
                      color: Color(0xFF25D366),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Send WhatsApp Re-engagement',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF25D366).withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  String? _primarySegment(Set<String> segs) {
    for (final s in [
      'inactive',
      'credit',
      'bulk',
      'regular',
      'occasional',
      'impulse',
    ]) {
      if (segs.contains(s)) return s;
    }
    return null;
  }

  Future<void> _sendWhatsAppReengagement(Customer customer) async {
    final message =
        'Hi ${customer.name.split(' ').first}! '
        'We miss you at our store. It\'s been a while since your last visit, '
        'and we have fresh stock and great deals waiting for you. '
        'Come visit us soon — your favourite items are ready! '
        'See you soon!';

    final phone = customer.phone.replaceAll(RegExp(r'[^\d+]'), '');
    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Customer form sheet ───────────────────────────────────────────────────────

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
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _householdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.customer == null
                      ? 'Add New Customer'
                      : 'Edit Customer',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
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
              maxLength: 60,
              inputFormatters: [
                // Allow Unicode letters, spaces, dots, hyphens, apostrophes — block HTML/script chars
                FilteringTextInputFormatter.deny(RegExp('[<>{}\\\\&;"\']')),
              ],
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline_rounded),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 15,
              inputFormatters: [
                // Allow digits, leading +, spaces, hyphens only
                FilteringTextInputFormatter.allow(RegExp(r'[-0-9+ ]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
                counterText: '',
                hintText: '+91 XXXXX XXXXX',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              maxLength: 100,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp('[<>{}\\\\&;"\']')),
              ],
              decoration: const InputDecoration(
                labelText: 'Email Address (Optional)',
                prefixIcon: Icon(Icons.email_outlined),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _householdController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Customer',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill name and phone')),
      );
      return;
    }
    final digits = phone.replaceAll('+', '');
    if (digits.length < 7 ||
        digits.length > 15 ||
        !RegExp(r'^\+?\d+$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid phone number (digits only)'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final data = {
      'name': name,
      'phone': phone,
      'email': _emailController.text.isEmpty ? null : _emailController.text,
      'household_size': int.tryParse(_householdController.text) ?? 4,
    };

    bool success;
    if (widget.customer == null) {
      success = await ref.read(customerProvider.notifier).createCustomer(data);
    } else {
      success = await ref
          .read(customerProvider.notifier)
          .updateCustomer(widget.customer!.customerId, data);
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
