import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/finance/models/finance_models.dart';

void main() {
  group('FinanceStats.fromJson', () {
    test('parses the nested backend shape', () {
      final s = FinanceStats.fromJson({
        'monthly_sales': {'amount': 125000.50, 'sku_count': 87},
        'udhaar_stats': {
          'total_pending': 4500,
          'total_recovered': 12000,
          'customer_count': 8,
        },
      });
      expect(s.monthlySalesAmount, 125000.50);
      expect(s.monthlySkuCount, 87);
      expect(s.totalUdhaarPending, 4500.0);
      expect(s.totalUdhaarRecovered, 12000.0);
      expect(s.udhaarCustomerCount, 8);
    });

    test('zero-defaults every field when nested objects are missing', () {
      final s = FinanceStats.fromJson({});
      expect(s.monthlySalesAmount, 0.0);
      expect(s.monthlySkuCount, 0);
      expect(s.totalUdhaarPending, 0.0);
      expect(s.totalUdhaarRecovered, 0.0);
      expect(s.udhaarCustomerCount, 0);
    });
  });

  group('UdhaarItem.fromJson', () {
    test('isRecovered is true when balance is zero or negative', () {
      final paid = UdhaarItem.fromJson({
        'khata_id': 1,
        'customer_id': 1,
        'customer_name': 'Ramesh',
        'phone': '9999999999',
        'balance': 0,
        'date_taken': '2026-05-01T10:00:00',
        'days_pending': 21,
      });
      expect(paid.isRecovered, isTrue);
    });

    test('isRecovered is false for any positive balance', () {
      final pending = UdhaarItem.fromJson({
        'khata_id': 2,
        'customer_id': 2,
        'customer_name': 'Lakshmi',
        'phone': '9999999998',
        'balance': 450,
        'date_taken': '2026-05-15T10:00:00',
        'days_pending': 7,
      });
      expect(pending.isRecovered, isFalse);
      expect(pending.balance, 450.0);
    });

    test('falls back to "Unknown" when customer_name is missing', () {
      final item = UdhaarItem.fromJson({
        'khata_id': 3,
        'customer_id': 3,
        'balance': 100,
        'date_taken': '2026-05-15T10:00:00',
        'days_pending': 1,
      });
      expect(item.customerName, 'Unknown');
    });
  });
}
