import 'package:flutter/material.dart';

/// A bottom navigation bar for the Home screen.
/// The first tab is now labeled "Attractions" (replacing "Home").
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.primary,
      selectedItemColor: theme.colorScheme.onPrimary,
      unselectedItemColor: theme.colorScheme.onPrimary.withOpacity(0.6),
      selectedIconTheme: IconThemeData(
        size: 28,
        color: theme.colorScheme.onPrimary,
        shadows: [
          BoxShadow(
            color: theme.colorScheme.onPrimary.withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
        color: theme.colorScheme.onPrimary.withOpacity(0.6),
      ),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onPrimary,
      ),
      unselectedLabelStyle: TextStyle(
        color: theme.colorScheme.onPrimary.withOpacity(0.6),
      ),
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}
