import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/dashboard/models/overview_models.dart';
import '../../features/dashboard/providers/overview_provider.dart';
import '../../features/finance/providers/finance_provider.dart';
import '../../features/pos_inventory/providers/inventory_provider.dart';
import '../../features/pos_inventory/providers/procurement_provider.dart';
import '../../features/support/providers/notification_provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../locale/locale_provider.dart';

/// Feeds the Android home-screen widget (the medium 4-stat grid) and routes
/// taps back into the app. The widget renders a snapshot the app writes — it
/// never calls the API itself. All labels/numbers are pushed already localized
/// + formatted, so the widget matches the in-app language. See the native
/// `KiranaWidgetProvider`.
class HomeWidgetService {
  static const _qualifiedAndroidName =
      'com.lohiya.kirana_ai.KiranaWidgetProvider';

  // iOS: the App Group both the app and the widget extension share, and the
  // WidgetKit kind to reload. No-ops on Android. See docs/IOS_WIDGET_SETUP.md.
  static const _appGroupId = 'group.com.lohiya.kiranaAi';
  static const _iosWidgetName = 'KiranaMediumWidget';

  /// Register tap handling (call once at startup, before runApp's first frame).
  static Future<void> init() async {
    await HomeWidget.setAppGroupId(
      _appGroupId,
    ); // iOS shared storage; no-op on Android
    HomeWidget.widgetClicked.listen(_handleUri);
    _handleUri(await HomeWidget.initiallyLaunchedFromHomeWidget());
  }

  static void _handleUri(Uri? uri) {
    if (uri == null) return;
    final q = uri.queryParameters;
    final nav = <String, String>{'route': '/home'};
    if (q['tab'] != null) nav['tab'] = q['tab']!;
    if (q['subtab'] != null) nav['subtab'] = q['subtab']!;
    if (q['action'] != null) nav['action'] = q['action']!;
    setPendingNavigation(nav);
  }

  /// Rebuild and push the snapshot. Pass [fetch] = true to force-load the four
  /// providers (used when the app goes to background, so the widget is complete
  /// even if some tabs were never opened); false reads last-known state cheaply.
  static Future<void> update(WidgetRef ref, {bool fetch = false}) async {
    try {
      // Ensure writes land in the iOS shared App Group before saving (no-op on Android).
      await HomeWidget.setAppGroupId(_appGroupId);
      final prefs = await SharedPreferences.getInstance();
      final l10n = lookupAppLocalizations(ref.read(localeProvider));

      if (prefs.getInt('user_id') == null) {
        await _saveLoggedOut(l10n.widgetSignIn);
        return;
      }

      final hide = prefs.getBool('widget_hide_amounts') ?? false;

      OverviewData? overview;
      FinanceData? finance;
      InventoryData? inventory;
      ProcurementData? procurement;
      if (fetch) {
        final r = await Future.wait([
          _guard(() => ref.read(overviewProvider.future)),
          _guard(() => ref.read(financeProvider.future)),
          _guard(() => ref.read(inventoryProvider.future)),
          _guard(() => ref.read(procurementProvider.future)),
        ]);
        overview = r[0] as OverviewData?;
        finance = r[1] as FinanceData?;
        inventory = r[2] as InventoryData?;
        procurement = r[3] as ProcurementData?;
      } else {
        overview = ref.read(overviewProvider).asData?.value;
        finance = ref.read(financeProvider).asData?.value;
        inventory = ref.read(inventoryProvider).asData?.value;
        procurement = ref.read(procurementProvider).asData?.value;
      }

      if (overview == null &&
          finance == null &&
          inventory == null &&
          procurement == null) {
        await _saveLoggedOut(l10n.widgetNoData);
        return;
      }

      // ── Today's Sales ─────────────────────────────────────────────────────
      final ds = overview?.dailySales;
      final salesValue = ds != null ? _inr(ds.totalSales, hide) : '—';
      final salesSub = ds != null
          ? '${ds.totalOrders} ${l10n.widgetUnitOrders}'
          : '';

      // ── Udhaar Due ────────────────────────────────────────────────────────
      final pending = (finance?.udhaarList ?? const []).where(
        (u) => !u.isRecovered,
      );
      final overdueCount = pending.where((u) => u.daysPending > 30).length;
      final udhaarValue = finance != null
          ? _inr(finance.stats.totalUdhaarPending, hide)
          : '—';
      final udhaarSub = finance == null
          ? ''
          : overdueCount > 0
          ? '$overdueCount ${l10n.widgetUnitOverdue}'
          : '${pending.length} ${l10n.widgetUnitPending}';

      // ── Low Stock ─────────────────────────────────────────────────────────
      final items = inventory?.items ?? const [];
      final lowCount = items
          .where((i) => i.isLowStock || i.isOutOfStock)
          .length;
      final stockValue = inventory != null ? '$lowCount' : '—';
      final stockCritical = items.any((i) => i.isOutOfStock);

      // ── Pay Today (supplier dues) ─────────────────────────────────────────
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final unpaid = (procurement?.purchases ?? const []).where(
        (p) => p.paymentStatus != 'paid' && p.dueDate != null,
      );
      final dueToday = unpaid.where((p) => _sameDay(p.dueDate!, now)).toList();
      final overdue = unpaid.where((p) => p.dueDate!.isBefore(today)).toList();
      String supplierValue;
      String supplierSub;
      bool supplierAlert;
      if (dueToday.isNotEmpty) {
        supplierValue = _inr(
          dueToday.fold<double>(0, (s, p) => s + p.totalAmount),
          hide,
        );
        supplierSub = '${dueToday.length} ${l10n.widgetUnitToPay}';
        supplierAlert = false;
      } else if (overdue.isNotEmpty) {
        supplierValue = _inr(
          overdue.fold<double>(0, (s, p) => s + p.totalAmount),
          hide,
        );
        supplierSub = '${overdue.length} ${l10n.widgetUnitOverdue}';
        supplierAlert = true;
      } else {
        supplierValue = procurement != null ? _inr(0, hide) : '—';
        supplierSub = '';
        supplierAlert = false;
      }

      await Future.wait([
        _set('logged_in', 'true'),
        _set('updated_at', DateFormat.jm().format(now)),
        _set('sales_label', l10n.widgetTitleSales),
        _set('sales_value', salesValue),
        _set('sales_sub', salesSub),
        _set('udhaar_label', l10n.widgetTitleUdhaar),
        _set('udhaar_value', udhaarValue),
        _set('udhaar_sub', udhaarSub),
        _set('udhaar_alert', '${overdueCount > 0}'),
        _set('stock_label', l10n.widgetTitleLowStock),
        _set('stock_value', stockValue),
        _set('stock_sub', l10n.widgetUnitItems),
        _set('stock_alert', '$stockCritical'),
        _set('supplier_label', l10n.widgetTitlePayToday),
        _set('supplier_value', supplierValue),
        _set('supplier_sub', supplierSub),
        _set('supplier_alert', '$supplierAlert'),
        _set('newbill_label', l10n.widgetNewBill),
      ]);
      await _push();
    } catch (_) {
      // Widget is best-effort; never let it surface an error to the app.
    }
  }

  static Future<void> _saveLoggedOut(String msg) async {
    await _set('logged_in', 'false');
    await _set('empty_msg', msg);
    await _push();
  }

  static Future<bool?> _set(String key, String value) =>
      HomeWidget.saveWidgetData<String>(key, value);

  static Future<bool?> _push() => HomeWidget.updateWidget(
    qualifiedAndroidName: _qualifiedAndroidName,
    iOSName: _iosWidgetName,
  );

  static String _inr(num v, bool hide) {
    if (hide) return '••••';
    return '₹${NumberFormat.decimalPattern('en_IN').format(v.round())}';
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static Future<T?> _guard<T>(Future<T> Function() f) async {
    try {
      return await f();
    } catch (_) {
      return null;
    }
  }
}
