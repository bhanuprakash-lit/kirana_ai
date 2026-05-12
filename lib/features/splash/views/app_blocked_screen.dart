import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/brand_theme.dart';

class AppBlockedScreen extends StatelessWidget {
  final String reason;
  final bool isStoreBlocked; // false = whole app blocked, true = just this store

  const AppBlockedScreen({
    super.key,
    required this.reason,
    this.isStoreBlocked = false,
  });

  Future<void> _contactUs(BuildContext context) async {
    final subject = isStoreBlocked
        ? 'Store Access Issue — Kirana AI'
        : 'App Access Issue — Kirana AI';
    final body = 'Hello LohiyaAI Team,\n\n'
        'I am unable to access the Kirana AI app.\n\n'
        'Displayed reason: $reason\n\n'
        'Please help me restore access.\n\n'
        '— Kirana Owner';

    final uri = Uri(
      scheme: 'mailto',
      path: 'support@lohiyaai.com',
      query: _encodeQuery({'subject': subject, 'body': body}),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please email support@lohiyaai.com directly.'),
        ),
      );
    }
  }

  String _encodeQuery(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: BrandColors.error.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block_rounded,
                  size: 44,
                  color: BrandColors.error,
                ),
              ),
              const SizedBox(height: 28),

              Text(
                isStoreBlocked ? 'Store Temporarily Unavailable' : 'App Temporarily Unavailable',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: BrandColors.ink,
                ),
              ),
              const SizedBox(height: 14),

              if (reason.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BrandColors.surfaceTint,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BrandColors.border),
                  ),
                  child: Text(
                    reason,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: BrandColors.ink,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const Text(
                'We are working to resolve this as soon as possible. '
                'If you need immediate help, tap the button below.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: BrandColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),

              ElevatedButton.icon(
                onPressed: () => _contactUs(context),
                icon: const Icon(Icons.mail_outline_rounded, size: 20),
                label: const Text(
                  'Contact Us',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront_rounded,
                      size: 14, color: BrandColors.muted),
                  const SizedBox(width: 6),
                  Text(
                    'Kirana AI by LohiyaAI',
                    style: const TextStyle(
                      fontSize: 12,
                      color: BrandColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
