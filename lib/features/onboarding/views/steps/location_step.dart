import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
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

  @override
  void dispose() {
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final address = _addressCtrl.text.trim();
    final city = _cityCtrl.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please detect or enter your store address.')),
      );
      return;
    }
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your city or district.')),
      );
      return;
    }

    final notifier = ref.read(onboardingProvider.notifier);
    final current = ref.read(onboardingProvider).data;

    // When user edits manually: address becomes location too (short form)
    final location =
        current.location.isNotEmpty ? current.location : address;

    notifier.updateData(
      current.copyWith(
        address: address,
        location: location,
        region: city,
      ),
    );
    notifier.goToStep(4);
  }

  @override
  Widget build(BuildContext context) {
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
            'Where is your\nstore located?',
            style: Theme.of(context).textTheme.headlineMedium,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'We use this to show local insights and enable delivery zones.',
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
            label: Text(state.isLocationLoading
                ? 'Detecting location…'
                : 'Detect My Location'),
            style: OutlinedButton.styleFrom(
              foregroundColor: BrandColors.primary,
              side: const BorderSide(color: BrandColors.primary),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: BrandColors.error),
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
          Row(children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text('or enter manually',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            const Expanded(child: Divider()),
          ]),
          const SizedBox(height: 24),
          BrandTextField(
            controller: _addressCtrl,
            label: 'Store address',
            hint: 'Street, area, landmark…',
            maxLines: 2,
          ).animate(delay: 150.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          BrandTextField(
            controller: _cityCtrl,
            label: 'City / District',
            hint: 'e.g. Hyderabad',
            keyboardType: TextInputType.streetAddress,
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 36),
          PrimaryButton(
            label: 'Continue',
            onPressed: _submit,
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
            child: const Icon(Icons.location_on_rounded,
                color: BrandColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.isNotEmpty ? location : 'Location detected',
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded,
              color: BrandColors.success, size: 20),
        ],
      ),
    );
  }
}
