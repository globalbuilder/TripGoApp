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
import '../../../attractions/presentation/pages/attractions_screen.dart';
import '../../../attractions/presentation/pages/map_screen.dart';
import '../../../attractions/presentation/pages/categories_screen.dart';
import '../../../app/presentation/pages/currency_converter_screen.dart';
import '../../../notifications/presentation/blocs/notifications_bloc.dart';
import '../../../notifications/presentation/blocs/notifications_event.dart';
import '../../../notifications/presentation/blocs/notifications_state.dart';

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
    CategoriesPage(),
    CurrencyConverterScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() {
    context.read<AccountsBloc>().add(FetchUserInfoEvent());
    context.read<NotificationsBloc>().add(const LoadNotifications());
  }

  Future<bool> _onWillPop() async {
    final exit = await showExitConfirmationDialog(context);
    if (exit) exitApp();
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
              onPressed: () => Navigator.pushNamed(context, AppRouter.searchAttractions),
            ),
            BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (_, notif) {
                final count = notif.unreadCount;
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () => Navigator.pushNamed(context, AppRouter.notifications),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            count > 9 ? '9+' : '$count',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        drawer: BlocBuilder<AccountsBloc, AccountsState>(
          builder: (_, acct) => CustomDrawer(
            username: acct.user?.username ?? '',
            email: acct.user?.email ?? '',
            profileImageUrl: acct.user?.imageUrl ?? '',
            onLogout: () {
              context.read<AccountsBloc>().add(LogoutEvent());
              Navigator.pushReplacementNamed(context, AppRouter.login);
            },
          ),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: CustomBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Attractions"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Convert"),
          ],
        ),
      ),
    );
  }
}
