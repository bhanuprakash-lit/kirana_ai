import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/pos_inventory/models/category_group.dart';
import 'package:kirana_ai/l10n/generated/app_localizations.dart';

Future<AppLocalizations> _l10n(WidgetTester tester, Locale locale) async {
  late AppLocalizations out;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        // `delegates` (plural) so Cupertino locales come along too — the Indic
        // locales aren't in CupertinoLocalizations' own list.
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          out = AppLocalizations.of(context);
          return const SizedBox();
        },
      ),
    ),
  );
  return out;
}

const _payload = {
  'customised': false,
  'groups': [
    {
      'group_id': 2,
      'name': 'Kids & treats',
      'seed_key': 'kids_treats',
      'sort_order': 20,
      'is_custom': false,
      'stocked_products': 3,
      'categories': [
        {'category_id': 10, 'name': 'Chips & Crisps', 'stocked_products': 2},
        {'category_id': 11, 'name': 'Biscuits', 'stocked_products': 1},
      ],
    },
    {
      'group_id': 1,
      'name': 'Household needs',
      'seed_key': 'household_needs',
      'sort_order': 10,
      'is_custom': false,
      'stocked_products': 0,
      'categories': [
        {'category_id': 12, 'name': 'Detergent', 'stocked_products': 0},
      ],
    },
  ],
  'ungrouped': [
    {'category_id': 13, 'name': 'Milk', 'stocked_products': 1},
  ],
};

void main() {
  group('CategoryGroupSet parsing', () {
    test('orders groups by sort_order, not payload order', () {
      final set = CategoryGroupSet.fromJson(Map<String, dynamic>.from(_payload));
      expect(
        set.groups.map((g) => g.name),
        ['Household needs', 'Kids & treats'],
      );
    });

    test('keeps ungrouped stock visible', () {
      final set = CategoryGroupSet.fromJson(Map<String, dynamic>.from(_payload));
      // Stock in no group must still be reachable, or the grouped view
      // silently hides it.
      expect(set.ungrouped.single.name, 'Milk');
      expect(set.customised, isFalse);
    });

    test('maps categories to their group', () {
      final set = CategoryGroupSet.fromJson(Map<String, dynamic>.from(_payload));
      final byName = set.byCategoryName();
      expect(byName['Chips & Crisps']!.seedKey, 'kids_treats');
      expect(byName['Detergent']!.seedKey, 'household_needs');
      expect(byName.containsKey('Milk'), isFalse);
    });

    test('a category in two groups resolves to the earlier-sorted one', () {
      final set = CategoryGroupSet.fromJson({
        'groups': [
          {
            'group_id': 1,
            'name': 'Snacks',
            'sort_order': 30,
            'categories': [
              {'category_id': 10, 'name': 'Chips & Crisps'},
            ],
          },
          {
            'group_id': 2,
            'name': 'Kids',
            'sort_order': 20,
            'categories': [
              {'category_id': 10, 'name': 'Chips & Crisps'},
            ],
          },
        ],
      });
      // Chips are legitimately both; the row label must be stable rather than
      // flip between headings.
      expect(set.byCategoryName()['Chips & Crisps']!.name, 'Kids');
    });

    test('treats a blank seed_key as absent', () {
      final g = CategoryGroup.fromJson({
        'group_id': 1,
        'name': 'My shelf',
        'seed_key': '   ',
        'categories': const [],
      });
      expect(g.seedKey, isNull);
    });

    test('an empty payload is a valid empty set', () {
      final set = CategoryGroupSet.fromJson(const {});
      expect(set.isEmpty, isTrue);
      expect(set.byCategoryName(), isEmpty);
    });
  });

  group('displayName', () {
    testWidgets('seeded groups translate, English', (tester) async {
      final l10n = await _l10n(tester, const Locale('en'));
      final set = CategoryGroupSet.fromJson(Map<String, dynamic>.from(_payload));
      expect(
        set.groups.map((g) => g.displayName(l10n)),
        ['Household needs', 'Kids & treats'],
      );
    });

    testWidgets('seeded groups translate, Telugu', (tester) async {
      final l10n = await _l10n(tester, const Locale('te'));
      final set = CategoryGroupSet.fromJson(Map<String, dynamic>.from(_payload));
      // The DB name is English; a Telugu store must not see it.
      final names = set.groups.map((g) => g.displayName(l10n)).toList();
      expect(names.any((n) => n == 'Kids & treats'), isFalse);
      for (final n in names) {
        expect(n.trim(), isNotEmpty);
      }
    });

    testWidgets('a renamed group shows the owner wording verbatim', (
      tester,
    ) async {
      final l10n = await _l10n(tester, const Locale('te'));
      // Server clears seed_key on rename, so no translation may be substituted.
      final g = CategoryGroup.fromJson({
        'group_id': 5,
        'name': 'Pillala samaan',
        'seed_key': null,
        'is_custom': true,
        'categories': const [],
      });
      expect(g.displayName(l10n), 'Pillala samaan');
    });

    testWidgets('an unknown seed key falls back to the server name', (
      tester,
    ) async {
      final l10n = await _l10n(tester, const Locale('en'));
      // A newer server shipping a group this build doesn't know must render
      // something, never a blank chip.
      final g = CategoryGroup.fromJson({
        'group_id': 9,
        'name': 'Festive picks',
        'seed_key': 'festive_picks_v2',
        'categories': const [],
      });
      expect(g.displayName(l10n), 'Festive picks');
    });
  });
}
