import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_provider.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/onboarding_prefs.dart';
import '../../core/theme/theme_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/identity_page.dart';
import '../../features/auth/presentation/pages/referral_page.dart';
import '../../features/auth/presentation/pages/account_confirmation_page.dart';
import '../../features/campus/presentation/pages/campus_selection_page.dart';
import '../../features/campus/presentation/pages/campus_page.dart';
import '../../features/vendors/presentation/pages/home_page.dart';
import '../../features/vendors/presentation/pages/canteen_detail_page.dart';
import '../../features/vendors/presentation/pages/canteen_list_page.dart';
import '../../features/menu/presentation/pages/menu_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/recharge_wallet_page.dart';
import '../../features/wallet/presentation/pages/recharge_step1_page.dart';
import '../../features/wallet/presentation/pages/recharge_step2_self_page.dart';
import '../../features/wallet/presentation/pages/recharge_step2_friend_page.dart';
import '../../features/wallet/presentation/pages/recharge_step3_page.dart';
import '../../features/wallet/presentation/pages/recharge_confirmation_page.dart';
import '../../features/wallet/presentation/pages/send_money_page.dart';
import '../../features/wallet/presentation/pages/transaction_history_page.dart';
import '../../features/orders/presentation/pages/order_history_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';

import '../../features/orders/presentation/pages/packaging_page.dart';
import '../../features/payments/presentation/pages/payment_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/legal_page.dart';
import '../../features/settings/presentation/pages/help_support_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_dashboard_page.dart';
import '../../features/ambassador/presentation/pages/promo_code_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_stats_page.dart';
import '../../features/ambassador/presentation/pages/commission_history_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_presentation_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_signup_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_application_pages.dart';
import 'main_navigation_wrapper.dart';

part 'app_router.g.dart';

const _publicRoutes = [
  '/',
  '/onboarding',
  '/auth',
  '/auth/identity',
  '/auth/campus-selection',
  '/auth/referral',
  '/auth/account-confirmation',
];

bool _isPublicRoute(String path) {
  return _publicRoutes.any(
    (route) => path == route || path.startsWith('$route/'),
  );
}

GoRouter? _cachedRouter;

bool _hasSession(Ref ref) =>
    ref.read(authRepositoryProvider).isAuthenticated();

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  ref.listen(authProvider, (_, __) {
    _cachedRouter?.refresh();
  });
  if (_cachedRouter != null) return _cachedRouter!;

  _cachedRouter = GoRouter(
    initialLocation: _hasSession(ref) ? '/home' : '/',
    redirect: (context, state) {
      final isLoggedIn = _hasSession(ref);
      final path = state.uri.path;
      final isGoingToPublic = _isPublicRoute(path);

      if (!isLoggedIn && !isGoingToPublic) {
        return '/auth';
      }

      if (!isLoggedIn &&
          path == '/onboarding' &&
          hasSeenOnboarding(ref.read(sharedPreferencesProvider))) {
        return '/auth';
      }

      if (isLoggedIn &&
          (path == '/' || path == '/auth' || path == '/onboarding')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'identity',
            builder: (context, state) => const IdentityPage(),
          ),
          GoRoute(
            path: 'campus-selection',
            builder: (context, state) => const CampusSelectionPage(),
          ),
          GoRoute(
            path: 'referral',
            builder: (context, state) => const ReferralPage(),
          ),
          GoRoute(
            path: 'account-confirmation',
            builder: (context, state) => const AccountConfirmationPage(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigationWrapper(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/order-history',
            builder: (context, state) => const OrderHistoryPage(),
          ),
          GoRoute(
            path: '/order-detail',
            builder: (context, state) {
              final extra = state.extra;
              final id = extra is String ? extra : extra?.toString() ?? '';
              return OrderDetailPage(orderId: id);
            },
          ),
          GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/canteen-list',
            builder: (context, state) => const CanteenListPage(),
          ),
          GoRoute(
            path: '/canteen-detail',
            builder: (context, state) {
              final extra = state.extra;
              final vendorId = extra is String
                  ? extra
                  : extra is Map
                  ? extra['vendorId'] as String?
                  : null;
              return CanteenDetailPage(vendorId: vendorId);
            },
          ),
          GoRoute(
            path: '/menu-detail',
            builder: (context, state) {
              final extra = state.extra;
              String? itemId;
              String? vendorId;
              if (extra is String) {
                itemId = extra;
              } else if (extra is Map) {
                itemId = extra['itemId'] as String?;
                vendorId = extra['vendorId'] as String?;
              }
              return MenuDetailPage(itemId: itemId, vendorId: vendorId);
            },
          ),
          GoRoute(
            path: '/recharge-wallet',
            builder: (context, state) => const RechargeWalletPage(),
          ),
          GoRoute(
            path: '/recharge/step1',
            builder: (context, state) => const RechargeStep1Page(),
          ),
          GoRoute(
            path: '/recharge/step2/self',
            builder: (context, state) => const RechargeStep2SelfPage(),
          ),
          GoRoute(
            path: '/recharge/step2/friend',
            builder: (context, state) => const RechargeStep2FriendPage(),
          ),
          GoRoute(
            path: '/recharge/step3',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              return RechargeStep3Page(data: data);
            },
          ),
          GoRoute(
            path: '/recharge/confirmation',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              return RechargeConfirmationPage(data: data);
            },
          ),
          GoRoute(
            path: '/send-money',
            builder: (context, state) => const SendMoneyPage(),
          ),
          GoRoute(
            path: '/transaction-history',
            builder: (context, state) => const TransactionHistoryPage(),
          ),
          GoRoute(
            path: '/packaging',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              return PackagingPage(data: data);
            },
          ),
          GoRoute(
            path: '/payment',
            builder: (context, state) => const PaymentPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/edit-profile',
            builder: (context, state) => const EditProfilePage(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: '/legal/terms',
            builder: (context, state) => const LegalPage(
              title: 'Conditions d’utilisation',
              kind: LegalKind.terms,
            ),
          ),
          GoRoute(
            path: '/legal/privacy',
            builder: (context, state) => const LegalPage(
              title: 'Confidentialité',
              kind: LegalKind.privacy,
            ),
          ),
          GoRoute(
            path: '/legal/mentions',
            builder: (context, state) => const LegalPage(
              title: 'Mentions légales',
              kind: LegalKind.mentions,
            ),
          ),
          GoRoute(
            path: '/legal/cookies',
            builder: (context, state) => const LegalPage(
              title: 'Gestion des cookies',
              kind: LegalKind.cookies,
            ),
          ),
          GoRoute(
            path: '/help-support',
            builder: (context, state) => const HelpSupportPage(),
          ),
          GoRoute(
            path: '/campus',
            builder: (context, state) => const CampusPage(),
          ),
          GoRoute(
            path: '/ambassador-dashboard',
            builder: (context, state) => const AmbassadorDashboardPage(),
          ),
          GoRoute(
            path: '/promo-code',
            builder: (context, state) => const PromoCodePage(),
          ),
          GoRoute(
            path: '/ambassador-stats',
            builder: (context, state) => const AmbassadorStatsPage(),
          ),
          GoRoute(
            path: '/commission-history',
            builder: (context, state) => const CommissionHistoryPage(),
          ),
          GoRoute(
            path: '/ambassador-presentation',
            builder: (context, state) => const AmbassadorPresentationPage(),
          ),
          GoRoute(
            path: '/ambassador-signup',
            builder: (context, state) => const AmbassadorSignupPage(),
          ),
          GoRoute(
            path: '/ambassador/conditions',
            builder: (context, state) => const AmbassadorConditionsPage(),
          ),
          GoRoute(
            path: '/ambassador/code',
            builder: (context, state) => AmbassadorPromoCodePage(
              applicationData: AmbassadorApplicationData.fromMap(
                state.extra as Map<String, dynamic>? ?? const {},
              ),
            ),
          ),
          GoRoute(
            path: '/ambassador/recap',
            builder: (context, state) => AmbassadorRecapPage(
              applicationData: AmbassadorApplicationData.fromMap(
                state.extra as Map<String, dynamic>? ?? const {},
              ),
            ),
          ),
          GoRoute(
            path: '/ambassador/pending',
            builder: (context, state) =>
                AmbassadorPendingPage(promoCode: state.extra as String),
          ),
        ],
      ),
    ],
  );
  return _cachedRouter!;
}
