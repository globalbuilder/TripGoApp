// lib/core/utils/preferences_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _tokenKey = 'auth_token';
  static const String _themeModeKey = 'theme_mode';

  /// Saves the authentication token.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Retrieves the authentication token.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Clears the saved authentication token.
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Saves the theme mode (true for dark, false for light).
  Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDark);
  }

  /// Retrieves the saved theme mode. Defaults to false (light theme).
  Future<bool> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? false;
  }
}
