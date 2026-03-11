import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:wife_gift/common/api/api_constants.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/common/services/asset_loader_service.dart';
import 'package:wife_gift/features/auth/data/models/auth_dtos.dart';
import 'package:wife_gift/features/auth/data/repositories/auth_repository.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/prefix_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final PreferenceRepository _preferenceRepository;
  final PrefixRepository _prefixRepository;
  final AssetLoaderService _assetLoader;
  final Dio _dio;

  AuthBloc({
    required AuthRepository repository,
    required PreferenceRepository preferenceRepository,
    required PrefixRepository prefixRepository,
    required AssetLoaderService assetLoader,
    required Dio dio,
  })  : _authRepository = repository,
        _preferenceRepository = preferenceRepository,
        _prefixRepository = prefixRepository,
        _assetLoader = assetLoader,
        _dio = dio,
        super(AuthState$Initial()) {
    on<AuthEvent$StatusChecked>(_onStatusChecked);
    on<AuthEvent$LoginRequested>(_onLoginRequested);
    on<AuthEvent$LogoutRequested>(_onLogoutRequested);
    on<AuthEvent$RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onStatusChecked(
      AuthEvent$StatusChecked event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final isAuth = await _authRepository.isAuthenticated();
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
      await _authRepository.register(event.request);
      emit(AuthState$RegisterSuccess());
    } on ValidationFailure catch (e) {
      emit(AuthState$Error('${e.message}\nerrors: ${e.errors}'));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
      AuthEvent$LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthState$Loading());
    try {
      await _authRepository.login(event.request);

      await _syncInitialDataIfNeeded();

      emit(AuthState$LoginSuccess(isAuthenticated: true));
    } catch (e) {
      emit(AuthState$Error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      AuthEvent$LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _authRepository.logout();
    emit(AuthState$LoginSuccess(isAuthenticated: false));
  }

  Future<void> _syncInitialDataIfNeeded() async {
    try {
      debugPrint('AuthBloc: Starting sync process...');

      // 1. Синхронизируем профиль
      await _dio.post(ApiConstants.profileSync);
      debugPrint('AuthBloc: Profile synced');

      // 2. Получаем текущие данные (параллельно для скорости)
      final results = await Future.wait([
        _prefixRepository.getAllPrefixes(),
        _preferenceRepository.getAllPreferences(),
      ]);

      final List<Prefix> currentPrefixes = results[0] as List<Prefix>;
      final List<Preference> currentPreferences = results[1] as List<Preference>;

      debugPrint('AuthBloc: Server data - Prefixes: ${currentPrefixes.length}, Preferences: ${currentPreferences.length}');

      // 3. Подготавливаем список задач на отправку
      final List<Future> uploadTasks = [];

      if (currentPrefixes.isEmpty) {
        final defaults = await _assetLoader.getDefaultPrefixes();
        if (defaults.isNotEmpty) {
          debugPrint('AuthBloc: Adding default prefixes to queue...');
          uploadTasks.add(_prefixRepository.addPrefixes(defaults));
        }
      }

      if (currentPreferences.isEmpty) {
        final defaults = await _assetLoader.getDefaultPreferences();
        if (defaults.isNotEmpty) {
          debugPrint('AuthBloc: Adding default preferences to queue...');
          uploadTasks.add(_preferenceRepository.addPreferences(defaults));
        }
      }

      // 4. Выполняем отправку
      if (uploadTasks.isNotEmpty) {
        await Future.wait(uploadTasks);
        debugPrint('AuthBloc: All default data uploaded successfully');
      } else {
        debugPrint('AuthBloc: No default data needed to upload');
      }

    } catch (e, stackTrace) {
      debugPrint('AuthBloc: Sync error: $e');
      debugPrint('AuthBloc: StackTrace: $stackTrace');
    }
  }
}