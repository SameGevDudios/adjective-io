import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/features/mood_screen/data/models/Adjective.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository_impl.dart';
import 'package:wife_gift/features/mood_screen/logic/adjective_tile_cubit/adjective_tile_cubit.dart';

class AdjectiveTile extends StatelessWidget {
  final Adjective adjective;
  final Function(DismissDirection) onDismissed;

  const AdjectiveTile({
    required this.adjective,
    required this.onDismissed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdjectiveTileCubit(context.read<PreferenceRepositoryImpl>()),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Dismissible(
              key: ValueKey(adjective.id),
              background: _buildBackground(Icons.add, Colors.green, Alignment.centerLeft),
              secondaryBackground: _buildBackground(Icons.remove, Colors.red, Alignment.centerRight),
              onDismissed: (direction) {
                final cubit = context.read<AdjectiveTileCubit>();
                if (direction == DismissDirection.startToEnd) {
                  cubit.increment(adjective.id);
                } else {
                  cubit.decrement(adjective.id);
                }
                onDismissed(direction);
              },
              child: SizedBox(
                width: double.infinity,
                height: 91,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: adjective.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          adjective.title,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackground(IconData icon, Color color, Alignment alignment) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Icon(icon, color: Colors.white, size: 35),
          ),
        ),
      ),
    );
  }
}