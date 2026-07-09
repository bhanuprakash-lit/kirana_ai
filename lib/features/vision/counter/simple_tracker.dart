import 'dart:math' as math;
import 'dart:ui' show Rect;

/// A detection assigned a stable identity by [SimpleTracker].
class TrackedBox {
  final int id;
  final Rect box; // normalized 0–1
  final String className;
  final double confidence;
  const TrackedBox(this.id, this.box, this.className, this.confidence);
}

class _Track {
  final int id;
  Rect box;
  String className;
  double confidence;
  int age; // frames since last matched
  _Track(this.id, this.box, this.className, this.confidence) : age = 0;
}

/// A lightweight greedy-IoU tracker (SORT without the Kalman filter). The on-device
/// YOLO plugin returns per-frame boxes with no identity; this assigns each a stable
/// [id] across frames so the [CounterEngine] can count a moving item exactly once.
///
/// Good enough for the counter: items pass one at a time across the counter, so
/// simple IoU association between consecutive frames is reliable without motion
/// prediction. Deterministic and camera-free ⇒ unit-testable.
class SimpleTracker {
  /// Minimum IoU to consider a detection the continuation of a track.
  final double iouThreshold;

  /// Fallback association: if IoU is below threshold (fast motion / low frame
  /// rate ⇒ non-overlapping boxes) a detection whose centre is within this
  /// normalized distance of the track's centre is still matched. Keeps identity
  /// stable when an item moves several box-widths between frames.
  final double maxCenterDist;

  /// Frames a track survives without a match before it's dropped (handles brief
  /// occlusion / a dropped detection).
  final int maxAge;

  int _nextId = 1;
  final List<_Track> _tracks = [];

  SimpleTracker({
    this.iouThreshold = 0.3,
    this.maxCenterDist = 0.15,
    this.maxAge = 8,
  });

  List<TrackedBox> update(List<TrackerInput> dets) {
    final assigned = <int>{}; // indices of dets already matched

    // Greedy: match each track to its best unmatched detection by IoU, falling
    // back to centre proximity when boxes don't overlap.
    for (final t in _tracks) {
      int bestIdx = -1;
      double bestIou = 0;
      double bestDist = double.infinity;
      for (var i = 0; i < dets.length; i++) {
        if (assigned.contains(i)) continue;
        final iou = _iou(t.box, dets[i].box);
        final dist = _centerDist(t.box, dets[i].box);
        final qualifies = iou >= iouThreshold || dist <= maxCenterDist;
        if (!qualifies) continue;
        // Prefer higher IoU; break ties / no-overlap cases by nearer centre.
        if (iou > bestIou || (iou == bestIou && dist < bestDist)) {
          bestIou = iou;
          bestDist = dist;
          bestIdx = i;
        }
      }
      if (bestIdx >= 0) {
        final d = dets[bestIdx];
        t.box = d.box;
        t.className = d.className;
        t.confidence = d.confidence;
        t.age = 0;
        assigned.add(bestIdx);
      } else {
        t.age += 1;
      }
    }

    // Unmatched detections spawn new tracks.
    for (var i = 0; i < dets.length; i++) {
      if (assigned.contains(i)) continue;
      final d = dets[i];
      _tracks.add(_Track(_nextId++, d.box, d.className, d.confidence));
    }

    // Age out stale tracks.
    _tracks.removeWhere((t) => t.age > maxAge);

    // Only report tracks matched this frame (age == 0).
    return [
      for (final t in _tracks)
        if (t.age == 0) TrackedBox(t.id, t.box, t.className, t.confidence),
    ];
  }

  void reset() {
    _tracks.clear();
    _nextId = 1;
  }

  static double _centerDist(Rect a, Rect b) {
    final dx = a.center.dx - b.center.dx;
    final dy = a.center.dy - b.center.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  static double _iou(Rect a, Rect b) {
    final ix =
        (a.right < b.right ? a.right : b.right) -
        (a.left > b.left ? a.left : b.left);
    final iy =
        (a.bottom < b.bottom ? a.bottom : b.bottom) -
        (a.top > b.top ? a.top : b.top);
    if (ix <= 0 || iy <= 0) return 0;
    final inter = ix * iy;
    final union = a.width * a.height + b.width * b.height - inter;
    return union <= 0 ? 0 : inter / union;
  }
}

class TrackerInput {
  final Rect box; // normalized 0–1
  final String className;
  final double confidence;
  const TrackerInput(this.box, this.className, this.confidence);
}
