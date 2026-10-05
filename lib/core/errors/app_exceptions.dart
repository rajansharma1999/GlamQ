/// Base exception for all application-level errors.
///
/// Exceptions occur at the data and technical layer (e.g. HTTP, storage, parsing).
/// They are caught and converted into [Failure] objects before reaching the presentation layer.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Thrown when an error occurs while communicating with a remote server or API.
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

/// Thrown when device has no internet connection or a network timeout occurs.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Please check your internet connection and try again.',
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

/// Thrown when an authentication or authorization failure occurs.
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.details,
  });
}

/// Thrown when a requested resource is not found.
class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.code = 'NOT_FOUND',
    super.details,
  });
}
