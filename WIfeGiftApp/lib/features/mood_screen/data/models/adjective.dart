import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wife_gift/common/ui_colors.dart';

import 'preference.dart';

final class Adjective {
  final String title;
  final Color color;

  Adjective({required this.title, required this.color});

  factory Adjective.fromPreference(Preference preference) {
    final Color color;
    final weight = preference.weight;

    if (weight > 1) {
      color = UiColors.stunningAdjective;
    } else if (weight > 0) {
      color = UiColors.positiveAdjective;
    } else if (weight == 0) {
      color = UiColors.neutralAdjective;
    } else {
      color = UiColors.negativeAdjective;
    }

    return Adjective(title: preference.adjective, color: color);
  }
}
