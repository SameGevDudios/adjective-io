part of 'preference_bloc.dart';

sealed class PreferenceState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PreferenceState$Initial extends PreferenceState {}

final class PreferenceState$Loading extends PreferenceState {}

final class PreferenceState$Success extends PreferenceState {
  final List<Adjective> adjectives;

  @override
  List<Object?> get props => [adjectives];

  PreferenceState$Success({required this.adjectives});

  PreferenceState$Success copyWith(List<Adjective>? adjectives) =>
      PreferenceState$Success(adjectives: adjectives ?? this.adjectives);
}

final class PreferenceState$Error extends PreferenceState {
  final String message;

  @override
  List<Object?> get props => [message];

  PreferenceState$Error(this.message);
}
