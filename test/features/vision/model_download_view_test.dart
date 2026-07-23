import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/vision/views/widgets/model_download_view.dart';

void main() {
  group('formatBytes', () {
    test('uses KB below a megabyte', () {
      expect(formatBytes(0), '0 MB');
      expect(formatBytes(2048), '2 KB');
    });

    test('keeps one decimal under 10 MB and rounds above', () {
      expect(formatBytes(1024 * 1024), '1.0 MB');
      expect(formatBytes(38624531), '37 MB');
    });

    test('never renders a negative size', () {
      expect(formatBytes(-1), '0 MB');
    });
  });

  group('ShelfStockingLoader', () {
    // The painter does arithmetic on progress (easeOutBack overshoot, per-slot
    // fractions). A bad value there throws inside paint, which in release is a
    // blank screen at exactly the moment the user is waiting on a 38 MB
    // download — so pin the boundaries.
    for (final p in <double?>[null, 0.0, 0.001, 0.5, 0.999, 1.0]) {
      testWidgets('paints without error at progress=$p', (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ShelfStockingLoader(progress: p))),
        );
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
        expect(find.byType(ShelfStockingLoader), findsOneWidget);
      });
    }

    testWidgets('animates without leaking its ticker', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShelfStockingLoader(progress: 0.4)),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      expect(tester.takeException(), isNull);
    });
  });

  group('ModelPercentText', () {
    testWidgets('floors rather than rounds up to a premature 100%', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ModelPercentText(progress: 0.999)),
        ),
      );
      expect(find.text('99%'), findsOneWidget);
    });

    testWidgets('shows a placeholder when the size is unknown', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ModelPercentText(progress: null))),
      );
      expect(find.text('· · ·'), findsOneWidget);
    });
  });

  group('RotatingHint', () {
    testWidgets('advances to the next hint on its own', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RotatingHint(hints: ['first', 'second'])),
        ),
      );
      expect(find.text('first'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('tolerates an empty hint list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: RotatingHint(hints: []))),
      );
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    });
  });
}
