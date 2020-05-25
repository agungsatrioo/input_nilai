import 'package:flutter/material.dart';

extension colorUtils on Color {
  Color changeShade([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}