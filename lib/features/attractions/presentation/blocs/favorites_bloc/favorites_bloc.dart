import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/add_favorite.dart';
import '../../../domain/usecases/remove_favorite.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites _get;
  final AddFavorite _add;
  final RemoveFavorite _remove;

  FavoritesBloc({
    required GetFavorites getFavoritesUseCase,
    required AddFavorite addFavoriteUseCase,
    required RemoveFavorite removeFavoriteUseCase,
  })  : _get = getFavoritesUseCase,
        _add = addFavoriteUseCase,
        _remove = removeFavoriteUseCase,
        super(FavoritesState.initial()) {
    on<FetchFavorites>(_onFetch);
    on<ToggleFavorite>(_onToggle);
  }

  // ──────────────────────────────────────────────────────────
  Future<void> _onFetch(
      FetchFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    final res = await _get();
    res.fold(
      (f) => emit(state.copyWith(
          status: FavoritesStatus.error, errorMessage: f.message)),
      (list) =>
          emit(state.copyWith(status: FavoritesStatus.refreshed, favorites: list)),
    );
  }

  // Optimistic toggle (instant animation) ✨
  Future<void> _onToggle(
      ToggleFavorite event, Emitter<FavoritesState> emit) async {
    final isFav = state.contains(event.attractionId);

    // 1. Local optimistic change
    final temp = List.of(state.favorites);
    if (isFav) {
      temp.removeWhere((f) => f.attractionId == event.attractionId);
    }
    emit(state.copyWith(status: FavoritesStatus.refreshed, favorites: temp));

    // 2. Fire request
    if (isFav) {
      await _remove(event.attractionId);
    } else {
      await _add(event.attractionId);
    }

    // 3. Reload from server (source of truth)
    add(const FetchFavorites());
  }
}
