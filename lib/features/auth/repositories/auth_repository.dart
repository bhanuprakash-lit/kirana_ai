import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/device_info.dart';
import '../models/app_user.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _posTokenKey = 'pos_token';
  static const _sessionExpiryKey = 'session_expiry';
  static const _sessionDays = 30;

  // ── Token helpers ──────────────────────────────────────────────────────────

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryStr = prefs.getString(_sessionExpiryKey);
    if (expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && DateTime.now().isAfter(expiry)) {
        await _clearTokensOnly(prefs);
        return null;
      }
    }
    return _storage.read(key: _tokenKey);
  }

  Future<void> _saveSession(
    AuthResult result, {
    String? username,
    String? password,
  }) async {
    await _storage.write(key: _tokenKey, value: result.accessToken);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', result.user.userId);
    if (result.user.storeId != null) {
      await prefs.setInt('store_id', result.user.storeId!);
    }
    await prefs.setString('username', result.user.username);
    await prefs.setString('full_name', result.user.fullName);
    await prefs.setString('role', result.user.role);
    await prefs.setBool('onboarding_completed', true);
    final expiry = DateTime.now().add(const Duration(days: _sessionDays));
    await prefs.setString(_sessionExpiryKey, expiry.toIso8601String());

    if (username != null && password != null && password.isNotEmpty) {
      await _obtainPosToken(username, password);
    } else {
      // Phone-auth users have no password — exchange Kirana token for POS JWT
      await _obtainPosTokenFromKirana(result.accessToken);
    }
  }

  Future<void> _obtainPosToken(String username, String password) async {
    try {
      final telemetry = await DeviceTelemetry.headers();
      final res = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/pos/token'),
        headers: {
          ...telemetry,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:
            'username=${Uri.encodeComponent(username)}&password=${Uri.encodeComponent(password)}',
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        await _storage.write(
          key: _posTokenKey,
          value: json['access_token'] as String,
        );
      }
    } catch (_) {}
  }

  /// Re-mint the POS JWT for the CURRENT active store. The POS token carries a
  /// baked-in store_id (POS rejects mismatched store_id), so after switching the
  /// active store we must refresh it — otherwise billing/stock 403 or show the
  /// old store. Safe no-op if there's no kirana token.
  Future<void> refreshPosToken() async {
    final kiranaToken = await _storage.read(key: _tokenKey);
    if (kiranaToken == null || kiranaToken.isEmpty) return;
    await _obtainPosTokenFromKirana(kiranaToken);
  }

  Future<void> _obtainPosTokenFromKirana(String kiranaToken) async {
    try {
      final telemetry = await DeviceTelemetry.headers();
      final res = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/pos/token-from-kirana'),
        headers: {...telemetry, 'Authorization': 'Bearer $kiranaToken'},
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        await _storage.write(
          key: _posTokenKey,
          value: json['access_token'] as String,
        );
      }
    } catch (_) {}
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearTokensOnly(prefs);
  }

  Future<void> _clearTokensOnly(SharedPreferences prefs) async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _posTokenKey);
    await prefs.remove('user_id');
    await prefs.remove('store_id');
    await prefs.remove('username');
    await prefs.remove('full_name');
    await prefs.remove('role');
    await prefs.remove(_sessionExpiryKey);
  }

  // ── Auth calls ─────────────────────────────────────────────────────────────

  Future<AppUser> getCurrentUser() async {
    final token = await getToken();
    if (token == null) throw const ApiException(401, 'Not authenticated');

    try {
      final res = await http
          .get(
            Uri.parse('${AppConfig.apiBaseUrl}/kirana/auth/me'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final user = AppUser.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
        // Refresh local cache on successful fetch
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user.userId);
        if (user.storeId != null) await prefs.setInt('store_id', user.storeId!);
        await prefs.setString('username', user.username);
        await prefs.setString('full_name', user.fullName);
        await prefs.setString('role', user.role);
        return user;
      }
      // 401 → truly not authenticated, don't fall back
      if (res.statusCode == 401) {
        throw ApiException(res.statusCode, _extractError(res.body));
      }
    } on ApiException {
      rethrow;
    } catch (_) {
      // Network error / timeout → fall through to cache
    }

    // Fallback: read from SharedPreferences (saved during login/register)
    return _userFromPrefs();
  }

  Future<AppUser> _userFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final username = prefs.getString('username');
    final fullName = prefs.getString('full_name');
    final role = prefs.getString('role');
    final storeId = prefs.getInt('store_id');
    if (userId == null || username == null) {
      throw const ApiException(401, 'Not authenticated');
    }
    return AppUser(
      userId: userId,
      username: username,
      fullName: fullName ?? username,
      role: role ?? 'store_owner',
      storeId: storeId,
    );
  }

  /// Email + password login (legacy / admin path).
  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    final telemetry = await DeviceTelemetry.headers();
    final res = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/kirana/auth/login'),
      headers: {...telemetry, 'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      final result = AuthResult.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
      await _saveSession(result, username: username, password: password);
      return result;
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  /// Phone OTP login — Firebase has already verified the OTP on the client.
  /// Returns null if no account exists for this number (caller shows registration).
  Future<AuthResult?> phoneLogin({
    required String phoneNumber,
    required String firebaseUid,
  }) async {
    final telemetry = await DeviceTelemetry.headers();
    final res = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/kirana/auth/phone-login'),
      headers: {...telemetry, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone_number': phoneNumber,
        'firebase_uid': firebaseUid,
      }),
    );
    if (res.statusCode == 200) {
      final result = AuthResult.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
      // No password for phone users — POS features gracefully unavailable
      await _saveSession(result);
      return result;
    }
    if (res.statusCode == 404) {
      return null; // No account → caller redirects to registration
    }
    throw ApiException(res.statusCode, _extractError(res.body));
  }

  /// Check whether a username is available (before registration).
  Future<bool> checkUsernameAvailable(String username) async {
    final res = await http.get(
      Uri.parse(
        '${AppConfig.apiBaseUrl}/kirana/auth/check-username/${Uri.encodeComponent(username)}',
      ),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return json['available'] as bool? ?? false;
    }
    return false;
  }

  Future<AuthResult> register({
    required String username,
    String password = '',
    required String fullName,
    required String storeName,
    required String storeType,
    String? verticalCode,
    int footfall = 40,
    double? budget,
    String? location,
    String? region,
    String? city,
    String? email,
    String? phoneNumber,
    String? firebaseUid,
    double? latitude,
    double? longitude,
  }) async {
    final telemetry = await DeviceTelemetry.headers();
    final res = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/kirana/auth/register'),
      headers: {...telemetry, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'full_name': fullName,
        'store_name': storeName,
        'store_type': storeType,
        if (verticalCode != null && verticalCode.isNotEmpty)
          'vertical_code': verticalCode,
        'footfall': footfall,
        'budget': ?budget,
        if (location != null && location.isNotEmpty) 'location': location,
        if (region != null && region.isNotEmpty) 'region': region,
        if (city != null && city.isNotEmpty) 'city': city,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phoneNumber != null && phoneNumber.isNotEmpty)
          'phone_number': phoneNumber,
        if (firebaseUid != null && firebaseUid.isNotEmpty)
          'firebase_uid': firebaseUid,
        'latitude': ?latitude,
        'longitude': ?longitude,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final result = AuthResult.fromJson(
        jsonDecode(res.body) as Map<String, dynamic>,
      );
      // Only exchange POS token when a real password was set
      await _saveSession(
        result,
        username: password.isNotEmpty ? username : null,
        password: password.isNotEmpty ? password : null,
      );
      return result;
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
