import 'dart:convert';

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

  /// Optional: Provide a way to clear or update the cache when logging in/out
  static void clearTokenCache() {
    _cachedAuthToken = null;
    _cachedPosToken = null;
  }

  static void updateTokenCache({String? authToken, String? posToken}) {
    if (authToken != null) _cachedAuthToken = authToken;
    if (posToken != null) _cachedPosToken = posToken;
  }

  // ── Kirana AI endpoints (Bearer kirana token) ──────────────────────────────

  Future<dynamic> get(String path) async {
    final token = await _getAuthToken();
    final res = await _client
        .get(
          Uri.parse('${AppConfig.apiBaseUrl}$path'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(_timeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> post(String path, dynamic body) async {
    final token = await _getAuthToken();
    final res = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> patch(String path, dynamic body) async {
    final token = await _getAuthToken();
    final res = await _client.patch(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
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
        .get(
          Uri.parse('${AppConfig.apiBaseUrl}$path'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(_timeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    if (res.statusCode == 401) {
      throw const ApiException(401, 'POS session expired. Please re-login.');
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  // POS endpoints that return a bare JSON array (e.g. /pos/products, /pos/categories)
  Future<List<dynamic>?> posGetList(String path) async {
    final token = await _getPosToken();
    if (token == null) return null;
    final res = await _client
        .get(
          Uri.parse('${AppConfig.apiBaseUrl}$path'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(_timeout);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
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
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
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

  // Kirana token but returns a bare list (e.g. /oltp/category when listing)
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
        .get(
          Uri.parse('${AppConfig.apiBaseUrl}$path'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
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
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
    final path = '/oltp/$table?$q';

    final res = await _client.delete(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
