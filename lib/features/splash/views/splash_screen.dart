import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/brand_theme.dart';
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
      context.go('/onboarding');
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
    return Scaffold(
      backgroundColor: BrandColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30), // squircle feel
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/logos/logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(0.4, 0.4),
                  duration: 700.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            Text(
                  'Kirana AI',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 34,
                    letterSpacing: -0.5,
                  ),
                )
                .animate(delay: 200.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 8),
            Text(
              'Smart business, smarter you',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.65),
                fontWeight: FontWeight.w400,
              ),
            ).animate(delay: 350.ms).fadeIn(duration: 500.ms),
            const SizedBox(height: 60),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
