// lib/injection.dart

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Core dependencies
import 'core/utils/api_client.dart';
import 'core/utils/preferences_helper.dart';
import 'core/theme/theme_manager.dart';

// Accounts dependencies:
import 'features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'features/accounts/data/repositories/accounts_repository_impl.dart';
import 'features/accounts/domain/repositories/accounts_repository.dart';
import 'features/accounts/domain/usecases/login.dart';
import 'features/accounts/domain/usecases/logout.dart';
import 'features/accounts/domain/usecases/register.dart';
import 'features/accounts/domain/usecases/get_user_info.dart';
import 'features/accounts/domain/usecases/update_profile.dart';
import 'features/accounts/domain/usecases/change_password.dart';

// Settings dependency:
import 'features/settings/presentation/blocs/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Core Dependencies
  sl.registerLazySingleton<PreferencesHelper>(() => PreferencesHelper());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      httpClient: sl<http.Client>(),
      preferencesHelper: sl<PreferencesHelper>(),
    ),
  );
  sl.registerLazySingleton<ThemeManager>(() => ThemeManager());

  /// Accounts Dependencies
  sl.registerLazySingleton<IAccountsRemoteDataSource>(
    () => AccountsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<AccountsRepository>(
    () => AccountsRepositoryImpl(
      remoteDataSource: sl<IAccountsRemoteDataSource>(),
      preferencesHelper: sl<PreferencesHelper>(),
    ),
  );
  sl.registerFactory(() => Login(sl<AccountsRepository>()));
  sl.registerFactory(() => Logout(sl<AccountsRepository>()));
  sl.registerFactory(() => Register(sl<AccountsRepository>()));
  sl.registerFactory(() => GetUserInfo(sl<AccountsRepository>()));
  sl.registerFactory(() => UpdateProfile(sl<AccountsRepository>()));
  sl.registerFactory(() => ChangePassword(sl<AccountsRepository>()));

  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      preferencesHelper: sl<PreferencesHelper>(),
      themeManager: sl<ThemeManager>(),
    ),
  );
}
