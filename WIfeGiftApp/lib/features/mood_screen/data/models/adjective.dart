import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wife_gift/common/exceptions/failure.dart';
import 'package:wife_gift/common/ui_colors.dart';

import 'preference.dart';

final class Adjective {
  final String id;
  final String title;
  final Color color;

  Adjective({required this.id, required this.title, required this.color});

  factory Adjective.fromPreference(Preference preference) {
    if (preference.id == null) {
      throw ValidationFailure(
        message: 'Preference validation error',
        errors: {'0': ['Server did not responded with a preference id']},
      );
    }

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

    return Adjective(id: preference.id!, title: preference.adjective, color: color);
  }
}
