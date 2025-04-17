import 'package:flutter/material.dart';

// ── App‑level pages ─────────────────────────────────────────
import 'features/app/presentation/pages/splash_screen.dart';
import 'features/app/presentation/pages/home_screen.dart';
import 'features/app/presentation/pages/currency_converter_screen.dart';

// ── Accounts ───────────────────────────────────────────────
import 'features/accounts/presentation/pages/login_screen.dart';
import 'features/accounts/presentation/pages/registration_screen.dart';
import 'features/accounts/presentation/pages/profile_screen.dart';
import 'features/accounts/presentation/pages/profile_edit_screen.dart';
import 'features/accounts/presentation/pages/password_change_screen.dart';

// ── Notifications ─────────────────────────────────────────
import 'features/attractions/domain/entities/attraction_entity.dart';
import 'features/notifications/presentation/pages/notifications_screen.dart';
import 'features/notifications/presentation/pages/notification_detail_screen.dart';

// ── Settings ───────────────────────────────────────────────
import 'features/settings/presentation/pages/settings_screen.dart';

// ── Attractions (incl. map / feedback / favourites) ───────
import 'features/attractions/presentation/pages/categories_screen.dart';
import 'features/attractions/presentation/pages/attractions_screen.dart';
import 'features/attractions/presentation/pages/attraction_detail_screen.dart';
import 'features/attractions/presentation/pages/favorites_screen.dart';
import 'features/attractions/presentation/pages/search_attraction_screen.dart';
import 'features/attractions/presentation/pages/feedback_screen.dart';
import 'features/attractions/presentation/pages/map_screen.dart';

class AppRouter {
  // ── route names (constants) ──────────────────────────────
  static const splash = '/splash';
  static const home = '/home';

  // accounts
  static const login = '/login';
  static const register = '/register';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const changePassword = '/change-password';

  // misc
  static const settings = '/settings';
  static const currencyConverter = '/currency-converter';

  // attractions
  static const categories = '/categories';
  static const attractions = '/attractions';
  static const attractionDetail = '/attraction-detail';
  static const favorites = '/favorites';
  static const searchAttractions = '/search-attractions';
  static const feedback = '/feedback';
  static const map = '/map';

  // notifications
  static const notifications = '/notifications';
  static const notificationDetail = '/notification-detail';

  // ── on‑generate‑route ────────────────────────────────────
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // splash / home
      case splash:
        return _page(const SplashScreen());
      case home:
        return _page(const HomeScreen());

      // ─────────── accounts
      case login:
        return _page(const LoginScreen());
      case register:
        return _page(const RegistrationScreen());
      case profile:
        return _page(const ProfileScreen());
      case profileEdit:
        return _page(const ProfileEditScreen());
      case changePassword:
        return _page(const PasswordChangeScreen());

      // settings
      case AppRouter.settings:
        return _page(const SettingsScreen());

      // ─────────── attractions
      case categories:
        return _page(const CategoriesPage());
      case attractions:
        return _page(const AttractionsPage());
      case attractionDetail:
        final id = settings.arguments as int;
        return _page(AttractionDetailPage(attractionId: id));
      case favorites:
        return _page(const FavoritesPage());
      case searchAttractions:
        return _page(const SearchAttractionPage());
      case currencyConverter:
        return _page(const CurrencyConverterScreen());
      case feedback:
        // we now pass ONLY the id
        final id = settings.arguments as int;
        return _page(FeedbackPage(attractionId: id));
      case map:
        final list =
            (settings.arguments as List<dynamic>? ?? <dynamic>[])
                .cast<AttractionEntity>();
        return _page(MapScreen(attractions: list));

      // ─────────── notifications
      case notifications:
        return _page(const NotificationsScreen());
      case notificationDetail:
        final id = settings.arguments as int;
        return _page(NotificationDetailScreen(id: id));

      default:
        return _page(const SplashScreen());
    }
  }

  // helper – less boiler‑plate
  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
