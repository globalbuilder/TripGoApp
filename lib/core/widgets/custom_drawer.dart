import 'package:flutter/material.dart';

/// A side drawer for the Home screen.
/// - If [username] or [email] are empty, they will be shown as empty strings.
/// - When a drawer item is tapped, the drawer closes before navigating.
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
    // If username or email are empty, use empty strings.
    final displayUsername = username.trim();
    final displayEmail = email.trim();

    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header with gradient background.
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
                    backgroundImage: (profileImageUrl.isNotEmpty && profileImageUrl.startsWith('http'))
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayUsername,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (displayEmail.isNotEmpty)
                    Text(
                      displayEmail,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            // Navigation items.
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
