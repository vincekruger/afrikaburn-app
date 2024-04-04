import 'package:afrikaburn/resources/themes/styles/color_styles.dart';
import 'package:flutter/material.dart';

class BaseThemeStuff {
  static ButtonThemeData makeButtonThemeData(ColorStyles color) =>
      ButtonThemeData(
        buttonColor: color.buttonPrimaryContent,
        colorScheme: ColorScheme.light(primary: color.buttonBackground),
      );

  static TextButtonThemeData makeTextButtonThemeData(ColorStyles color) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color.primaryContent,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
        ),
      );

  static ElevatedButtonThemeData makeElevatedButtonThemeData(
          ColorStyles color, TextTheme textTheme) =>
      ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color.primaryContent,
          backgroundColor: color.background,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          minimumSize: Size(0, 0),
        ),
      );

  static OutlinedButtonThemeData makeOutlinedButtonThemeData(
          ColorStyles color, TextTheme textTheme) =>
      OutlinedButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color.outlinedButtonLabel,
          backgroundColor: color.outlinedButtonBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          minimumSize: Size(0, 0),
          textStyle: textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  static PageTransitionsTheme get pageTransitionsTheme => PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      );

  static NavigationBarThemeData get navigationBarTheme =>
      NavigationBarThemeData(
        shadowColor: Colors.transparent,
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: MaterialStateProperty.all(IconThemeData(
          size: 24,
          color: Colors.white,
        )),
      );
}
