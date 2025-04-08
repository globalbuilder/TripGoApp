// lib/core/errors/failure.dart

import '../locale/locale_keys.g.dart';

abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = LocaleKeys.networkError])
      : super(message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = LocaleKeys.serverError])
      : super(message);
}

class EmptyCacheFailure extends Failure {
  EmptyCacheFailure([String message = LocaleKeys.emptyCacheError])
      : super(message);
}
