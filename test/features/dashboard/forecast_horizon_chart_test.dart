import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/dashboard/views/widgets/forecast_horizon_chart.dart';
import 'package:kirana_ai/l10n/generated/app_localizations.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
  await tester.pumpAndSettle();
}

String _fmt(ForecastMetric m, double v) =>
    m == ForecastMetric.revenue ? '₹${v.round()}' : v.round().toString();

List<ForecastBar> _bars({
  List<double> values = const [100, 300, 500, 700, 900, 1200],
  bool allLoaded = true,
}) {
  const horizons = [1, 3, 5, 7, 14, 30];
  return [
    for (var i = 0; i < horizons.length; i++)
      ForecastBar(
        horizonDays: horizons[i],
        label: horizons[i] == 1 ? 'Tmrw' : '${horizons[i]}d',
        value: values[i],
        hasData: allLoaded || i < 2,
      ),
  ];
}

void main() {
  group('ForecastHorizonChart', () {
    testWidgets('renders one labelled bar per horizon', (tester) async {
      await _pump(
        tester,
        ForecastHorizonChart(
          bars: _bars(),
          metric: ForecastMetric.revenue,
          selectedHorizon: 7,
          onSelect: (_) {},
          format: _fmt,
        ),
      );
      for (final label in ['Tmrw', '3d', '5d', '7d', '14d', '30d']) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('₹1200'), findsOneWidget);
    });

    testWidgets('tapping a bar reports its horizon', (tester) async {
      int? tapped;
      await _pump(
        tester,
        ForecastHorizonChart(
          bars: _bars(),
          metric: ForecastMetric.units,
          selectedHorizon: 1,
          onSelect: (d) => tapped = d,
          format: _fmt,
        ),
      );
      await tester.tap(find.text('14d'));
      expect(tapped, 14);
    });

    testWidgets('an all-zero forecast does not divide by zero', (tester) async {
      // A store with no history forecasts zeros; the chart must still lay out.
      await _pump(
        tester,
        ForecastHorizonChart(
          bars: _bars(values: const [0, 0, 0, 0, 0, 0]),
          metric: ForecastMetric.revenue,
          selectedHorizon: 1,
          onSelect: (_) {},
          format: _fmt,
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('₹0'), findsNWidgets(6));
    });

    testWidgets('a horizon still loading shows a dash, not a zero', (
      tester,
    ) async {
      // Drawing 0 would read as "no sales expected" rather than "not known yet".
      await _pump(
        tester,
        ForecastHorizonChart(
          bars: _bars(allLoaded: false),
          metric: ForecastMetric.revenue,
          selectedHorizon: 1,
          onSelect: (_) {},
          format: _fmt,
        ),
      );
      expect(find.text('—'), findsNWidgets(4));
    });

    testWidgets('handles a single huge outlier without overflowing', (
      tester,
    ) async {
      await _pump(
        tester,
        ForecastHorizonChart(
          bars: _bars(values: const [1, 1, 1, 1, 1, 9999999]),
          metric: ForecastMetric.revenue,
          selectedHorizon: 30,
          onSelect: (_) {},
          format: _fmt,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('ForecastMetricChips', () {
    testWidgets('offers every metric and reports the choice', (tester) async {
      ForecastMetric? picked;
      await _pump(
        tester,
        ForecastMetricChips(
          selected: ForecastMetric.revenue,
          onSelect: (m) => picked = m,
        ),
      );
      expect(find.byType(ChoiceChip), findsNWidgets(4));
      await tester.tap(find.text('Stock-out risk'));
      expect(picked, ForecastMetric.stockouts);
    });

    testWidgets('metric labels translate', (tester) async {
      await _pump(
        tester,
        ForecastMetricChips(selected: ForecastMetric.revenue, onSelect: (_) {}),
        locale: const Locale('hi'),
      );
      expect(find.text('Revenue'), findsNothing);
      expect(find.byType(ChoiceChip), findsNWidgets(4));
    });
  });
}
