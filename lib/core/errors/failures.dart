/// Abstract Failure class for Domain Layer error representation.
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

/// Represents authentication failures (e.g., wrong password, user not found, email in use).
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    'Invalid email or password.',
    code: 'invalid-credentials',
  );

  factory AuthFailure.userNotFound() => const AuthFailure(
    'No user account found with this email.',
    code: 'user-not-found',
  );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    'An account already exists for this email.',
    code: 'email-already-in-use',
  );

  factory AuthFailure.weakPassword() => const AuthFailure(
    'Password provided is too weak.',
    code: 'weak-password',
  );
}

/// Represents database / server failures.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Represents network unavailability failures.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'Network unavailable. Please check your internet connection.',
    String? code,
  ]) : super(code: code);
}

/// Represents caching / local storage failures.
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Represents generic unknown errors.
class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unexpected error occurred.',
    String? code,
  ]) : super(code: code);
}
