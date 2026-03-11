part of 'prefix_bloc.dart';

sealed class PrefixState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PrefixState$Initial extends PrefixState {}

final class PrefixState$Loading extends PrefixState {}

final class PrefixState$Success extends PrefixState {
  final Prefix prefix;

  @override
  List<Object?> get props => [prefix];

  PrefixState$Success({required this.prefix});

  PrefixState$Success copyWith({Prefix? prefix}) =>
      PrefixState$Success(prefix: prefix ?? this.prefix);
}

final class PrefixState$Error extends PrefixState {
  final String message;

  @override
  List<Object?> get props => [message];

  PrefixState$Error(this.message);
}
