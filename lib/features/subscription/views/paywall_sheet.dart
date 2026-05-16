import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/brand_theme.dart';

/// Shows a Pro-feature paywall bottom sheet and returns true if the user
/// chose to go to the subscription screen, false otherwise.
Future<bool> showPaywallSheet(
  BuildContext context, {
  required String featureName,
  required String featureDescription,
  IconData featureIcon = Icons.workspace_premium_rounded,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _PaywallSheet(
      featureName: featureName,
      featureDescription: featureDescription,
      featureIcon: featureIcon,
    ),
  );
  return result ?? false;
}

class _PaywallSheet extends StatelessWidget {
  final String featureName;
  final String featureDescription;
  final IconData featureIcon;

  const _PaywallSheet({
    required this.featureName,
    required this.featureDescription,
    required this.featureIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Pro badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_rounded, size: 14, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'PRO FEATURE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Feature icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(featureIcon, size: 36, color: const Color(0xFF7C3AED)),
          ).animate().scale(delay: 100.ms),

          const SizedBox(height: 20),

          Text(
            featureName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: BrandColors.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            featureDescription,
            style: const TextStyle(
              fontSize: 14,
              color: BrandColors.muted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // What's in Pro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pro Plan includes:',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(height: 10),
                ..._proFeatures.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 16, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 13,
                            color: BrandColors.ink,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Price + CTA
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Not Now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    context.push('/profile/subscription');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text(
                    'Upgrade to Pro  ₹500/mo · just ₹17/day',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _proFeatures = [
    'Everything in Basic',
    'Vendor & Procurement Management',
    'Cashflow Support (up to ₹10L)',
    'Customer Growth Engine',
    'Priority AI recommendations',
  ];
}
