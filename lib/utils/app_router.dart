import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/user_role.dart';
import '../models/trip_package.dart';
import '../models/vendor_option.dart';
import '../models/hotel_option.dart';
import '../models/restaurant_option.dart';
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
import '../screens/home/add_new_listing_screen.dart';
import '../screens/my_trips/my_trips_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/templates/templates_screen.dart';
import '../screens/templates/package_detail_screen.dart';
import '../screens/trip_builder/trip_basics_screen.dart';
import '../screens/trip_builder/trip_destinations_screen.dart';
import '../screens/trip_builder/choose_starting_location_screen.dart';
import '../screens/trip_builder/trip_setup_loading_screen.dart';
import '../screens/trip_builder/trip_participants_screen.dart';
import '../screens/trip_builder/trip_services_screen.dart';
import '../screens/trip_builder/transport_selection_screen.dart';
import '../screens/trip_builder/select_vehicle_type_screen.dart';
import '../screens/trip_builder/vendor_listing_screen.dart';
import '../screens/trip_builder/route_preview_screen.dart';
import '../screens/trip_builder/pick_on_map_screen.dart';
import '../screens/trip_builder/trip_review_screen.dart';
import '../screens/trip_builder/select_hotel_screen.dart';
import '../screens/trip_builder/hotel_detail_screen.dart';
import '../screens/trip_builder/choose_restaurant_screen.dart';
import '../screens/trip_builder/restaurant_menu_screen.dart';
import '../screens/trip_builder/restaurant_review_screen.dart';
import '../screens/trip_builder/plan_quantities_screen.dart';
import '../screens/trip_builder/vehicle_detail_screen.dart';
import '../screens/trip_builder/vehicle_capacity_mismatch_screen.dart';
import '../screens/trip_builder/multi_vehicle_listing_screen.dart';
import '../screens/trip_builder/itinerary_generating_screen.dart';
import '../screens/trip_builder/itinerary_day_screen.dart';
import '../screens/trip_builder/declarations_screen.dart';

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
  static const String myTrips = '/my-trips';
  static const String profile = '/profile';
  static const String tripBasics = '/trip/basics';
  static const String tripDestinations = '/trip/destinations';
  static const String chooseStartingLocation = '/trip/destinations/starting-location';
  static const String tripSetupLoading = '/trip/setting-up';
  static const String addNewListing = '/add-new-listing';
  static const String templates = '/templates';
  static const String packageDetail = '/templates/package';
  static const String tripServices = '/trip/services';
  static const String tripParticipants = '/trip/participants';
  static const String tripReview = '/trip/review';
  static const String transportSelection = '/trip/services/vehicle/transport-selection';
  static const String selectVehicleType = '/trip/services/vehicle/select-type';
  static const String vendorListing = '/trip/services/vendor-listing';
  static const String routePreview = '/trip/destinations/route-preview';
  static const String pickOnMap = '/trip/destinations/pick-on-map';
  static const String selectHotel = '/trip/services/hotel';
  static const String hotelDetail = '/trip/services/hotel/detail';
  static const String chooseRestaurant = '/trip/services/restaurant';
  static const String restaurantMenu = '/trip/services/restaurant/menu';
  static const String restaurantReview = '/trip/services/restaurant/review';
  static const String planQuantities = '/trip/services/restaurant/quantities';
  static const String vehicleDetail = '/trip/services/vehicle/detail';
  static const String vehicleCapacityMismatch = '/trip/services/vehicle/capacity-mismatch';
  static const String multiVehicleListing = '/trip/services/vehicle/multi-listing';
  static const String itineraryGenerating = '/trip/itinerary/generating';
  static const String itineraryDay = '/trip/itinerary/day';
  static const String declarations = '/trip/review/declarations';

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
        GoRoute(path: myTrips, builder: (ctx, state) => const MyTripsScreen()),
        GoRoute(path: profile, builder: (ctx, state) => const ProfileScreen()),
        GoRoute(path: tripBasics, builder: (ctx, state) => const TripBasicsScreen()),
        GoRoute(path: tripDestinations, builder: (ctx, state) => const TripDestinationsScreen()),
        GoRoute(path: chooseStartingLocation, builder: (ctx, state) => const ChooseStartingLocationScreen()),
        GoRoute(path: tripSetupLoading, builder: (ctx, state) => const TripSetupLoadingScreen()),
        GoRoute(path: addNewListing, builder: (ctx, state) => const AddNewListingScreen()),
        GoRoute(path: templates, builder: (ctx, state) => const TemplatesScreen()),
        GoRoute(
          path: packageDetail,
          builder: (ctx, state) {
            final extra = state.extra as ({TripPackage package, bool isTemplate});
            return PackageDetailScreen(package: extra.package, isTemplate: extra.isTemplate);
          },
        ),
        GoRoute(path: tripParticipants, builder: (ctx, state) => const TripParticipantsScreen()),
        GoRoute(path: tripServices, builder: (ctx, state) => const TripServicesScreen()),
        GoRoute(path: tripReview, builder: (ctx, state) => const TripReviewScreen()),
        GoRoute(path: transportSelection, builder: (ctx, state) => const TransportSelectionScreen()),
        GoRoute(path: selectVehicleType, builder: (ctx, state) => const SelectVehicleTypeScreen()),
        GoRoute(
          path: vendorListing,
          builder: (ctx, state) {
            final extra = state.extra as ({String title, List<VendorOption> options, void Function(VendorOption) onSelect});
            return VendorListingScreen(title: extra.title, options: extra.options, onSelect: extra.onSelect);
          },
        ),
        GoRoute(path: routePreview, builder: (ctx, state) => const RoutePreviewScreen()),
        GoRoute(path: pickOnMap, builder: (ctx, state) => const PickOnMapScreen()),
        GoRoute(path: selectHotel, builder: (ctx, state) => const SelectHotelScreen()),
        GoRoute(
          path: hotelDetail,
          builder: (ctx, state) => HotelDetailScreen(hotel: state.extra as HotelOption),
        ),
        GoRoute(path: chooseRestaurant, builder: (ctx, state) => const ChooseRestaurantScreen()),
        GoRoute(
          path: restaurantMenu,
          builder: (ctx, state) => RestaurantMenuScreen(restaurant: state.extra as RestaurantOption),
        ),
        GoRoute(
          path: restaurantReview,
          builder: (ctx, state) => RestaurantReviewScreen(args: state.extra as RestaurantReviewArgs),
        ),
        GoRoute(
          path: planQuantities,
          builder: (ctx, state) => PlanQuantitiesScreen(args: state.extra as RestaurantReviewArgs),
        ),
        GoRoute(
          path: vehicleDetail,
          builder: (ctx, state) => VehicleDetailScreen(option: state.extra as VendorOption),
        ),
        GoRoute(
          path: vehicleCapacityMismatch,
          builder: (ctx, state) => VehicleCapacityMismatchScreen(option: state.extra as VendorOption),
        ),
        GoRoute(
          path: multiVehicleListing,
          builder: (ctx, state) {
            final extra = state.extra as ({String title, List<VendorOption> options});
            return MultiVehicleListingScreen(title: extra.title, options: extra.options);
          },
        ),
        GoRoute(path: itineraryGenerating, builder: (ctx, state) => const ItineraryGeneratingScreen()),
        GoRoute(
          path: itineraryDay,
          builder: (ctx, state) => ItineraryDayScreen(day: state.extra as int? ?? 0),
        ),
        GoRoute(path: declarations, builder: (ctx, state) => const DeclarationsScreen()),
      ],
      errorBuilder: (ctx, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.uri.path}')),
      ),
    );
  }
}
