// lib/features/attractions/domain/usecases/add_favorite.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/attractions_repository.dart';

class AddFavorite {
  final AttractionsRepository repository;

  AddFavorite(this.repository);

  Future<Either<Failure, void>> call(int attractionId) async {
    return await repository.addFavorite(attractionId);
  }
}
