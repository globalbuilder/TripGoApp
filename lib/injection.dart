// lib/injection.dart

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'core/utils/api_client.dart';
import 'core/utils/preferences_helper.dart';
import 'features/accounts/data/datasources/auth_remote_datasource.dart';
import 'features/accounts/data/repositories/auth_repository.dart';
import 'features/accounts/domain/repositories/i_auth_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core dependencies
  sl.registerLazySingleton<PreferencesHelper>(() => PreferencesHelper());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      httpClient: sl<http.Client>(),
      preferencesHelper: sl<PreferencesHelper>(),
    ),
  );

  // Accounts Feature
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<IAuthRemoteDataSource>(),
      preferencesHelper: sl<PreferencesHelper>(),
    ),
  );

  // Register additional feature dependencies (e.g., attractions, notifications) here.
}
