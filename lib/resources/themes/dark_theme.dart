import 'package:afrikaburn/resources/themes/base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/config/design.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/text_theme/default_text_theme.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Dark Theme
|--------------------------------------------------------------------------
| Theme Config - config/theme.dart
|-------------------------------------------------------------------------- */

ThemeData darkTheme(ColorStyles color) {
  TextTheme darkTheme =
      getAppTextTheme(appFont, defaultTextTheme.merge(_textTheme(color)));
  return ThemeData(
    useMaterial3: true,
    primaryColor: color.primaryContent,
    primaryColorDark: color.primaryContent,
    focusColor: color.primaryContent,
    scaffoldBackgroundColor: color.background,
    appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: color.appBarBackground,
        titleTextStyle: darkTheme.titleLarge!.copyWith(
          color: color.appBarPrimaryContent,
        ),
        iconTheme: IconThemeData(color: color.appBarPrimaryContent),
        elevation: 1.0,
        systemOverlayStyle: SystemUiOverlayStyle.light),
    buttonTheme: BaseThemeStuff.makeButtonThemeData(color),
    textButtonTheme: BaseThemeStuff.makeTextButtonThemeData(color),
    elevatedButtonTheme:
        BaseThemeStuff.makeElevatedButtonThemeData(color, darkTheme),
    outlinedButtonTheme:
        BaseThemeStuff.makeOutlinedButtonThemeData(color, darkTheme),
    navigationBarTheme: BaseThemeStuff.navigationBarTheme.copyWith(
      backgroundColor: color.bottomTabBarBackground,
      labelTextStyle: MaterialStateTextStyle.resolveWith(
        (states) => darkTheme.titleSmall!
            .copyWith(color: color.bottomTabBarLabelSelected),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: color.bottomTabBarBackground,
      // Selected
      selectedIconTheme: IconThemeData(color: color.bottomTabBarIconSelected),
      selectedItemColor: color.bottomTabBarLabelSelected,
      selectedLabelStyle: darkTheme.titleSmall,
      // Unselected
      unselectedItemColor: color.bottomTabBarLabelUnselected,
      unselectedLabelStyle: darkTheme.titleSmall!.copyWith(
        fontSize: darkTheme.titleSmall!.fontSize! - 1,
      ),
      unselectedIconTheme:
          IconThemeData(color: color.bottomTabBarIconUnselected),
    ),
    textTheme: darkTheme,
    colorScheme: ColorScheme.dark(background: color.background),
    dialogTheme: DialogTheme(
      backgroundColor: color.surfaceBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titleTextStyle: darkTheme.headlineSmall!.copyWith(
        color: color.surfaceContent,
      ),
      contentTextStyle: darkTheme.bodyMedium!.copyWith(
        color: color.surfaceContent,
      ),
    ),
    pageTransitionsTheme: BaseThemeStuff.pageTransitionsTheme,
  );
}

/*
|--------------------------------------------------------------------------
| Dark Text Theme
|--------------------------------------------------------------------------
*/

TextTheme _textTheme(ColorStyles colors) {
  Color primaryContent = colors.primaryContent;
  TextTheme textTheme = TextTheme().apply(displayColor: primaryContent);
  return textTheme.copyWith(
      titleLarge: TextStyle(color: primaryContent.withOpacity(0.8)),
      labelLarge: TextStyle(color: primaryContent.withOpacity(0.8)),
      bodySmall: TextStyle(color: primaryContent.withOpacity(0.8)),
      bodyMedium: TextStyle(color: primaryContent.withOpacity(0.8)));
}
