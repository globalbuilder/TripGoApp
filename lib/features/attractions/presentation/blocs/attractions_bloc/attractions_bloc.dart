// lib/features/attractions/presentation/blocs/attractions_bloc/attractions_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'attractions_event.dart';
import 'attractions_state.dart';

import '../../../domain/usecases/get_attractions.dart';
import '../../../domain/usecases/get_attraction_detail.dart';
import '../../../domain/usecases/search_attractions.dart';

class AttractionsBloc extends Bloc<AttractionsEvent, AttractionsState> {
  final GetAttractions getAttractionsUseCase;
  final GetAttractionDetail getAttractionDetailUseCase;
  final SearchAttractions searchAttractionsUseCase;

  AttractionsBloc({
    required this.getAttractionsUseCase,
    required this.getAttractionDetailUseCase,
    required this.searchAttractionsUseCase,
  }) : super(AttractionsState.initial()) {
    on<FetchAllAttractionsEvent>(_onFetchAllAttractions);
    on<FetchAttractionDetailEvent>(_onFetchAttractionDetail);
    on<SearchAttractionsEvent>(_onSearchAttractions);
  }

  Future<void> _onFetchAllAttractions(
    FetchAllAttractionsEvent event,
    Emitter<AttractionsState> emit,
  ) async {
    emit(state.copyWith(status: AttractionsStatus.loading));
    final result = await getAttractionsUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AttractionsStatus.error,
        errorMessage: failure.message,
      )),
      (attractions) => emit(state.copyWith(
        status: AttractionsStatus.loaded,
        attractions: attractions,
      )),
    );
  }

  Future<void> _onFetchAttractionDetail(
    FetchAttractionDetailEvent event,
    Emitter<AttractionsState> emit,
  ) async {
    emit(state.copyWith(status: AttractionsStatus.loading));
    final result = await getAttractionDetailUseCase.call(event.attractionId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AttractionsStatus.error,
        errorMessage: failure.message,
      )),
      (attraction) => emit(state.copyWith(
        status: AttractionsStatus.loaded,
        selectedAttraction: attraction,
      )),
    );
  }

  Future<void> _onSearchAttractions(
    SearchAttractionsEvent event,
    Emitter<AttractionsState> emit,
  ) async {
    emit(state.copyWith(status: AttractionsStatus.loading));
    final result = await searchAttractionsUseCase.call(event.query);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AttractionsStatus.error,
        errorMessage: failure.message,
      )),
      (results) => emit(state.copyWith(
        status: AttractionsStatus.loaded,
        attractions: results,
      )),
    );
  }
}
