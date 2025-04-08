// lib/features/attractions/presentation/blocs/attractions_bloc/attractions_event.dart

import 'package:equatable/equatable.dart';

abstract class AttractionsEvent extends Equatable {
  const AttractionsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllAttractionsEvent extends AttractionsEvent {
  const FetchAllAttractionsEvent();
}

class FetchAttractionDetailEvent extends AttractionsEvent {
  final int attractionId;
  const FetchAttractionDetailEvent(this.attractionId);

  @override
  List<Object?> get props => [attractionId];
}

class SearchAttractionsEvent extends AttractionsEvent {
  final String query;
  const SearchAttractionsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
