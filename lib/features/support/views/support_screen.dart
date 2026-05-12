import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../auth/providers/user_provider.dart';
import '../../profile/providers/store_settings_provider.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  String _version = '...';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = 'v${info.version}+${info.buildNumber}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Header Image or Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: BrandColors.surfaceTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  size: 50,
                  color: BrandColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get instant answers to your questions',
              style: TextStyle(color: BrandColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Options List
            _SupportOption(
              icon: Icons.help_outline_rounded,
              title: 'Frequently Asked Questions',
              subtitle: 'Common questions and answers',
              onTap: () => context.push('/profile/support/faq'),
            ),
            _SupportOption(
              icon: Icons.bug_report_outlined,
              title: 'Report an Issue',
              subtitle: 'Encountered a bug? let us know',
              onTap: () => context.push('/profile/support/report'),
            ),
            _SupportOption(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Chat with us',
              subtitle: 'Connect with our support team',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat support coming soon!')),
                );
              },
            ),
            _SupportOption(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'Send us an email directly',
              onTap: _handleEmailSupport,
              isLast: true,
            ),

            const SizedBox(height: 32),

            // Version Info
            Text(
              'Kirana AI $_version',
              style: const TextStyle(color: BrandColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Future<void> _handleEmailSupport() async {
  //   final user = ref.read(userProvider).value;
  //   final store = ref.read(storeSettingsProvider).value;

  //   final name = user?.fullName ?? 'Store Owner';
  //   final storeName = store?.name ?? 'Unknown Store';
  //   final storeId = store?.storeId ?? 0;

  //   final Uri emailLaunchUri = Uri(
  //     scheme: 'mailto',
  //     path: 'support@lohiyaai.com',
  //     query: encodeQueryParameters(<String, String>{
  //       'subject': 'Support Request: $storeName (ID: $storeId)',
  //       'body':
  //           'Hello LohiyaAI Support Team,\n\n'
  //           'I am writing to you regarding...\n\n\n'
  //           '--- Details ---\n'
  //           'Owner: $name\n'
  //           'Store: $storeName\n'
  //           'Store ID: $storeId\n'
  //           'App Version: $_version',
  //     }),
  //   );

  //   if (await canLaunchUrl(emailLaunchUri)) {
  //     await launchUrl(emailLaunchUri);
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'Could not launch email client. Please email support@lohiyaai.com directly.',
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  Future<void> _handleEmailSupport() async {
    try {
      final user = ref.read(userProvider).value;
      final store = ref.read(storeSettingsProvider).value;

      final name = user?.fullName ?? 'Store Owner';
      final storeName = store?.name ?? 'Unknown Store';
      final storeId = store?.storeId ?? 0;

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'support@lohiyaai.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Support Request: $storeName (ID: $storeId)',
          'body':
              'Hello LohiyaAI Support Team,\n\n'
              'I am writing to you regarding...\n\n\n'
              '--- Details ---\n'
              'Owner: $name\n'
              'Store: $storeName\n'
              'Store ID: $storeId\n'
              'App Version: $_version',
        }),
      );

      final canLaunch = await canLaunchUrl(emailLaunchUri);

      debugPrint('Email URI: $emailLaunchUri');
      debugPrint('Can launch: $canLaunch');

      if (canLaunch) {
        final launched = await launchUrl(emailLaunchUri);

        debugPrint('Launch result: $launched');

        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open email app.')),
          );
        }
      } else {
        debugPrint('Cannot launch email URI');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to open email app.')),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Email launch error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong while opening email app.'),
          ),
        );
      }
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}

class _SupportOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;

  const _SupportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: BrandColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(icon, color: BrandColors.primary, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: BrandColors.muted,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: BrandColors.muted,
            size: 20,
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 1),
          ),
      ],
    );
  }
}
