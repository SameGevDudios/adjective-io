import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/data/models/adjective.dart';
import 'package:wife_gift/features/mood_screen/data/models/preference.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository.dart';

part 'preference_event.dart';
part 'preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  final PreferenceRepository _repository;

  PreferenceBloc(PreferenceRepository repository)
    : _repository = repository,
      super(PreferenceState$Initial()) {
    on<PreferenceEvent$PreferencesRequested>(_onPreferencesRequested);
    on<PreferenceEvent$AddRequested>(_onPreferenceAddRequested);
  }

  Future<void> _onPreferencesRequested(
    PreferenceEvent$PreferencesRequested event,
    Emitter<PreferenceState> emit,
  ) async {
    emit(PreferenceState$Loading());

    try {
      final preferences = await _repository.getSampledPreferences();

      final adjectives = preferences.map(Adjective.fromPreference).toList();

      emit(PreferenceState$Success(adjectives: adjectives));
    } catch (e) {
      emit(PreferenceState$Error(e.toString()));
    }
  }

  Future<void> _onPreferenceAddRequested(
    PreferenceEvent$AddRequested event,
    Emitter<PreferenceState> emit,
  ) async {
    if (state is! PreferenceState$Success) {
      return;
    }

    emit(PreferenceState$Loading());

    try {
      await _repository.addPreferences(event.preferences);
      final success = state as PreferenceState$Success;

      emit(
        success.copyWith(
          success.adjectives + event.preferences.map(Adjective.fromPreference).toList(),
        ),
      );
    } catch (e) {
      emit(PreferenceState$Error(e.toString()));
    }
  }
}
