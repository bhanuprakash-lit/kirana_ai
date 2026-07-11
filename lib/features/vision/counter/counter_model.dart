import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the on-device counter model + labels live once exported (see
/// vision-ai/ml/export/export_tflite.py). The .tflite is NOT committed — it's a
/// large binary produced from the trained YOLO weights and dropped in here.
class CounterModel {
  static const String tfliteAsset = 'assets/models/counter_model.tflite';
  static const String labelsAsset = 'assets/models/counter_labels.txt';

  /// Camera-feed threshold, deliberately LOW: an item that is already being
  /// tracked keeps its identity through blur/shake/motion frames where the
  /// detector's confidence dips. Raising this is what made the old counter
  /// "lose everything on a small disturbance" — weak frames disappeared and
  /// tracks aged out.
  static const double liveConfidence = 0.25;

  /// Confidence required to START a new track (and hence ever be counted).
  /// Acquisition stays precise while tracking stays sticky: weak detections can
  /// only extend existing tracks, never spawn phantom ones.
  static const double countConfidence = 0.4;
}

/// Whether the on-device model binary is actually bundled. Until the .tflite is
/// exported and dropped into assets/models/, the counter shows a "not installed"
/// state instead of a black camera — the rest of the app is unaffected.
final counterModelAvailableProvider = FutureProvider<bool>((ref) async {
  try {
    final data = await rootBundle.load(CounterModel.tfliteAsset);
    return data.lengthInBytes > 0;
  } catch (_) {
    return false;
  }
});

/// The on-device model's class labels (one per line). Used to ask the backend
/// which catalog product + price each class maps to, so the live tally can show
/// money, not just units. Empty when the model/labels aren't bundled.
final counterLabelsProvider = FutureProvider<List<String>>((ref) async {
  try {
    final raw = await rootBundle.loadString(CounterModel.labelsAsset);
    return [
      for (final line in raw.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];
  } catch (_) {
    return const [];
  }
});
