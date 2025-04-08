// lib/features/attractions/domain/usecases/search_attractions.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/attraction_entity.dart';
import '../repositories/attractions_repository.dart';

class SearchAttractions {
  final AttractionsRepository repository;

  SearchAttractions(this.repository);

  Future<Either<Failure, List<AttractionEntity>>> call(String query) async {
    return await repository.searchAttractions(query);
  }
}
