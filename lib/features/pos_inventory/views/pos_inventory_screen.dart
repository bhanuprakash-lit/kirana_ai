import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kirana_ai/shared/widgets/notification_bell.dart';

import '../../../core/theme/brand_theme.dart';
import '../../../shared/widgets/shimmer_widgets.dart';
import '../providers/pos_provider.dart';
import '../providers/printer_provider.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';
import 'inventory_tab.dart';
import 'pos_tab.dart';
import 'tabs/procurement_tab.dart';
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
      if (!_tabController.indexIsChanging) {
        ref
            .read(dashboardSubTabProvider.notifier)
            .setSubTab(_tabController.index);
      }
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

  @override
  Widget build(BuildContext context) {
    final posState = ref.watch(posProvider);
    final posOnline = posState.error == null;
    final printerState = ref.watch(printerProvider);

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
            const Text('POS / Inventory'),
            const SizedBox(width: 8),
            // POS online/offline pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
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
                  Text(
                    posOnline ? 'POS Online' : 'POS Offline',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: posOnline
                          ? BrandColors.success
                          : BrandColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // ── Printer icon (colored by status) ────────────────────────────
          IconButton(
            icon: Icon(
              Icons.print_rounded,
              color: printerState.statusColor,
              size: 22,
            ),
            tooltip: printerState.statusLabel,
            onPressed: _showPrinterPickerSheet,
          ),
          const NotificationBell(),
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
          tabs: const [
            Tab(icon: Icon(Icons.point_of_sale_rounded), text: 'Billing'),
            Tab(icon: Icon(Icons.inventory_2_rounded), text: 'Stock'),
            Tab(icon: Icon(Icons.local_shipping_rounded), text: 'Purchase'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Printer status strip ───────────────────────────────────────────
          _PrinterStatusStrip(onTap: _showPrinterPickerSheet),
          // ── Tab content ───────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const PosTab(),
                const InventoryTab(),
                Consumer(
                  builder: (ctx, ref, _) {
                    final sub = ref.watch(subInfoProvider);
                    if (sub.canAccessVendorManagement)
                      return const ProcurementTab();
                    return _ProGateTab(
                      title: 'Purchase & Suppliers',
                      description:
                          'Create purchase orders, manage your suppliers, and track what you owe them — all in one place.',
                      icon: Icons.local_shipping_rounded,
                      onUpgrade: () => showPaywallSheet(
                        ctx,
                        featureName: 'Purchase & Suppliers',
                        featureDescription:
                            'Manage purchase orders and suppliers. Track payments to distributors. Available on the Pro plan.',
                        featureIcon: Icons.local_shipping_rounded,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Printer status strip (below TabBar) ──────────────────────────────────────

class _PrinterStatusStrip extends ConsumerWidget {
  final VoidCallback onTap;
  const _PrinterStatusStrip({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printer = ref.watch(printerProvider);
    final color = printer.statusColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          border: Border(
            bottom: BorderSide(color: color.withValues(alpha: 0.18), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.print_rounded, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              printer.statusLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 14,
              color: color.withValues(alpha: 0.6),
            ),
          ],
        ),
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
            const SizedBox(height: 12),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
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
                        const Text(
                          'Printer Setup',
                          style: TextStyle(
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
                      label: const Text('Reconnect'),
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
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
                          horizontal: 8,
                          vertical: 3,
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await onForget();
                  },
                  icon: const Icon(Icons.link_off_rounded, size: 15),
                  label: const Text('Forget this printer'),
                  style: TextButton.styleFrom(
                    foregroundColor: BrandColors.error,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PAIRED BLUETOOTH DEVICES',
                  style: TextStyle(
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
                      padding: EdgeInsets.all(20),
                      child: ListShimmer(itemCount: 4, itemHeight: 60),
                    )
                  : printer.pairedDevices.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bluetooth_disabled_rounded,
                              size: 48,
                              color: BrandColors.muted.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No paired devices found',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: BrandColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Pair your thermal printer in Android\nBluetooth settings first, then refresh.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: BrandColors.muted,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () => ref
                                  .read(printerProvider.notifier)
                                  .loadPairedDevices(),
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Refresh'),
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: const Color(0xFF7C3AED)),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PRO ONLY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: const Text('Upgrade to Pro  ₹500/mo · just ₹17/day'),
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
