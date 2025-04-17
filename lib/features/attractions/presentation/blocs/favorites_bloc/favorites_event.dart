// lib/features/attractions/presentation/blocs/favorites_bloc/favorites_event.dart
import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class FetchFavorites extends FavoritesEvent {
  const FetchFavorites();
}

class ToggleFavorite extends FavoritesEvent {
  /// ID of the attraction the user just tapped.
  final int attractionId;
  const ToggleFavorite(this.attractionId);

  @override
  List<Object?> get props => [attractionId];
}
