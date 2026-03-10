part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthEvent$LoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthEvent$LoginRequested({required this.email, required this.password});
}

class AuthEvent$LogoutRequested extends AuthEvent {}

class AuthEvent$StatusChecked extends AuthEvent {}

class AuthEvent$RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  AuthEvent$RegisterRequested({required this.request});
}
