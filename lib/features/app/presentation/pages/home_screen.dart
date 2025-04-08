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

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    AttractionsPage(),
    MapScreen(),
    CategoriesScreen(),
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
              onPressed: () async {
                
                // Later, implement search screen navigation.
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Later, implement notification screen navigation.
              },
            ),
          ],
        ),
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
        // body: GlobalConnectivityBanner(
        //   child: _pages[_currentIndex],
        // ),
        body:_pages[_currentIndex],
        bottomNavigationBar: CustomBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Attractions"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          ],
        ),
      ),
    );
  }
}

// Stub pages for the HomeScreen tabs:

class AttractionsPage extends StatelessWidget {
  const AttractionsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Attractions Page: List of Attractions"));
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Map Screen: Google Map of Attractions"));
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Categories Screen: List of Categories"));
  }
}
