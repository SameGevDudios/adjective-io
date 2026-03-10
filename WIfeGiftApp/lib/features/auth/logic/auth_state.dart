part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthState$Initial extends AuthState {}

final class AuthState$Loading extends AuthState {}

final class AuthState$Auth extends AuthState {}

final class AuthState$Unauth extends AuthState {}

final class AuthState$Error extends AuthState {
  final String message;

  AuthState$Error(this.message);
}
