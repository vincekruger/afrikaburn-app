import 'package:afrikaburn/resources/themes/styles/base_colors.dart';
import 'package:flutter/material.dart';
import '/resources/themes/styles/color_styles.dart';

/* Dark Theme Colors
|-------------------------------------------------------------------------- */

class DarkThemeColors extends BaseThemeColors implements ColorStyles {
  // general
  Color get background => const Color(0xFF333333);

  Color get primaryContent => const Color(0xFFEDEDED);
  Color get primaryAccent => const Color(0xFF20EDC4);
  Color get primaryAlternate => const Color(0xFF797979);

  // app bar
  Color get appBarBackground => const Color(0xFF4b5e6d);
  Color get appBarPrimaryContent => Colors.white;

  // gradients
  Color get gradient1Start => const Color(0xFF9C1FE9);
  Color get gradient1Middle => const Color(0xFFD2D347);
  Color get gradient1End => const Color(0xFF22EDC3);

  // gradient colors
  Color get gradientButtonBackgroundStart => this.gradient1Start;
  Color get gradientButtonBackgroundMiddle => this.gradient1Middle;
  Color get gradientButtonBackgroundEnd => this.gradient1End;
  Color get gradientButtonLabel => Colors.white;

  // outlined button
  Color get outlinedButtonGradientBorderStart => this.gradient1Start;
  Color get outlinedButtonGradientBorderMiddle => this.gradient1Middle;
  Color get outlinedButtonGradientBorderEnd => this.gradient1End;
  Color get outlinedButtonBackground => this.background;
  Color get outlinedButtonLabel => this.primaryContent;

  // buttons
  Color get buttonBackground => Colors.white60;
  Color get buttonPrimaryContent => const Color(0xFF232c33);

  // bottom tab bar
  Color get bottomTabBarBackground => const Color(0xFF232c33);

  // bottom tab bar - icons
  Color get bottomTabBarIconSelected => Colors.white70;
  Color get bottomTabBarIconUnselected => Colors.white60;

  // bottom tab bar - label
  Color get bottomTabBarLabelUnselected => Colors.white54;
  Color get bottomTabBarLabelSelected => Colors.white;
}
