// lib/features/attractions/domain/usecases/get_favorites.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/favorite_entity.dart';
import '../repositories/attractions_repository.dart';

class GetFavorites {
  final AttractionsRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<FavoriteEntity>>> call() async {
    return await repository.getFavorites();
  }
}
