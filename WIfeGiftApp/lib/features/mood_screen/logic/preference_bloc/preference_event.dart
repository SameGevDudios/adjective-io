part of 'preference_bloc.dart';

sealed class PreferenceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PreferenceEvent$AllPreferencesRequested extends PreferenceEvent {}

final class PreferenceEvent$PreferencesRequested extends PreferenceEvent {}

final class PreferenceEvent$AddRequested extends PreferenceEvent {
  final List<Preference> preferences;

  PreferenceEvent$AddRequested({required this.preferences});
}
