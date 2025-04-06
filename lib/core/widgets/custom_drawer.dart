// lib/core/widgets/custom_drawer.dart

import 'package:flutter/material.dart';

/// A side drawer with a header showing a gradient background, profile avatar, username, and email.
/// It includes navigation items (Profile, Favorites, Settings, and Logout) all together.
class CustomDrawer extends StatelessWidget {
  final String username;
  final String email;
  final String profileImageUrl;
  final VoidCallback onLogout;

  const CustomDrawer({
    Key? key,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header with gradient background using theme colors.
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: (profileImageUrl.isNotEmpty &&
                            profileImageUrl.startsWith('http'))
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/images/avatar_placeholder.png')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username.isNotEmpty ? username : "Guest",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            // Navigation items are now grouped together in order.
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () => Navigator.pushNamed(context, '/favorites'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
