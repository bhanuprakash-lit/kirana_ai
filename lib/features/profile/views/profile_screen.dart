import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../providers/store_settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final storeAsync = ref.watch(storeSettingsProvider);

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading profile: $err')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data found.'));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              const SizedBox(height: 24),
              // User Info Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: BrandColors.ink.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BrandColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/logos/logo.png'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: BrandColors.ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          storeAsync.when(
                            loading: () => const SizedBox(
                              height: 14,
                              width: 100,
                              child: LinearProgressIndicator(),
                            ),
                            error: (_, _) => const Text(
                              'Lohiya Store',
                              style: TextStyle(
                                color: BrandColors.muted,
                                fontSize: 14,
                              ),
                            ),
                            data: (store) => Text(
                              store.name,
                              style: const TextStyle(
                                color: BrandColors.muted,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'username: ${user.username}',
                            style: const TextStyle(
                              color: BrandColors.muted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 32),
              // Settings Options
              _ProfileOption(
                icon: Icons.people_outline_rounded,
                label: 'Customer Management',
                subtitle: 'Manage your regular shoppers and khata',
                onTap: () => context.push('/profile/customers'),
              ),
              _ProfileOption(
                icon: Icons.analytics_outlined,
                label: 'KPI Subscriptions',
                subtitle: 'Choose and monitor your key metrics',
                onTap: () => context.push('/profile/kpis'),
              ),
              _ProfileOption(
                icon: Icons.history_rounded,
                label: 'Transaction History',
                subtitle: 'View past purchases and POS orders',
                onTap: () => context.push('/profile/history'),
              ),
              _ProfileOption(
                icon: Icons.storefront_rounded,
                label: 'Store Settings',
                subtitle: 'Manage your store details and layout',
                onTap: () => context.push('/profile/store'),
              ),
              _ProfileOption(
                icon: Icons.tune_rounded,
                label: 'Configuration',
                subtitle: 'POS preferences, AI settings, notifications',
                onTap: () => context.push('/profile/config'),
              ),
              _ProfileOption(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                subtitle: 'Contact us for any assistance',
                onTap: () => context.push('/profile/support'),
              ),
              const _ProfileFooter(),
              // Logout Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    ref.invalidate(onboardingProvider);
                    await ref.read(authRepositoryProvider).clearSession();
                    if (context.mounted) context.go('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    side: const BorderSide(
                      color: BrandColors.error,
                      width: 1.5,
                    ),
                    foregroundColor: BrandColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final version = snap.hasData
            ? 'v${snap.data!.version}+${snap.data!.buildNumber}'
            : '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Image.asset('assets/logos/foreground.png', width: 36, height: 36),
              const SizedBox(height: 6),
              const Text(
                'Kirana AI by LohiyaAI',
                style: TextStyle(
                  fontSize: 12,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              if (version.isNotEmpty)
                Text(
                  version,
                  style: const TextStyle(
                    fontSize: 11,
                    color: BrandColors.muted,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BrandColors.surfaceTint,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: BrandColors.primary, size: 24),
      ),
      title: Text(
        label,
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
    );
  }
}
