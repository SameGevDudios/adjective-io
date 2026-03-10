part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthState$Initial extends AuthState {}

final class AuthState$Loading extends AuthState {}

final class AuthState$LoginSuccess extends AuthState {
  final bool isAuthenticated;

  @override
  List<Object> get props => [isAuthenticated];

  AuthState$LoginSuccess({required this.isAuthenticated});
}

final class AuthState$Error extends AuthState {
  final String message;

  @override
  List<Object> get props => [message];

  AuthState$Error(this.message);
}

final class AuthState$RegisterSuccess extends AuthState {}
