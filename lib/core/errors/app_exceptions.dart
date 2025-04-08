// lib/core/errors/app_exceptions.dart

import '../locale/locale_keys.g.dart';

class AppException implements Exception {
  final String message;
  final String? prefix;
  final String? suffix;

  AppException([this.message = "An error occurred", this.prefix, this.suffix]);

  @override
  String toString() => "${prefix ?? ''}$message${suffix ?? ''}";
}

class NetworkException extends AppException {
  NetworkException([String message = LocaleKeys.networkError])
      : super(message, "Network Error: ");
}

class ServerException extends AppException {
  ServerException([String message = LocaleKeys.serverError])
      : super(message, "Server Error: ");
}
