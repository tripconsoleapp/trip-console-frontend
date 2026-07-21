import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/phone_auth_provider.dart';
import 'providers/email_auth_provider.dart';
import 'providers/new_trip_provider.dart';
import 'providers/hotel_booking_provider.dart';
import 'providers/restaurant_booking_provider.dart';
import 'utils/app_theme.dart';
import 'utils/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // No Firebase project wired up yet (missing google-services.json /
    // GoogleService-Info.plist) — let the UI still run so screens can be
    // previewed; phone auth calls will fail until the project is configured.
    debugPrint('Firebase.initializeApp() failed: $e');
  }
  runApp(const TripConsoleApp());
}

class TripConsoleApp extends StatelessWidget {
  const TripConsoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhoneAuthProvider()),
        ChangeNotifierProvider(create: (_) => EmailAuthProvider()),
        ChangeNotifierProvider(create: (_) => NewTripProvider()),
        ChangeNotifierProvider(create: (_) => HotelBookingProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantBookingProvider()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context);
          return MaterialApp.router(
            title: 'Trip.Console',
            theme: AppTheme.light,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
