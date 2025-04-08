import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/utils/preferences_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/accounts_repository.dart';
import '../datasources/accounts_remote_data_source.dart';
import '../models/user_model.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final IAccountsRemoteDataSource remoteDataSource;
  final PreferencesHelper preferencesHelper;

  AccountsRepositoryImpl({
    required this.remoteDataSource,
    required this.preferencesHelper,
  });

  @override
  Future<Either<Failure, String>> login(String username, String password) async {
    try {
      final token = await remoteDataSource.login(username, password);
      await preferencesHelper.saveToken(token); // Save token locally
      return Right(token);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> register(Map<String, dynamic> registrationData, {dynamic imageFile}) async {
    try {
      await remoteDataSource.register(registrationData, imageFile: imageFile);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await preferencesHelper.clearToken(); // Clear token from local storage
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      await remoteDataSource.changePassword(oldPassword: oldPassword, newPassword: newPassword);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo() async {
    try {
      final userModel = await remoteDataSource.getUserInfo();
      return Right(_mapModelToEntity(userModel));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(Map<String, dynamic> updatedData, {dynamic imageFile}) async {
    try {
      final userModel = await remoteDataSource.updateProfile(updatedData, imageFile: imageFile);
      return Right(_mapModelToEntity(userModel));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  UserEntity _mapModelToEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      email: model.email,
      firstName: model.firstName,
      lastName: model.lastName,
      phoneNumber: model.phoneNumber,
      address: model.address,
      imageUrl: model.imageUrl,
    );
  }
}
