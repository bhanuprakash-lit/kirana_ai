import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../models/association_model.dart';
import '../providers/association_provider.dart';

class AssociationScreen extends ConsumerWidget {
  const AssociationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(
          title: Text(
            l10n.mktAreaAssociations,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.mktMyAreas),
              Tab(text: l10n.mktCustomerHeatmap),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showAddSheet(context, ref),
            ),
          ],
        ),
        body: const TabBarView(children: [_AssociationsTab(), _HeatmapTab()]),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAssociationSheet(ref: ref),
    );
  }
}

// ── Associations list tab ─────────────────────────────────────────────────────

class _AssociationsTab extends ConsumerWidget {
  const _AssociationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(associationProvider);
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: ListShimmer(itemCount: 5),
      ),
      error: (e, _) =>
          Center(child: Text(l10n.mktErrorWithMessage(e.toString()))),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🏘️', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.mktNoAreasAddedYet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.mktAreasEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: BrandColors.muted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => _AddAssociationSheet(ref: ref),
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.mktAddFirstArea),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () => ref.read(associationProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) => _AssociationTile(
              assoc: list[i],
              onDelete: () => _confirmDelete(context, ref, list[i]),
              onToggle: () =>
                  ref.read(associationProvider.notifier).toggleActive(list[i]),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    StoreAssociation assoc,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mktRemoveAreaTitle),
        content: Text(l10n.mktRemoveAreaConfirm(assoc.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.mktCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: BrandColors.error),
            child: Text(l10n.mktRemove),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(associationProvider.notifier).delete(assoc.associationId);
    }
  }
}

class _AssociationTile extends StatelessWidget {
  final StoreAssociation assoc;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  const _AssociationTile({
    required this.assoc,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: BrandColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              assoc.areaType.emoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        title: Text(
          assoc.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assoc.areaType.label,
              style: const TextStyle(color: BrandColors.muted, fontSize: 12),
            ),
            if (assoc.estimatedHouseholds != null)
              Text(
                l10n.mktHouseholdsCount(assoc.estimatedHouseholds!),
                style: const TextStyle(color: BrandColors.muted, fontSize: 11),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: assoc.isActive,
              onChanged: (_) => onToggle(),
              activeThumbColor: BrandColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: BrandColors.muted,
                size: 20,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Heatmap tab ───────────────────────────────────────────────────────────────

class _HeatmapTab extends ConsumerWidget {
  const _HeatmapTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(heatmapProvider);
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: ListShimmer(itemCount: 5),
      ),
      error: (e, _) =>
          Center(child: Text(l10n.mktErrorWithMessage(e.toString()))),
      data: (rows) {
        if (rows.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📊', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.mktNoHeatmapDataYet,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.mktHeatmapEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: BrandColors.muted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final maxRevenue = rows.fold<double>(
          0,
          (m, r) => r.totalRevenue > m ? r.totalRevenue : m,
        );

        return RefreshIndicator.adaptive(
          onRefresh: () => ref.read(heatmapProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  l10n.mktLast90DaysByRevenue,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...rows.map((r) => _HeatmapRow(row: r, maxRevenue: maxRevenue)),
            ],
          ),
        );
      },
    );
  }
}

class _HeatmapRow extends StatelessWidget {
  final AssociationHeatmap row;
  final double maxRevenue;
  const _HeatmapRow({required this.row, required this.maxRevenue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pct = maxRevenue > 0
        ? (row.totalRevenue / maxRevenue).clamp(0.0, 1.0)
        : 0.0;
    final hasData = row.totalOrders > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(row.areaType.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.areaName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      row.areaType.label,
                      style: const TextStyle(
                        color: BrandColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasData)
                Text(
                  '₹${row.totalRevenue.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: BrandColors.primary,
                  ),
                ),
            ],
          ),
          if (hasData) ...[
            const SizedBox(height: 10),
            // Revenue bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: BrandColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  BrandColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatChip('👥 ${row.customerCount}', l10n.mktCustomers),
                const SizedBox(width: 12),
                _StatChip('🛒 ${row.totalOrders}', l10n.mktOrders),
                const SizedBox(width: 12),
                _StatChip(
                  '₹${row.avgOrderValue.toStringAsFixed(0)}',
                  l10n.mktAvgOrder,
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              l10n.mktNoOrdersYetTagCustomers,
              style: const TextStyle(fontSize: 11, color: BrandColors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: BrandColors.muted),
        ),
      ],
    );
  }
}

// ── Add Association sheet ─────────────────────────────────────────────────────

class _AddAssociationSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AddAssociationSheet({required this.ref});

  @override
  State<_AddAssociationSheet> createState() => _AddAssociationSheetState();
}

class _AddAssociationSheetState extends State<_AddAssociationSheet> {
  final _nameCtrl = TextEditingController();
  final _hhCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  AreaType _selectedType = AreaType.apartment;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hhCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    try {
      await widget.ref
          .read(associationProvider.notifier)
          .add(
            name: name,
            areaType: _selectedType,
            estimatedHouseholds: int.tryParse(_hhCtrl.text.trim()),
            notes: _notesCtrl.text.trim().isEmpty
                ? null
                : _notesCtrl.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.mktErrorWithMessage(e.toString())),
            backgroundColor: BrandColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.mktAddNearbyArea,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),

            // Area type chips
            Text(
              l10n.mktAreaType,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AreaType.values.map((t) {
                final selected = _selectedType == t;
                return GestureDetector(
                  onTap: () => setState(() => _selectedType = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? BrandColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? BrandColors.primary
                            : BrandColors.border,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.emoji),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            t.label,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: selected ? Colors.white : BrandColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.mktAreaNameLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hhCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.mktEstimatedHouseholdsOptional,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesCtrl,
              decoration: InputDecoration(
                labelText: l10n.mktNotesOptional,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: BrandColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.mktAddArea,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
