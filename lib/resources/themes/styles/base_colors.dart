import 'package:flutter/material.dart';
import '/resources/themes/styles/color_styles.dart';

/* Base Theme Colors
|-------------------------------------------------------------------------- */

class BaseThemeColors implements ColorStyles {
  // colors
  Color get black => const Color(0xFF333333);

  // general
  Color get background => const Color(0xFFFFFFFF);

  Color get primaryContent => const Color(0xFF333333);
  Color get primaryAccent => const Color(0xFF20EDC4);
  Color get primaryAlternate => const Color(0xFF797979);

  Color get blue => const Color(0xFF000681);

  // accents
  Color get secondaryAccent => const Color(0xFF000681);
  Color get thirdAccent => const Color(0xFF000681);
  Color get fourthAccent => const Color(0xFF20EDC4);

  /// Shadows
  Color get shadowColor => const Color(0xFF000681);

  // surface - this is used for cards, dialogs, etc.
  Color get surfaceBackground => const Color(0xFFD9D9D9);
  Color get surfaceContent => const Color(0xFF333333);

  // app bar
  Color get appBarBackground => Colors.transparent;
  Color get appBarPrimaryContent => fourthAccent;

  // gradients
  Color get gradient1Start => const Color(0xFF9C1FE9);
  Color get gradient1Middle => const Color(0xFFD2D347);
  Color get gradient1End => const Color(0xFF22EDC3);

  // gradient button
  Color get gradientButtonBackgroundStart => this.gradient1Start;
  Color get gradientButtonBackgroundMiddle => this.gradient1Middle;
  Color get gradientButtonBackgroundEnd => this.gradient1End;
  Color get gradientButtonLabel => Colors.white;

  // icon gradient button
  Color get iconButtonGradientBorderStart => const Color(0xFF9B1EE9);
  Color get iconButtonGradientBorderEnd => this.primaryAccent;
  Color get iconButtonBackground => this.surfaceBackground;
  Color get iconButtonLabel => Colors.white;

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

  // tickets
  Color get ticketSlotBackground => Colors.white;
  Color get ticketSlotLabel => this.blue;
  Color get ticketSlotIcon => this.blue;

  // dialogs
  Color get dialogDescructiveActionColor => Colors.red.shade900;
  Color get cupertinoDialogActionColor => this.primaryContent;
}
