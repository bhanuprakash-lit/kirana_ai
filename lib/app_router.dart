import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/views/login_screen.dart';
import 'features/dashboard/views/dashboard_screen.dart';
import 'features/dashboard/views/intelligence_details/intelligence_detail_screen.dart';
import 'features/onboarding/views/language_select_screen.dart';
import 'features/onboarding/views/onboarding_screen.dart';
import 'features/pos_inventory/views/transaction_history_screen.dart';
import 'features/pos_inventory/views/order_details_screen.dart';
import 'features/profile/views/history_screen.dart';
import 'features/profile/views/kpi_subscription_screen.dart';
import 'features/profile/views/profile_screen.dart';
import 'features/profile/views/store_settings_screen.dart';
import 'features/profile/views/customer_management_screen.dart';
import 'features/associations/views/association_screen.dart';
import 'features/profile/views/config_screen.dart';
import 'features/profile/views/password_screen.dart';
import 'features/profile/views/cashflow_screen.dart';
import 'features/profile/views/customer_detail_screen.dart';
import 'features/referral/models/referral_models.dart';
import 'features/referral/views/referral_screen.dart';
import 'features/referral/views/referral_qr_screen.dart';
import 'features/subscription/views/subscription_screen.dart';
import 'features/support/views/support_screen.dart';
import 'features/support/views/faq_screen.dart';
import 'features/support/views/report_issue_screen.dart';
import 'features/splash/views/splash_screen.dart';
import 'features/profile/views/admin_activity_screen.dart';
import 'features/baskets/views/baskets_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    // Strip /kiranaai prefix from deep links (lohiyaai.com/kiranaai/home → /home)
    redirect: (context, state) {
      final path = state.uri.path;
      if (path == '/') return '/home';
      if (path.startsWith('/kiranaai')) {
        final stripped = path.replaceFirst('/kiranaai', '');
        return stripped.isEmpty ? '/home' : stripped;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) {
          final extra = state.extra as Map<String, String?>?;
          return OnboardingScreen(
            preFilledPhone: extra?['phone'],
            preFilledFirebaseUid: extra?['firebase_uid'],
          );
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/pos-history',
        builder: (context, state) => const TransactionHistoryScreen(),
      ),
      GoRoute(
        path: '/pos-order-details',
        builder: (context, state) {
          final order = state.extra as Map<String, dynamic>;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: '/intelligence-detail/:type',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? 'fast_moving';
          return IntelligenceDetailScreen(type: type);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'cashflow',
            builder: (context, state) => const CashflowScreen(),
          ),
          GoRoute(
            path: 'subscription',
            builder: (context, state) => const SubscriptionScreen(),
          ),
          GoRoute(
            path: 'referral',
            builder: (context, state) => const ReferralScreen(),
            routes: [
              GoRoute(
                path: 'qr',
                builder: (context, state) {
                  final campaign = state.extra as ReferralCampaign;
                  return ReferralQrScreen(campaign: campaign);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'kpis',
            builder: (context, state) => KpiSubscriptionScreen(
              focusSlug: state.uri.queryParameters['focus'],
            ),
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'store',
            builder: (context, state) => const StoreSettingsScreen(),
          ),
          GoRoute(
            path: 'config',
            builder: (context, state) => const ConfigScreen(),
          ),
          GoRoute(
            path: 'password',
            builder: (context, state) => const PasswordScreen(),
          ),
          GoRoute(
            path: 'customers',
            builder: (context, state) => const CustomerManagementScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id =
                      int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                  return CustomerDetailScreen(customerId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'associations',
            builder: (context, state) => const AssociationScreen(),
          ),
          GoRoute(
            path: 'admin-activity',
            builder: (context, state) => const AdminActivityScreen(),
          ),
          GoRoute(
            path: 'baskets',
            builder: (context, state) => const BasketsScreen(),
          ),
          GoRoute(
            path: 'support',
            builder: (context, state) => const SupportScreen(),
            routes: [
              GoRoute(
                path: 'faq',
                builder: (context, state) => const FaqScreen(),
              ),
              GoRoute(
                path: 'report',
                builder: (context, state) => const ReportIssueScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
