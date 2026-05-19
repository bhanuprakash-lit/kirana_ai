import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:record/record.dart';

import '../config/secrets.dart';
import 'gemini_item.dart';

class GeminiAudioService {
  static const _apiKey = kGeminiApiKey;
  static const _model = 'gemini-2.5-flash';
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  final AudioRecorder _recorder = AudioRecorder();

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

  Future<({String transcript, List<GeminiItem> items})> stopAndProcess() async {
    final path = await _recorder.stop();
    if (path == null || path.isEmpty) throw Exception('No audio recorded');

    final bytes = await File(path).readAsBytes();
    if (bytes.isEmpty) throw Exception('Recorded file is empty');

    final response = await http.post(
      Uri.parse('$_endpoint?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'inline_data': {'mime_type': 'audio/aac', 'data': base64Encode(bytes)}},
              {'text': _prompt},
            ],
          },
        ],
        'generationConfig': {'temperature': 0, 'responseMimeType': 'application/json'},
      }),
    );

    if (response.statusCode != 200) {
      developer.log('Gemini audio error', error: response.body);
      throw Exception('Gemini API error ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final raw = data['candidates'][0]['content']['parts'][0]['text'] as String;
    final parsed = jsonDecode(raw) as Map<String, dynamic>;

    final transcript = (parsed['transcript'] as String?) ?? '';
    final items = (parsed['items'] as List<dynamic>? ?? [])
        .map((e) => GeminiItem.fromMap(e as Map<String, dynamic>))
        .toList();

    return (transcript: transcript, items: items);
  }

  void dispose() => _recorder.dispose();
}

const _prompt = r'''
You are a grocery sales assistant for Indian kirana stores.
Listen to the audio and:
1. Transcribe what was said.
2. Extract each grocery item with its quantity.

The speech may be in Telugu, Hindi, Urdu, Tamil, Malayalam, Kannada, English, or a mix.

Return ONLY a JSON object in this exact shape — no explanation, no markdown:
{
  "transcript": "<what was said>",
  "items": [
    {"name": "<English name> (<regional word if spoken in regional language>)", "quantity": "<number + unit>"}
  ]
}

Rules for "name":
- Always English as the primary name (this goes into the database).
- If the item was spoken in a regional language, append the original word in parentheses.
- Examples: "Rice (బియ్యం)", "Wheat Flour (आटा)", "Sugar" (if said in English).

Rules for "quantity":
- Include number and unit: "2kg", "500g", "3 packets", "1 dozen", "2 liters".
- Normalise: "kilo" → "kg", "gram" → "g", "litre/liter" → "L".

Common translations:
Telugu  → biyyam/biyam→Rice, godhuma→Wheat Flour, pappu→Dal, nune→Oil, uppu→Salt,
           senagapappu→Chana Dal, minumulu→Urad Dal, pesalu→Moong Dal,
           pachi mirchi→Green Chilli, karam→Chilli Powder, pallilu→Peanuts,
           velulli→Garlic, ullipaya→Onion, aviselu→Mustard Seeds
Hindi/Urdu → chawal→Rice, gehu/atta/aata→Wheat Flour, dal→Dal, tel→Oil,
             namak→Salt, cheeni→Sugar, doodh→Milk, dahi→Curd,
             pyaaz→Onion, aloo→Potato, tamatar→Tomato,
             haldi→Turmeric, jeera→Cumin, sarson→Mustard Seeds, lahsun→Garlic
Tamil      → arisi→Rice, kodumai→Wheat Flour, paruppu→Dal, yennai→Oil, uppu→Salt
Kannada    → akki→Rice, godhi→Wheat Flour, bele→Dal, yenne→Oil, uppu→Salt
Malayalam  → ariyari→Rice, gothambu→Wheat Flour, parippu→Dal, velichenna→Coconut Oil
''';
