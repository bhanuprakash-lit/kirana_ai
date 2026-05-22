import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/shared/widgets/primary_button.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  testWidgets('renders the label and fires onPressed when tapped', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(PrimaryButton(label: 'Sign In', onPressed: () => taps++)),
    );

    expect(find.text('Sign In'), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('shows a spinner and hides the label while isLoading', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(PrimaryButton(label: 'Saving', isLoading: true, onPressed: () {})),
    );

    expect(find.text('Saving'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('isLoading disables the button (onPressed not called)', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        PrimaryButton(label: 'Save', isLoading: true, onPressed: () => taps++),
      ),
    );

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(taps, 0);
  });

  testWidgets('null onPressed disables the button', (tester) async {
    await tester.pumpWidget(
      _host(const PrimaryButton(label: 'Save', onPressed: null)),
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });
}
