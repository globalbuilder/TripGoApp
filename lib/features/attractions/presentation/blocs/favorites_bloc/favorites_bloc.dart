// lib/features/attractions/presentation/blocs/favorites_bloc/favorites_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/add_favorite.dart';
import '../../../domain/usecases/remove_favorite.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavoritesUseCase;
  final AddFavorite addFavoriteUseCase;
  final RemoveFavorite removeFavoriteUseCase;

  FavoritesBloc({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
  }) : super(FavoritesState.initial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  Future<void> _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    final result = await getFavoritesUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: failure.message,
      )),
      (favorites) => emit(state.copyWith(
        status: FavoritesStatus.loaded,
        favorites: favorites,
      )),
    );
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    final result = await addFavoriteUseCase.call(event.attractionId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: failure.message,
      )),
      (_) async {
        // If success, refresh the favorites list
        final refreshResult = await getFavoritesUseCase.call();
        refreshResult.fold(
          (failure) => emit(state.copyWith(
            status: FavoritesStatus.error,
            errorMessage: failure.message,
          )),
          (updatedFavorites) => emit(state.copyWith(
            status: FavoritesStatus.loaded,
            favorites: updatedFavorites,
          )),
        );
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    final result = await removeFavoriteUseCase.call(event.attractionId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: failure.message,
      )),
      (_) async {
        // If success, refresh favorites list
        final refreshResult = await getFavoritesUseCase.call();
        refreshResult.fold(
          (failure) => emit(state.copyWith(
            status: FavoritesStatus.error,
            errorMessage: failure.message,
          )),
          (updatedFavorites) => emit(state.copyWith(
            status: FavoritesStatus.loaded,
            favorites: updatedFavorites,
          )),
        );
      },
    );
  }
}
