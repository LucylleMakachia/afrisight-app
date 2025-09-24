import 'package:get/get.dart';
// Add aliases to avoid ambiguous import errors
import '../screens/home_screen.dart' as home_screen;
import '../screens/onboarding_screen.dart' as onboarding_screen;

import '../screens/splash_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/country_details_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.signin,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const home_screen.HomeScreen(), // Use alias here
    ),
    GetPage(
      name: Routes.explore,
      page: () => ExploreScreen(),
    ),
    GetPage(
      name: Routes.favorites,
      page: () => FavoritesScreen(),
    ),
    GetPage(
      name: Routes.countryDetails,
      page: () => CountryDetailsScreen(country: Get.arguments),
    ),
    GetPage(
      name: Routes.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => NotificationsScreen(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const onboarding_screen.OnboardingScreen(), // Alias here
    ),
  ];
}
