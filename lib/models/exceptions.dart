class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException(${statusCode ?? "no-status"}): $message';
}

class BadRequestException extends AppException {
  const BadRequestException(super.message) : super(statusCode: 400);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(statusCode: 404);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

class ServerException extends AppException {
  const ServerException(super.message) : super(statusCode: 500);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  factory Failure.initial() {
    return Failure(message: '', statusCode: 0);
  }
}
