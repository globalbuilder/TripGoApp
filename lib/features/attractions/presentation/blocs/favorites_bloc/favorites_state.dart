import 'package:equatable/equatable.dart';

import '../../../domain/entities/favorite_entity.dart';

enum FavoritesStatus { initial, loading, refreshed, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteEntity> favorites;
  final String? errorMessage;

  const FavoritesState({
    required this.status,
    required this.favorites,
    this.errorMessage,
  });

  // Convenient helpers
  Set<int> get ids => favorites.map((e) => e.attractionId).toSet();
  bool contains(int id) => ids.contains(id);

  factory FavoritesState.initial() =>
      const FavoritesState(status: FavoritesStatus.initial, favorites: []);

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteEntity>? favorites,
    String? errorMessage,
  }) =>
      FavoritesState(
        status: status ?? this.status,
        favorites: favorites ?? this.favorites,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, favorites, errorMessage];
}
