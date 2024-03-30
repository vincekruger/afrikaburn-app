import 'package:afrikaburn/resources/themes/styles/base_colors.dart';
import 'package:flutter/material.dart';

class GradientStyles {
  LinearGradient get canvasLine => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          BaseThemeColors().gradient1Start,
          BaseThemeColors().gradient1Middle,
          BaseThemeColors().gradient1End,
        ],
      );
  LinearGradient get ticketItemGradient => LinearGradient(
        begin: const Alignment(0.87, -0.50),
        end: const Alignment(-0.87, 0.5),
        colors: [
          BaseThemeColors().gradient1Start,
          BaseThemeColors().gradient1Middle,
          BaseThemeColors().gradient1End,
        ],
      );
}
