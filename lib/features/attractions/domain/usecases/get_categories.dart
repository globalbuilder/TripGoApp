// lib/features/attractions/domain/usecases/get_categories.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/attractions_repository.dart';

class GetCategories {
  final AttractionsRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await repository.getCategories();
  }
}
