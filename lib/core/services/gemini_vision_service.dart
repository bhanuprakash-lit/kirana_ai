import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config/secrets.dart';
import 'gemini_item.dart';

class GeminiVisionService {
  static const _apiKey = kGeminiApiKey;
  static const _model = 'gemini-2.5-flash';
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  Future<({String transcript, List<GeminiItem> items})> processHandwriting(
      Uint8List pngBytes) async {
    final response = await http.post(
      Uri.parse('$_endpoint?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'inline_data': {'mime_type': 'image/png', 'data': base64Encode(pngBytes)}},
              {'text': _prompt},
            ],
          },
        ],
        'generationConfig': {'temperature': 0, 'responseMimeType': 'application/json'},
      }),
    );

    if (response.statusCode != 200) {
      developer.log('Gemini vision error', error: response.body);
      throw Exception('Gemini Vision error ${response.statusCode}');
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
}

const _prompt = r'''
You are a grocery sales assistant for Indian kirana stores.
Look at this handwritten note and:
1. Read what is written (may be Telugu, Hindi, Urdu, Tamil, Malayalam, Kannada, English, or mixed).
2. Extract each grocery item with its quantity.

Return ONLY a JSON object in this exact shape — no explanation, no markdown:
{
  "transcript": "<everything you read from the image>",
  "items": [
    {"name": "<English name> (<regional word if written in regional script>)", "quantity": "<number + unit>"}
  ]
}

Rules for "name":
- Always English as primary (stored in the database).
- If written in a regional script, add the original word in parentheses.
- Examples: "Rice (బియ్యం)", "Wheat Flour (आटा)", "Sugar" (if written in English).

Rules for "quantity":
- Include number and unit: "2kg", "500g", "3 packets", "1 dozen", "2L".
- Normalise: "kilo"→"kg", "gram/grams"→"g", "litre/liter"→"L".
- If no unit is written, infer from context (grocery items usually kg/g, liquids L/ml).

Common translations:
Telugu  → biyyam→Rice, godhuma→Wheat Flour, pappu→Dal, nune→Oil, uppu→Salt,
           senagapappu→Chana Dal, minumulu→Urad Dal, pesalu→Moong Dal,
           pachi mirchi→Green Chilli, karam→Chilli Powder, pallilu→Peanuts
Hindi/Urdu → chawal→Rice, gehu/atta→Wheat Flour, dal→Dal, tel→Oil,
             namak→Salt, cheeni→Sugar, doodh→Milk, dahi→Curd,
             pyaaz→Onion, aloo→Potato, tamatar→Tomato, haldi→Turmeric, jeera→Cumin
Tamil      → arisi→Rice, kodumai→Wheat Flour, paruppu→Dal, yennai→Oil
Kannada    → akki→Rice, godhi→Wheat Flour, bele→Dal, yenne→Oil
Malayalam  → ariyari→Rice, gothambu→Wheat Flour, parippu→Dal, velichenna→Coconut Oil
''';
