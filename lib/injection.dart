import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/utils/api_client.dart';
import 'core/utils/preferences_helper.dart';
import 'core/theme/theme_manager.dart';

// ── ACCOUNTS ───────────────────────────────────────────────
import 'features/accounts/data/datasources/accounts_remote_data_source.dart';
import 'features/accounts/data/repositories/accounts_repository_impl.dart';
import 'features/accounts/domain/repositories/accounts_repository.dart';
import 'features/accounts/domain/usecases/login.dart';
import 'features/accounts/domain/usecases/logout.dart';
import 'features/accounts/domain/usecases/register.dart';
import 'features/accounts/domain/usecases/get_user_info.dart';
import 'features/accounts/domain/usecases/update_profile.dart';
import 'features/accounts/domain/usecases/change_password.dart';
import 'features/accounts/presentation/blocs/accounts_bloc.dart';

// ── SETTINGS ───────────────────────────────────────────────
import 'features/settings/presentation/blocs/settings_bloc.dart';

// ── ATTRACTIONS ────────────────────────────────────────────
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
import 'features/attractions/domain/usecases/get_attraction_feedbacks.dart';

import 'features/attractions/presentation/blocs/categories_bloc/categories_bloc.dart';
import 'features/attractions/presentation/blocs/attractions_bloc/attractions_bloc.dart';
import 'features/attractions/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'features/attractions/presentation/blocs/feedback_bloc/feedback_bloc.dart';

// ── NOTIFICATIONS ─────────────────────────────────────────
import 'features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/repositories/notifications_repository.dart';
import 'features/notifications/domain/usecases/get_notifications.dart';
import 'features/notifications/domain/usecases/get_notification_detail.dart';
import 'features/notifications/presentation/blocs/notifications_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── CORE ────────────────────────────────────────────────
  sl.registerLazySingleton(() => PreferencesHelper());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(
      () => ApiClient(httpClient: sl(), preferencesHelper: sl()));
  sl.registerLazySingleton(() => ThemeManager());

  // ── ACCOUNTS ────────────────────────────────────────────
  sl.registerLazySingleton<IAccountsRemoteDataSource>(
      () => AccountsRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<AccountsRepository>(() =>
      AccountsRepositoryImpl(remoteDataSource: sl(), preferencesHelper: sl()));

  sl.registerFactory(() => Login(sl()));
  sl.registerFactory(() => Logout(sl()));
  sl.registerFactory(() => Register(sl()));
  sl.registerFactory(() => GetUserInfo(sl()));
  sl.registerFactory(() => UpdateProfile(sl()));
  sl.registerFactory(() => ChangePassword(sl()));

  sl.registerFactory(() => AccountsBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        registerUseCase: sl(),
        getUserInfoUseCase: sl(),
        updateProfileUseCase: sl(),
        changePasswordUseCase: sl(),
      ));

  // ── SETTINGS ───────────────────────────────────────────
  sl.registerFactory(() =>
      SettingsBloc(preferencesHelper: sl(), themeManager: sl()));

  // ── ATTRACTIONS ────────────────────────────────────────
  sl.registerLazySingleton<IAttractionsRemoteDataSource>(
      () => AttractionsRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<AttractionsRepository>(
      () => AttractionsRepositoryImpl(remote: sl()));

  // use‑cases
  sl.registerFactory(() => GetCategories(sl()));
  sl.registerFactory(() => GetCategoryAttractions(sl()));
  sl.registerFactory(() => GetAttractions(sl()));
  sl.registerFactory(() => GetAttractionDetail(sl()));
  sl.registerFactory(() => SearchAttractions(sl()));

  sl.registerFactory(() => GetFavorites(sl()));
  sl.registerFactory(() => AddFavorite(sl()));
  sl.registerFactory(() => RemoveFavorite(sl()));

  sl.registerFactory(() => CreateFeedback(sl()));
  sl.registerFactory(() => DeleteFeedback(sl()));
  sl.registerFactory(() => GetAttractionFeedbacks(sl()));      

  // blocs
  sl.registerFactory(() => CategoriesBloc(
        getCategoriesUseCase: sl(),
        getCategoryAttractionsUseCase: sl(),
      ));
  sl.registerFactory(() => AttractionsBloc(
        getAttractionsUseCase: sl(),
        getAttractionDetailUseCase: sl(),
        searchAttractionsUseCase: sl(),
      ));
  sl.registerFactory(() => FavoritesBloc(
        getFavoritesUseCase: sl(),
        addFavoriteUseCase: sl(),
        removeFavoriteUseCase: sl(),
      ));
  sl.registerFactory(() => FeedbackBloc(
        createFeedback: sl(),
        deleteFeedback: sl(),
        getAttractionFeedbacks: sl(),                         
      ));

  // ── NOTIFICATIONS ──────────────────────────────────────
  sl.registerLazySingleton<INotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSourceImpl(apiClient: sl()));
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(remote: sl()));

  sl.registerFactory(() => GetNotifications(sl()));
  sl.registerFactory(() => GetNotificationDetail(sl()));

  sl.registerFactory(() => NotificationsBloc(getList: sl()));
}
