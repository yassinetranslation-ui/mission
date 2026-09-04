sealed class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.code]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.code]);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.code]);
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? validationErrors;
  
  const ValidationFailure(super.message, [super.code, this.validationErrors]);
}

class FileFailure extends Failure {
  const FileFailure(super.message, [super.code]);
}

class AIGenerationFailure extends Failure {
  const AIGenerationFailure(super.message, [super.code]);
}
