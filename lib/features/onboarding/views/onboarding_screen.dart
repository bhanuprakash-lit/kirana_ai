import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/theme/brand_theme.dart';
import '../providers/onboarding_provider.dart';
import '../../support/providers/notification_provider.dart';
import 'steps/account_step.dart';
import 'steps/business_step.dart';
import 'steps/consent_step.dart';
import 'steps/location_step.dart';
import 'steps/welcome_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  /// Set when arriving from login screen after phone OTP was already verified.
  final String? preFilledPhone;
  final String? preFilledFirebaseUid;

  const OnboardingScreen({
    super.key,
    this.preFilledPhone,
    this.preFilledFirebaseUid,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final startPage = widget.preFilledPhone != null ? 1 : 0;
    _pageController = PageController(initialPage: startPage);
    if (startPage != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(onboardingProvider.notifier).goToStep(startPage);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OnboardingState>(onboardingProvider, (prev, next) {
      if (next.currentStep != (prev?.currentStep ?? 0)) {
        _pageController.animateToPage(
          next.currentStep,
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeInOutCubic,
        );
      }
      if (next.status == OnboardingStatus.success) {
        ref.read(notificationServiceProvider).uploadToken();
        context.go('/home');
      }
    });

    final state = ref.watch(onboardingProvider);

    return PopScope(
      canPop: state.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && state.currentStep > 0) {
          ref.read(onboardingProvider.notifier).goToStep(state.currentStep - 1);
        }
      },
      child: Scaffold(
        backgroundColor: BrandColors.background,
        body: Column(
          children: [
            if (state.currentStep > 0)
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: _buildHeader(context, state),
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const WelcomeStep(),
                  AccountStep(
                    preFilledPhone: widget.preFilledPhone,
                    preFilledFirebaseUid: widget.preFilledFirebaseUid,
                  ),
                  const BusinessStep(),
                  const LocationStep(),
                  const ConsentStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingState state) {
    final canGoBack = state.currentStep >= 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 24, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: canGoBack
                ? () => ref
                      .read(onboardingProvider.notifier)
                      .goToStep(state.currentStep - 1)
                : null,
            child: AnimatedOpacity(
              opacity: canGoBack ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: BrandColors.border),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 15),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: state.currentStep - 1,
                count: 4,
                effect: WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: BrandColors.primary,
                  dotColor: BrandColors.border,
                  spacing: 8,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${state.currentStep}/4',
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
