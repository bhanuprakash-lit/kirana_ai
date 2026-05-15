import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/providers/auth_provider.dart';
import '../../auth/repositories/auth_repository.dart'; // ApiException
import '../models/onboarding_data.dart';

enum OnboardingStatus { idle, loading, success, error }

class OnboardingState {
  final OnboardingData data;
  final int currentStep;
  final OnboardingStatus status;
  final String? errorMessage;
  final bool isLocationLoading;

  const OnboardingState({
    this.data = const OnboardingData(),
    this.currentStep = 0,
    this.status = OnboardingStatus.idle,
    this.errorMessage,
    this.isLocationLoading = false,
  });

  OnboardingState copyWith({
    OnboardingData? data,
    int? currentStep,
    OnboardingStatus? status,
    String? errorMessage,
    bool? isLocationLoading,
    bool clearError = false,
  }) => OnboardingState(
    data: data ?? this.data,
    currentStep: currentStep ?? this.currentStep,
    status: status ?? this.status,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    isLocationLoading: isLocationLoading ?? this.isLocationLoading,
  );
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void updateData(OnboardingData data) => state = state.copyWith(data: data);

  void goToStep(int step) =>
      state = state.copyWith(currentStep: step, clearError: true);

  // Account step: local validation only — no API call yet
  void advanceFromAccount() =>
      state = state.copyWith(currentStep: 2, clearError: true);

  Future<void> detectLocation() async {
    state = state.copyWith(isLocationLoading: true, clearError: true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLocationLoading: false,
          errorMessage:
              'Location permission denied. Please enter address manually.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final geo = await _reverseGeocode(position.latitude, position.longitude);

      state = state.copyWith(
        isLocationLoading: false,
        data: state.data.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
          address: geo['address'],
          location: geo['location'],
          region: geo['region'],
        ),
      );
    } catch (_) {
      state = state.copyWith(
        isLocationLoading: false,
        errorMessage:
            'Could not detect location. Please enter address manually.',
      );
    }
  }

  Future<Map<String, String>> _reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
      );
      final res = await http.get(
        uri,
        headers: {'User-Agent': 'KiranaAI/1.0 (contact@lohiyaai.com)'},
      );
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
        final fullAddress = json['display_name'] as String? ?? '';

        return {
          'address': fullAddress,
          'location': location.isNotEmpty ? location : fullAddress,
          'region': city,
        };
      }
    } catch (_) {}
    return {'address': '', 'location': '', 'region': ''};
  }

  // Final step: register with backend + persist locally
  Future<bool> completeOnboarding() async {
    state = state.copyWith(status: OnboardingStatus.loading, clearError: true);
    try {
      await ref
          .read(authRepositoryProvider)
          .register(
            username: state.data.username,
            password: state.data.password,
            fullName: state.data.ownerName,
            storeName: state.data.storeName,
            storeType: _mapStoreType(state.data.businessType),
            footfall: state.data.footfall,
            location: state.data.location.isNotEmpty
                ? state.data.location
                : state.data.address,
            region: state.data.region,
            email: state.data.email.isNotEmpty ? state.data.email : null,
            phoneNumber: state.data.phoneNumber.isNotEmpty
                ? state.data.phoneNumber
                : null,
            firebaseUid: state.data.firebaseUid.isNotEmpty
                ? state.data.firebaseUid
                : null,
            latitude: state.data.latitude,
            longitude: state.data.longitude,
          );

      // Persist extra fields not stored by the backend register endpoint
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      await prefs.setString('store_name', state.data.storeName);
      await prefs.setString('phone_number', state.data.phoneNumber);
      await prefs.setString('address', state.data.address);
      await prefs.setString('location', state.data.location);
      await prefs.setString('region', state.data.region);
      if (state.data.latitude != null) {
        await prefs.setDouble('latitude', state.data.latitude!);
      }
      if (state.data.longitude != null) {
        await prefs.setDouble('longitude', state.data.longitude!);
      }

      state = state.copyWith(status: OnboardingStatus.success);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: _apiError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: 'Could not connect to the server. Please try again.',
      );
      return false;
    }
  }

  String _mapStoreType(String uiLabel) {
    switch (uiLabel) {
      case 'Grocery Store (Kirana)':
        return 'kirana';
      case 'General Store':
        return 'general';
      case 'Provision Store':
        return 'provision';
      case 'Fruits & Vegetables':
        return 'fruits_vegetables';
      case 'Medical / Pharmacy':
        return 'pharmacy';
      case 'Stationery & Books':
        return 'stationery';
      default:
        return 'other';
    }
  }

  String _apiError(ApiException e) {
    final msg = e.message.toLowerCase();
    if (e.statusCode == 409 || msg.contains('exists') || msg.contains('already')) {
      if (msg.contains('phone')) {
        return 'This phone number is already registered. Please sign in instead.';
      }
      return 'This username is already taken. Please choose another.';
    }
    if (e.statusCode == 422) {
      return 'Invalid details. Please check your entries and try again.';
    }
    return 'Registration failed: ${e.message}';
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
