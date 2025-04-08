// lib/features/attractions/domain/usecases/get_attractions.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/attraction_entity.dart';
import '../repositories/attractions_repository.dart';

class GetAttractions {
  final AttractionsRepository repository;

  GetAttractions(this.repository);

  Future<Either<Failure, List<AttractionEntity>>> call() async {
    return await repository.getAllAttractions();
  }
}
