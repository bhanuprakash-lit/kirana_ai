import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

/// Add-store form (name + type→vertical + city). On success, switches to it.
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
  final _name = TextEditingController();
  final _city = TextEditingController();
  StoreTypeOption _type = kStoreTypeOptions.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(storeActionsProvider).addStore(
            storeName: _name.text.trim(),
            storeType: _type.code,
            verticalCode: _type.vertical,
            city: _city.text.trim().isEmpty ? null : _city.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context); // add sheet
        if (Navigator.canPop(context)) Navigator.pop(context); // switcher sheet
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not add store: $e'), backgroundColor: BrandColors.error),
        );
      }
    }
  }

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
            const Text('Add a store',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: BrandColors.ink)),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
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
            TextField(
              controller: _city,
              decoration: const InputDecoration(labelText: 'City (optional)', isDense: true),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrandColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _saving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Create & switch', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
