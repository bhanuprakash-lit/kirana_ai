import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/brand_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../providers/onboarding_provider.dart';

class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({super.key});

  @override
  ConsumerState<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _geocoding = false;

  @override
  void dispose() {
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final address = _addressCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.locationErrAddress)));
      return;
    }
    if (city.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.locationErrCity)));
      return;
    }

    final notifier = ref.read(onboardingProvider.notifier);
    final current = ref.read(onboardingProvider).data;
    final location = current.location.isNotEmpty ? current.location : address;

    double? lat = current.latitude;
    double? lng = current.longitude;

    // Manual entry — forward geocode to get coordinates
    if (lat == null) {
      setState(() => _geocoding = true);
      final coords = await _forwardGeocode('$address, $city, India');
      if (mounted) setState(() => _geocoding = false);
      lat = coords?['lat'];
      lng = coords?['lng'];
    }

    notifier.updateData(
      current.copyWith(
        address: address,
        location: location,
        region: city,
        latitude: lat,
        longitude: lng,
      ),
    );
    notifier.goToStep(4);
  }

  Future<Map<String, double>?> _forwardGeocode(String query) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?format=json&q=${Uri.encodeComponent(query)}&limit=1',
      );
      final res = await http.get(
        uri,
        headers: {'User-Agent': 'KiranaAI/1.0 (contact@lohiyaai.com)'},
      );
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);

    // Sync auto-detected values into text fields whenever GPS resolves
    ref.listen<OnboardingState>(onboardingProvider, (prev, next) {
      final prevData = prev?.data;
      final nextData = next.data;
      if (nextData.address != (prevData?.address ?? '') &&
          nextData.address.isNotEmpty) {
        _addressCtrl.text = nextData.address;
      }
      if (nextData.region != (prevData?.region ?? '') &&
          nextData.region.isNotEmpty) {
        _cityCtrl.text = nextData.region;
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.locationTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            l10n.locationSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate(delay: 50.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: state.isLocationLoading
                ? null
                : () => ref.read(onboardingProvider.notifier).detectLocation(),
            icon: state.isLocationLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location_rounded),
            label: Text(
              state.isLocationLoading
                  ? l10n.locationDetecting
                  : l10n.locationDetect,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: BrandColors.primary,
              side: const BorderSide(color: BrandColors.primary),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: BrandColors.error),
            ).animate().fadeIn(duration: 300.ms),
          ],
          if (state.data.latitude != null) ...[
            const SizedBox(height: 16),
            _LocationBadge(
                  lat: state.data.latitude!,
                  lon: state.data.longitude!,
                  location: state.data.location,
                  region: state.data.region,
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(begin: const Offset(0.92, 0.92)),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  l10n.locationOrManual,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          BrandTextField(
            controller: _addressCtrl,
            label: l10n.locationAddressLabel,
            hint: l10n.locationAddressHint,
            maxLines: 2,
          ).animate(delay: 150.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          BrandTextField(
            controller: _cityCtrl,
            label: l10n.locationCityLabel,
            hint: l10n.locationCityHint,
            keyboardType: TextInputType.streetAddress,
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 36),
          PrimaryButton(
            label: _geocoding
                ? l10n.locationGettingCoords
                : l10n.commonContinue,
            isLoading: _geocoding,
            onPressed: _geocoding ? null : _submit,
          ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _LocationBadge extends StatelessWidget {
  final double lat;
  final double lon;
  final String location;
  final String region;

  const _LocationBadge({
    required this.lat,
    required this.lon,
    required this.location,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BrandColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BrandColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: BrandColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: BrandColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.isNotEmpty
                      ? location
                      : AppLocalizations.of(context).locationDetected,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: BrandColors.success,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  region.isNotEmpty
                      ? region
                      : '${lat.toStringAsFixed(4)}°N, ${lon.toStringAsFixed(4)}°E',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: BrandColors.success,
            size: 20,
          ),
        ],
      ),
    );
  }
}
