import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/user_role.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/get_started_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/verify_email_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/session_expired_screen.dart';
import '../screens/auth/verify_otp_screen.dart';
import '../screens/placeholder/coming_soon_screen.dart';
import '../screens/home/home_dashboard_screen.dart';
import '../screens/trip_builder/trip_basics_screen.dart';
import '../screens/trip_builder/trip_destinations_screen.dart';

/// Central route table. New screens register a route here as they're
/// converted from Figma, in the same order as the project's screen list.
class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String getStarted = '/get-started';
  static const String signUp = '/sign-up';
  static const String roleSelection = '/role-selection';
  static const String verifyEmail = '/verify-email';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String sessionExpired = '/session-expired';
  static const String comingSoon = '/coming-soon';
  static const String home = '/home';
  static const String tripBasics = '/trip/basics';
  static const String tripDestinations = '/trip/destinations';
  static const String tripServices = '/trip/services';
  static const String tripParticipants = '/trip/participants';
  static const String tripReview = '/trip/review';

  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(path: splash, builder: (ctx, state) => const SplashScreen()),
        GoRoute(path: onboarding, builder: (ctx, state) => const OnboardingScreen()),
        GoRoute(path: getStarted, builder: (ctx, state) => const GetStartedScreen()),
        GoRoute(path: signUp, builder: (ctx, state) => const SignUpScreen()),
        GoRoute(path: roleSelection, builder: (ctx, state) => const RoleSelectionScreen()),
        GoRoute(
          path: verifyEmail,
          builder: (ctx, state) => VerifyEmailScreen(role: state.extra as UserRole? ?? UserRole.organizer),
        ),
        GoRoute(path: login, builder: (ctx, state) => const LoginScreen()),
        GoRoute(path: verifyOtp, builder: (ctx, state) => const VerifyOtpScreen()),
        GoRoute(path: forgotPassword, builder: (ctx, state) => const ForgotPasswordScreen()),
        GoRoute(path: resetPassword, builder: (ctx, state) => const ResetPasswordScreen()),
        GoRoute(path: sessionExpired, builder: (ctx, state) => const SessionExpiredScreen()),
        GoRoute(
          path: comingSoon,
          builder: (ctx, state) => ComingSoonScreen(role: state.extra as UserRole? ?? UserRole.operator),
        ),
        GoRoute(path: home, builder: (ctx, state) => const HomeDashboardScreen()),
        GoRoute(path: tripBasics, builder: (ctx, state) => const TripBasicsScreen()),
        GoRoute(path: tripDestinations, builder: (ctx, state) => const TripDestinationsScreen()),
        // TODO(wizard): tripServices, tripParticipants, tripReview register here as they're built.
      ],
      errorBuilder: (ctx, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.uri.path}')),
      ),
    );
  }
}
