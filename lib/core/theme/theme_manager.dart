import 'package:flutter/material.dart';
import 'app_theme.dart';

/// A ChangeNotifier that holds the current theme state.
/// When toggled, it notifies all listeners so that the UI can rebuild.
class ThemeManager extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  /// Returns the active ThemeData based on the current state.
  ThemeData get currentTheme => _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

  /// Toggles between light and dark themes.
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Sets the theme explicitly.
  void setTheme(bool darkMode) {
    _isDark = darkMode;
    notifyListeners();
  }
}
