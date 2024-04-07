import 'package:afrikaburn/resources/themes/styles/base_colors.dart';
import 'package:flutter/material.dart';

class GradientStyles {
  static LinearGradient get canvasLine => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          BaseThemeColors().gradient1Start,
          BaseThemeColors().gradient1Middle,
          BaseThemeColors().gradient1End,
        ],
      );

  static LinearGradient get canvasLineInverted => LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          BaseThemeColors().gradient1Start,
          BaseThemeColors().gradient1Middle,
          BaseThemeColors().gradient1End,
        ],
      );

  static LinearGradient get ticketSlotGradient => LinearGradient(
        begin: const Alignment(0.87, -0.50),
        end: const Alignment(-0.87, 0.5),
        colors: [
          BaseThemeColors().gradient1Start,
          BaseThemeColors().gradient1Middle,
          BaseThemeColors().gradient1End,
        ],
      );

  static LinearGradient get outlinedButtonBorder => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          BaseThemeColors().gradient1Start,
          BaseThemeColors().gradient1Middle,
          BaseThemeColors().gradient1End,
        ],
      );

  static LinearGradient get appbarIcon => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          BaseThemeColors().gradient1End,
          BaseThemeColors().gradient1Start,
        ],
      );
}
