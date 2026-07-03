import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the on-device counter model + labels live once exported (see
/// vision-ai/ml/export/export_tflite.py). The .tflite is NOT committed — it's a
/// large binary produced from the trained YOLO weights and dropped in here.
class CounterModel {
  static const String tfliteAsset = 'assets/models/counter_model.tflite';
  static const String labelsAsset = 'assets/models/counter_labels.txt';

  /// Default detection confidence for the live feed. A touch higher than the
  /// plugin default (0.25) to cut counter noise; tunable in the UI later.
  static const double defaultConfidence = 0.4;
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
