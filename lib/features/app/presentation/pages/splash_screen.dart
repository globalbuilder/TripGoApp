// lib/features/app/presentation/pages/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app_router.dart';
import '../../../../core/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    // Wait 2 seconds for splash effect.
    await Future.delayed(const Duration(seconds: 2));
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background for a "fancy" splash screen.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A47A7), Color(0xFF8E63C5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                AppLogo(size: 150),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
