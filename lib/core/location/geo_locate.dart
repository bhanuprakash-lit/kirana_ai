import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Resolved location from GPS / geocoding. Mirrors the fields onboarding feeds
/// into store registration so the add-store flow can reuse the same pipeline.
class GeoResult {
  final String address; // full display address
  final String location; // "suburb, city" friendly label
  final String city; // city / region
  final double? lat;
  final double? lng;
  const GeoResult({
    this.address = '',
    this.location = '',
    this.city = '',
    this.lat,
    this.lng,
  });
}

const _ua = {'User-Agent': 'KiranaAI/1.0 (contact@lohiyaai.com)'};

/// GPS → reverse-geocoded address. Throws if permission is denied or it fails.
Future<GeoResult> detectCurrentLocation() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('Location permission denied');
  }
  final pos = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 15),
    ),
  );
  final geo = await _reverseGeocode(pos.latitude, pos.longitude);
  return GeoResult(
    address: geo['address'] ?? '',
    location: geo['location'] ?? '',
    city: geo['region'] ?? '',
    lat: pos.latitude,
    lng: pos.longitude,
  );
}

Future<Map<String, String>> _reverseGeocode(double lat, double lon) async {
  try {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
    );
    final res = await http.get(uri, headers: _ua);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final addr = json['address'] as Map<String, dynamic>? ?? {};
      final suburb =
          addr['suburb'] as String? ??
          addr['quarter'] as String? ??
          addr['neighbourhood'] as String? ??
          addr['village'] as String? ??
          '';
      final city =
          addr['city'] as String? ??
          addr['town'] as String? ??
          addr['state_district'] as String? ??
          addr['state'] as String? ??
          '';
      final location = suburb.isNotEmpty && city.isNotEmpty
          ? '$suburb, $city'
          : city;
      final full = json['display_name'] as String? ?? '';
      return {
        'address': full,
        'location': location.isNotEmpty ? location : full,
        'region': city,
      };
    }
  } catch (_) {}
  return {'address': '', 'location': '', 'region': ''};
}

/// Manual address → coordinates (best-effort; returns null on failure).
Future<Map<String, double>?> forwardGeocode(String query) async {
  try {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?format=json&q=${Uri.encodeComponent(query)}&limit=1',
    );
    final res = await http.get(uri, headers: _ua);
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      if (list.isNotEmpty) {
        final item = list.first as Map<String, dynamic>;
        final lat = double.tryParse(item['lat'] as String? ?? '');
        final lng = double.tryParse(item['lon'] as String? ?? '');
        if (lat != null && lng != null) return {'lat': lat, 'lng': lng};
      }
    }
  } catch (_) {}
  return null;
}
