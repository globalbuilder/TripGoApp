import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Accounts Dependencies
import 'features/accounts/domain/repositories/accounts_repository.dart';
import 'features/accounts/domain/usecases/change_password.dart';
import 'features/accounts/domain/usecases/get_user_info.dart';
import 'features/accounts/domain/usecases/login.dart';
import 'features/accounts/domain/usecases/logout.dart';
import 'features/accounts/domain/usecases/register.dart';
import 'features/accounts/domain/usecases/update_profile.dart';
import 'features/accounts/presentation/blocs/accounts_bloc.dart';

// Settings Dependency
import 'features/settings/presentation/blocs/settings_bloc.dart';

import 'injection.dart' as di;
import 'app_router.dart';
import 'core/theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AccountsRepository>(
          create: (_) => di.sl<AccountsRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountsBloc>(
            create: (_) => AccountsBloc(
              loginUseCase: di.sl<Login>(),
              logoutUseCase: di.sl<Logout>(),
              registerUseCase: di.sl<Register>(),
              getUserInfoUseCase: di.sl<GetUserInfo>(),
              updateProfileUseCase: di.sl<UpdateProfile>(),
              changePasswordUseCase: di.sl<ChangePassword>(),
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (_) => di.sl<SettingsBloc>(),
          ),
        ],
        // Provide ThemeManager from GetIt through a ChangeNotifierProvider,
        // then use Consumer to rebuild MaterialApp when theme changes.
        child: ChangeNotifierProvider<ThemeManager>.value(
          value: di.sl<ThemeManager>(),
          child: Consumer<ThemeManager>(
            builder: (context, themeManager, _) {
              return MaterialApp(
                title: 'TripGo',
                debugShowCheckedModeBanner: false,
                theme: themeManager.currentTheme,
                // The initialRoute and onGenerateRoute handle navigation.
                initialRoute: AppRouter.splash,
                onGenerateRoute: AppRouter.generateRoute,
              );
            },
          ),
        ),
      ),
    );
  }
}
