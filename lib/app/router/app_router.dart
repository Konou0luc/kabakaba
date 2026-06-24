import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/identity_page.dart';
import '../../features/auth/presentation/pages/referral_page.dart';
import '../../features/auth/presentation/pages/account_confirmation_page.dart';
import '../../features/campus/presentation/pages/campus_selection_page.dart';
import '../../features/vendors/presentation/pages/home_page.dart';
import '../../features/vendors/presentation/pages/canteen_detail_page.dart';
import '../../features/vendors/presentation/pages/canteen_list_page.dart';
import '../../features/menu/presentation/pages/menu_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/recharge_wallet_page.dart';
import '../../features/wallet/presentation/pages/send_money_page.dart';
import '../../features/wallet/presentation/pages/transaction_history_page.dart';
import '../../features/orders/presentation/pages/order_history_page.dart';
import '../../features/orders/presentation/pages/order_tracking_page.dart';
import '../../features/payments/presentation/pages/payment_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/notifications_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_dashboard_page.dart';
import '../../features/ambassador/presentation/pages/promo_code_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_stats_page.dart';
import '../../features/ambassador/presentation/pages/commission_history_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_presentation_page.dart';
import '../../features/ambassador/presentation/pages/ambassador_signup_page.dart';
import 'main_navigation_wrapper.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
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
      GoRoute(
        path: '/canteen-detail',
        builder: (context, state) => const CanteenDetailPage(),
      ),
      GoRoute(
        path: '/canteen-list',
        builder: (context, state) => const CanteenListPage(),
      ),
      GoRoute(
        path: '/menu-detail',
        builder: (context, state) => const MenuDetailPage(),
      ),
      GoRoute(
        path: '/recharge-wallet',
        builder: (context, state) => const RechargeWalletPage(),
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
        path: '/order-history',
        builder: (context, state) => const OrderHistoryPage(),
      ),
      GoRoute(
        path: '/order-tracking',
        builder: (context, state) => const OrderTrackingPage(),
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
      GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
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
      ShellRoute(
        builder: (context, state, child) => MainNavigationWrapper(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(path: '/cart', builder: (context, state) => const CartPage()),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
