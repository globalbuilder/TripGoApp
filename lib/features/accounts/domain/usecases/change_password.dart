// lib/features/accounts/domain/usecases/change_password.dart

import 'package:dartz/dartz.dart';
import 'package:trip_go/core/errors/failure.dart';
import '../repositories/accounts_repository.dart';

class ChangePassword {
  final AccountsRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> execute({required String oldPassword, required String newPassword}) async {
    return await repository.changePassword(oldPassword: oldPassword, newPassword: newPassword);
  }
}
