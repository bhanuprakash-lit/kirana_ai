import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../providers/onboarding_provider.dart';

class ConsentStep extends ConsumerStatefulWidget {
  const ConsentStep({super.key});

  @override
  ConsumerState<ConsentStep> createState() => _ConsentStepState();
}

class _ConsentStepState extends ConsumerState<ConsentStep> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  Future<void> _submit() async {
    if (!_termsAccepted || !_privacyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).consentAcceptBoth)),
      );
      return;
    }
    final notifier = ref.read(onboardingProvider.notifier);
    notifier.updateData(
      ref
          .read(onboardingProvider)
          .data
          .copyWith(
            consentAccepted: _termsAccepted,
            privacyAccepted: _privacyAccepted,
          ),
    );
    await notifier.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingProvider);
    final isLoading = state.status == OnboardingStatus.loading;
    final canSubmit = _termsAccepted && _privacyAccepted;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.consentTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            l10n.consentSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate(delay: 50.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 28),
          _ConsentCard(
            icon: Icons.gavel_rounded,
            title: l10n.consentTermsTitle,
            summary: l10n.consentTermsSummary,
          ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 12),
          _ConsentCard(
            icon: Icons.shield_rounded,
            title: l10n.consentPrivacyTitle,
            summary: l10n.consentPrivacySummary,
          ).animate(delay: 150.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          _ConsentCheckbox(
            value: _termsAccepted,
            onChanged: (v) => setState(() => _termsAccepted = v ?? false),
            prefix: l10n.consentTermsCheckPrefix,
            linkLabel: l10n.consentTermsTitle,
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 12),
          _ConsentCheckbox(
            value: _privacyAccepted,
            onChanged: (v) => setState(() => _privacyAccepted = v ?? false),
            prefix: l10n.consentPrivacyCheckPrefix,
            linkLabel: l10n.consentPrivacyTitle,
          ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BrandColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: BrandColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: BrandColors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrandColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ],
          const SizedBox(height: 36),
          PrimaryButton(
            label: l10n.consentCompleteSetup,
            isLoading: isLoading,
            onPressed: canSubmit ? _submit : null,
          ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _ConsentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String summary;

  const _ConsentCard({
    required this.icon,
    required this.title,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: BrandColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: BrandColors.primary),
              ),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String prefix;
  final String linkLabel;

  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.prefix,
    required this.linkLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: BrandColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: prefix,
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: linkLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: BrandColors.primary,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: BrandColors.primary,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
