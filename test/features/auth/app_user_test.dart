import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/auth/models/app_user.dart';

void main() {
  group('AppUser.fromJson', () {
    test('parses a complete payload', () {
      final user = AppUser.fromJson({
        'user_id': 42,
        'username': 'ramesh',
        'full_name': 'Ramesh Kumar',
        'role': 'store_owner',
        'store_id': 10,
      });

      expect(user.userId, 42);
      expect(user.username, 'ramesh');
      expect(user.fullName, 'Ramesh Kumar');
      expect(user.role, 'store_owner');
      expect(user.storeId, 10);
    });

    test('falls back to username when full_name is missing', () {
      final user = AppUser.fromJson({
        'user_id': 1,
        'username': 'fallback_user',
      });
      expect(user.fullName, 'fallback_user');
    });

    test('defaults role to store_owner when missing', () {
      final user = AppUser.fromJson({'user_id': 1, 'username': 'x'});
      expect(user.role, 'store_owner');
    });

    test('store_id is nullable', () {
      final user = AppUser.fromJson({'user_id': 1, 'username': 'x'});
      expect(user.storeId, isNull);
    });
  });

  group('AppUser.toPrefs', () {
    test('round-trips all fields', () {
      const user = AppUser(
        userId: 7,
        username: 'lakshmi',
        fullName: 'Lakshmi Stores',
        role: 'admin',
        storeId: 22,
      );
      expect(user.toPrefs(), {
        'user_id': 7,
        'username': 'lakshmi',
        'full_name': 'Lakshmi Stores',
        'role': 'admin',
        'store_id': 22,
      });
    });
  });

  group('AuthResult.fromJson', () {
    test('extracts token and nested user', () {
      final result = AuthResult.fromJson({
        'access_token': 'abc.def.ghi',
        'user': {'user_id': 1, 'username': 'shop'},
      });
      expect(result.accessToken, 'abc.def.ghi');
      expect(result.user.username, 'shop');
    });
  });
}
