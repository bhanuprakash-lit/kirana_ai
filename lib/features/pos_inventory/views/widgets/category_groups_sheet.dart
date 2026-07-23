import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../models/category_group.dart';
import '../../providers/category_group_provider.dart';

/// Manage the store's category groups (G7).
///
/// The categories offered are the ones this store actually stocks — the global
/// catalog has 135 grocery categories and a shop carries a fraction of them, so
/// listing all of them would bury the ones that matter.
Future<void> showCategoryGroupsSheet(
  BuildContext context,
  WidgetRef ref, {
  required Map<int, String> stockedCategories,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CategoryGroupsSheet(stockedCategories: stockedCategories),
  );
}

class _CategoryGroupsSheet extends ConsumerWidget {
  final Map<int, String> stockedCategories;
  const _CategoryGroupsSheet({required this.stockedCategories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(categoryGroupsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: BrandColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.muted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.invGroupsTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.invGroupsHint,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: BrandColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: async.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '$e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BrandColors.muted),
                    ),
                  ),
                ),
                data: (set) => ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  children: [
                    for (final g in set.groups)
                      _GroupCard(
                        group: g,
                        stockedCategories: stockedCategories,
                        onEdit: () => _editGroup(context, ref, g),
                        onRename: () => _rename(context, ref, g),
                        onDelete: () => _delete(context, ref, g),
                      ),
                    if (set.ungrouped.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                        child: Text(
                          '${l10n.invGroupOther} · ${set.ungrouped.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: BrandColors.muted,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final c in set.ungrouped)
                            Chip(
                              label: Text(
                                c.name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _create(context, ref),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.invGroupNew),
                    ),
                    if (set.customised) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await ref
                              .read(categoryGroupActionsProvider)
                              .resetToDefaults();
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.invGroupSaved)),
                          );
                        },
                        child: Text(
                          l10n.invGroupResetDefaults,
                          style: const TextStyle(color: BrandColors.muted),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    CategoryGroup g,
  ) async {
    final l10n = AppLocalizations.of(context);
    final name = await _askName(context, l10n, initial: g.displayName(l10n));
    if (name == null) return;
    await ref.read(categoryGroupActionsProvider).rename(g.groupId, name);
    if (context.mounted) _toast(context, l10n.invGroupSaved);
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final name = await _askName(context, l10n);
    if (name == null || !context.mounted) return;
    final picked = await _pickCategories(context, l10n, const {});
    if (picked == null) return;
    await ref
        .read(categoryGroupActionsProvider)
        .create(name, picked.toList());
    if (context.mounted) _toast(context, l10n.invGroupSaved);
  }

  Future<void> _editGroup(
    BuildContext context,
    WidgetRef ref,
    CategoryGroup g,
  ) async {
    final l10n = AppLocalizations.of(context);
    final picked = await _pickCategories(context, l10n, g.categoryIds);
    if (picked == null) return;
    await ref
        .read(categoryGroupActionsProvider)
        .setCategories(g.groupId, picked.toList());
    if (context.mounted) _toast(context, l10n.invGroupSaved);
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    CategoryGroup g,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.invGroupDelete),
        // Deleting a group only removes the grouping. The categories and the
        // products in them are shared master data and stay put — say so, or it
        // reads like "delete my stock".
        content: Text('${g.displayName(l10n)}\n\n${l10n.invGroupsHint}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.posCommonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.invGroupDelete,
              style: const TextStyle(color: BrandColors.error),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(categoryGroupActionsProvider).delete(g.groupId);
    if (context.mounted) _toast(context, l10n.invGroupSaved);
  }

  Future<String?> _askName(
    BuildContext context,
    AppLocalizations l10n, {
    String? initial,
  }) async {
    final ctrl = TextEditingController(text: initial ?? '');
    final out = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initial == null ? l10n.invGroupNew : l10n.invGroupRename),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLength: 120,
          decoration: InputDecoration(hintText: l10n.invGroupNameHint),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.posCommonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: Text(l10n.invSave),
          ),
        ],
      ),
    );
    ctrl.dispose();
    final trimmed = out?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  Future<Set<int>?> _pickCategories(
    BuildContext context,
    AppLocalizations l10n,
    Set<int> initial,
  ) {
    final selected = {...initial};
    final entries = stockedCategories.entries.toList()
      ..sort((a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()));
    return showDialog<Set<int>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.invGroupPickCategories),
          content: SizedBox(
            width: double.maxFinite,
            child: entries.isEmpty
                ? Text(l10n.invUncategorised)
                : ListView(
                    shrinkWrap: true,
                    children: [
                      for (final e in entries)
                        CheckboxListTile(
                          dense: true,
                          value: selected.contains(e.key),
                          title: Text(
                            e.value,
                            style: const TextStyle(fontSize: 14),
                          ),
                          onChanged: (v) => setState(() {
                            if (v == true) {
                              selected.add(e.key);
                            } else {
                              selected.remove(e.key);
                            }
                          }),
                        ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.posCommonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: Text(l10n.invSave),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _GroupCard extends StatelessWidget {
  final CategoryGroup group;
  final Map<int, String> stockedCategories;
  final VoidCallback onEdit;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const _GroupCard({
    required this.group,
    required this.stockedCategories,
    required this.onEdit,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Only the categories this store stocks — a group can legitimately list
    // categories the shop doesn't carry, and showing them here reads as clutter.
    final shown = [
      for (final c in group.categories)
        if (stockedCategories.containsKey(c.categoryId)) c.name,
    ]..sort();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: BrandColors.muted.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.displayName(l10n),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${group.stockedProducts}',
                  style: const TextStyle(
                    color: BrandColors.muted,
                    fontSize: 12.5,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'rename') onRename();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(l10n.invGroupPickCategories),
                    ),
                    PopupMenuItem(
                      value: 'rename',
                      child: Text(l10n.invGroupRename),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(l10n.invGroupDelete),
                    ),
                  ],
                ),
              ],
            ),
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 2, top: 2),
                child: Text(
                  l10n.invGroupOther,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 2),
                child: Wrap(
                  spacing: 6,
                  runSpacing: -6,
                  children: [
                    for (final name in shown)
                      Chip(
                        label: Text(
                          name,
                          style: const TextStyle(fontSize: 11.5),
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
