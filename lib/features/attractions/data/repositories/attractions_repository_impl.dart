import 'package:dartz/dartz.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/attraction_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/feedback_entity.dart';
import '../../domain/repositories/attractions_repository.dart';
import '../datasources/attractions_remote_data_source.dart';

class AttractionsRepositoryImpl implements AttractionsRepository {
  final IAttractionsRemoteDataSource remote;
  AttractionsRepositoryImpl({required this.remote});

  // ---------------- 1) CATEGORIES ----------------
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async =>
      _guard(() => remote.getCategories());

  @override
  Future<Either<Failure, List<AttractionEntity>>> getCategoryAttractions(
          int id) async =>
      _guard(() => remote.getCategoryAttractions(id));

  // ---------------- 2) ATTRACTIONS ---------------
  @override
  Future<Either<Failure, List<AttractionEntity>>> getAllAttractions() async =>
      _guard(() => remote.getAllAttractions());

  @override
  Future<Either<Failure, AttractionEntity>> getAttractionDetail(int id) async =>
      _guard(() => remote.getAttractionDetail(id));

  // ---------------- 3) SEARCH --------------------
  @override
  Future<Either<Failure, List<AttractionEntity>>> searchAttractions(
          String q) async =>
      _guard(() => remote.searchAttractions(q));

  // ---------------- 4) FEEDBACK ------------------
  @override
  Future<Either<Failure, void>> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  }) async =>
      _guardVoid(() =>
          remote.createFeedback(attractionId: attractionId, rating: rating, comment: comment));

  @override
  Future<Either<Failure, void>> deleteFeedback(int id) async =>
      _guardVoid(() => remote.deleteFeedback(id));

  @override
  Future<Either<Failure, List<FeedbackEntity>>> getAttractionFeedbacks(
          int attractionId) async =>
      _guard(() => remote.getAttractionFeedbacks(attractionId));

  // ---------------- 5) FAVOURITES ----------------
  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async =>
      _guard(() => remote.getFavorites());

  @override
  Future<Either<Failure, void>> addFavorite(int id) async =>
      _guardVoid(() => remote.addFavorite(id));

  @override
  Future<Either<Failure, void>> removeFavorite(int id) async =>
      _guardVoid(() => remote.removeFavorite(id));

  // -----------------------------------------------------------------
  // Small helpers to avoid repeating try/catch everywhere
  // -----------------------------------------------------------------
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, void>> _guardVoid(
      Future<void> Function() call) async {
    try {
      await call();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
