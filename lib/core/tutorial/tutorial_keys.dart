import 'package:flutter/widgets.dart';

/// Global anchor keys the guided tours spotlight. Screens attach these to the
/// real widgets ("the actual Add-product button"), so a tour step highlights —
/// and lets the owner tap — the exact control he'll use every day after.
///
/// Each key must be attached to at most one mounted widget at a time. Anchors
/// live on distinct screens/sheets, so that holds by construction; a missing
/// anchor simply drops its step (the overlay skips unmounted targets).
class TutorialKeys {
  TutorialKeys._();

  // Bottom navigation (dashboard_screen.dart)
  static final navHome = GlobalKey(debugLabel: 'tut_nav_home');
  static final navKhata = GlobalKey(debugLabel: 'tut_nav_khata');
  static final navBilling = GlobalKey(debugLabel: 'tut_nav_billing');
  static final navVision = GlobalKey(debugLabel: 'tut_nav_vision');

  // Home tab (overview_tab.dart)
  static final homeChecklist = GlobalKey(debugLabel: 'tut_home_checklist');
  static final homeTodaySales = GlobalKey(debugLabel: 'tut_home_today');

  // POS tab (postab.dart / orderfooter.dart)
  static final posSearch = GlobalKey(debugLabel: 'tut_pos_search');
  static final posCustomer = GlobalKey(debugLabel: 'tut_pos_customer');
  static final posOrder = GlobalKey(debugLabel: 'tut_pos_order');

  // Order sheet (order_dialog.dart)
  static final payMethods = GlobalKey(debugLabel: 'tut_pay_methods');
  static final payConfirm = GlobalKey(debugLabel: 'tut_pay_confirm');

  // Inventory tab (inventory_tab.dart / add_product_sheet_new)
  static final invAddFab = GlobalKey(debugLabel: 'tut_inv_add_fab');
  static final invCatalogSearch = GlobalKey(debugLabel: 'tut_inv_catalog');
  static final invPrice = GlobalKey(debugLabel: 'tut_inv_price');
  static final invStock = GlobalKey(debugLabel: 'tut_inv_stock');
  static final invSave = GlobalKey(debugLabel: 'tut_inv_save');
}
