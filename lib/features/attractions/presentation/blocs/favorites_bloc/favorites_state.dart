// lib/features/attractions/presentation/blocs/favorites_bloc/favorites_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/favorite_entity.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteEntity> favorites;
  final String? errorMessage;

  const FavoritesState({
    required this.status,
    required this.favorites,
    this.errorMessage,
  });

  factory FavoritesState.initial() => const FavoritesState(
        status: FavoritesStatus.initial,
        favorites: [],
      );

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteEntity>? favorites,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, favorites, errorMessage];
}
