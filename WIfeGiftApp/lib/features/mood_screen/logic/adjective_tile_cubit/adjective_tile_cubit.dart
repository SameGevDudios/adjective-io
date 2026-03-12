import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository.dart';

class AdjectiveTileCubit extends Cubit<void> {
  final PreferenceRepository _repository;

  AdjectiveTileCubit(this._repository) : super(null);

  void increment(String id) => _repository.incrementWeight(id);
  void decrement(String id) => _repository.decrementWeight(id);
}