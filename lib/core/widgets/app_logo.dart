// lib/core/widgets/app_logo.dart

import 'package:flutter/material.dart';

/// Displays the app's main logo as an icon or you can replace the Icon with an image asset.
/// Commonly used on the splash screen with a suitable background.
class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    Key? key,
    this.size = 150,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default to white if no color is provided
    final iconColor = color ?? Colors.white;
    return Icon(
      Icons.flight_takeoff, // Example icon that suggests travel
      size: size,
      color: iconColor,
    );
  }
}
