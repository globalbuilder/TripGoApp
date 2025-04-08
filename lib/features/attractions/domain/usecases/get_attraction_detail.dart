// lib/features/attractions/domain/usecases/get_attraction_detail.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/attraction_entity.dart';
import '../repositories/attractions_repository.dart';

class GetAttractionDetail {
  final AttractionsRepository repository;

  GetAttractionDetail(this.repository);

  Future<Either<Failure, AttractionEntity>> call(int attractionId) async {
    return await repository.getAttractionDetail(attractionId);
  }
}
