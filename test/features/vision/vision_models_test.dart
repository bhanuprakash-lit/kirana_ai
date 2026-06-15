import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/vision/models/vision_models.dart';

void main() {
  group('VisionSession.fromJson', () {
    test('parses fields and status helpers', () {
      final s = VisionSession.fromJson({
        'session_id': 5,
        'session_type': 'morning',
        'session_date': '2026-06-14',
        'status': 'done',
        'total_skus': 12,
        'total_units': 40,
        'unknown_count': 2,
        'created_at': '2026-06-14T08:00:00Z',
      });
      expect(s.sessionId, 5);
      expect(s.isMorning, true);
      expect(s.isDone, true);
      expect(s.isPending, false);
      expect(s.totalUnits, 40);
      expect(s.unknownCount, 2);
    });

    test('defaults are safe when fields are missing', () {
      final s = VisionSession.fromJson({'session_id': 1});
      expect(s.status, 'pending');
      expect(s.isPending, true);
      expect(s.totalSkus, 0);
      expect(s.sessionType, 'morning');
    });
  });

  group('VisionItem.fromJson', () {
    test('label prefers matched display name, else gemini name', () {
      final matched = VisionItem.fromJson({
        'item_id': 1,
        'product_id': 9,
        'display_name': 'Tata Salt 1kg',
        'gemini_name': 'tata salt',
        'count': 3,
        'is_unknown': false,
      });
      expect(matched.label, 'Tata Salt 1kg');
      expect(matched.needsReview, false);

      final unknown = VisionItem.fromJson({
        'item_id': 2,
        'gemini_name': 'mystery box',
        'is_unknown': true,
      });
      expect(unknown.label, 'mystery box');
      expect(unknown.productId, isNull);
      expect(unknown.needsReview, true);
    });

    test('corrected item is no longer "needs review"', () {
      final it = VisionItem.fromJson({
        'item_id': 3,
        'gemini_name': 'x',
        'is_unknown': true,
        'corrected_product_id': 42,
      });
      expect(it.isCorrected, true);
      expect(it.needsReview, false);
    });
  });

  group('SalesDeltaItem.fromJson', () {
    test('parses morning/evening/sold', () {
      final d = SalesDeltaItem.fromJson({
        'product_id': 7,
        'display_name': 'Maggi Noodles',
        'morning_count': 10,
        'evening_count': 4,
        'sold': 6,
      });
      expect(d.productId, 7);
      expect(d.sold, 6);
      expect(d.morningCount, 10);
      expect(d.eveningCount, 4);
    });
  });
}
