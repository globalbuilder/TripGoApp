// lib/core/widgets/custom_text_field.dart

import 'package:flutter/material.dart';

/// A reusable text form field widget that uses the app's [InputDecorationTheme].
/// Wrap it in a form or use it standalone.
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  /// **Add this line**: optional keyboardType parameter
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.obscureText = false,
    this.icon,
    this.validator,
    this.onSaved,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,

      /// Use the optional keyboardType
      keyboardType: keyboardType,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}
