import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/onboarding/utils/username_validator.dart';

void main() {
  group('UsernameRules.evaluate', () {
    test('empty / whitespace-only → empty', () {
      expect(UsernameRules.evaluate(''), UsernameStatus.empty);
      expect(UsernameRules.evaluate('   '), UsernameStatus.empty);
    });

    test('shorter than 3 → tooShort', () {
      expect(UsernameRules.evaluate('a'), UsernameStatus.tooShort);
      expect(UsernameRules.evaluate('ab'), UsernameStatus.tooShort);
    });

    test('longer than 30 → tooLong', () {
      expect(UsernameRules.evaluate('a' * 31), UsernameStatus.tooLong);
      expect(UsernameRules.evaluate('a' * 30), UsernameStatus.valid);
    });

    test('disallowed characters → invalidChars', () {
      expect(UsernameRules.evaluate('lohiya store'), UsernameStatus.invalidChars); // space
      expect(UsernameRules.evaluate('lohiya-store'), UsernameStatus.invalidChars); // hyphen
      expect(UsernameRules.evaluate('store@1'), UsernameStatus.invalidChars); // symbol
      expect(UsernameRules.evaluate('café99'), UsernameStatus.invalidChars); // unicode
    });

    test('letters, digits, underscore, mixed case → valid', () {
      expect(UsernameRules.evaluate('lohiyastore123'), UsernameStatus.valid);
      expect(UsernameRules.evaluate('Lohiya_Store_99'), UsernameStatus.valid);
      expect(UsernameRules.evaluate('___'), UsernameStatus.valid);
      expect(UsernameRules.evaluate('ABC'), UsernameStatus.valid);
    });

    test('surrounding whitespace is trimmed before evaluating', () {
      expect(UsernameRules.evaluate('  shop_1  '), UsernameStatus.valid);
    });

    test('isValid convenience matches evaluate', () {
      expect(UsernameRules.isValid('good_name'), isTrue);
      expect(UsernameRules.isValid('no'), isFalse);
      expect(UsernameRules.isValid('bad name'), isFalse);
    });
  });
}
