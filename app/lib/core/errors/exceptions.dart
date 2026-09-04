class ServerException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  ServerException(this.message, {this.code, this.data});

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;
  ValidationException(this.message, {this.errors});

  @override
  String toString() => message;
}

class FileException implements Exception {
  final String message;
  FileException(this.message);

  @override
  String toString() => message;
}

class AIGenerationException implements Exception {
  final String message;
  final String? code;
  AIGenerationException(this.message, [this.code]);

  @override
  String toString() => message;
}
