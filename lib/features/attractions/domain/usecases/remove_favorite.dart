// lib/features/attractions/domain/usecases/remove_favorite.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/attractions_repository.dart';

class RemoveFavorite {
  final AttractionsRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Failure, void>> call(int attractionId) async {
    return await repository.removeFavorite(attractionId);
  }
}
