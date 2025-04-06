// lib/core/utils/messages.dart

import 'package:flutter/material.dart';

class MessageUtils {
  /// Displays a success message.
  static void showSuccessMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.green);
  }

  /// Displays an error message.
  static void showErrorMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red);
  }

  /// Displays an information message.
  static void showInfoMessage(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.blue);
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12.0),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
