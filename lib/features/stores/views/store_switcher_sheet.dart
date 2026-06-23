import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/location/geo_locate.dart';
import '../../../core/theme/brand_theme.dart';
import '../models/user_store.dart';
import '../providers/stores_provider.dart';
import '../store_types.dart';

/// Bottom sheet: list the owner's stores, switch between them, or add a new one.
Future<void> showStoreSwitcher(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _StoreSwitcherSheet(),
  );
}

String _verticalLabel(String v) => v.isEmpty ? '' : v[0].toUpperCase() + v.substring(1);

class _StoreSwitcherSheet extends ConsumerWidget {
  const _StoreSwitcherSheet();

  Future<void> _switch(BuildContext context, WidgetRef ref, UserStore s) async {
    if (s.isActive) {
      Navigator.pop(context);
      return;
    }
    try {
      await ref.read(storeActionsProvider).switchStore(s.storeId);
      if (context.mounted) {
        Navigator.pop(context);
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not switch: $e'), backgroundColor: BrandColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stores = ref.watch(myStoresProvider);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44, height: 5,
              decoration: BoxDecoration(
                color: BrandColors.border, borderRadius: BorderRadius.circular(3)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Your stores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: BrandColors.ink)),
          const SizedBox(height: 12),
          stores.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Could not load stores\n$e',
                  style: const TextStyle(color: BrandColors.muted))),
            data: (list) => Column(
              children: [
                ...list.map((s) => _StoreTile(
                      store: s,
                      onTap: () => _switch(context, ref, s),
                    )),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => showAddStoreSheet(context, ref),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: BrandColors.primary.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_business_rounded, color: BrandColors.primary, size: 20),
                        SizedBox(width: 10),
                        Text('Add a store',
                            style: TextStyle(fontWeight: FontWeight.w700, color: BrandColors.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreTile extends StatelessWidget {
  final UserStore store;
  final VoidCallback onTap;
  const _StoreTile({required this.store, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: store.isActive ? BrandColors.primary.withValues(alpha: 0.06) : BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: store.isActive ? BrandColors.primary : BrandColors.border,
            width: store.isActive ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: BrandColors.primary.withValues(alpha: 0.12),
              child: Text(
                store.storeName.isNotEmpty ? store.storeName[0].toUpperCase() : '?',
                style: const TextStyle(color: BrandColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.storeName,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: BrandColors.ink)),
                  Text(
                    '${_verticalLabel(store.verticalCode)}${store.city != null && store.city!.isNotEmpty ? ' · ${store.city}' : ''}',
                    style: const TextStyle(fontSize: 12, color: BrandColors.muted),
                  ),
                ],
              ),
            ),
            if (store.isActive)
              const Icon(Icons.check_circle_rounded, color: BrandColors.primary, size: 20)
            else
              const Icon(Icons.chevron_right_rounded, color: BrandColors.muted, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Add-store flow: Step 1 business details (owner prefilled), Step 2 location
/// (GPS detect + manual). Mirrors onboarding so the new store gets a real
/// location/footfall/budget. On success, switches to the new store.
Future<void> showAddStoreSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddStoreSheet(),
  );
}

class _AddStoreSheet extends ConsumerStatefulWidget {
  const _AddStoreSheet();
  @override
  ConsumerState<_AddStoreSheet> createState() => _AddStoreSheetState();
}

class _AddStoreSheetState extends ConsumerState<_AddStoreSheet> {
  int _step = 0; // 0 = details, 1 = location
  final _name = TextEditingController();
  final _footfall = TextEditingController(text: '40');
  final _budget = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  StoreTypeOption _type = kStoreTypeOptions.first;
  String _ownerName = '';
  bool _detecting = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => _ownerName = p.getString('full_name') ?? '');
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _footfall.dispose();
    _budget.dispose();
    _address.dispose();
    _city.dispose();
    super.dispose();
  }

  void _toLocation() {
    if (_name.text.trim().isEmpty) {
      _snack('Enter a store name');
      return;
    }
    setState(() => _step = 1);
  }

  Future<void> _detect() async {
    setState(() => _detecting = true);
    try {
      final r = await detectCurrentLocation();
      if (!mounted) return;
      setState(() {
        if (r.address.isNotEmpty) _address.text = r.address;
        if (r.city.isNotEmpty) _city.text = r.city;
      });
    } catch (_) {
      _snack('Could not detect location — enter it manually');
    } finally {
      if (mounted) setState(() => _detecting = false);
    }
  }

  Future<void> _save() async {
    final address = _address.text.trim();
    final city = _city.text.trim();
    if (address.isEmpty || city.isEmpty) {
      _snack('Address and city are required');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(storeActionsProvider).addStore(
            storeName: _name.text.trim(),
            storeType: _type.code,
            verticalCode: _type.vertical,
            city: city,
            location: address,
            region: city,
            footfall: int.tryParse(_footfall.text.trim()),
            budget: _budget.text.trim().isEmpty
                ? null
                : double.tryParse(_budget.text.trim()),
          );
      if (mounted) {
        Navigator.pop(context); // add sheet
        if (Navigator.canPop(context)) Navigator.pop(context); // switcher sheet
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _snack('Could not add store: $e');
      }
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: BrandColors.error),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (_step == 1)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    onPressed: () => setState(() => _step = 0),
                  ),
                if (_step == 1) const SizedBox(width: 8),
                Text(_step == 0 ? 'Add a store · Details' : 'Add a store · Location',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900, color: BrandColors.ink)),
              ],
            ),
            const SizedBox(height: 16),
            if (_step == 0) ..._detailsStep() else ..._locationStep(),
          ],
        ),
      ),
    );
  }

  List<Widget> _detailsStep() => [
        if (_ownerName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(children: [
              const Icon(Icons.person_outline_rounded, size: 18, color: BrandColors.muted),
              const SizedBox(width: 8),
              Text('Owner: $_ownerName',
                  style: const TextStyle(fontSize: 13, color: BrandColors.muted)),
            ]),
          ),
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Store name', isDense: true),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<StoreTypeOption>(
          initialValue: _type,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Store type', isDense: true),
          items: kStoreTypeOptions
              .map((o) => DropdownMenuItem(value: o, child: Text(o.label)))
              .toList(),
          onChanged: (v) => setState(() => _type = v ?? kStoreTypeOptions.first),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _footfall,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Daily footfall', isDense: true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _budget,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: const InputDecoration(labelText: 'Monthly budget ₹ (optional)', isDense: true),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        _primaryButton('Continue', _saving ? null : _toLocation),
      ];

  List<Widget> _locationStep() => [
        OutlinedButton.icon(
          onPressed: _detecting ? null : _detect,
          icon: _detecting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.my_location_rounded),
          label: Text(_detecting ? 'Detecting…' : 'Use my location'),
          style: OutlinedButton.styleFrom(
            foregroundColor: BrandColors.primary,
            side: const BorderSide(color: BrandColors.primary),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _address,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Address', isDense: true),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _city,
          decoration: const InputDecoration(labelText: 'City', isDense: true),
        ),
        const SizedBox(height: 20),
        _primaryButton(
          _saving ? 'Creating…' : 'Create & switch',
          _saving ? null : _save,
          loading: _saving,
        ),
      ];

  Widget _primaryButton(String label, VoidCallback? onTap, {bool loading = false}) =>
      SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: BrandColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: loading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      );
}
