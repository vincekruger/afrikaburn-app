import 'package:flutter/material.dart';

class BaseThemeStuff {
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
      );
}
