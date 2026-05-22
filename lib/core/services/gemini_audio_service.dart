import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import 'api_client.dart';
import 'gemini_item.dart';

class GeminiAudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final ApiClient _client;

  GeminiAudioService(this._client);

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> startRecording(String filePath) async {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: filePath,
    );
  }

  Future<
    ({
      String transcript,
      List<GeminiItem> items,
      Map<String, dynamic>? aiStatus,
    })
  >
  stopAndProcess() async {
    final path = await _recorder.stop();
    if (path == null || path.isEmpty) throw Exception('No audio recorded');

    final bytes = await File(path).readAsBytes();
    if (bytes.isEmpty) throw Exception('Recorded file is empty');

    final data = await _client.post('/kirana/ai/voice', {
      'audio_b64': base64Encode(bytes),
      'mime_type': 'audio/aac',
    });

    final transcript = (data['transcript'] as String?) ?? '';
    final items = (data['items'] as List<dynamic>? ?? [])
        .map((e) => GeminiItem.fromMap(e as Map<String, dynamic>))
        .toList();
    final aiStatus = data['ai_status'] as Map<String, dynamic>?;

    return (transcript: transcript, items: items, aiStatus: aiStatus);
  }

  void dispose() => _recorder.dispose();
}

final geminiAudioServiceProvider = Provider<GeminiAudioService>((ref) {
  return GeminiAudioService(ref.read(apiClientProvider));
});
