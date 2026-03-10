part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthEvent$LogoutRequested extends AuthEvent {}

class AuthEvent$StatusChecked extends AuthEvent {}

class AuthEvent$RegisterRequested extends AuthEvent {
  final RegisterRequest request;

  AuthEvent$RegisterRequested({required this.request});
}

class AuthEvent$LoginRequested extends AuthEvent {
  final LoginRequest request;

  AuthEvent$LoginRequested({required this.request});
}
