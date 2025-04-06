// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart' as di;
import 'app_router.dart';
import 'features/accounts/domain/repositories/i_auth_repository.dart';
import 'features/accounts/presentation/blocs/accounts_bloc.dart';
import 'core/theme/app_theme.dart'; // Use your custom theme

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the authentication repository from GetIt.
    final authRepository = di.sl<IAuthRepository>();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IAuthRepository>(
          create: (_) => authRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AccountsBloc>(
            create: (context) =>
                AccountsBloc(authRepository: context.read<IAuthRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'TripGo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme, // Use your custom light theme
          darkTheme: AppTheme.darkTheme, // Use your custom dark theme
          initialRoute: '/splash', // Always start at the splash screen
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
