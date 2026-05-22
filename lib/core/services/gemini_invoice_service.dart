import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import '../../features/pos_inventory/models/invoice_extraction.dart';

class GeminiInvoiceService {
  final ApiClient _client;

  GeminiInvoiceService(this._client);

  Future<({InvoiceExtraction extraction, Map<String, dynamic>? aiStatus})>
      extractInvoice(Uint8List bytes, String mimeType) async {
    final data = await _client.post('/kirana/ai/invoice', {
      'data_b64': base64Encode(bytes),
      'mime_type': mimeType,
    }) as Map<String, dynamic>;

    final aiStatus = data['ai_status'] as Map<String, dynamic>?;
    // Remove ai_status before parsing invoice so fromJson doesn't choke on it
    data.remove('ai_status');

    return (extraction: InvoiceExtraction.fromJson(data), aiStatus: aiStatus);
  }
}

final geminiInvoiceServiceProvider = Provider<GeminiInvoiceService>((ref) {
  return GeminiInvoiceService(ref.read(apiClientProvider));
});
