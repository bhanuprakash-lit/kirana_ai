import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/shared/widgets/brand_text_field.dart';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  testWidgets('renders the label and forwards text to the controller', (
    tester,
  ) async {
    final ctrl = TextEditingController();
    await tester.pumpWidget(
      _host(BrandTextField(controller: ctrl, label: 'Phone number')),
    );

    expect(find.text('Phone number'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '9876543210');
    expect(ctrl.text, '9876543210');
  });

  testWidgets('obscureText hides the entered characters', (tester) async {
    final ctrl = TextEditingController();
    await tester.pumpWidget(
      _host(
        BrandTextField(controller: ctrl, label: 'Password', obscureText: true),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);
  });

  testWidgets('inputFormatters restrict invalid characters', (tester) async {
    final ctrl = TextEditingController();
    await tester.pumpWidget(
      _host(
        BrandTextField(
          controller: ctrl,
          label: 'OTP',
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'abc1234567');
    expect(ctrl.text, '123456'); // letters stripped, capped at 6
  });

  testWidgets('validator runs inside a Form and surfaces the error', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final ctrl = TextEditingController();

    await tester.pumpWidget(
      _host(
        Form(
          key: formKey,
          child: BrandTextField(
            controller: ctrl,
            label: 'Username',
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Username is required' : null,
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);
    await tester.pump();
    expect(find.text('Username is required'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'lohiyastore');
    expect(formKey.currentState!.validate(), isTrue);
  });

  testWidgets('renders prefix and suffix widgets when provided', (
    tester,
  ) async {
    final ctrl = TextEditingController();
    await tester.pumpWidget(
      _host(
        BrandTextField(
          controller: ctrl,
          label: 'Phone',
          prefix: const Text('+91', key: ValueKey('prefix')),
          suffix: const Icon(Icons.visibility, key: ValueKey('suffix')),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('prefix')), findsOneWidget);
    expect(find.byKey(const ValueKey('suffix')), findsOneWidget);
  });
}
