import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/prefix_repository.dart';

part 'prefix_event.dart';
part 'prefix_state.dart';

class PrefixBloc extends Bloc<PrefixEvent, PrefixState> {
  final PrefixRepository _repository;

  PrefixBloc(PrefixRepository repository) : _repository = repository, super(PrefixState$Initial()) {
    on<PrefixEvent$PrefixesRequested>(_onPrefixesRequested);
    on<PrefixEvent$PrefixAddRequested>(_onPrefixAddRequested);
  }

  Future<void> _onPrefixesRequested(
    PrefixEvent$PrefixesRequested event,
    Emitter<PrefixState> emit,
  ) async {
    emit(PrefixState$Loading());

    try {
      final prefixes = await _repository.getAllPrefixes();
      final random = Random();

      final randomPrefix = prefixes[random.nextInt(prefixes.length)];

      emit(PrefixState$Success(prefix: randomPrefix));
    } catch (e) {
      emit(PrefixState$Error(e.toString()));
    }
  }

  Future<void> _onPrefixAddRequested(
    PrefixEvent$PrefixAddRequested event,
    Emitter<PrefixState> emit,
  ) async {
    emit(PrefixState$Loading());

    try {
      await _repository.addPrefixes(event.prefixes);

      emit(state is PrefixState$Success ? state : PrefixState$Success(prefix: Prefix.empty()));
    } catch (e) {
      emit(PrefixState$Error(e.toString()));
    }
  }
}
