import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/features/referral/views/referral_scan_sheet.dart';
import 'package:kirana_ai/shared/widgets/notification_bell.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../core/vertical/vertical_config_provider.dart';
import '../../../core/vertical/vertical_copy.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../providers/pos_provider.dart';
import '../providers/printer_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import 'inventory_tab.dart';
// import 'pos_tab.dart';
import 'pos_tab_new.dart';
import 'tabs/procurement_tab.dart';
import 'widgets/today_orders_sheet.dart';
import '../../dashboard/views/dashboard_screen.dart';

class PosInventoryScreen extends ConsumerStatefulWidget {
  const PosInventoryScreen({super.key});

  @override
  ConsumerState<PosInventoryScreen> createState() => _PosInventoryScreenState();
}

class _PosInventoryScreenState extends ConsumerState<PosInventoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = ref.read(dashboardSubTabProvider);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialTab.clamp(0, 2),
    );
    _tabController.addListener(() {
      FocusManager.instance.primaryFocus?.unfocus();
      // Rebuild so AppBar actions (Sales-tab-only menu) track the live tab.
      if (mounted) setState(() {});
      if (!_tabController.indexIsChanging) {
        ref
            .read(dashboardSubTabProvider.notifier)
            .setSubTab(_tabController.index);
      }
    });

    // Initialize Bluetooth contextually when opening POS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(printerProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPrinterPickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PrinterPickerSheet(
        onSelect: (device) async {
          await ref.read(printerProvider.notifier).selectPrinter(device);
        },
        onForget: () async {
          await ref.read(printerProvider.notifier).forgetPrinter();
        },
      ),
    );
    // Trigger device scan as sheet opens
    ref.read(printerProvider.notifier).loadPairedDevices();
  }

  Future<void> _openReferralScanner() async {
    final l10n = AppLocalizations.of(context);
    const prefix = 'KIRANA_REF:';
    String? scannedToken;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.posScanReferralQr,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            backgroundColor: BrandColors.accent,
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue ?? '';
              if (code.startsWith(prefix) && scannedToken == null) {
                scannedToken = code.substring(prefix.length);
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );

    if (!mounted || scannedToken == null) return;

    final pending = await showReferralScanSheet(context, ref, scannedToken!);
    if (!mounted || pending == null) return;

    ref.read(posProvider.notifier).setPendingReferral(pending);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final posState = ref.watch(posProvider);
    final posOnline = posState.error == null;
    final printerState = ref.watch(printerProvider);
    // Sales-tab-only utility actions (Referral / Order History) live here.
    // Use the controller's live index (the provider write-back lags behind
    // swipes because it's gated on !indexIsChanging).
    final onSalesTab = _tabController.index == 0;

    ref.listen(dashboardSubTabProvider, (prev, next) {
      if (next != _tabController.index) {
        _tabController.animateTo(next);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(l10n.dashNavBilling, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            // POS online/offline pill — Flexible so a narrow AppBar (small
            // screens / long translations) shrinks it instead of overflowing.
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: posOnline
                      ? BrandColors.success.withValues(alpha: 0.12)
                      : BrandColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: posOnline
                            ? BrandColors.success
                            : BrandColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        posOnline ? l10n.posOnline : l10n.posOffline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: posOnline
                              ? BrandColors.success
                              : BrandColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          // ── Printer icon with status label below (colored by status) ──────
          Tooltip(
            message: printerState.statusLabel,
            child: InkWell(
              onTap: _showPrinterPickerSheet,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.print_rounded,
                      color: printerState.statusColor,
                      size: 22,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      printerState.statusLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 8,
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: printerState.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const NotificationBell(),
          // ── Sales-tab utility actions — far-right overflow menu (keeps the
          //    AppBar from crowding on small screens / long translations) ─────
          if (onSalesTab)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              tooltip: 'More actions',
              onSelected: (value) {
                switch (value) {
                  case 'referral':
                    _openReferralScanner();
                  case 'history':
                    showTodayOrdersSheet(context, ref);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'referral',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.card_giftcard_rounded,
                      color: BrandColors.accent,
                    ),
                    title: Text('Referral Scan'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.history_rounded),
                    title: Text('Order History'),
                  ),
                ),
              ],
            )
          else
            const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: BrandColors.primary,
          unselectedLabelColor: BrandColors.muted,
          indicatorColor: BrandColors.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          tabs: [
            Tab(
              icon: const Icon(Icons.point_of_sale_rounded),
              text: l10n.posTabSales,
            ),
            Tab(
              icon: const Icon(Icons.inventory_2_rounded),
              // Vertical wording: "Articles" for apparel, "Items" for
              // services/general, "Stock" elsewhere.
              text: vcopy(l10n, verticalConfigOf(ref), VSlot.inventoryTab),
            ),
            Tab(
              icon: const Icon(Icons.local_shipping_rounded),
              text: l10n.posTabPurchase,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const PosTab(),
          const InventoryTab(),
          Consumer(
            builder: (ctx, ref, _) {
              final ctxL10n = AppLocalizations.of(ctx);
              final sub = ref.watch(subInfoProvider);
              if (sub.canAccessVendorManagement) {
                return const ProcurementTab();
              }
              return _ProGateTab(
                title: ctxL10n.posPurchaseSuppliers,
                description: ctxL10n.posPurchaseSuppliersDesc,
                icon: Icons.local_shipping_rounded,
                onUpgrade: () => showPaywallSheet(
                  ctx,
                  featureName: ctxL10n.posPurchaseSuppliers,
                  featureDescription: ctxL10n.posPaywallPurchaseDesc,
                  featureIcon: Icons.local_shipping_rounded,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Printer device picker sheet ───────────────────────────────────────────────

class _PrinterPickerSheet extends ConsumerWidget {
  final Future<void> Function(PrinterDevice) onSelect;
  final Future<void> Function() onForget;

  const _PrinterPickerSheet({required this.onSelect, required this.onForget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final printer = ref.watch(printerProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      expand: false,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // ── Handle ──────────────────────────────────────────────────────
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: BrandColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: BrandColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.print_rounded,
                      color: BrandColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.posPrinterSetup,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          printer.statusLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: printer.statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Reconnect button when not connected
                  if (!printer.isConnected &&
                      printer.selectedPrinter != null &&
                      !printer.isBusy)
                    TextButton.icon(
                      onPressed: () =>
                          ref.read(printerProvider.notifier).reconnect(),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: Text(l10n.posReconnect),
                      style: TextButton.styleFrom(
                        foregroundColor: BrandColors.primary,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),

            // ── Current printer ──────────────────────────────────────────────
            if (printer.selectedPrinter != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: printer.statusColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: printer.statusColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bluetooth_rounded,
                        color: printer.statusColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              printer.selectedPrinter!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              printer.selectedPrinter!.address,
                              style: const TextStyle(
                                fontSize: 11,
                                color: BrandColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: printer.statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          printer.statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: printer.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await onForget();
                  },
                  icon: const Icon(Icons.link_off_rounded, size: 15),
                  label: Text(l10n.posForgetPrinter),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.error,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.posPairedDevices,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: BrandColors.muted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // ── Device list ──────────────────────────────────────────────────
            Expanded(
              child: printer.loadingDevices
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: ListShimmer(itemCount: 4, itemHeight: 60),
                    )
                  : printer.pairedDevices.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bluetooth_disabled_rounded,
                              size: 48,
                              color: BrandColors.muted.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.posNoPairedDevices,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: BrandColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.posPairDeviceHint,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrandColors.muted,
                              ),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(printerProvider.notifier)
                                  .loadPairedDevices(),
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: Text(l10n.posCommonRefresh),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: BrandColors.primary,
                                side: const BorderSide(
                                  color: BrandColors.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: sc,
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                      itemCount: printer.pairedDevices.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final dev = printer.pairedDevices[i];
                        final isCurrent =
                            dev.address == printer.selectedPrinter?.address;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              await onSelect(dev);
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? BrandColors.primary.withValues(
                                        alpha: 0.05,
                                      )
                                    : BrandColors.surfaceTint,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isCurrent
                                      ? BrandColors.primary.withValues(
                                          alpha: 0.3,
                                        )
                                      : BrandColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bluetooth_rounded,
                                    size: 20,
                                    color: isCurrent
                                        ? BrandColors.primary
                                        : BrandColors.muted,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dev.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          dev.address,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: BrandColors.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isCurrent)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: BrandColors.primary,
                                      size: 18,
                                    )
                                  else
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: BrandColors.muted,
                                      size: 18,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pro gate placeholder tab ───────────────────────────────────────────────────

class _ProGateTab extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onUpgrade;

  const _ProGateTab({
    required this.title,
    required this.description,
    required this.icon,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: const Color(0xFF7C3AED)),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
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
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BrandColors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: BrandColors.muted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: Text(l10n.posUpgradeToProDay),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFF7C3AED),
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
    );
  }
}
