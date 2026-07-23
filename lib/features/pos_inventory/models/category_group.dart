import '../../../l10n/generated/app_localizations.dart';

/// A store-owned bucket over the shared categories — "Kids & treats" holding
/// chips, biscuits and ice cream (G7).
///
/// Products stay global on purpose: that's what lets one store add a product and
/// every other store scan its barcode and set its own price. Only the *grouping*
/// is per store.
class CategoryGroupMember {
  final int categoryId;
  final String name;

  /// How many products the store actually stocks in this category — not the
  /// global catalog count, which would read as thousands.
  final int stockedProducts;

  const CategoryGroupMember({
    required this.categoryId,
    required this.name,
    this.stockedProducts = 0,
  });

  factory CategoryGroupMember.fromJson(Map<String, dynamic> j) =>
      CategoryGroupMember(
        categoryId: (j['category_id'] as num).toInt(),
        name: (j['name'] ?? '').toString(),
        stockedProducts: (j['stocked_products'] as num?)?.toInt() ?? 0,
      );
}

class CategoryGroup {
  final int groupId;

  /// Server-side name. For a seeded group this is English and should not be
  /// shown directly — see [displayName].
  final String name;

  /// Set only while the group still carries its seeded identity. A DB column
  /// can hold exactly one language, which is why the shipped group names are
  /// translated in the app rather than stored translated (same reasoning that
  /// keeps `copy_pack` empty). Cleared server-side the moment an owner renames
  /// the group, because their wording must then win verbatim.
  final String? seedKey;

  final int sortOrder;

  /// True once this store has forked the vertical defaults.
  final bool isCustom;

  final List<CategoryGroupMember> categories;
  final int stockedProducts;

  const CategoryGroup({
    required this.groupId,
    required this.name,
    this.seedKey,
    this.sortOrder = 0,
    this.isCustom = false,
    this.categories = const [],
    this.stockedProducts = 0,
  });

  factory CategoryGroup.fromJson(Map<String, dynamic> j) => CategoryGroup(
    groupId: (j['group_id'] as num).toInt(),
    name: (j['name'] ?? '').toString(),
    seedKey: (j['seed_key'] as String?)?.trim().isEmpty ?? true
        ? null
        : j['seed_key'] as String,
    sortOrder: (j['sort_order'] as num?)?.toInt() ?? 0,
    isCustom: j['is_custom'] == true,
    categories: ((j['categories'] as List<dynamic>?) ?? const [])
        .whereType<Map>()
        .map((e) => CategoryGroupMember.fromJson(e.cast<String, dynamic>()))
        .toList(),
    stockedProducts: (j['stocked_products'] as num?)?.toInt() ?? 0,
  );

  Set<int> get categoryIds => {for (final c in categories) c.categoryId};

  /// What the owner should read. Falls back to the server name for anything
  /// renamed, custom, or seeded with a key this build doesn't know yet — a
  /// newer server must never render a blank chip on an older app.
  String displayName(AppLocalizations l10n) {
    switch (seedKey) {
      case 'staples_cooking':
        return l10n.catGroupStaplesCooking;
      case 'kids_treats':
        return l10n.catGroupKidsTreats;
      case 'snacks_namkeen':
        return l10n.catGroupSnacksNamkeen;
      case 'beverages':
        return l10n.catGroupBeverages;
      case 'personal_care':
        return l10n.catGroupPersonalCare;
      case 'breakfast_instant':
        return l10n.catGroupBreakfastInstant;
      case 'household_needs':
        return l10n.catGroupHouseholdNeeds;
      case 'dairy_bakery':
        return l10n.catGroupDairyBakery;
      case 'fresh_produce':
        return l10n.catGroupFreshProduce;
      case 'sauces_spreads':
        return l10n.catGroupSaucesSpreads;
      default:
        return name;
    }
  }
}

/// The whole grouped view: the store's groups plus anything it stocks that no
/// group covers. `ungrouped` is not decoration — without it the grouped list
/// silently hides stock, which is how owners learn to distrust the feature.
class CategoryGroupSet {
  final List<CategoryGroup> groups;
  final List<CategoryGroupMember> ungrouped;

  /// False while the store is still on the vertical defaults, so "reset to
  /// defaults" can be offered only when there is something to reset.
  final bool customised;

  const CategoryGroupSet({
    this.groups = const [],
    this.ungrouped = const [],
    this.customised = false,
  });

  factory CategoryGroupSet.fromJson(Map<String, dynamic> j) => CategoryGroupSet(
    groups:
        ((j['groups'] as List<dynamic>?) ?? const [])
            .whereType<Map>()
            .map((e) => CategoryGroup.fromJson(e.cast<String, dynamic>()))
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
    ungrouped: ((j['ungrouped'] as List<dynamic>?) ?? const [])
        .whereType<Map>()
        .map((e) => CategoryGroupMember.fromJson(e.cast<String, dynamic>()))
        .toList(),
    customised: j['customised'] == true,
  );

  bool get isEmpty => groups.isEmpty;

  /// category name -> group, for labelling an inventory row. Names rather than
  /// ids because the inventory list carries `categoryName`, not `categoryId`.
  Map<String, CategoryGroup> byCategoryName() {
    final out = <String, CategoryGroup>{};
    for (final g in groups) {
      for (final c in g.categories) {
        // A category can sit in two groups (chips are both "kids" and
        // "namkeen"). First group by sort order wins the row label, so the
        // list stays stable instead of flickering between headings.
        out.putIfAbsent(c.name, () => g);
      }
    }
    return out;
  }
}
