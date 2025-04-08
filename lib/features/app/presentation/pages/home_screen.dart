import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_router.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_bar.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../core/widgets/exit_confirmation.dart';
import '../../../accounts/presentation/blocs/accounts_bloc.dart';
import '../../../accounts/presentation/blocs/accounts_event.dart';
import '../../../accounts/presentation/blocs/accounts_state.dart';

// IMPORT the real pages
import '../../../attractions/presentation/pages/attractions_screen.dart';
import '../../../attractions/presentation/pages/categories_screen.dart';
import '../../../attractions/presentation/pages/map_screen.dart';
// If you'd like to implement search or notifications, import those pages too.

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // The actual pages/tabs for this HomeScreen
  final List<Widget> _pages = const [
    AttractionsPage(),
    MapScreen(),
    CategoriesPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Fetch user info on HomeScreen initialization.
    context.read<AccountsBloc>().add(FetchUserInfoEvent());
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showExitConfirmationDialog(context);
    if (shouldExit) {
      exitApp();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'TripGo',
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to the search screen
                Navigator.pushNamed(context, AppRouter.searchAttractions);
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // If you have a Notifications page or route, navigate there
                // e.g. Navigator.pushNamed(context, AppRouter.notifications);
              },
            ),
          ],
        ),
        // Drawer with user info
        drawer: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (context, state) {
            final username = state.user?.username ?? "";
            final email = state.user?.email ?? "";
            final profileImageUrl = state.user?.imageUrl ?? "";

            return CustomDrawer(
              username: username,
              email: email,
              profileImageUrl: profileImageUrl,
              onLogout: () {
                context.read<AccountsBloc>().add(LogoutEvent());
                Navigator.pushReplacementNamed(context, AppRouter.login);
              },
            );
          },
        ),

        // Main content
        body: _pages[_currentIndex],

        // Bottom Nav Bar
        bottomNavigationBar: CustomBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Attractions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Categories",
            ),
          ],
        ),
      ),
    );
  }
}
