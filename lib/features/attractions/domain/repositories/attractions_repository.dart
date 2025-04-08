// lib/features/attractions/domain/repositories/attractions_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/category_entity.dart';
import '../entities/attraction_entity.dart';
import '../entities/favorite_entity.dart';

abstract class AttractionsRepository {
  // 1) Categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<AttractionEntity>>> getCategoryAttractions(int categoryId);

  // 2) Attractions
  Future<Either<Failure, List<AttractionEntity>>> getAllAttractions();
  Future<Either<Failure, AttractionEntity>> getAttractionDetail(int attractionId);

  // 3) Search
  Future<Either<Failure, List<AttractionEntity>>> searchAttractions(String query);

  // 4) Feedback
  Future<Either<Failure, void>> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  });
  Future<Either<Failure, void>> deleteFeedback(int feedbackId);

  // 5) Favorites
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(int attractionId);
  Future<Either<Failure, void>> removeFavorite(int attractionId);
}
