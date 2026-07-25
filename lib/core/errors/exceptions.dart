/// Exception classes for the Data Layer.
/// Data sources throw these exceptions, which are caught and converted into [Failure] objects by Repositories.
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Thrown when a Firebase or Server API call fails.
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// Thrown when an Authentication operation fails (e.g. invalid credentials, user disabled).
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

/// Thrown when local cache or storage access fails.
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Thrown when device network is unavailable.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No Internet Connection',
    String? code,
  ]) : super(code: code);
}
