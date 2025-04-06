// lib/core/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';

/// A reusable app bar that uses colors from the theme,
/// with an optional leading widget and actions.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    this.leading,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get colors from the theme (using the app_theme values).
    final appBarColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return AppBar(
      leading: leading,
      backgroundColor: appBarColor,
      foregroundColor: textColor,
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
