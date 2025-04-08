// lib/features/attractions/presentation/blocs/categories_bloc/categories_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/attraction_entity.dart';

enum CategoriesStatus { initial, loading, loaded, error }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final List<CategoryEntity> categories;
  final List<AttractionEntity> categoryAttractions;
  final String? errorMessage;

  const CategoriesState({
    required this.status,
    required this.categories,
    required this.categoryAttractions,
    this.errorMessage,
  });

  factory CategoriesState.initial() {
    return const CategoriesState(
      status: CategoriesStatus.initial,
      categories: [],
      categoryAttractions: [],
      errorMessage: null,
    );
  }

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryEntity>? categories,
    List<AttractionEntity>? categoryAttractions,
    String? errorMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      categoryAttractions: categoryAttractions ?? this.categoryAttractions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, categoryAttractions, errorMessage];
}
