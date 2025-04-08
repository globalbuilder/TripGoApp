// lib/features/attractions/domain/usecases/get_category_attractions.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/attraction_entity.dart';
import '../repositories/attractions_repository.dart';

class GetCategoryAttractions {
  final AttractionsRepository repository;

  GetCategoryAttractions(this.repository);

  Future<Either<Failure, List<AttractionEntity>>> call(int categoryId) async {
    return await repository.getCategoryAttractions(categoryId);
  }
}
