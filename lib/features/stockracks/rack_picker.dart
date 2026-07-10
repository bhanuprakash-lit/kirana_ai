import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/api_client.dart';
import '../../core/theme/brand_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'rack_data.dart';

/// Shared rack selector: pick one of the store's racks, or type a new label to
/// create it on the spot. Typing a variant of an existing label ("a 1" while
/// "A1" exists) surfaces the existing rack instead of creating a duplicate.
/// Returns the chosen [StoreRack], or null if dismissed.
Future<StoreRack?> showRackPicker(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<StoreRack>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _RackPicker(),
  );
}

class _RackPicker extends ConsumerStatefulWidget {
  const _RackPicker();

  @override
  ConsumerState<_RackPicker> createState() => _RackPickerState();
}

class _RackPickerState extends ConsumerState<_RackPicker> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _creating = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _addRack(String label) async {
    setState(() => _creating = true);
    try {
      final res = await createRack(ref.read(apiClientProvider), label);
      ref.invalidate(storeRacksProvider);
      if (mounted) Navigator.pop(context, res.rack);
    } catch (_) {
      if (mounted) {
        setState(() => _creating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).rackSaveFailed),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final racks = ref.watch(storeRacksProvider).asData?.value ?? const [];
    final typedKey = rackLabelKey(_query);
    final filtered = typedKey.isEmpty
        ? racks
        : racks.where((r) => rackLabelKey(r.label).contains(typedKey)).toList();
    // Exact normalized match means the typed label IS an existing rack — offer
    // that rack, never a duplicate.
    final exact = typedKey.isEmpty
        ? null
        : racks.where((r) => rackLabelKey(r.label) == typedKey).firstOrNull;
    final canAdd = typedKey.isNotEmpty && exact == null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
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
                    const Icon(
                      Icons.shelves,
                      size: 20,
                      color: BrandColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.rackChooseRack,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: l10n.rackSearchRacks,
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
                child: ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    if (canAdd)
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: BrandColors.primary,
                        ),
                        title: Text(
                          l10n.rackAddAs(rackDisplayLabel(_query)),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: BrandColors.primary,
                            fontSize: 14,
                          ),
                        ),
                        trailing: _creating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
                        onTap: _creating ? null : () => _addRack(_query),
                      ),
                    if (racks.isEmpty && !canAdd)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.rackNoRacksYet,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      ),
                    for (final r in filtered)
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          Icons.shelves,
                          size: 20,
                          color: r.id == exact?.id
                              ? BrandColors.primary
                              : BrandColors.muted,
                        ),
                        title: Text(
                          r.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: r.id == exact?.id
                            ? Text(
                                l10n.rackAlreadyExists(r.label),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: BrandColors.primary,
                                ),
                              )
                            : null,
                        trailing: Text(
                          '${r.items} ${l10n.rackItems}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: BrandColors.muted,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, r),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
