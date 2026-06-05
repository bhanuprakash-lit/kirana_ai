import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../../providers/onboarding_provider.dart';

class WelcomeStep extends ConsumerStatefulWidget {
  const WelcomeStep({super.key});

  @override
  ConsumerState<WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends ConsumerState<WelcomeStep> {
  final _slideController = PageController();
  Timer? _timer;
  int _currentSlide = 0;

  // Per-slide visuals; the title/subtitle text is pulled from AppLocalizations
  // at build time so it follows the chosen language.
  static const _slideVisuals = [
    _SlideVisual(
      icon: Icons.storefront_rounded,
      iconColor: Color(0xFFF59E0B),
      gradient: [Color(0xFF243B6B), Color(0xFF1E3A5F)],
    ),
    _SlideVisual(
      icon: Icons.inventory_2_rounded,
      iconColor: Color(0xFF34D399),
      gradient: [Color(0xFF064E3B), Color(0xFF065F46)],
    ),
    _SlideVisual(
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFFF59E0B),
      gradient: [Color(0xFF312E81), Color(0xFF243B6B)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _slideController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      final next = (_currentSlide + 1) % _slideVisuals.length;
      _slideController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titles = [
      l10n.welcomeSlide1Title,
      l10n.welcomeSlide2Title,
      l10n.welcomeSlide3Title,
    ];
    final subtitles = [
      l10n.welcomeSlide1Subtitle,
      l10n.welcomeSlide2Subtitle,
      l10n.welcomeSlide3Subtitle,
    ];

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _slideController,
                onPageChanged: (i) => setState(() => _currentSlide = i),
                itemCount: _slideVisuals.length,
                itemBuilder: (_, i) => _SlideCard(
                  visual: _slideVisuals[i],
                  title: titles[i],
                  subtitle: subtitles[i],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 20,
                child: const LanguageChip(),
              ),
            ],
          ),
        ),
        Container(
          color: BrandColors.background,
          padding: EdgeInsets.fromLTRB(
            28,
            24,
            28,
            40 + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              SmoothPageIndicator(
                controller: _slideController,
                count: _slideVisuals.length,
                effect: WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: BrandColors.primary,
                  dotColor: BrandColors.border,
                  spacing: 8,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      ref.read(onboardingProvider.notifier).goToStep(1),
                  child: Text(l10n.welcomeGetStarted),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: RichText(
                  text: TextSpan(
                    text: l10n.welcomeHaveAccount,
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: l10n.welcomeSignIn,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BrandColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SlideCard extends StatelessWidget {
  final _SlideVisual visual;
  final String title;
  final String subtitle;
  const _SlideCard({
    required this.visual,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: visual.gradient,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(visual.icon, size: 40, color: visual.iconColor),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.4, 0.4),
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 40),
              Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      height: 1.1,
                      fontSize: 36,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 500.ms)
                  .slideX(begin: -0.15, end: 0),
              const SizedBox(height: 16),
              Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.6,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideX(begin: -0.15, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideVisual {
  final IconData icon;
  final Color iconColor;
  final List<Color> gradient;

  const _SlideVisual({
    required this.icon,
    required this.iconColor,
    required this.gradient,
  });
}
