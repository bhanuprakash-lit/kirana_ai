import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/core/services/api_client.dart';
import 'package:kirana_ai/features/finance/providers/finance_provider.dart';

import '../../helpers/fake_api_client.dart';

void main() {
  group('FinanceNotifier', () {
    test('initial build fetches overview + udhaar list', () async {
      final fake = FakeApiClient();
      fake.enqueue('/kirana/finance/overview', {
        'monthly_sales': {'amount': 50000, 'sku_count': 30},
        'udhaar_stats': {
          'total_pending': 2000,
          'total_recovered': 8000,
          'customer_count': 5,
        },
      });
      fake.enqueue('/kirana/finance/udhaar?include_recovered=true', []);

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      final data = await container.read(financeProvider.future);

      expect(data.stats.monthlySalesAmount, 50000.0);
      expect(data.stats.udhaarCustomerCount, 5);
      expect(data.udhaarList, isEmpty);
      expect(
        fake.calls,
        containsAll([
          'GET /kirana/finance/overview',
          'GET /kirana/finance/udhaar?include_recovered=true',
        ]),
      );
    });

    test('addUdhaar posts the correct body shape', () async {
      final fake = FakeApiClient();

      // Initial build()
      fake.enqueue('/kirana/finance/overview', {
        'monthly_sales': {},
        'udhaar_stats': {},
      });
      fake.enqueue('/kirana/finance/udhaar?include_recovered=true', []);
      // addUdhaar's POST
      fake.enqueue('/kirana/finance/udhaar/add', {'ok': true});
      // refresh() after the POST
      fake.enqueue('/kirana/finance/overview', {
        'monthly_sales': {},
        'udhaar_stats': {},
      });
      fake.enqueue('/kirana/finance/udhaar?include_recovered=true', []);

      final container = ProviderContainer(
        overrides: [apiClientProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);

      await container.read(financeProvider.future);

      await container
          .read(financeProvider.notifier)
          .addUdhaar(name: 'Ramesh', phone: '9999999999', amount: 450.0);

      expect(
        fake.postedBodies,
        contains(
          equals({
            'customer_name': 'Ramesh',
            'phone': '9999999999',
            'amount': 450.0,
          }),
        ),
      );
      expect(fake.calls, contains('POST /kirana/finance/udhaar/add'));
    });

    test(
      'recordRecovery hits the recovery endpoint with khata_id + amount',
      () async {
        final fake = FakeApiClient();
        fake.enqueue('/kirana/finance/overview', {
          'monthly_sales': {},
          'udhaar_stats': {},
        });
        fake.enqueue('/kirana/finance/udhaar?include_recovered=true', []);
        fake.enqueue('/kirana/finance/udhaar/recovery', {'ok': true});
        fake.enqueue('/kirana/finance/overview', {
          'monthly_sales': {},
          'udhaar_stats': {},
        });
        fake.enqueue('/kirana/finance/udhaar?include_recovered=true', []);

        final container = ProviderContainer(
          overrides: [apiClientProvider.overrideWithValue(fake)],
        );
        addTearDown(container.dispose);

        await container.read(financeProvider.future);
        await container
            .read(financeProvider.notifier)
            .recordRecovery(42, 200.0);

        expect(
          fake.postedBodies,
          contains(equals({'khata_id': 42, 'amount': 200.0})),
        );
      },
    );
  });
}
