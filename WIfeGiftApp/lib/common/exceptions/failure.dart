import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Internal Server Error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  @override
  List<Object?> get props => [message, errors];

  const ValidationFailure({required String message, required this.errors}) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
