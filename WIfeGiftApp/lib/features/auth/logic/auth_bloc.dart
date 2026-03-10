import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/features/auth/data/models/requests/register_request.dart';
import 'package:wife_gift/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(AuthRepository repository) : _repository = repository, super(AuthState$Initial()) {
    on<AuthEvent$StatusChecked>(_onStatusChecked);
    on<AuthEvent$LoginRequested>(_onLoginRequested);
    on<AuthEvent$LogoutRequested>(_onLogoutRequested);
    on<AuthEvent$RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onStatusChecked(AuthEvent$StatusChecked event, Emitter<AuthState> emit) async {
    try {
      final isAuth = await _repository.isAuthenticated();

      emit(AuthState$Success(isAuthenticated: isAuth));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
  }

  Future<void> _onLoginRequested(AuthEvent$LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthState$Loading());

    try {
      await _repository.login(event.email, event.password);

      emit(AuthState$Success(isAuthenticated: true));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthEvent$LogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();

    emit(AuthState$Success(isAuthenticated: false));
  }

  Future<void> _onRegisterRequested(
    AuthEvent$RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState$Loading());

    try {
      await _repository.register(event.request);

      emit(AuthState$RegisterSuccess());
    } on ValidationFailure catch (e) {
      emit(AuthState$Error('${e.message}\nerrors: ${e.errors}'));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
  }
}
