// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // -----------------------------
  // Light Theme Color Palette
  // -----------------------------
  static const Color lightPrimary = Color(0xFF6A47A7);
  static const Color lightAccent = Color(0xFFE1BEE7);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightContainer = Color(0xFFF7F2FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF000000);
  static const Color lightButton = lightPrimary;

  // -----------------------------
  // Dark Theme Color Palette
  // -----------------------------
  static const Color darkPrimary = Color(0xFF6A47A7);
  static const Color darkAccent = Color(0xFF9E77C9);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkContainer = Color(0xFF2A2140);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkButton = darkPrimary;

  // -----------------------------
  // LIGHT THEME
  // -----------------------------
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: lightPrimary,

    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: lightBackground,
      titleTextStyle: TextStyle(
        color: lightBackground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPrimary,
      brightness: Brightness.light,
    ).copyWith(
      surface: lightSurface,
      onSurface: lightText,
      primary: lightPrimary,
      onPrimary: lightBackground,
      secondary: lightAccent,
      onSecondary: lightText,
      surfaceTint: lightContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightButton,
        foregroundColor: lightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: lightPrimary),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: lightContainer,
      filled: true,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );

  // -----------------------------
  // DARK THEME
  // -----------------------------
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: darkPrimary,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimary,
      foregroundColor: darkText,
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: darkPrimary,
      brightness: Brightness.dark,
    ).copyWith(
      surface: darkSurface,
      onSurface: darkText,
      primary: darkPrimary,
      onPrimary: darkText,
      secondary: darkAccent,
      onSecondary: darkText,
      surfaceTint: darkContainer,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkButton,
        foregroundColor: darkText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: darkPrimary),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: darkContainer,
      filled: true,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
  );
}
