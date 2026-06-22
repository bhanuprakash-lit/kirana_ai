import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/shimmer_widgets.dart';
import '../providers/customer_provider.dart';
import '../models/customer_model.dart';
import '../../loyalty/providers/loyalty_provider.dart';
import '../../customer360/customer360_provider.dart';
import '../../../../core/vertical/vertical_config_provider.dart';
import '../../pos_inventory/providers/pos_provider.dart';
import '../../pos_inventory/views/widgets/add_product_sheet_new.dart';
import 'customer_management_screen.dart';
import '../../associations/providers/association_provider.dart';
import '../../associations/models/association_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/locale/locale_provider.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final int customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  bool _savingAssociation = false;

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(customerProvider);
    final customer = state.customers.firstWhere(
      (c) => c.customerId == widget.customerId,
      orElse: () => Customer(
        customerId: widget.customerId,
        name: l10n.profLoading,
        phone: '',
      ),
    );

    final ordersAsync = ref.watch(customerOrdersProvider(widget.customerId));
    final khataAsync = ref.watch(customerKhataProvider(widget.customerId));

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.profCustomerDetails,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditCustomerSheet(context, customer),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: BrandColors.error,
            ),
            onPressed: () => _confirmDelete(context, customer),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: BrandColors.surfaceTint,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        customer.name.isNotEmpty
                            ? customer.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: BrandColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: BrandColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customer.phone,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.muted,
                    ),
                  ),
                  if (customer.email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      customer.email!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            _CustomerLoyaltyCard(customerId: widget.customerId),

            _Customer360Card(customerId: widget.customerId),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: l10n.profStatBalance,
                      value: khataAsync.when(
                        data: (khata) =>
                            '₹${(khata?['amount'] as num? ?? 0) - (khata?['amount_paid'] as num? ?? 0)}',
                        loading: () => '...',
                        error: (_, _) => 'N/A',
                      ),
                      icon: Icons.account_balance_wallet_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: l10n.profStatSpent,
                      value: ordersAsync.when(
                        data: (orders) {
                          final total = orders.fold<double>(
                            0,
                            (sum, o) =>
                                sum + (o['total_amount'] as num).toDouble(),
                          );
                          return '₹${NumberFormat('#,##,###').format(total)}';
                        },
                        loading: () => '...',
                        error: (_, _) => 'N/A',
                      ),
                      icon: Icons.shopping_bag_outlined,
                      color: BrandColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: l10n.profStatOrders,
                      value: ordersAsync.when(
                        data: (orders) => orders.length.toString(),
                        loading: () => '...',
                        error: (_, _) => 'N/A',
                      ),
                      icon: Icons.receipt_long_outlined,
                      color: BrandColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Section
            _SectionHeader(title: l10n.profCustomerInfo),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    label: l10n.profHouseholdSize,
                    value: l10n.profMembersCount(customer.householdSize),
                    icon: Icons.group_outlined,
                  ),
                  const Divider(height: 32),
                  _InfoRow(
                    label: l10n.profJoinedOn,
                    value: customer.createdAt != null
                        ? DateFormat(
                            'MMM dd, yyyy',
                          ).format(customer.createdAt!.toLocal())
                        : l10n.profUnknown,
                    icon: Icons.calendar_today_outlined,
                  ),
                  const Divider(height: 32),
                  _AssociationRow(
                    customer: customer,
                    saving: _savingAssociation,
                    onChanged: (newId) => _saveAssociation(customer, newId),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Purchase History
            _SectionHeader(title: l10n.profPurchaseHistory),
            ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(l10n.profNoOrdersForCustomer),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _OrderListItem(order: order);
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ListShimmer(itemCount: 3, itemHeight: 64),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(40),
                child: Text(l10n.profErrorLoadingOrders(err.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCustomerSheet(BuildContext context, Customer customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerFormSheet(customer: customer),
    );
  }

  void _confirmDelete(BuildContext context, Customer customer) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profDeleteCustomerTitle),
        content: Text(l10n.profDeleteCustomerBody(customer.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.profCancel),
          ),
          TextButton(
            onPressed: () async {
              final error = await ref
                  .read(customerProvider.notifier)
                  .deleteCustomer(customer.customerId);
              if (!context.mounted) return;
              Navigator.pop(context); // close dialog
              if (error == null) {
                context.pop(); // success — go back to list
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: BrandColors.error,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            child: Text(
              l10n.profDelete,
              style: const TextStyle(color: BrandColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAssociation(Customer customer, int? newId) async {
    setState(() => _savingAssociation = true);
    try {
      await ref.read(customerProvider.notifier).updateCustomer(
        customer.customerId,
        {'association_id': newId},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_l10n.profFailedToUpdateArea(e.toString())),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _savingAssociation = false);
    }
  }
}

// ── Association row with inline dropdown ──────────────────────────────────────

class _AssociationRow extends ConsumerWidget {
  final Customer customer;
  final bool saving;
  final ValueChanged<int?> onChanged;

  const _AssociationRow({
    required this.customer,
    required this.saving,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assocAsync = ref.watch(associationProvider);
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        const Icon(
          Icons.location_city_rounded,
          size: 20,
          color: BrandColors.muted,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profAreaAssociation,
                style: const TextStyle(
                  fontSize: 12,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              assocAsync.when(
                loading: () =>
                    const ShimmerBox(width: 80, height: 20, radius: 6),
                error: (_, _) => Text(
                  l10n.profUnableToLoadAreas,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BrandColors.muted,
                  ),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return GestureDetector(
                      onTap: () => context.push('/profile/associations'),
                      child: Text(
                        l10n.profNoAreasTapToAdd,
                        style: const TextStyle(
                          fontSize: 13,
                          color: BrandColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  final items = <DropdownMenuItem<int?>>[
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        l10n.profNone,
                        style: const TextStyle(color: BrandColors.muted),
                      ),
                    ),
                    ...list.map(
                      (a) => DropdownMenuItem(
                        value: a.associationId,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(a.areaType.emoji),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                a.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];

                  return saving
                      ? const ShimmerBox(width: 80, height: 20, radius: 6)
                      : DropdownButtonHideUnderline(
                          child: DropdownButton<int?>(
                            value: customer.associationId,
                            isDense: true,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: BrandColors.ink,
                            ),
                            onChanged: onChanged,
                            items: items,
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: BrandColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: BrandColors.muted,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: BrandColors.muted),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: BrandColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: BrandColors.ink,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OrderListItem extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderListItem({required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateStr = order['order_date'] as String;
    final date = DateTime.parse(dateStr).toLocal();
    final amount = (order['total_amount'] as num).toDouble();

    return InkWell(
      onTap: () => context.push('/pos-order-details', extra: order),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BrandColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profOrderNumber(order['order_id'].toString()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '₹${amount.toStringAsFixed(1)}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: BrandColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: BrandColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

/// M1 — customer loyalty points / tier card. Only shown when the store has
/// loyalty enabled; nothing rendered otherwise.
class _CustomerLoyaltyCard extends ConsumerWidget {
  final int customerId;
  const _CustomerLoyaltyCard({required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active =
        ref.watch(loyaltyConfigProvider).asData?.value.isActive ?? false;
    if (!active) return const SizedBox.shrink();
    final async = ref.watch(customerLoyaltyProvider(customerId));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (l) {
        final tierColor = l.tier == 'gold'
            ? const Color(0xFFD4AF37)
            : l.tier == 'silver'
                ? const Color(0xFF9CA3AF)
                : const Color(0xFFB87333);
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BrandColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.card_giftcard_rounded, color: tierColor, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l.points.toStringAsFixed(0)} points',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: BrandColors.ink)),
                    Text(
                      '${l.tier[0].toUpperCase()}${l.tier.substring(1)} tier · worth ₹${l.redeemValue.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 12, color: BrandColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.tier.toUpperCase(),
                  style: TextStyle(
                      color: tierColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 11),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// M8 — Customer 360+: prescription/style/size profile + wishlist.
class _Customer360Card extends ConsumerWidget {
  final int customerId;
  const _Customer360Card({required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerProfileProvider(customerId)).asData?.value;
    final wishes = ref.watch(wishlistProvider(customerId)).asData?.value ?? [];
    // Only show the profile fields that make sense for this store's vertical:
    // optical → prescription (+ renewal date), fashion → style & size.
    final vcode = verticalConfigOf(ref).verticalCode;
    final isOptical = vcode == 'optical';
    final isFashion = vcode == 'apparel' || vcode == 'footwear';
    final showProfile = isOptical || isFashion;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (showProfile) ...[
          Row(children: [
            const Expanded(
              child: Text('Customer profile',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            ),
            TextButton(
              onPressed: () =>
                  _editProfile(context, ref, profile, isOptical, isFashion),
              child: const Text('Edit'),
            ),
          ]),
          if (isOptical && (profile?.prescription ?? '').isNotEmpty)
            _line('Prescription', profile!.prescription!),
          if (isOptical && (profile?.prescriptionDate ?? '').isNotEmpty)
            _line('Rx date', profile!.prescriptionDate!),
          if (isFashion && (profile?.styleProfile ?? '').isNotEmpty)
            _line('Style', profile!.styleProfile!),
          if (isFashion && (profile?.sizeProfile ?? '').isNotEmpty)
            _line('Size', profile!.sizeProfile!),
          if (profile == null || profile.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('No profile details yet.',
                  style: TextStyle(fontSize: 12, color: BrandColors.muted)),
            ),
          const Divider(height: 18),
        ],
        Row(children: [
          Expanded(
            child: Text('Wishlist (${wishes.length})',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 20),
            onPressed: () => _pickWish(context, ref),
          ),
        ]),
        if (wishes.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 2, bottom: 4),
            child: Text('No items wishlisted yet.',
                style: TextStyle(fontSize: 12, color: BrandColors.muted)),
          ),
        ...wishes.map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(children: [
                const Icon(Icons.favorite_border_rounded,
                    size: 14, color: BrandColors.muted),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                        (w['product_name'] ?? w['note'] ?? 'Item').toString(),
                        style: const TextStyle(fontSize: 13))),
                InkWell(
                  onTap: () => ref
                      .read(customer360ActionsProvider)
                      .removeWish(customerId, (w['id'] as num).toInt()),
                  child: const Icon(Icons.close_rounded,
                      size: 14, color: BrandColors.muted),
                ),
              ]),
            )),
      ]),
    );
  }

  Widget _line(String k, String v) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: BrandColors.ink),
            children: [
              TextSpan(
                  text: '$k: ',
                  style: const TextStyle(color: BrandColors.muted)),
              TextSpan(text: v),
            ],
          ),
        ),
      );

  void _pickWish(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WishProductPicker(customerId: customerId),
    );
  }

  void _editProfile(BuildContext context, WidgetRef ref, CustomerProfile? p,
      bool isOptical, bool isFashion) {
    final rx = TextEditingController(text: p?.prescription ?? '');
    final style = TextEditingController(text: p?.styleProfile ?? '');
    final size = TextEditingController(text: p?.sizeProfile ?? '');
    DateTime? rxDate = (p?.prescriptionDate != null && p!.prescriptionDate!.isNotEmpty)
        ? DateTime.tryParse(p.prescriptionDate!)
        : null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 20,
              right: 20,
              top: 16),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Customer profile',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              if (isOptical) ...[
                TextField(
                    controller: rx,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: 'Prescription (power / notes)')),
                const SizedBox(height: 12),
                // Structured Rx date feeds the prescription-renewal KPI.
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: rxDate ?? DateTime.now(),
                      firstDate: DateTime(2018),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setSheet(() => rxDate = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        labelText: 'Prescription date',
                        suffixIcon: Icon(Icons.calendar_today_rounded, size: 18)),
                    child: Text(rxDate == null
                        ? 'Not set'
                        : '${rxDate!.year}-${rxDate!.month.toString().padLeft(2, '0')}-${rxDate!.day.toString().padLeft(2, '0')}'),
                  ),
                ),
              ],
              if (isFashion) ...[
                TextField(
                    controller: style,
                    decoration:
                        const InputDecoration(labelText: 'Style preferences')),
                const SizedBox(height: 12),
                TextField(
                    controller: size,
                    decoration: const InputDecoration(
                        labelText: 'Sizes (e.g. shirt M, shoe 9)')),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () async {
                    final body = <String, dynamic>{};
                    if (isOptical) {
                      body['prescription'] = rx.text.trim();
                      if (rxDate != null) {
                        body['prescription_date'] =
                            '${rxDate!.year}-${rxDate!.month.toString().padLeft(2, '0')}-${rxDate!.day.toString().padLeft(2, '0')}';
                      }
                    }
                    if (isFashion) {
                      body['style_profile'] = style.text.trim();
                      body['size_profile'] = size.text.trim();
                    }
                    await ref
                        .read(customer360ActionsProvider)
                        .saveProfile(customerId, body);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Wishlist picker — choose from the store's products; if it's not stocked yet,
/// jump straight to the Add Product flow.
class _WishProductPicker extends ConsumerStatefulWidget {
  final int customerId;
  const _WishProductPicker({required this.customerId});
  @override
  ConsumerState<_WishProductPicker> createState() => _WishProductPickerState();
}

class _WishProductPickerState extends ConsumerState<_WishProductPicker> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(posProvider).products;
    final filtered = _q.isEmpty
        ? products
        : products
            .where((p) => p.name.toLowerCase().contains(_q.toLowerCase()))
            .toList();
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: Column(children: [
          const Text('Add to wishlist',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            onChanged: (v) => setState(() => _q = v),
            decoration: const InputDecoration(
              hintText: 'Search products',
              prefixIcon: Icon(Icons.search_rounded, size: 20),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                        products.isEmpty
                            ? 'No products in this store yet.'
                            : 'No match for "$_q".',
                        style: const TextStyle(color: BrandColors.muted)),
                  )
                : ListView.builder(
                    controller: sc,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return ListTile(
                        dense: true,
                        title: Text(p.name),
                        trailing: const Icon(Icons.add_circle_outline_rounded,
                            size: 20, color: BrandColors.primary),
                        onTap: () async {
                          await ref
                              .read(customer360ActionsProvider)
                              .addWishProduct(widget.customerId, p.productId);
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
          // Not stocked? Take the owner to add it to inventory.
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              showAddProductSheet(context, ref);
            },
            icon: const Icon(Icons.add_box_outlined, size: 18),
            label: const Text("Item not in inventory? Add product"),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
          ),
        ]),
      ),
    );
  }
}
