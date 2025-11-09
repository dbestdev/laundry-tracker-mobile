import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/authentication/presentation/pages/welcome_screen.dart';
import '../../features/authentication/presentation/pages/sign_up_screen.dart';
import '../../features/authentication/presentation/pages/sign_in_screen.dart';
import '../../features/authentication/presentation/pages/otp_verification_screen.dart';
import '../../features/authentication/presentation/pages/forgot_password_screen.dart';
import '../../features/authentication/presentation/pages/reset_password_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/orders/presentation/pages/view_all_orders_screen.dart';

// Route names
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String passwordResetSuccess = '/password-reset-success';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String viewAllOrders = '/view-all-orders';
}

// Router provider
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    routes: [
      // Onboarding Route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),

      // Welcome Route
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _slideTransition(animation, child);
          },
        ),
      ),

      // Sign In Route
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signIn',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignInScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _slideTransition(animation, child);
          },
        ),
      ),

      // Sign Up Route
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signUp',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _slideTransition(animation, child);
          },
        ),
      ),

      // OTP Verification Route
      GoRoute(
        path: AppRoutes.otpVerification,
        name: 'otpVerification',
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final isFromSignUp = state.uri.queryParameters['fromSignUp'] == 'true';

          return CustomTransitionPage(
            key: state.pageKey,
            child: OtpVerificationScreen(
              email: email,
              isFromSignUp: isFromSignUp,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return _slideTransition(animation, child);
            },
          );
        },
      ),

      // Forgot Password Route
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _slideTransition(animation, child);
          },
        ),
      ),

      // Reset Password Route
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';

          return CustomTransitionPage(
            key: state.pageKey,
            child: ResetPasswordScreen(
              email: email,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return _slideTransition(animation, child);
            },
          );
        },
      ),

      // Home Route
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),

      // Notifications Route
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _slideTransition(animation, child);
          },
        ),
      ),

      // View All Orders Route
      GoRoute(
        path: AppRoutes.viewAllOrders,
        name: 'viewAllOrders',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ViewAllOrdersScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _slideTransition(animation, child);
          },
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
          ],
        ),
      ),
    ),
  );
});

// Slide transition helper
Widget _slideTransition(Animation<double> animation, Widget child) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
