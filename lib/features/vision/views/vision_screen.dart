import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/api_client.dart';
import '../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../pos_inventory/providers/pos_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import '../models/vision_models.dart';
import '../providers/vision_provider.dart';
import '../widgets/item_thumb.dart';
import 'counter_screen.dart';

/// 4th dashboard tab. Pro-gated as a whole (like Procurement). Hosts three
/// sub-tabs: Shelf Scan (morning/evening capture), Results (what sold), and the
/// upcoming live Counter.
class VisionScreen extends ConsumerStatefulWidget {
  const VisionScreen({super.key});

  @override
  ConsumerState<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends ConsumerState<VisionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this, initialIndex: 0);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        ref.read(visionSubTabProvider.notifier).set(_tab.index);
      }
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Keep the TabController in sync with deep-link requests (e.g. notification).
    ref.listen<int>(visionSubTabProvider, (_, next) {
      if (next != _tab.index) _tab.animateTo(next);
    });

    final isPro = ref.watch(subInfoProvider).canAccessVendorManagement;
    if (!isPro) return const _VisionProGate();

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(l10n.visionTitle),
        actions: [
          IconButton(
            tooltip: l10n.visionHistoryTitle,
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _ScanHistoryScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: [
            Tab(text: l10n.visionTabShelf),
            Tab(text: l10n.visionTabResults),
            Tab(text: l10n.visionTabCounter),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [_ShelfTab(), _ResultsTab(), CounterScreen()],
      ),
    );
  }
}

// ── Pro gate ────────────────────────────────────────────────────────────────

class _VisionProGate extends StatelessWidget {
  const _VisionProGate();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.visionTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BrandColors.purple.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.center_focus_strong_rounded,
                  size: 52,
                  color: BrandColors.purple,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: BrandColors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.posProOnly,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.visionProTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.visionProDesc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: BrandColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => showPaywallSheet(
                    context,
                    featureName: l10n.visionProTitle,
                    featureDescription: l10n.visionProDesc,
                    featureIcon: Icons.center_focus_strong_rounded,
                  ),
                  icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                  label: Text(l10n.posUpgradeToProDay),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: BrandColors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shelf tab ───────────────────────────────────────────────────────────────

class _ShelfTab extends ConsumerWidget {
  const _ShelfTab();

  Future<void> _capture(
    BuildContext context,
    WidgetRef ref,
    String type,
  ) async {
    final paths = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CaptureSheet(),
    );
    if (paths == null || paths.isEmpty) return;
    final accepted = await ref
        .read(visionProvider.notifier)
        .capture(type, paths);
    // The upload is done and analysis continues server-side — tell the owner
    // they're free to go; the card tracks progress and a push lands on finish.
    if (accepted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).visionUploadAccepted),
          backgroundColor: BrandColors.success,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(visionProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(visionProvider.notifier).loadToday(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (state.error != null) _ErrorBanner(state.error!),
          _SessionCard(
            title: l10n.visionMorningTitle,
            icon: Icons.wb_sunny_rounded,
            iconColor: BrandColors.orange,
            busy: state.busyMorning,
            session: state.morning,
            onCapture: () => _capture(context, ref, 'morning'),
          ),
          const SizedBox(height: 14),
          _SessionCard(
            title: l10n.visionEveningTitle,
            icon: Icons.nights_stay_rounded,
            iconColor: BrandColors.primary,
            busy: state.busyEvening,
            session: state.evening,
            onCapture: () => _capture(context, ref, 'evening'),
          ),
          const SizedBox(height: 18),
          if (state.canViewSales)
            FilledButton.icon(
              onPressed: () => ref.read(visionSubTabProvider.notifier).set(1),
              icon: const Icon(Icons.bar_chart_rounded),
              label: Text(l10n.visionViewSales),
            ),
          const SizedBox(height: 16),
          Text(
            l10n.visionTip,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: BrandColors.muted),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final bool busy;
  final VisionSession? session;
  final VoidCallback onCapture;

  const _SessionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.busy,
    required this.session,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: BrandColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (session?.isDone ?? false)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: BrandColors.success,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (busy)
              // Photos are uploading — the only phase that holds the owner here.
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      l10n.visionUploading,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ],
                ),
              )
            else if (session != null && session!.isPending) ...[
              // The upload succeeded and analysis is still running on the server
              // (a full photo batch can outlast the in-app poll). Keep the session
              // visible as "processing" with a manual refresh instead of falling
              // through to the blank "no photo yet" state.
              Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.visionStillProcessing,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(visionProvider.notifier).loadToday(),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(l10n.visionCheckAgain),
                ),
              ),
            ] else if (session != null && session!.isFailed) ...[
              Text(
                l10n.visionScanFailed,
                style: const TextStyle(color: BrandColors.error),
              ),
              const SizedBox(height: 8),
              _captureButton(l10n.visionRetake, onCapture),
            ] else if (session != null && session!.isDone) ...[
              _stat(l10n.visionProductsIdentified, '${session!.totalSkus}'),
              _stat(l10n.visionUnitsCounted, '${session!.totalUnits}'),
              if (session!.unknownCount > 0)
                _stat(
                  l10n.visionNeedsReview,
                  '${session!.unknownCount}',
                  color: BrandColors.orange,
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCapture,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(l10n.visionRetake),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _SessionItemsScreen(
                            sessionId: session!.sessionId,
                            photoCount: session!.photoCount,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.fact_check_outlined, size: 16),
                      label: Text(l10n.visionReview),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                l10n.visionNoPhotoYet,
                style: const TextStyle(color: BrandColors.muted),
              ),
              const SizedBox(height: 8),
              _captureButton(l10n.visionTakePhoto, onCapture),
            ],
          ],
        ),
      ),
    );
  }

  Widget _captureButton(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.camera_alt_rounded, size: 18),
      label: Text(label),
    ),
  );

  Widget _stat(String label, String value, {Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: BrandColors.muted),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    ),
  );
}

// ── Capture sheet (collect 3–10 photos) ─────────────────────────────────────

class _CaptureSheet extends StatefulWidget {
  const _CaptureSheet();

  @override
  State<_CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends State<_CaptureSheet> {
  static const _min = 3;
  static const _max = 10;
  final List<String> _paths = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _addCamera() async {
    if (_paths.length >= _max) return;
    final x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
      maxWidth: 1920,
    );
    if (x != null) setState(() => _paths.add(x.path));
  }

  Future<void> _addGallery() async {
    if (_paths.length >= _max) return;
    final xs = await _picker.pickMultiImage(imageQuality: 88, maxWidth: 1920);
    if (xs.isEmpty) return;
    final room = _max - _paths.length;
    setState(() => _paths.addAll(xs.take(room).map((e) => e.path)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final full = _paths.length >= _max;
    final canAnalyze = _paths.length >= _min && _paths.length <= _max;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
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
            Text(
              l10n.visionAddPhotosTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.visionAddPhotosHint,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: BrandColors.muted),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: full ? null : _addCamera,
                    icon: const Icon(Icons.camera_alt_rounded, size: 18),
                    label: Text(l10n.visionFromCamera),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: full ? null : _addGallery,
                    icon: const Icon(Icons.photo_library_rounded, size: 18),
                    label: Text(l10n.visionFromGallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              full
                  ? l10n.visionMaxReached
                  : (_paths.length < _min
                        ? l10n.visionMinPhotosHint
                        : '${_paths.length} / $_max'),
              style: TextStyle(
                fontSize: 12,
                color: _paths.length < _min
                    ? BrandColors.orange
                    : BrandColors.muted,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _paths.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 48,
                        color: BrandColors.muted.withValues(alpha: 0.4),
                      ),
                    )
                  : GridView.builder(
                      controller: sc,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: _paths.length,
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(File(_paths[i]), fit: BoxFit.cover),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () => setState(() => _paths.removeAt(i)),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: canAnalyze
                    ? () => Navigator.pop(context, _paths)
                    : null,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: Text('${l10n.visionAnalyze} (${_paths.length})'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Results tab (sales delta) ───────────────────────────────────────────────

class _ResultsTab extends ConsumerWidget {
  const _ResultsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(visionProvider);

    // Lazily load sales once both scans are ready and we haven't yet.
    if (state.canViewSales && state.sales == null && !state.salesLoading) {
      Future.microtask(() => ref.read(visionProvider.notifier).loadSales());
    }

    if (!state.canViewSales) {
      return _EmptyState(
        icon: Icons.insights_rounded,
        message: l10n.visionSalesEmpty,
      );
    }
    if (state.salesLoading && state.sales == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final sales = state.sales ?? const [];
    if (sales.isEmpty) {
      return _EmptyState(
        icon: Icons.insights_rounded,
        message: l10n.visionSalesEmpty,
      );
    }
    final totalSold = sales.fold<int>(0, (a, b) => a + b.sold);

    return RefreshIndicator(
      onRefresh: () => ref.read(visionProvider.notifier).loadSales(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sales.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BrandColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.visionTotalSold,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: BrandColors.ink,
                    ),
                  ),
                  Text(
                    '$totalSold',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: BrandColors.success,
                    ),
                  ),
                ],
              ),
            );
          }
          final item = sales[i - 1];
          return _SalesTile(item);
        },
      ),
    );
  }
}

class _SalesTile extends StatelessWidget {
  final SalesDeltaItem item;
  const _SalesTile(this.item);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: BrandColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: BrandColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.visionMorningCount} ${item.morningCount}  ·  '
                  '${l10n.visionEveningCount} ${item.eveningCount}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.sold}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.success,
                ),
              ),
              Text(
                l10n.visionSold,
                style: const TextStyle(fontSize: 10, color: BrandColors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Session items + correction ──────────────────────────────────────────────

class _SessionItemsScreen extends ConsumerStatefulWidget {
  final int sessionId;
  final int photoCount;
  const _SessionItemsScreen({required this.sessionId, this.photoCount = 0});

  @override
  ConsumerState<_SessionItemsScreen> createState() =>
      _SessionItemsScreenState();
}

class _SessionItemsScreenState extends ConsumerState<_SessionItemsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(visionProvider.notifier).loadItems(widget.sessionId),
    );
  }

  Future<void> _correct(VisionItem item) async {
    final productId = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CorrectionSheet(item: item),
    );
    // Sentinel: -1 means "clear correction"; null means dismissed.
    if (productId == null) return;
    await ref
        .read(visionProvider.notifier)
        .correctItem(
          widget.sessionId,
          item.itemId,
          productId == -1 ? null : productId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(visionProvider).items[widget.sessionId];

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.visionReview)),
      body: items == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length + (widget.photoCount > 0 ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                if (widget.photoCount > 0 && index == 0) {
                  return _SessionPhotosStrip(
                    sessionId: widget.sessionId,
                    photoCount: widget.photoCount,
                  );
                }
                final i = index - (widget.photoCount > 0 ? 1 : 0);
                final it = items[i];
                return ListTile(
                  tileColor: BrandColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: BrandColors.border),
                  ),
                  leading: VisionItemThumb(
                    itemId: it.itemId,
                    size: 48,
                    fallbackIcon: it.needsReview
                        ? Icons.help_outline_rounded
                        : Icons.check_circle_rounded,
                    fallbackColor: it.needsReview
                        ? BrandColors.orange
                        : BrandColors.success,
                  ),
                  title: Text(
                    it.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: it.needsReview
                      ? Text(
                          l10n.visionUnknownItem,
                          style: const TextStyle(color: BrandColors.orange),
                        )
                      : (it.isCorrected
                            ? Text(
                                l10n.visionCorrected,
                                style: const TextStyle(
                                  color: BrandColors.success,
                                ),
                              )
                            : null),
                  trailing: Text(
                    '×${it.count}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onTap: () => _correct(it),
                );
              },
            ),
    );
  }
}

class _CorrectionSheet extends ConsumerStatefulWidget {
  final VisionItem item;
  const _CorrectionSheet({required this.item});

  @override
  ConsumerState<_CorrectionSheet> createState() => _CorrectionSheetState();
}

class _CorrectionSheetState extends ConsumerState<_CorrectionSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = ref.watch(posProvider).products;
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? products.take(40).toList()
        : products
              .where(
                (p) =>
                    p.name.toLowerCase().contains(q) ||
                    (p.brand?.toLowerCase().contains(q) ?? false),
              )
              .take(40)
              .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
              Text(
                l10n.visionCorrectTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.item.label,
                style: const TextStyle(fontSize: 12, color: BrandColors.muted),
              ),
              const SizedBox(height: 12),
              VisionItemThumb(
                itemId: widget.item.itemId,
                size: 128,
                fallbackIcon: Icons.image_not_supported_outlined,
                fallbackColor: BrandColors.muted,
              ),
              const SizedBox(height: 12),
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: l10n.visionSearchProducts,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 8),
              if (widget.item.isCorrected)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context, -1),
                    icon: const Icon(Icons.undo_rounded, size: 16),
                    label: Text(l10n.visionClearCorrection),
                  ),
                ),
              Expanded(
                child: products.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.visionNoProducts,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: BrandColors.muted),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: sc,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final p = filtered[i];
                          return ListTile(
                            dense: true,
                            title: Text(
                              p.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => Navigator.pop(context, p.productId),
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

// ── Scan history ────────────────────────────────────────────────────────────

/// Every past shelf scan (morning/evening/onboarding) with its status, photos
/// and results — nothing is discarded just because the owner left the screen.
class _ScanHistoryScreen extends ConsumerStatefulWidget {
  const _ScanHistoryScreen();

  @override
  ConsumerState<_ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends ConsumerState<_ScanHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(visionProvider.notifier).loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(visionProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(title: Text(l10n.visionHistoryTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(visionProvider.notifier).loadHistory(),
        child: state.historyLoading && state.history.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.history.isEmpty
            ? ListView(
                children: [
                  const SizedBox(height: 120),
                  _EmptyState(
                    icon: Icons.history_rounded,
                    message: l10n.visionHistoryEmpty,
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.history.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _HistoryTile(state.history[i]),
              ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final VisionSession s;
  const _HistoryTile(this.s);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMorning = s.sessionType == 'morning';
    final isOnboarding = s.sessionType == 'onboarding';
    final typeLabel = isOnboarding
        ? l10n.visionHistoryStockIn
        : (isMorning ? l10n.visionMorningTitle : l10n.visionEveningTitle);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: BrandColors.border),
      ),
      child: ListTile(
        leading: Icon(
          isOnboarding
              ? Icons.add_business_rounded
              : (isMorning ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded),
          color: isOnboarding
              ? BrandColors.purple
              : (isMorning ? BrandColors.orange : BrandColors.primary),
        ),
        title: Text(
          '$typeLabel · ${s.sessionDate}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          s.isDone
              ? '${s.totalSkus} ${l10n.visionProductsIdentified} · '
                    '${s.totalUnits} ${l10n.visionUnitsCounted} · '
                    '${s.photoCount} ${l10n.visionPhotos}'
              : '${s.photoCount} ${l10n.visionPhotos}',
          style: const TextStyle(fontSize: 11, color: BrandColors.muted),
        ),
        trailing: _StatusChip(status: s.status),
        onTap: s.isDone || s.photoCount > 0
            ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _SessionItemsScreen(
                    sessionId: s.sessionId,
                    photoCount: s.photoCount,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (status) {
      'done' => (l10n.visionStatusDone, BrandColors.success),
      'failed' => (l10n.visionStatusFailed, BrandColors.error),
      _ => (l10n.visionStatusProcessing, BrandColors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

/// The photos the owner uploaded for one scan — small authed thumbnails, tap
/// for full screen. Photos may be gone for very old scans (pre-durable-storage);
/// those tiles just show a placeholder.
class _SessionPhotosStrip extends StatelessWidget {
  final int sessionId;
  final int photoCount;
  const _SessionPhotosStrip({
    required this.sessionId,
    required this.photoCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.visionPhotos} ($photoCount)',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photoCount,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => _PhotoViewer(sessionId: sessionId, index: i),
              ),
              child: _SessionPhoto(
                sessionId: sessionId,
                index: i,
                size: 84,
                thumb: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SessionPhoto extends StatelessWidget {
  final int sessionId;
  final int index;
  final double size;
  final bool thumb;
  const _SessionPhoto({
    required this.sessionId,
    required this.index,
    required this.size,
    required this.thumb,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      color: BrandColors.muted.withValues(alpha: 0.08),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: BrandColors.muted,
        size: size * 0.4,
      ),
    );
    final url =
        '${AppConfig.apiBaseUrl}/kirana/vision/session/$sessionId/photo/$index'
        '${thumb ? '?thumb=1' : ''}';
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: FutureBuilder<String?>(
          future: ApiClient.mediaAuthToken(),
          builder: (_, snap) {
            final token = snap.data;
            if (token == null) return fallback;
            return Image.network(
              url,
              headers: {'Authorization': 'Bearer $token'},
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => fallback,
              loadingBuilder: (ctx, child, progress) =>
                  progress == null ? child : fallback,
            );
          },
        ),
      ),
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  final int sessionId;
  final int index;
  const _PhotoViewer({required this.sessionId, required this.index});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          InteractiveViewer(
            child: Center(
              child: _SessionPhoto(
                sessionId: sessionId,
                index: index,
                size: double.infinity,
                thumb: false,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared bits ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 52,
              color: BrandColors.muted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: BrandColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BrandColors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrandColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: BrandColors.error,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, color: BrandColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
