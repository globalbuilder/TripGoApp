// lib/injection.dart

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Core dependencies
import 'core/utils/api_client.dart';
import 'core/utils/preferences_helper.dart';
import 'core/theme/theme_manager.dart';

// Accounts dependencies
import 'features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'features/accounts/data/repositories/accounts_repository_impl.dart';
import 'features/accounts/domain/repositories/accounts_repository.dart';
import 'features/accounts/domain/usecases/login.dart';
import 'features/accounts/domain/usecases/logout.dart';
import 'features/accounts/domain/usecases/register.dart';
import 'features/accounts/domain/usecases/get_user_info.dart';
import 'features/accounts/domain/usecases/update_profile.dart';
import 'features/accounts/domain/usecases/change_password.dart';

// Settings
import 'features/settings/presentation/blocs/settings_bloc.dart';

// Attractions (Data)
import 'features/attractions/data/datasources/attractions_remote_data_source.dart';
import 'features/attractions/data/repositories/attractions_repository_impl.dart';
import 'features/attractions/domain/repositories/attractions_repository.dart';
import 'features/attractions/domain/usecases/get_categories.dart';
import 'features/attractions/domain/usecases/get_category_attractions.dart';
import 'features/attractions/domain/usecases/get_attractions.dart';
import 'features/attractions/domain/usecases/get_attraction_detail.dart';
import 'features/attractions/domain/usecases/search_attractions.dart';
import 'features/attractions/domain/usecases/get_favorites.dart';
import 'features/attractions/domain/usecases/add_favorite.dart';
import 'features/attractions/domain/usecases/remove_favorite.dart';
import 'features/attractions/domain/usecases/create_feedback.dart';
import 'features/attractions/domain/usecases/delete_feedback.dart';

// Attractions (Presentation)
import 'features/attractions/presentation/blocs/categories_bloc/categories_bloc.dart';
import 'features/attractions/presentation/blocs/attractions_bloc/attractions_bloc.dart';
import 'features/attractions/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'features/attractions/presentation/blocs/feedback_bloc/feedback_bloc.dart';

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

  // Settings
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      preferencesHelper: sl<PreferencesHelper>(),
      themeManager: sl<ThemeManager>(),
    ),
  );

  // ------------------------------
  // Attractions Feature
  // ------------------------------
  // 1) Data Source & Repository
  sl.registerLazySingleton<IAttractionsRemoteDataSource>(
    () => AttractionsRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<AttractionsRepository>(
    () => AttractionsRepositoryImpl(remoteDataSource: sl<IAttractionsRemoteDataSource>()),
  );

  // 2) Use Cases
  sl.registerFactory(() => GetCategories(sl<AttractionsRepository>()));
  sl.registerFactory(() => GetCategoryAttractions(sl<AttractionsRepository>()));
  sl.registerFactory(() => GetAttractions(sl<AttractionsRepository>()));
  sl.registerFactory(() => GetAttractionDetail(sl<AttractionsRepository>()));
  sl.registerFactory(() => SearchAttractions(sl<AttractionsRepository>()));
  sl.registerFactory(() => GetFavorites(sl<AttractionsRepository>()));
  sl.registerFactory(() => AddFavorite(sl<AttractionsRepository>()));
  sl.registerFactory(() => RemoveFavorite(sl<AttractionsRepository>()));
  sl.registerFactory(() => CreateFeedback(sl<AttractionsRepository>()));
  sl.registerFactory(() => DeleteFeedback(sl<AttractionsRepository>()));

  // 3) BLoCs
  sl.registerFactory<CategoriesBloc>(
    () => CategoriesBloc(
      getCategoriesUseCase: sl<GetCategories>(),
      getCategoryAttractionsUseCase: sl<GetCategoryAttractions>(),
    ),
  );
  sl.registerFactory<AttractionsBloc>(
    () => AttractionsBloc(
      getAttractionsUseCase: sl<GetAttractions>(),
      getAttractionDetailUseCase: sl<GetAttractionDetail>(),
      searchAttractionsUseCase: sl<SearchAttractions>(),
    ),
  );
  sl.registerFactory<FavoritesBloc>(
    () => FavoritesBloc(
      getFavoritesUseCase: sl<GetFavorites>(),
      addFavoriteUseCase: sl<AddFavorite>(),
      removeFavoriteUseCase: sl<RemoveFavorite>(),
    ),
  );
  sl.registerFactory<FeedbackBloc>(
    () => FeedbackBloc(
      createFeedbackUseCase: sl<CreateFeedback>(),
      deleteFeedbackUseCase: sl<DeleteFeedback>(),
    ),
  );
}
