import 'dart:ui' show Rect;

import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/vision/counter/counter_engine.dart';
import 'package:kirana_ai/features/vision/counter/simple_tracker.dart';

CounterDetection _det(
  int? id,
  double cx, {
  String cls = 'santoor_soap',
  double conf = 0.9,
}) {
  // A small box centred at cx (normalized). Height/width fixed.
  const w = 0.1, h = 0.2;
  return CounterDetection(
    trackId: id,
    className: cls,
    confidence: conf,
    boxNorm: Rect.fromLTWH(cx - w / 2, 0.4, w, h),
  );
}

void main() {
  group('CounterEngine line crossing', () {
    test('counts a track once when it crosses left→right', () {
      final e = CounterEngine(lineFrac: 0.5);
      expect(e.processFrame([_det(1, 0.2)]), isEmpty); // left of line
      final ev = e.processFrame([_det(1, 0.6)]); // crossed to the right
      expect(ev.length, 1);
      expect(ev.first.className, 'santoor_soap');
      expect(e.totalUnits, 1);
      expect(e.totalSkus, 1);
    });

    test('does not double-count a track lingering in the sold zone', () {
      final e = CounterEngine(lineFrac: 0.5);
      e.processFrame([_det(1, 0.2)]);
      e.processFrame([_det(1, 0.6)]); // counted
      e.processFrame([_det(1, 0.7)]); // still right — no recount
      e.processFrame([_det(1, 0.8)]);
      expect(e.totalUnits, 1);
    });

    test('ignores right→left movement in leftToRight mode', () {
      final e = CounterEngine(lineFrac: 0.5);
      e.processFrame([_det(1, 0.8)]);
      e.processFrame([_det(1, 0.3)]); // moved into normal zone
      expect(e.totalUnits, 0);
    });

    test('counts distinct tracks and different products separately', () {
      final e = CounterEngine(lineFrac: 0.5);
      e.processFrame([
        _det(1, 0.2, cls: 'santoor_soap'),
        _det(2, 0.2, cls: 'red_label_tea_powder'),
      ]);
      final ev = e.processFrame([
        _det(1, 0.6, cls: 'santoor_soap'),
        _det(2, 0.6, cls: 'red_label_tea_powder'),
      ]);
      expect(ev.length, 2);
      expect(e.totalUnits, 2);
      expect(e.totalSkus, 2);
    });

    test('undoLast reverses the most recent count', () {
      final e = CounterEngine(lineFrac: 0.5);
      e.processFrame([_det(1, 0.2)]);
      e.processFrame([_det(1, 0.6)]);
      expect(e.totalUnits, 1);
      final undone = e.undoLast();
      expect(undone, isNotNull);
      expect(e.totalUnits, 0);
      expect(e.isEmpty, isTrue);
    });

    test('detections without a trackId are not counted', () {
      final e = CounterEngine(lineFrac: 0.5);
      e.processFrame([_det(null, 0.2)]);
      e.processFrame([_det(null, 0.6)]);
      expect(e.totalUnits, 0);
    });

    test('avgConfidence averages the counted crossings', () {
      final e = CounterEngine(lineFrac: 0.5);
      e.processFrame([_det(1, 0.2, conf: 0.8)]);
      e.processFrame([_det(1, 0.6, conf: 0.8)]);
      e.processFrame([_det(2, 0.2, conf: 0.6)]);
      e.processFrame([_det(2, 0.6, conf: 0.6)]);
      final entry = e.tally.firstWhere((t) => t.className == 'santoor_soap');
      expect(entry.qty, 2);
      expect(entry.avgConfidence, closeTo(0.7, 1e-9));
    });
  });

  group('SimpleTracker + engine', () {
    test('assigns stable ids so a moving item counts once end-to-end', () {
      final tracker = SimpleTracker();
      final engine = CounterEngine(lineFrac: 0.5);
      // Simulate one soap sliding across the frame over several frames.
      for (final cx in [0.15, 0.30, 0.45, 0.60, 0.75]) {
        const w = 0.1, h = 0.2;
        final tracked = tracker.update([
          TrackerInput(
            Rect.fromLTWH(cx - w / 2, 0.4, w, h),
            'santoor_soap',
            0.9,
          ),
        ]);
        final dets = tracked
            .map(
              (t) => CounterDetection(
                trackId: t.id,
                className: t.className,
                confidence: t.confidence,
                boxNorm: t.box,
              ),
            )
            .toList();
        engine.processFrame(dets);
      }
      expect(engine.totalUnits, 1);
      expect(engine.totalSkus, 1);
    });

    test('tracker keeps two side-by-side items as separate ids', () {
      final tracker = SimpleTracker();
      const w = 0.1, h = 0.2;
      final f1 = tracker.update([
        TrackerInput(const Rect.fromLTWH(0.10, 0.4, w, h), 'a', 0.9),
        TrackerInput(const Rect.fromLTWH(0.70, 0.4, w, h), 'b', 0.9),
      ]);
      expect(f1.length, 2);
      // Next frame, both nudged slightly — ids must persist.
      final f2 = tracker.update([
        TrackerInput(const Rect.fromLTWH(0.13, 0.4, w, h), 'a', 0.9),
        TrackerInput(const Rect.fromLTWH(0.73, 0.4, w, h), 'b', 0.9),
      ]);
      final ids1 = f1.map((t) => t.id).toSet();
      final ids2 = f2.map((t) => t.id).toSet();
      expect(ids2, equals(ids1));
    });
  });
}
