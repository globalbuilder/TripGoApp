// lib/core/errors/app_exceptions.dart

/// Common exceptions that you might throw or catch in your application.
///
/// You can extend these or create new ones as needed.
class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// More specific exceptions can be added here, e.g.:
/// AuthException, CacheException, NotFoundException, etc.
