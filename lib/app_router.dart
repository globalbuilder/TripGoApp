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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
