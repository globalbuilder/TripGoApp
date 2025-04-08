// lib/features/accounts/domain/usecases/register.dart

import 'package:dartz/dartz.dart';
import 'package:trip_go/core/errors/failure.dart';
import '../repositories/accounts_repository.dart';

class Register {
  final AccountsRepository repository;

  Register(this.repository);

  Future<Either<Failure, void>> execute(Map<String, dynamic> registrationData, {dynamic imageFile}) async {
    return await repository.register(registrationData, imageFile: imageFile);
  }
}
