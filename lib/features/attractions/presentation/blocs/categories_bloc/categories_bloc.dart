// lib/features/attractions/presentation/blocs/categories_bloc/categories_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'categories_event.dart';
import 'categories_state.dart';

import '../../../domain/usecases/get_categories.dart';
import '../../../domain/usecases/get_category_attractions.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategories getCategoriesUseCase;
  final GetCategoryAttractions getCategoryAttractionsUseCase;

  CategoriesBloc({
    required this.getCategoriesUseCase,
    required this.getCategoryAttractionsUseCase,
  }) : super(CategoriesState.initial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<FetchCategoryAttractionsEvent>(_onFetchCategoryAttractions);
  }

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    final result = await getCategoriesUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoriesStatus.error,
        errorMessage: failure.message,
      )),
      (categories) => emit(state.copyWith(
        status: CategoriesStatus.loaded,
        categories: categories,
      )),
    );
  }

  Future<void> _onFetchCategoryAttractions(
    FetchCategoryAttractionsEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(status: CategoriesStatus.loading));

    final result = await getCategoryAttractionsUseCase.call(event.categoryId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoriesStatus.error,
        errorMessage: failure.message,
      )),
      (attractions) => emit(state.copyWith(
        status: CategoriesStatus.loaded,
        categoryAttractions: attractions,
      )),
    );
  }
}
