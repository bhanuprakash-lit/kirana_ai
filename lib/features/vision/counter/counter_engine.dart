import 'dart:ui' show Rect;

/// Which crossing direction registers a sale.
///  - [leftToRight]: an item moving from the "normal" area (left) into the
///    "sold" area (right) is counted. This mirrors the standalone counter demo.
enum CountDirection { leftToRight, rightToLeft }

/// One product tally accumulated by the engine.
class TallyEntry {
  final String className;
  int qty;
  double _confSum;

  TallyEntry(this.className, {this.qty = 0, double confSum = 0})
    : _confSum = confSum;

  /// Mean detection confidence across the counted crossings for this product.
  double get avgConfidence => qty == 0 ? 0 : _confSum / qty;
}

/// Emitted the moment a tracked item crosses the sold line for the first time.
class CrossingEvent {
  final int trackId;
  final String className;
  final double confidence;
  const CrossingEvent(this.trackId, this.className, this.confidence);
}

class _Track {
  double lastCx;
  String className;
  double confidence;
  _Track(this.lastCx, this.className, this.confidence);
}

/// Pure-Dart line-crossing counter. Framework-free and deterministic so it can be
/// unit-tested without a camera: feed it per-frame detections (each carrying a
/// stable [trackId] from the on-device tracker) and it counts each track exactly
/// once, the first time its centre crosses the sold line in the chosen direction.
///
/// Kept identical in spirit to vision-ai/ml/counter/counter_feed.py: an item is
/// SOLD when it passes from the normal area into the sold area.
class CounterEngine {
  /// Sold line position as a fraction of frame width (0–1).
  double lineFrac;
  CountDirection direction;

  final Map<int, _Track> _tracks = {};
  final Set<int> _countedTracks = {};
  final Map<String, TallyEntry> _tally = {};
  // Ordered history of counted (trackId, className) so the owner can undo.
  final List<CrossingEvent> _history = [];

  CounterEngine({this.lineFrac = 0.5, this.direction = CountDirection.leftToRight});

  /// Per-product tallies, highest count first.
  List<TallyEntry> get tally {
    final list = _tally.values.toList()
      ..sort((a, b) => b.qty.compareTo(a.qty));
    return list;
  }

  int get totalUnits => _tally.values.fold(0, (a, e) => a + e.qty);
  int get totalSkus => _tally.length;
  bool get isEmpty => _tally.isEmpty;

  /// Process one camera frame. [boxNorm] must be normalized to 0–1 in frame
  /// space. Returns any crossings that happened on this frame (usually empty).
  /// Detections without a [trackId] are ignored for counting — reliable tallying
  /// needs frame-to-frame identity, which the on-device tracker provides.
  List<CrossingEvent> processFrame(List<CounterDetection> dets) {
    final events = <CrossingEvent>[];
    for (final d in dets) {
      final id = d.trackId;
      if (id == null) continue;
      final cx = (d.boxNorm.left + d.boxNorm.right) / 2;
      final prev = _tracks[id];
      _tracks[id] = _Track(cx, d.className, d.confidence);

      if (prev == null || _countedTracks.contains(id)) continue;

      final crossed = direction == CountDirection.leftToRight
          ? prev.lastCx < lineFrac && cx >= lineFrac
          : prev.lastCx > lineFrac && cx <= lineFrac;
      if (!crossed) continue;

      _countedTracks.add(id);
      final entry = _tally.putIfAbsent(d.className, () => TallyEntry(d.className));
      entry.qty += 1;
      entry._confSum += d.confidence;
      final ev = CrossingEvent(id, d.className, d.confidence);
      _history.add(ev);
      events.add(ev);
    }
    return events;
  }

  /// Undo the most recent count (owner over-counted / mis-detection). Returns the
  /// removed event, or null if nothing to undo.
  CrossingEvent? undoLast() {
    if (_history.isEmpty) return null;
    final ev = _history.removeLast();
    _countedTracks.remove(ev.trackId); // allow it to be recounted if it crosses again
    final entry = _tally[ev.className];
    if (entry != null) {
      entry.qty -= 1;
      entry._confSum -= ev.confidence;
      if (entry.qty <= 0) _tally.remove(ev.className);
    }
    return ev;
  }

  /// Manually add one to a product's tally (owner correction: model missed it).
  void bump(String className, {double confidence = 1.0}) {
    final entry = _tally.putIfAbsent(className, () => TallyEntry(className));
    entry.qty += 1;
    entry._confSum += confidence;
    // Synthetic negative trackId keeps undo working without colliding with real IDs.
    _history.add(CrossingEvent(-_history.length - 1, className, confidence));
  }

  void reset() {
    _tracks.clear();
    _countedTracks.clear();
    _tally.clear();
    _history.clear();
  }
}

/// A single detection for one frame, normalized to frame space (0–1).
class CounterDetection {
  final int? trackId;
  final String className;
  final double confidence;
  final Rect boxNorm;
  const CounterDetection({
    required this.trackId,
    required this.className,
    required this.confidence,
    required this.boxNorm,
  });
}
