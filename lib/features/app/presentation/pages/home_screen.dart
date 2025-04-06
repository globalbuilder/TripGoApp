// lib/features/app/presentation/pages/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_go/core/widgets/custom_app_bar.dart';
import 'package:trip_go/core/widgets/custom_bottom_bar.dart';
import 'package:trip_go/core/widgets/custom_drawer.dart';
import 'package:trip_go/features/accounts/presentation/blocs/accounts_bloc.dart';
import 'package:trip_go/features/accounts/presentation/blocs/accounts_event.dart';
import 'package:trip_go/features/accounts/presentation/blocs/accounts_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    MapScreen(),
    CategoriesScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    // Optionally fetch user info (if not already available)
    context.read<AccountsBloc>().add(FetchUserInfoEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'TripGo',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here.
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications page.
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      // Use a dynamic drawer with data from the AccountsBloc.
      drawer: BlocBuilder<AccountsBloc, AccountsState>(
        builder: (context, state) {
          final username = state.user?.username ?? "Guest";
          final email = state.user?.email ?? "";
          final profileImageUrl = state.user?.imageUrl ?? "";
          return CustomDrawer(
            username: username,
            email: email,
            profileImageUrl: profileImageUrl,
            onLogout: () {
              // Dispatch logout event and navigate to login.
              context.read<AccountsBloc>().add(LogoutEvent());
              Navigator.pushReplacementNamed(context, '/login');
            },
          );
        },
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
        ],
      ),
    );
  }
}

// Stub page for Home (shows new & best attractions)
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Page: New & Best Attractions"));
  }
}

// Stub page for Map
class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Map Screen: Google Map of Attractions"));
  }
}

// Stub page for Categories
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Categories Screen: List of Categories"));
  }
}
