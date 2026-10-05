/// Base failure class representing a domain-level error.
///
/// Unlike [Exception], which is technical, a [Failure] carries a user-friendly
/// message that can be displayed safely on the UI.
abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Generic server failure.
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Connectivity or network failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please verify your network.',
    super.code = 'NETWORK_FAILURE',
  });
}

/// Authentication / authorization failure.
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_FAILURE',
  });
}

/// Unknown / unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN_FAILURE',
  });
}
