part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthState$Initial extends AuthState {}

final class AuthState$Loading extends AuthState {}

final class AuthState$Success extends AuthState {
  final bool isAuthenticated;

  AuthState$Success({required this.isAuthenticated});
}

final class AuthState$Error extends AuthState {
  final String message;

  AuthState$Error(this.message);
}

final class AuthState$RegisterSuccess extends AuthState {}
