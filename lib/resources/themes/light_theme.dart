import 'package:afrikaburn/resources/themes/base_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/config/design.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/text_theme/default_text_theme.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Light Theme
|--------------------------------------------------------------------------
| Theme Config - config/theme.dart
|-------------------------------------------------------------------------- */

ThemeData lightTheme(ColorStyles color) {
  TextTheme lightTheme =
      getAppTextTheme(appFont, defaultTextTheme.merge(_textTheme(color)));

  return ThemeData(
    useMaterial3: true,
    primaryColor: color.primaryContent,
    primaryColorLight: color.primaryAccent,
    focusColor: color.primaryContent,
    scaffoldBackgroundColor: color.background,
    hintColor: color.primaryAccent,
    dividerTheme: DividerThemeData(color: Colors.grey[100]),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: color.appBarBackground,
      titleTextStyle: lightTheme.titleSmall!.copyWith(
        color: color.appBarPrimaryContent,
      ),
      iconTheme: IconThemeData(color: color.appBarPrimaryContent),
      elevation: 1.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: color.buttonPrimaryContent,
      colorScheme: ColorScheme.light(primary: color.buttonBackground),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.primaryContent,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.primaryContent,
        backgroundColor: color.background,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        minimumSize: Size(0, 0),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.outlinedButtonLabel,
        backgroundColor: color.outlinedButtonBackground,
        side: BorderSide(color: color.outlinedButtonBackground, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        minimumSize: Size(0, 0),
      ),
    ),
    navigationBarTheme: BaseThemeStuff.navigationBarTheme.copyWith(
      backgroundColor: color.bottomTabBarBackground,
      labelTextStyle: MaterialStateTextStyle.resolveWith(
        (states) => lightTheme.titleSmall!
            .copyWith(color: color.bottomTabBarLabelSelected),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: color.bottomTabBarBackground,
      // Selected
      selectedIconTheme: IconThemeData(color: color.bottomTabBarIconSelected),
      selectedItemColor: color.bottomTabBarLabelSelected,
      selectedLabelStyle: lightTheme.titleSmall,
      // Unselected
      unselectedItemColor: color.bottomTabBarLabelUnselected,
      unselectedLabelStyle: lightTheme.titleSmall!.copyWith(
        fontSize: lightTheme.titleSmall!.fontSize! - 1,
      ),
      unselectedIconTheme:
          IconThemeData(color: color.bottomTabBarIconUnselected),
    ),
    textTheme: lightTheme,
    colorScheme: ColorScheme.light(
        background: color.background, primary: color.primaryAccent),
  );
}

/*
|--------------------------------------------------------------------------
| Light Text Theme
|--------------------------------------------------------------------------
*/

TextTheme _textTheme(ColorStyles colors) {
  Color primaryContent = colors.primaryContent;
  TextTheme textTheme = TextTheme().apply(displayColor: primaryContent);
  return textTheme.copyWith(
      labelLarge: TextStyle(color: primaryContent.withOpacity(0.8)));
}
