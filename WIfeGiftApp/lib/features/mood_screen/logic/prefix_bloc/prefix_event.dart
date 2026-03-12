part of 'prefix_bloc.dart';

sealed class PrefixEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrefixEvent$PrefixesRequested extends PrefixEvent {}

class PrefixEvent$PrefixAddRequested extends PrefixEvent {
  final List<Prefix> prefixes;

  PrefixEvent$PrefixAddRequested({required this.prefixes});

  @override
  List<Object> get props => [prefixes];
}
