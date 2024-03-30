import 'package:afrikaburn/resources/themes/styles/base_colors.dart';
import 'package:flutter/material.dart';
import '/resources/themes/styles/color_styles.dart';

/* Light Theme Colors
|-------------------------------------------------------------------------- */

class LightThemeColors extends BaseThemeColors implements ColorStyles {
  // general
  Color get background => const Color(0xFFFFFFFF);

  Color get primaryContent => const Color(0xFF333333);
  Color get primaryAccent => const Color(0xFF20EDC4);
  Color get primaryAlternate => const Color(0xFF797979);

  // app bar
  Color get appBarBackground => Colors.blue;
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
  Color get buttonBackground => Colors.blueAccent;
  Color get buttonPrimaryContent => Colors.white;

  // bottom tab bar
  Color get bottomTabBarBackground => Colors.white;

  // bottom tab bar - icons
  Color get bottomTabBarIconSelected => Colors.blue;
  Color get bottomTabBarIconUnselected => Colors.black54;

  // bottom tab bar - label
  Color get bottomTabBarLabelUnselected => Colors.black45;
  Color get bottomTabBarLabelSelected => Colors.black;
}
