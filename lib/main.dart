import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'injection.dart' as di;          // ← new file name
import 'app_router.dart';
import 'core/theme/theme_manager.dart';

// ── Blocs ───────────────────────────────────────────────────────────
import 'features/accounts/presentation/blocs/accounts_bloc.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';

import 'features/attractions/presentation/blocs/categories_bloc/categories_bloc.dart';
import 'features/attractions/presentation/blocs/attractions_bloc/attractions_bloc.dart';
import 'features/attractions/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'features/attractions/presentation/blocs/feedback_bloc/feedback_bloc.dart';

import 'features/notifications/presentation/blocs/notifications_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();                               // register everything
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Accounts / Settings
        BlocProvider(create: (_) => di.sl<AccountsBloc>()),
        BlocProvider(create: (_) => di.sl<SettingsBloc>()),

        // Attractions feature
        BlocProvider(create: (_) => di.sl<CategoriesBloc>()),
        BlocProvider(create: (_) => di.sl<AttractionsBloc>()),
        BlocProvider(create: (_) => di.sl<FavoritesBloc>()),
        BlocProvider(create: (_) => di.sl<FeedbackBloc>()),   

        // Notifications
        BlocProvider(create: (_) => di.sl<NotificationsBloc>()),
      ],

      child: ChangeNotifierProvider.value(
        value: di.sl<ThemeManager>(),
        child: Consumer<ThemeManager>(
          builder: (_, themeManager, __) => MaterialApp(
            title: 'TripGo',
            debugShowCheckedModeBanner: false,
            theme: themeManager.currentTheme,
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.generateRoute,
          ),
        ),
      ),
    );
  }
}
