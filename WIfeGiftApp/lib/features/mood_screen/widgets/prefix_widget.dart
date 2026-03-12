import 'package:flutter/material.dart';
import 'package:wife_gift/common/ui_colors.dart';
import 'package:wife_gift/features/mood_screen/data/models/prefix.dart';

class PrefixWidget extends StatelessWidget {
  final Prefix prefix;
  final Size size;

  const PrefixWidget({
    required this.prefix,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: size.width * -0.2,
          left: size.width * -0.4,
          right: size.width * -0.4,
          child: SizedBox(
            width: size.width * 1.4,
            height: size.width * 1.4,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UiColors.accent,
              ),
            ),
          ),
        ),
        Positioned(
          top: size.width * 0.05,
          left: size.width * 0.1,
          right: size.width * 0.1,
          child: SizedBox(
            width: size.width * 0.85,
            height: size.width * 0.85,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UiColors.accentLight,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.12),
              Text(
                prefix.title,
                style: const TextStyle(
                  color: UiColors.textLight,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
              ),
              Text(
                prefix.subtitle,
                style: const TextStyle(
                  color: UiColors.textLight,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}