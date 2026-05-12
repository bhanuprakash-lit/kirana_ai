import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/brand_theme.dart';
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

  static const _slides = [
    _Slide(
      icon: Icons.storefront_rounded,
      iconColor: Color(0xFFF59E0B),
      title: 'Welcome to\nKirana AI',
      subtitle:
          'Your smart business partner for managing your kirana store — built for South India.',
      gradient: [Color(0xFF243B6B), Color(0xFF1E3A5F)],
    ),
    _Slide(
      icon: Icons.inventory_2_rounded,
      iconColor: Color(0xFF34D399),
      title: 'Smart Inventory\nManagement',
      subtitle:
          'Track stock levels, get low-stock alerts, and never run out of your bestselling products.',
      gradient: [Color(0xFF064E3B), Color(0xFF065F46)],
    ),
    _Slide(
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFFF59E0B),
      title: 'Grow Your\nBusiness',
      subtitle:
          'Get AI-powered insights, sales analytics, and personalised tips for your store.',
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
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_currentSlide + 1) % _slides.length;
      _slideController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _slideController,
            onPageChanged: (i) => setState(() => _currentSlide = i),
            itemCount: _slides.length,
            itemBuilder: (_, i) => _SlideCard(slide: _slides[i]),
          ),
        ),
        Container(
          color: BrandColors.background,
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
          child: Column(
            children: [
              SmoothPageIndicator(
                controller: _slideController,
                count: _slides.length,
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
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
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
  final _Slide slide;
  const _SlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: slide.gradient,
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
                    child: Icon(slide.icon, size: 40, color: slide.iconColor),
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
                    slide.title,
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
                    slide.subtitle,
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

class _Slide {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _Slide({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
