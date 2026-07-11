import 'dart:ui' show Rect;

import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/vision/counter/simple_tracker.dart';

Rect box(double cx, {double cy = 0.5, double w = 0.2, double h = 0.2}) =>
    Rect.fromCenter(center: Offset(cx, cy), width: w, height: h);

void main() {
  group('SimpleTracker robustness', () {
    test('a track survives many missed frames (shake / blur)', () {
      final t = SimpleTracker(maxAge: 24);
      final id = t.update([TrackerInput(box(0.3), 'tea', 0.9)]).single.id;

      // 20 empty frames — the camera shook and the detector saw nothing.
      for (var i = 0; i < 20; i++) {
        expect(t.update(const []), isEmpty);
      }

      // Item re-detected nearby → SAME identity, not a new track.
      final back = t.update([TrackerInput(box(0.34), 'tea', 0.9)]).single;
      expect(back.id, id);
    });

    test('track dies only past maxAge', () {
      final t = SimpleTracker(maxAge: 5);
      final id = t.update([TrackerInput(box(0.3), 'tea', 0.9)]).single.id;
      for (var i = 0; i < 6; i++) {
        t.update(const []);
      }
      final again = t.update([TrackerInput(box(0.3), 'tea', 0.9)]).single;
      expect(again.id, isNot(id)); // aged out ⇒ new identity
    });

    test('weak detections extend a track but never start one', () {
      final t = SimpleTracker(minNewTrackConfidence: 0.4);

      // A weak detection alone: no track at all.
      expect(t.update([TrackerInput(box(0.3), 'tea', 0.3)]), isEmpty);

      // A confident detection starts the track…
      final id = t.update([TrackerInput(box(0.3), 'tea', 0.8)]).single.id;

      // …and a weak follow-up keeps its identity alive (sticky tracking).
      final weak = t.update([TrackerInput(box(0.35), 'tea', 0.28)]).single;
      expect(weak.id, id);
    });

    test('same-class detection wins association over a closer other class', () {
      final t = SimpleTracker();
      final ids = t.update([
        TrackerInput(box(0.3), 'tea', 0.9),
        TrackerInput(box(0.7), 'soap', 0.9),
      ]);
      final teaId = ids.firstWhere((x) => x.className == 'tea').id;

      // Next frame both moved; the tea box is now nearer the soap track's old
      // spot — class preference must keep identities straight.
      final next = t.update([
        TrackerInput(box(0.38), 'tea', 0.9),
        TrackerInput(box(0.62), 'soap', 0.9),
      ]);
      expect(next.firstWhere((x) => x.className == 'tea').id, teaId);
    });

    test('fast motion matches by centre distance when boxes stop overlapping', () {
      final t = SimpleTracker(maxCenterDist: 0.2);
      final id = t
          .update([TrackerInput(box(0.3, w: 0.1, h: 0.1), 'tea', 0.9)])
          .single
          .id;
      // Moved 0.15 — no IoU with a 0.1-wide box, but within centre distance.
      final moved = t
          .update([TrackerInput(box(0.45, w: 0.1, h: 0.1), 'tea', 0.9)])
          .single;
      expect(moved.id, id);
    });
  });
}
