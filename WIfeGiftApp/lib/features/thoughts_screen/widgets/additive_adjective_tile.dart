import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/data/models/adjective.dart';
import 'package:wife_gift/features/mood_screen/data/repositories/preference_repository_impl.dart';
import 'package:wife_gift/features/mood_screen/logic/adjective_tile_cubit/adjective_tile_cubit.dart';

class AdditiveAdjectiveTile extends StatelessWidget {
  final VoidCallback onTap;

  const AdditiveAdjectiveTile({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 91,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: UiColors.white),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Icon(Icons.add, color: UiColors.white, size: 56)),
            ),
          ),
        ),
      ),
    );
  }
}
