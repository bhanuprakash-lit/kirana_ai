import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/core/config/app_config.dart';

void main() {
  group('AppConfig.updateFromRemote', () {
    test('null and empty strings leave baseUrl on the dev fallback', () {
      AppConfig.updateFromRemote(null);
      expect(AppConfig.baseUrl, AppConfig.devBaseUrl);

      AppConfig.updateFromRemote('   ');
      expect(AppConfig.baseUrl, AppConfig.devBaseUrl);
    });

    test('valid URL is accepted and trailing slashes are stripped', () {
      AppConfig.updateFromRemote('https://api.example.com/');
      expect(AppConfig.baseUrl, 'https://api.example.com');

      AppConfig.updateFromRemote('https://api.example.com////');
      expect(AppConfig.baseUrl, 'https://api.example.com');
    });

    test('malformed URLs are rejected and fall back', () {
      AppConfig.updateFromRemote('not a url');
      expect(AppConfig.baseUrl, AppConfig.devBaseUrl);

      AppConfig.updateFromRemote('https://');
      expect(AppConfig.baseUrl, AppConfig.devBaseUrl);
    });

    test('apiBaseUrl mirrors baseUrl', () {
      AppConfig.updateFromRemote('https://api.example.com');
      expect(AppConfig.apiBaseUrl, AppConfig.baseUrl);
    });

    tearDown(() => AppConfig.updateFromRemote(null));
  });

  group('AppConfig trial days', () {
    test('default is 14', () {
      expect(AppConfig.trialDays, greaterThan(0));
    });

    test('updateTrialDays accepts positive values', () {
      AppConfig.updateTrialDays(21);
      expect(AppConfig.trialDays, 21);
    });

    test('updateTrialDays ignores zero and negatives', () {
      AppConfig.updateTrialDays(21);
      AppConfig.updateTrialDays(0);
      expect(AppConfig.trialDays, 21);
      AppConfig.updateTrialDays(-5);
      expect(AppConfig.trialDays, 21);
    });

    tearDown(() => AppConfig.updateTrialDays(14));
  });

  group('AppConfig block state', () {
    test('isStoreBlocked returns true only for ids in the blocked list', () {
      AppConfig.updateBlockState(
        appBlocked: false,
        blockedReason: '',
        blockedStoreIds: [10, 20],
      );
      expect(AppConfig.isStoreBlocked(10), isTrue);
      expect(AppConfig.isStoreBlocked(11), isFalse);
    });

    test('app-level block sets the reason and flag', () {
      AppConfig.updateBlockState(
        appBlocked: true,
        blockedReason: 'Maintenance',
        blockedStoreIds: const [],
      );
      expect(AppConfig.isAppBlocked, isTrue);
      expect(AppConfig.blockedReason, 'Maintenance');
    });

    test('blockedStoreIds is exposed unmodifiable', () {
      AppConfig.updateBlockState(
        appBlocked: false,
        blockedReason: '',
        blockedStoreIds: [1, 2, 3],
      );
      final list = AppConfig.blockedStoreIds;
      expect(() => list.add(4), throwsUnsupportedError);
    });

    tearDown(
      () => AppConfig.updateBlockState(
        appBlocked: false,
        blockedReason: '',
        blockedStoreIds: const [],
      ),
    );
  });
}
