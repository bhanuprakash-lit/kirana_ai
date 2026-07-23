import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/dashboard/models/forecast_model.dart';
import 'package:kirana_ai/features/dashboard/providers/forecast_provider.dart';
import 'package:kirana_ai/features/dashboard/views/widgets/forecast_strip.dart';
import 'package:kirana_ai/l10n/generated/app_localizations.dart';

const _storeId = 7;
const _notReady = 'Forecast is still learning';

ForecastSummary _summary(double tomorrowUnits) => ForecastSummary(
  storeId: _storeId,
  horizons: {
    '1d': ForecastHorizon(
      label: 'Tomorrow',
      predictedUnits: tomorrowUnits,
      revenue: tomorrowUnits * 70,
      revenueLow: 0,
      revenueHigh: 0,
    ),
  },
  dataStale: false,
);

/// Takes the summary-producing callback rather than a prebuilt override —
/// riverpod's `Override` type isn't part of the public surface to name here.
Future<void> _pump(
  WidgetTester tester,
  Future<ForecastSummary> Function() create,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        forecastSummaryProvider(_storeId).overrideWith((_) => create()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: ForecastStrip(storeId: _storeId)),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('ForecastStrip degrades instead of disappearing', () {
    testWidgets('on a zero forecast', (tester) async {
      // This used to return SizedBox.shrink(), which hid the only route to the
      // forecast screen with no explanation.
      await _pump(tester, () async => _summary(0));
      expect(find.text(_notReady), findsOneWidget);
      // Still tappable — the screen explains itself better than an absent card.
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('on a missing 1d horizon', (tester) async {
      await _pump(
        tester,
        () async => const ForecastSummary(
          storeId: _storeId,
          horizons: {},
          dataStale: true,
        ),
      );
      expect(find.text(_notReady), findsOneWidget);
    });

    testWidgets('on an error — the summary 503s before the first train', (
      tester,
    ) async {
      await _pump(tester, () async => throw Exception('503'));
      // The rejection lands a microtask later than the first frame.
      await tester.pump();
      // Riverpod reports the provider failure to the zone; consume it so the
      // binding doesn't fail the test for an error the widget handles.
      tester.takeException();
      expect(find.text(_notReady), findsOneWidget);
    });

    testWidgets('but renders nothing while the first fetch is in flight', (
      tester,
    ) async {
      // A placeholder that appears and is instantly replaced reads as a glitch.
      // The future is left pending on purpose: completing it would render the
      // animated card, whose flutter_animate timer outlives the binding.
      final pending = Completer<ForecastSummary>();
      await _pump(tester, () => pending.future);
      expect(find.text(_notReady), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('shows a real forecast rather than the learning state', (
      tester,
    ) async {
      await _pump(tester, () async => _summary(16));
      expect(find.text(_notReady), findsNothing);
      // Drain the fade so its timer doesn't outlive the binding.
      await tester.pumpAndSettle();
    });
  });
}
