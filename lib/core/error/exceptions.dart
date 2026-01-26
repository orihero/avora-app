/// Base exception class
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

/// Cache exception
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

/// Network exception
class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}
