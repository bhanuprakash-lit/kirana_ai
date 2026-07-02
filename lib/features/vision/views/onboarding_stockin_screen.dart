import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../pos_inventory/providers/pos_provider.dart';
import '../providers/onboarding_provider.dart';

/// Bulk stock-in: photograph shelves in-app → detect products → confirm
/// quantities → add to inventory. Launched from the empty-inventory CTA.
/// Pops `true` once stock has been committed so the caller can refresh.
class OnboardingStockInScreen extends ConsumerStatefulWidget {
  /// When set (e.g. opened from the "results ready" notification), resume that
  /// session straight into review instead of starting a fresh capture.
  final int? resumeSessionId;

  /// true = existing store restocking (detected quantities ADD to current stock);
  /// false = onboarding an empty store (quantities SET the opening stock).
  final bool addToExisting;
  const OnboardingStockInScreen({
    super.key,
    this.resumeSessionId,
    this.addToExisting = false,
  });

  @override
  ConsumerState<OnboardingStockInScreen> createState() =>
      _OnboardingStockInScreenState();
}

class _OnboardingStockInScreenState
    extends ConsumerState<OnboardingStockInScreen> {
  static const _min = 3;
  static const _max = 10;
  final List<String> _paths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(onboardingProvider.notifier);
      if (widget.resumeSessionId != null) {
        notifier.resumeSession(widget.resumeSessionId!); // deep-link → straight to review
      } else {
        notifier.reset(); // fresh capture flow
      }
    });
  }

  Future<void> _addPhoto() async {
    if (_paths.length >= _max) return;
    final x = await _picker.pickImage(
      source: ImageSource.camera, // in-app capture only — no gallery
      imageQuality: 88,
      maxWidth: 1920,
    );
    if (x != null) setState(() => _paths.add(x.path));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);

    return PopScope(
      canPop: state.status != OnboardingStatus.committing,
      child: Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(title: Text(l10n.onbCaptureTitle)),
        body: switch (state.status) {
          OnboardingStatus.idle => _CaptureBody(
            paths: _paths,
            onAdd: _addPhoto,
            onRemove: (i) => setState(() => _paths.removeAt(i)),
            onAnalyze: _paths.length >= _min
                ? () => ref.read(onboardingProvider.notifier).analyze(_paths)
                : null,
          ),
          OnboardingStatus.uploading ||
          OnboardingStatus.processing => const _ProcessingBody(),
          OnboardingStatus.ready ||
          OnboardingStatus.committing => _ReviewBody(
            committing: state.status == OnboardingStatus.committing,
            addToExisting: widget.addToExisting,
          ),
          OnboardingStatus.done => _DoneBody(
            products: state.committedProducts,
            units: state.committedQuantity,
            onDone: () => Navigator.pop(context, true),
          ),
          OnboardingStatus.failed => _FailedBody(onRetake: () {
            setState(_paths.clear);
            ref.read(onboardingProvider.notifier).reset();
          }),
        },
      ),
    );
  }
}

// ── Capture ───────────────────────────────────────────────────────────────────

class _CaptureBody extends StatelessWidget {
  final List<String> paths;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback? onAnalyze;
  const _CaptureBody({
    required this.paths,
    required this.onAdd,
    required this.onRemove,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.onbCaptureHint,
                  style: const TextStyle(color: BrandColors.muted, height: 1.5)),
              const SizedBox(height: 16),
              if (paths.isEmpty)
                _EmptyCapture(onAdd: onAdd)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: paths.length + (paths.length < 10 ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == paths.length) {
                      return _AddTile(onAdd: onAdd);
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(File(paths[i]), fit: BoxFit.cover),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => onRemove(i),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.black54, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close_rounded,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  paths.length < 3
                      ? l10n.onbMinPhotos
                      : l10n.onbPhotosProgress(paths.length),
                  style: TextStyle(
                    fontSize: 12,
                    color: paths.length < 3 ? BrandColors.orange : BrandColors.muted,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onAnalyze,
                    style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52)),
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: Text(l10n.onbAnalyze),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyCapture extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyCapture({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: BrandColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: BrandColors.primary.withValues(alpha: 0.3),
              style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_rounded, size: 48, color: BrandColors.primary),
            const SizedBox(height: 12),
            Text(l10n.onbTakePhoto,
                style: const TextStyle(
                    color: BrandColors.primary, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  final VoidCallback onAdd;
  const _AddTile({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        decoration: BoxDecoration(
          color: BrandColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BrandColors.primary.withValues(alpha: 0.3)),
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: BrandColors.primary),
      ),
    );
  }
}

// ── Processing ────────────────────────────────────────────────────────────────

class _ProcessingBody extends StatelessWidget {
  const _ProcessingBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 56, height: 56,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 24),
            Text(l10n.onbProcessingTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: BrandColors.ink)),
            const SizedBox(height: 10),
            Text(l10n.onbProcessingDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: BrandColors.muted, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

// ── Review ────────────────────────────────────────────────────────────────────

class _ReviewBody extends ConsumerWidget {
  final bool committing;
  final bool addToExisting;
  const _ReviewBody({required this.committing, required this.addToExisting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    if (state.items.isEmpty) {
      return _FailedBody(
        message: l10n.onbEmptyDetected,
        onRetake: () => notifier.reset(),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            _DisclaimerBanner(text: l10n.onbReviewDisclaimer),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Text(l10n.onbReviewSummary(state.mappedCount, state.unmappedCount),
                      style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: state.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final item = state.items[i];
                  return _ReviewTile(
                    item: item,
                    onQty: (q) => notifier.setQuantity(item.itemId, q),
                    onMap: () => _pickProduct(context, ref, item.itemId),
                    onRemove: () => notifier.removeItem(item.itemId),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: committing || state.committable.isEmpty
                        ? null
                        : () async {
                            final ok = await notifier.commit(addToExisting: addToExisting);
                            if (!ok && context.mounted && state.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(ref.read(onboardingProvider).error ?? '')),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: BrandColors.success,
                    ),
                    icon: const Icon(Icons.inventory_2_rounded),
                    label: Text(committing ? l10n.onbCommitting : l10n.onbCommit),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (committing)
          Container(
            color: Colors.black.withValues(alpha: 0.15),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Future<void> _pickProduct(BuildContext context, WidgetRef ref, int itemId) async {
    final picked = await showModalBottomSheet<({int id, String name})>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ProductPickerSheet(),
    );
    if (picked != null) {
      ref.read(onboardingProvider.notifier).mapProduct(itemId, picked.id, picked.name);
    }
  }
}

class _DisclaimerBanner extends StatelessWidget {
  final String text;
  const _DisclaimerBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BrandColors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.orange.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: BrandColors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 12, color: BrandColors.ink, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final OnboardingReviewItem item;
  final void Function(int) onQty;
  final VoidCallback onMap;
  final VoidCallback onRemove;
  const _ReviewTile({
    required this.item,
    required this.onQty,
    required this.onMap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final needsMap = item.needsMapping;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BrandColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: needsMap ? BrandColors.orange.withValues(alpha: 0.4) : BrandColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: BrandColors.ink)),
                const SizedBox(height: 4),
                if (needsMap)
                  GestureDetector(
                    onTap: onMap,
                    child: Row(
                      children: [
                        const Icon(Icons.add_link_rounded, size: 14, color: BrandColors.orange),
                        const SizedBox(width: 4),
                        Text(l10n.onbChooseProduct,
                            style: const TextStyle(fontSize: 12, color: BrandColors.orange, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                else
                  Text('${l10n.onbQuantity}: ${item.quantity}',
                      style: const TextStyle(fontSize: 12, color: BrandColors.muted)),
              ],
            ),
          ),
          _Stepper(qty: item.quantity, onChanged: onQty),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int qty;
  final void Function(int) onChanged;
  const _Stepper({required this.qty, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _sqBtn(Icons.remove_rounded, () => onChanged(qty - 1)),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text('$qty',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        _sqBtn(Icons.add_rounded, () => onChanged(qty + 1)),
      ],
    );
  }

  Widget _sqBtn(IconData icon, VoidCallback onTap) => Material(
    color: BrandColors.primary.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: BrandColors.primary),
      ),
    ),
  );
}

class _ProductPickerSheet extends ConsumerStatefulWidget {
  const _ProductPickerSheet();
  @override
  ConsumerState<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends ConsumerState<_ProductPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = ref.watch(posProvider).products;
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? products.take(40).toList()
        : products
            .where((p) =>
                p.name.toLowerCase().contains(q) ||
                (p.brand?.toLowerCase().contains(q) ?? false))
            .take(40)
            .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        expand: false,
        builder: (_, sc) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(l10n.onbChooseProduct,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.visionSearchProducts,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: products.isEmpty
                    ? Center(child: Text(l10n.visionNoProducts,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: BrandColors.muted)))
                    : ListView.builder(
                        controller: sc,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final p = filtered[i];
                          return ListTile(
                            dense: true,
                            title: Text(p.displayName,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () =>
                                Navigator.pop(context, (id: p.productId, name: p.displayName)),
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

// ── Done / Failed ─────────────────────────────────────────────────────────────

class _DoneBody extends StatelessWidget {
  final int products;
  final int units;
  final VoidCallback onDone;
  const _DoneBody({required this.products, required this.units, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: BrandColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, size: 56, color: BrandColors.success),
            ),
            const SizedBox(height: 20),
            Text(l10n.onbDoneTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: BrandColors.ink)),
            const SizedBox(height: 10),
            Text(l10n.onbDoneDesc(products, units),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: BrandColors.muted, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onDone,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                child: Text(l10n.onbDone),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailedBody extends StatelessWidget {
  final VoidCallback onRetake;
  final String? message;
  const _FailedBody({required this.onRetake, this.message});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 52, color: BrandColors.error.withValues(alpha: 0.7)),
            const SizedBox(height: 16),
            Text(message == null ? l10n.onbFailedTitle : l10n.onbFailedTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: BrandColors.ink)),
            const SizedBox(height: 8),
            Text(message ?? l10n.onbEmptyDetected,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: BrandColors.muted)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetake,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.onbRetake),
            ),
          ],
        ),
      ),
    );
  }
}
