// lib/features/accounts/domain/usecases/update_profile.dart

import 'package:dartz/dartz.dart';
import 'package:trip_go/core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/accounts_repository.dart';

class UpdateProfile {
  final AccountsRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, UserEntity>> execute(Map<String, dynamic> updatedData, {dynamic imageFile}) async {
    return await repository.updateProfile(updatedData, imageFile: imageFile);
  }
}
