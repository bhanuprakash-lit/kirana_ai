import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../../features/auth/repositories/auth_repository.dart';

class ApiClient {
  static const _storage = FlutterSecureStorage();

  // ── Kirana AI endpoints (Bearer kirana token) ──────────────────────────────

  Future<dynamic> get(String path) async {
    final token = await _storage.read(key: 'auth_token');
    final res = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<dynamic> post(
      String path, dynamic body) async {
    final token = await _storage.read(key: 'auth_token');
    final res = await http.post(
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

  Future<dynamic> patch(
      String path, dynamic body) async {
    final token = await _storage.read(key: 'auth_token');
    final res = await http.patch(
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

  // ── POS endpoints (Bearer pos token) ──────────────────────────────────────

  Future<Map<String, dynamic>?> posGet(String path) async {
    final token = await _storage.read(key: 'pos_token');
    if (token == null) return null;
    final res = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {'Authorization': 'Bearer $token'},
    );
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
    final token = await _storage.read(key: 'pos_token');
    if (token == null) return null;
    final res = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    if (res.statusCode == 401) {
      throw const ApiException(401, 'POS session expired. Please re-login.');
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<Map<String, dynamic>?> posPost(
      String path, Map<String, dynamic> body) async {
    final token = await _storage.read(key: 'pos_token');
    if (token == null) return null;
    try {
      final res = await http.post(
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
  Future<Map<String, dynamic>> getOltp(String table,
      {Map<String, String>? filters}) async {
    final token = await _storage.read(key: 'auth_token');
    var path = '/oltp/$table';
    if (filters != null && filters.isNotEmpty) {
      final q = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
      path = '$path?$q';
    }
    final res = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  Future<Map<String, dynamic>> postOltp(
      String table, Map<String, dynamic> body) async {
    final token = await _storage.read(key: 'auth_token');
    final res = await http.post(
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
      String table, Map<String, dynamic> body,
      {Map<String, String>? filters}) async {
    final token = await _storage.read(key: 'auth_token');
    var path = '/oltp/$table';
    if (filters != null && filters.isNotEmpty) {
      final q = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
      path = '$path?$q';
    }
    final res = await http.patch(
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

  Future<Map<String, dynamic>> deleteOltp(String table,
      {required Map<String, String> filters}) async {
    final token = await _storage.read(key: 'auth_token');
    final q = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
    final path = '/oltp/$table?$q';

    final res = await http.delete(
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
