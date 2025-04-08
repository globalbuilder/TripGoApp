// lib/features/accounts/domain/repositories/accounts_repository.dart

import 'package:dartz/dartz.dart';
import 'package:trip_go/core/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class AccountsRepository {
  Future<Either<Failure, String>> login(String username, String password);
  Future<Either<Failure, void>> register(Map<String, dynamic> registrationData, {dynamic imageFile});
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> changePassword({required String oldPassword, required String newPassword});
  Future<Either<Failure, UserEntity>> getUserInfo();
  Future<Either<Failure, UserEntity>> updateProfile(Map<String, dynamic> updatedData, {dynamic imageFile});
}
