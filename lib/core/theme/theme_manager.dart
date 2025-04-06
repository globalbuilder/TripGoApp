// lib/core/theme/theme_manager.dart

import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Manages the light/dark theme state across the app.
class ThemeManager extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  /// Returns the currently active [ThemeData].
  ThemeData get currentTheme => _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

  /// Toggles between light and dark themes.
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Set the theme explicitly (e.g., from saved preferences).
  void setTheme(bool darkMode) {
    _isDark = darkMode;
    notifyListeners();
  }
}
