// lib/features/accounts/domain/usecases/get_user_info.dart

import 'package:dartz/dartz.dart';
import 'package:trip_go/core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/accounts_repository.dart';

class GetUserInfo {
  final AccountsRepository repository;

  GetUserInfo(this.repository);

  Future<Either<Failure, UserEntity>> execute() async {
    return await repository.getUserInfo();
  }
}
