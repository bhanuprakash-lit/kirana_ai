import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'gemini_item.dart';

class GeminiVisionService {
  final ApiClient _client;

  GeminiVisionService(this._client);

  Future<
    ({
      String transcript,
      List<GeminiItem> items,
      Map<String, dynamic>? aiStatus,
    })
  >
  processHandwriting(Uint8List pngBytes) async {
    final data = await _client.post('/kirana/ai/handwrite', {
      'image_b64': base64Encode(pngBytes),
    });

    final transcript = (data['transcript'] as String?) ?? '';
    final items = (data['items'] as List<dynamic>? ?? [])
        .map((e) => GeminiItem.fromMap(e as Map<String, dynamic>))
        .toList();
    final aiStatus = data['ai_status'] as Map<String, dynamic>?;

    return (transcript: transcript, items: items, aiStatus: aiStatus);
  }
}

final geminiVisionServiceProvider = Provider<GeminiVisionService>((ref) {
  return GeminiVisionService(ref.read(apiClientProvider));
});
