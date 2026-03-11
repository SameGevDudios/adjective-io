import 'package:flutter/material.dart';
import 'package:wife_gift/features/mood_screen/data/models/Adjective.dart';

class AdjectiveTile extends StatelessWidget {
  final Adjective adjective;

  const AdjectiveTile({required this.adjective, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: 298,
          height: 91,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: adjective.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                adjective.title,
                textAlign: TextAlign.center,
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
    );
  }
}