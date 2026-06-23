import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/app_update_service.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import 'app_blocked_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    // Check for app updates silently in the background
    try {
      await AppUpdateService.checkForUpdates();
    } catch (_) {}

    if (!mounted) return;

    // ── App-level block check ─────────────────────────────────────────────────
    if (AppConfig.isAppBlocked) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AppBlockedScreen(reason: AppConfig.blockedReason),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarding_completed') ?? false;

    if (!mounted) return;

    if (!onboarded) {
      // First launch: let the user pick a language before the welcome step.
      // `app_locale` is written by LocaleNotifier.setLocale, so its absence
      // means the user hasn't chosen yet.
      final languageChosen = (prefs.getString('app_locale') ?? '').isNotEmpty;
      context.go(languageChosen ? '/onboarding' : '/language');
      return;
    }

    // ── Per-store block check ─────────────────────────────────────────────────
    final storeId = prefs.getInt('store_id') ?? 0;
    if (storeId > 0 && AppConfig.isStoreBlocked(storeId)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AppBlockedScreen(
            reason: AppConfig.blockedReason,
            isStoreBlocked: true,
          ),
        ),
      );
      return;
    }

    // Check if a valid token exists in secure storage
    final token = await ref.read(authRepositoryProvider).getToken();
    if (!mounted) return;

    if (token != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Same palette as the language screen so the launch feels continuous.
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A5F), Color(0xFF243B6B), Color(0xFF312E81)],
          ),
        ),
        child: Stack(
          children: [
            // Soft, slowly drifting colour blobs for depth.
            _Bokeh(
              color: const Color(0xFFF59E0B),
              diameter: 240,
              left: -70,
              top: size.height * 0.10,
              drift: 28,
              delayMs: 0,
            ),
            _Bokeh(
              color: const Color(0xFF34D399),
              diameter: 200,
              right: -60,
              top: size.height * 0.32,
              drift: -32,
              delayMs: 500,
            ),
            _Bokeh(
              color: const Color(0xFF60A5FA),
              diameter: 220,
              left: size.width * 0.18,
              bottom: -90,
              drift: 24,
              delayMs: 900,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Radar pulse rings + glowing breathing logo.
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const _PulseRing(delayMs: 0),
                        const _PulseRing(delayMs: 700),
                        const _PulseRing(delayMs: 1400),
                        Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(
                                      0xFFF59E0B,
                                    ).withValues(alpha: 0.45),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scaleXY(
                              begin: 0.82,
                              end: 1.18,
                              duration: 1800.ms,
                              curve: Curves.easeInOut,
                            )
                            .fade(begin: 0.55, end: 1.0, duration: 1800.ms),
                        Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 28,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.asset(
                                  'assets/logos/logo.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                            .animate()
                            .scale(
                              begin: const Offset(0.4, 0.4),
                              duration: 800.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(duration: 400.ms),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                        'Outlet AI',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                      )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0)
                      .then()
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(
                        duration: 2400.ms,
                        delay: 800.ms,
                        color: Colors.white,
                      ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.supSplashTagline,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w400,
                    ),
                  ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
                  const SizedBox(height: 44),
                  const _LoadingBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A ring that expands outward and fades — repeated for a radar-ping effect.
class _PulseRing extends StatelessWidget {
  final int delayMs;
  const _PulseRing({required this.delayMs});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.40),
              width: 1.5,
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(), delay: delayMs.ms)
        .scaleXY(
          begin: 0.7,
          end: 1.85,
          duration: 2100.ms,
          curve: Curves.easeOut,
        )
        .fadeOut(duration: 2100.ms, curve: Curves.easeOut);
  }
}

/// A soft radial colour blob that gently drifts up/down.
class _Bokeh extends StatelessWidget {
  final Color color;
  final double diameter;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double drift;
  final int delayMs;

  const _Bokeh({
    required this.color,
    required this.diameter,
    required this.drift,
    required this.delayMs,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child:
          Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.30),
                      color.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              )
              .animate(
                onPlay: (c) => c.repeat(reverse: true),
                delay: delayMs.ms,
              )
              .moveY(
                begin: 0,
                end: drift,
                duration: 3200.ms,
                curve: Curves.easeInOut,
              )
              .fade(begin: 0.5, end: 0.9, duration: 3200.ms),
    );
  }
}

/// Slim gradient bar that fills over the splash duration — purposeful
/// "loading" feedback that replaces the generic spinner.
class _LoadingBar extends StatelessWidget {
  const _LoadingBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.white.withValues(alpha: 0.15)),
            ),
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                builder: (_, value, _) => Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF59E0B), Colors.white],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 400.ms);
  }
}
