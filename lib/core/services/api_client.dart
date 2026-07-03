import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../../features/auth/repositories/auth_repository.dart';

class ApiClient {
  static const _storage = FlutterSecureStorage();

  /// Single shared client so connections are pooled/kept-alive across the many
  /// concurrent requests fired at app start (overview, subscription, inventory,
  /// finance, etc.). The top-level `http.get`/`http.post` helpers open and tear
  /// down a fresh TCP+TLS connection per call — a costly handshake storm on a
  /// cold launch over mobile data. Reusing one client removes that overhead.
  static final http.Client _client = http.Client();

  /// Network calls that hang shouldn't keep the UI on a shimmer forever. A
  /// stalled request now fails after this window so providers can surface an
  /// error (and retry) instead of blocking indefinitely.
  static const Duration _timeout = Duration(seconds: 20);

  // In-memory token cache to prevent slow, concurrent Keystore reads on Android.
  static String? _cachedAuthToken;
  static String? _cachedPosToken;

  static Future<String?> _getAuthToken() async {
    _cachedAuthToken ??= await _storage.read(key: 'auth_token');
    return _cachedAuthToken;
  }

  static Future<String?> _getPosToken() async {
    _cachedPosToken ??= await _storage.read(key: 'pos_token');
    return _cachedPosToken;
  }

  static void clearTokenCache() {
    _cachedAuthToken = null;
    _cachedPosToken = null;
  }

  /// Bearer token for authenticated media loads (e.g. `Image.network` of a
  /// backend-served image, which can't go through the JSON helpers below).
  static Future<String?> mediaAuthToken() => _getAuthToken();

  static void updateTokenCache({String? authToken, String? posToken}) {
    if (authToken != null) _cachedAuthToken = authToken;
    if (posToken != null) _cachedPosToken = posToken;
  }

  // ── Correlation ID ─────────────────────────────────────────────────────────
  // A unique ID stamped on every outgoing request and echoed back by the
  // backend in X-Correlation-ID. Searching this ID in Azure Log Analytics
  // shows the exact backend log lines produced by that one call.
  static final _rng = math.Random.secure();

  static String _newCid() {
    final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
    final rnd = _rng.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '$ts$rnd';
  }

  /// Base headers for all JSON endpoints. Generates a fresh correlation ID
  /// per call so every request is individually traceable in backend logs.
  static Map<String, String> _h(String? token) => {
    if (token != null) 'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'X-Correlation-ID': _newCid(),
  };

  // ── Kirana AI endpoints (Bearer kirana token) ──────────────────────────────

  Future<dynamic> get(String path) async {
    final token = await _getAuthToken();
    final res = await _client
        .get(Uri.parse('${AppConfig.apiBaseUrl}$path'), headers: _h(token))
        .timeout(_timeout);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  /// Authed GET that returns raw bytes — used for binary blobs like udhaar
  /// voice-consent clips.
  Future<List<int>> getBytes(String path) async {
    final token = await _getAuthToken();
    final res = await _client
        .get(
          Uri.parse('${AppConfig.apiBaseUrl}$path'),
          headers: {
            'Authorization': 'Bearer $token',
            'X-Correlation-ID': _newCid(),
          },
        )
        .timeout(const Duration(seconds: 60));
    if (res.statusCode == 200) return res.bodyBytes;
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> post(String path, dynamic body) async {
    final token = await _getAuthToken();
    final res = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: _h(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> put(String path, dynamic body) async {
    final token = await _getAuthToken();
    final res = await _client.put(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: _h(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 204) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> patch(String path, dynamic body) async {
    final token = await _getAuthToken();
    final res = await _client.patch(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: _h(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> delete(String path) async {
    final token = await _getAuthToken();
    final res = await _client.delete(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: _h(token),
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  /// Multipart upload on the Kirana (Bearer) token — used by Vision shelf scans.
  Future<dynamic> postMultipart(
    String path, {
    required List<String> filePaths,
    String fileField = 'files',
    Map<String, String>? fields,
  }) async {
    final token = await _getAuthToken();
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
    );
    req.headers['Authorization'] = 'Bearer $token';
    req.headers['X-Correlation-ID'] = _newCid();
    if (fields != null) req.fields.addAll(fields);
    for (final p in filePaths) {
      req.files.add(await http.MultipartFile.fromPath(fileField, p));
    }
    final streamed = await _client
        .send(req)
        .timeout(const Duration(seconds: 120));
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200 ||
        res.statusCode == 201 ||
        res.statusCode == 202) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  // ── POS endpoints (Bearer pos token) ──────────────────────────────────────

  Future<Map<String, dynamic>?> posGet(String path) async {
    final token = await _getPosToken();
    if (token == null) return null;
    final res = await _client
        .get(Uri.parse('${AppConfig.apiBaseUrl}$path'), headers: _h(token))
        .timeout(_timeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    if (res.statusCode == 401) {
      throw const ApiException(401, 'POS session expired. Please re-login.');
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<List<dynamic>?> posGetList(String path) async {
    final token = await _getPosToken();
    if (token == null) return null;
    final res = await _client
        .get(Uri.parse('${AppConfig.apiBaseUrl}$path'), headers: _h(token))
        .timeout(_timeout);
    if (res.statusCode == 200) return jsonDecode(res.body) as List<dynamic>;
    if (res.statusCode == 401) {
      throw const ApiException(401, 'POS session expired. Please re-login.');
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<Map<String, dynamic>?> posPost(
    String path,
    Map<String, dynamic> body,
  ) async {
    final token = await _getPosToken();
    if (token == null) return null;
    try {
      final res = await _client.post(
        Uri.parse('${AppConfig.apiBaseUrl}$path'),
        headers: _h(token),
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      throw ApiException(res.statusCode, _extractError(res.body));
    } catch (e) {
      rethrow;
    }
  }

  // ── OLTP endpoints (Kirana Bearer token) ──────────────────────────────────

  Future<Map<String, dynamic>> getOltp(
    String table, {
    Map<String, String>? filters,
  }) async {
    final token = await _getAuthToken();
    var path = '/oltp/$table';
    if (filters != null && filters.isNotEmpty) {
      final q = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
      path = '$path?$q';
    }
    final res = await _client
        .get(Uri.parse('${AppConfig.apiBaseUrl}$path'), headers: _h(token))
        .timeout(_timeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<Map<String, dynamic>> postOltp(
    String table,
    Map<String, dynamic> body,
  ) async {
    final token = await _getAuthToken();
    final res = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}/oltp/$table'),
      headers: _h(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<Map<String, dynamic>> patchOltp(
    String table,
    Map<String, dynamic> body, {
    Map<String, String>? filters,
  }) async {
    final token = await _getAuthToken();
    var path = '/oltp/$table';
    if (filters != null && filters.isNotEmpty) {
      final q = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
      path = '$path?$q';
    }
    final res = await _client.patch(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: _h(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<Map<String, dynamic>> deleteOltp(
    String table, {
    required Map<String, String> filters,
  }) async {
    final token = await _getAuthToken();
    final q = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
    final res = await _client.delete(
      Uri.parse('${AppConfig.apiBaseUrl}/oltp/$table?$q'),
      headers: _h(token),
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _extractError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['error'] as String? ??
          json['detail']?.toString() ??
          'Unknown error';
    } catch (_) {
      return body;
    }
  }
}

final apiClientProvider = Provider<ApiClient>((_) => ApiClient());
