// lib/app_router.dart

import 'package:flutter/material.dart';

// Existing imports
import 'features/app/presentation/pages/splash_screen.dart';
import 'features/app/presentation/pages/home_screen.dart';
import 'features/accounts/presentation/pages/login_screen.dart';
import 'features/accounts/presentation/pages/registration_screen.dart';
import 'features/accounts/presentation/pages/profile_screen.dart';
import 'features/accounts/presentation/pages/profile_edit_screen.dart';
import 'features/accounts/presentation/pages/password_change_screen.dart';

// NEW: import your SettingsScreen
import 'features/settings/presentation/pages/settings_screen.dart';

// NEW: import Attractions pages
import 'features/attractions/presentation/pages/categories_screen.dart';
import 'features/attractions/presentation/pages/attractions_screen.dart';
import 'features/attractions/presentation/pages/attraction_detail_screen.dart';
import 'features/attractions/presentation/pages/favorites_screen.dart';
import 'features/attractions/presentation/pages/search_attraction_screen.dart';
import 'features/attractions/presentation/pages/feedback_screen.dart';
import 'features/attractions/presentation/pages/currency_converter_screen.dart';
import 'features/attractions/presentation/pages/map_screen.dart';

class AppRouter {
  // Existing route constants
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String changePassword = '/change-password';
  static const String settings = '/settings';

  // NEW: route constants for attractions
  static const String categories = '/categories';
  static const String attractions = '/attractions';
  static const String attractionDetail = '/attraction-detail';
  static const String favorites = '/favorites';
  static const String searchAttractions = '/search-attractions';
  static const String feedback = '/feedback';
  static const String currencyConverter = '/currency-converter';
  static const String map = '/map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Existing routes
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case profileEdit:
        return MaterialPageRoute(builder: (_) => const ProfileEditScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const PasswordChangeScreen());

      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      // NEW: Attractions Feature
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesPage());
      case attractions:
        return MaterialPageRoute(builder: (_) => const AttractionsPage());
      case attractionDetail:
        // Expecting an int argument for attractionId
        final attractionId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => AttractionDetailPage(attractionId: attractionId),
        );
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case searchAttractions:
        return MaterialPageRoute(builder: (_) => const SearchAttractionPage());
      case currencyConverter:
        return MaterialPageRoute(builder: (_) => const CurrencyConverterScreen());
      case feedback:
        // Expecting a Map with "attractionId" & optional "existingFeedback"
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final attractionId = args['attractionId'] as int? ?? 0;
        // You could cast existingFeedback to List<FeedbackEntity> if needed
        return MaterialPageRoute(
          builder: (_) => FeedbackPage(
            attractionId: attractionId,
            // If you have a typed list, parse it. Otherwise, pass empty or raw
            existingFeedback: const [],
          ),
        );
      case map:
        // Expecting a list of AttractionEntity or empty
        final attractionsList = settings.arguments as List? ?? [];
        return MaterialPageRoute(
          builder: (_) => MapScreen(
            attractions: attractionsList.cast(), // if typed
          ),
        );

      // Default
      default:
        // If no matching route, fall back to splash
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
