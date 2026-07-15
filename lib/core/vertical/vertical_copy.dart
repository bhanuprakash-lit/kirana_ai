import '../../l10n/generated/app_localizations.dart';
import 'vertical_config.dart';

/// V0.2 — vertical-aware UI wording.
///
/// The app ships in 7 languages, so vertical copy lives in the ARBs (one
/// entry per slot × vertical where the wording actually differs), NOT in the
/// backend `copy_pack` — a DB string can only ever be one language.
///
/// Resolution order for a slot:
///  1. `copy_pack[slot.key]` — emergency server override (kept for back-compat;
///     packs are empty today and should stay that way except for hotfixes),
///  2. the vertical-specific ARB string,
///  3. the generic string the app always used.
///
/// Footwear intentionally reuses the apparel wording (same trade language).
enum VSlot {
  /// Add-product sheet title. Legacy copy_pack key: `add_title`.
  addTitle('add_title'),

  /// Product-name field hint in the add sheet + search surfaces.
  /// Legacy copy_pack key: `search_hint`.
  searchHint('search_hint'),

  /// Empty-inventory title. Legacy copy_pack key: `empty_inventory`.
  emptyInventoryTitle('empty_inventory'),

  /// Empty-inventory explanatory hint.
  emptyInventoryHint('empty_inventory_hint'),

  /// The Billing screen's inventory sub-tab label.
  inventoryTab('inventory_tab');

  final String key;
  const VSlot(this.key);
}

/// [fallback] overrides the slot's default generic string — for call sites
/// whose grocery wording differs from the slot's usual one (e.g. the
/// inventory search bar says "items or categories", not "product name").
String vcopy(
  AppLocalizations l10n,
  VerticalConfig vc,
  VSlot slot, {
  String? fallback,
}) {
  // 1. Server override (single-language — emergency use only).
  final override = vc.copyPack[slot.key];
  if (override is String && override.trim().isNotEmpty) return override;

  // 2. Vertical-specific ARB string.
  final specific = _verticalString(l10n, vc.verticalCode, slot);
  if (specific != null) return specific;

  // 3. Generic.
  return fallback ?? _genericString(l10n, slot);
}

String _genericString(AppLocalizations l10n, VSlot slot) {
  switch (slot) {
    case VSlot.addTitle:
      return l10n.invAddProduct;
    case VSlot.searchHint:
      return l10n.invSearchProductName;
    case VSlot.emptyInventoryTitle:
      return l10n.invNoInventoryYet;
    case VSlot.emptyInventoryHint:
      return l10n.invNoInventoryHint;
    case VSlot.inventoryTab:
      return l10n.posTabStock;
  }
}

String? _verticalString(AppLocalizations l10n, String verticalCode, VSlot slot) {
  // Footwear shares apparel's trade language; grocery keeps the generics.
  final code = verticalCode == 'footwear' ? 'apparel' : verticalCode;
  switch (code) {
    case 'services':
      switch (slot) {
        case VSlot.addTitle:
          return l10n.vcopyServicesAddTitle;
        case VSlot.searchHint:
          return l10n.vcopyServicesSearchHint;
        case VSlot.emptyInventoryTitle:
          return l10n.vcopyServicesEmptyTitle;
        case VSlot.emptyInventoryHint:
          return l10n.vcopyServicesEmptyHint;
        case VSlot.inventoryTab:
          return l10n.vcopyServicesInvTab;
      }
    case 'electronics':
      switch (slot) {
        case VSlot.addTitle:
          return l10n.vcopyElectronicsAddTitle;
        case VSlot.searchHint:
          return l10n.vcopyElectronicsSearchHint;
        case VSlot.emptyInventoryTitle:
          return l10n.vcopyElectronicsEmptyTitle;
        case VSlot.emptyInventoryHint:
          return l10n.vcopyElectronicsEmptyHint;
        case VSlot.inventoryTab:
          return l10n.vcopyElectronicsInvTab;
      }
    case 'apparel':
      switch (slot) {
        case VSlot.addTitle:
          return l10n.vcopyApparelAddTitle;
        case VSlot.searchHint:
          return l10n.vcopyApparelSearchHint;
        case VSlot.emptyInventoryTitle:
          return l10n.vcopyApparelEmptyTitle;
        case VSlot.emptyInventoryHint:
          return l10n.vcopyApparelEmptyHint;
        case VSlot.inventoryTab:
          return l10n.vcopyApparelInvTab;
      }
    case 'optical':
      switch (slot) {
        case VSlot.addTitle:
          return l10n.vcopyOpticalAddTitle;
        case VSlot.searchHint:
          return l10n.vcopyOpticalSearchHint;
        case VSlot.emptyInventoryTitle:
          return l10n.vcopyOpticalEmptyTitle;
        case VSlot.emptyInventoryHint:
          return l10n.vcopyOpticalEmptyHint;
        case VSlot.inventoryTab:
          return l10n.vcopyOpticalInvTab;
      }
    case 'general':
      switch (slot) {
        case VSlot.addTitle:
          return l10n.vcopyGeneralAddTitle;
        case VSlot.searchHint:
          return l10n.vcopyGeneralSearchHint;
        case VSlot.emptyInventoryTitle:
          return l10n.vcopyGeneralEmptyTitle;
        case VSlot.emptyInventoryHint:
          return l10n.vcopyGeneralEmptyHint;
        case VSlot.inventoryTab:
          return l10n.vcopyGeneralInvTab;
      }
  }
  return null;
}
