// lib/features/attractions/domain/repositories/attractions_repository.dart

import 'package:dartz/dartz.dart';
import 'package:trip_go/features/attractions/domain/entities/feedback_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/category_entity.dart';
import '../entities/attraction_entity.dart';
import '../entities/favorite_entity.dart';

abstract class AttractionsRepository {
  // ---------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<AttractionEntity>>> getCategoryAttractions(int categoryId);

  // ---------------------------------------------------------------------
  // Attractions
  // ---------------------------------------------------------------------
  Future<Either<Failure, List<AttractionEntity>>> getAllAttractions();
  Future<Either<Failure, AttractionEntity>> getAttractionDetail(int attractionId);

  // ---------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------
  Future<Either<Failure, List<AttractionEntity>>> searchAttractions(String query);

  // ---------------------------------------------------------------------
  // Feedback -------------------------------------------------------------
  /// Create or delete remain identical …
  Future<Either<Failure, void>> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  });
  Future<Either<Failure, void>> deleteFeedback(int feedbackId);

  /// NEW – fetch every feedback entry for one attraction
  Future<Either<Failure, List<FeedbackEntity>>> getAttractionFeedbacks(int attractionId);

  // ---------------------------------------------------------------------
  // Favourites -----------------------------------------------------------
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(int attractionId);
  Future<Either<Failure, void>> removeFavorite(int attractionId);
}