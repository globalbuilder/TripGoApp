import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/attraction_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/attractions_repository.dart';
import '../datasources/attractions_remote_data_source.dart';


class AttractionsRepositoryImpl implements AttractionsRepository {
  final IAttractionsRemoteDataSource remoteDataSource;

  AttractionsRepositoryImpl({required this.remoteDataSource});

  // -----------------------
  // 1) Categories
  // -----------------------
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return Right(models); // CategoryModel extends CategoryEntity
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AttractionEntity>>> getCategoryAttractions(int categoryId) async {
    try {
      final models = await remoteDataSource.getCategoryAttractions(categoryId);
      return Right(models);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // -----------------------
  // 2) Attractions
  // -----------------------
  @override
  Future<Either<Failure, List<AttractionEntity>>> getAllAttractions() async {
    try {
      final models = await remoteDataSource.getAllAttractions();
      return Right(models);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AttractionEntity>> getAttractionDetail(int attractionId) async {
    try {
      final model = await remoteDataSource.getAttractionDetail(attractionId);
      return Right(model);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // -----------------------
  // 3) Search
  // -----------------------
  @override
  Future<Either<Failure, List<AttractionEntity>>> searchAttractions(String query) async {
    try {
      final models = await remoteDataSource.searchAttractions(query);
      return Right(models);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // -----------------------
  // 4) Feedback
  // -----------------------
  @override
  Future<Either<Failure, void>> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  }) async {
    try {
      await remoteDataSource.createFeedback(
        attractionId: attractionId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFeedback(int feedbackId) async {
    try {
      await remoteDataSource.deleteFeedback(feedbackId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  // -----------------------
  // 5) Favorites
  // -----------------------
  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async {
    try {
      final models = await remoteDataSource.getFavorites();
      return Right(models);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(int attractionId) async {
    try {
      await remoteDataSource.addFavorite(attractionId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int attractionId) async {
    try {
      await remoteDataSource.removeFavorite(attractionId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
