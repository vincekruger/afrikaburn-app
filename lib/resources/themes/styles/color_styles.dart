import 'package:nylo_framework/nylo_framework.dart';

/// Interface for your base styles.
/// Add more styles here and then implement in
/// light_theme_colors.dart and dark_theme_colors.dart.

abstract class ColorStyles extends BaseColorStyles {
  /// * Available styles *

  // simple colors
  Color get black;

  // general
  Color get background;
  Color get primaryContent;
  Color get primaryAccent;
  Color get primaryAlternate;
  Color get blue;

  // accents
  // Color get secondAccent;
  Color get thirdAccent;
  Color get fourthAccent;

  /// Shadows
  Color get shadowColor;

  // surface
  Color get surfaceBackground;
  Color get surfaceContent;

  // app bar
  Color get appBarBackground;
  Color get appBarPrimaryContent;

  // gradients
  Color get gradient1Start;
  Color get gradient1Middle;
  Color get gradient1End;

  // gradient button
  Color get gradientButtonBackgroundStart;
  Color get gradientButtonBackgroundMiddle;
  Color get gradientButtonBackgroundEnd;
  Color get gradientButtonLabel;

  // outlined button
  Color get outlinedButtonGradientBorderStart;
  Color get outlinedButtonGradientBorderMiddle;
  Color get outlinedButtonGradientBorderEnd;
  Color get outlinedButtonBackground;
  Color get outlinedButtonLabel;

  // icon button
  Color get iconButtonGradientBorderStart;
  Color get iconButtonGradientBorderEnd;
  Color get iconButtonBackground;
  Color get iconButtonLabel;

  // buttons
  Color get buttonBackground;
  Color get buttonPrimaryContent;

  // bottom tab bar
  Color get bottomTabBarBackground;

  // bottom tab bar - icons
  Color get bottomTabBarIconSelected;
  Color get bottomTabBarIconUnselected;

  // bottom tab bar - label
  Color get bottomTabBarLabelUnselected;
  Color get bottomTabBarLabelSelected;

  // tickets
  Color get ticketSlotBackground;
  Color get ticketSlotLabel;
  Color get ticketSlotIcon;

  // ios dialog
  Color get dialogDescructiveActionColor;
  Color get cupertinoDialogActionColor;

  // Then implement in color in:
  // /resources/  themes/styles/light_theme_colors
  // /resources/themes/styles/dark_theme_colors
}
