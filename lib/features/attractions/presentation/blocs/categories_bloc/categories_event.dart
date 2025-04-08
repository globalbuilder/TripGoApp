// lib/features/attractions/presentation/blocs/categories_bloc/categories_event.dart

import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends CategoriesEvent {
  const FetchCategoriesEvent();
}

class FetchCategoryAttractionsEvent extends CategoriesEvent {
  final int categoryId;
  const FetchCategoryAttractionsEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
