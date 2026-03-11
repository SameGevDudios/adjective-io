import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/common/services/asset_loader_service.dart';
import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';
import 'package:wife_gift/features/auth/data/repositories/auth_repository.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/prefix_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  final PreferenceRepository _preferenceRepository;
  final PrefixRepository _prefixRepository;
  final AssetLoaderService _assetLoader;

  AuthBloc({
    required AuthRepository repository,
    required PreferenceRepository preferenceRepository,
    required PrefixRepository prefixRepository,
    required AssetLoaderService assetLoader,
  })  : _repository = repository,
        _preferenceRepository = preferenceRepository,
        _prefixRepository = prefixRepository,
        _assetLoader = assetLoader,
        super(AuthState$Initial()) {
    on<AuthEvent$StatusChecked>(_onStatusChecked);
    on<AuthEvent$LoginRequested>(_onLoginRequested);
    on<AuthEvent$LogoutRequested>(_onLogoutRequested);
    on<AuthEvent$RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onStatusChecked(AuthEvent$StatusChecked event, Emitter<AuthState> emit) async {
    try {
      final isAuth = await _repository.isAuthenticated();

      emit(AuthState$LoginSuccess(isAuthenticated: isAuth));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
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

  Future<void> _onLoginRequested(AuthEvent$LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthState$Loading());

    try {
      await _repository.login(event.request);

      await _syncInitialDataIfNeeded();

      emit(AuthState$LoginSuccess(isAuthenticated: true));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(AuthEvent$LogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();

    emit(AuthState$LoginSuccess(isAuthenticated: false));
  }

  Future<void> _syncInitialDataIfNeeded() async {
    try {
      final prefixes = await _prefixRepository.getAllPrefixes();
      final preferences = await _preferenceRepository.getAllPreferences();

      if (prefixes.isEmpty && preferences.isEmpty) {
        final defaultPrefixes = await _assetLoader.getDefaultPrefixes();
        final defaultPreferences = await _assetLoader.getDefaultPreferences();

        await Future.wait([
          _prefixRepository.addPrefixes(defaultPrefixes),
          _preferenceRepository.addPreferences(defaultPreferences),
        ]);
      }
    } catch (_) {}
  }
}