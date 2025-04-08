// lib/features/attractions/presentation/blocs/favorites_bloc/favorites_event.dart

import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FetchFavoritesEvent extends FavoritesEvent {
  const FetchFavoritesEvent();
}

class AddFavoriteEvent extends FavoritesEvent {
  final int attractionId;
  const AddFavoriteEvent(this.attractionId);

  @override
  List<Object?> get props => [attractionId];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int attractionId;
  const RemoveFavoriteEvent(this.attractionId);

  @override
  List<Object?> get props => [attractionId];
}
