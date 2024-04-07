import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/themes/styles/color_styles.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
import 'package:afrikaburn/resources/pages/ticket_page.dart';

/* Helpers
|--------------------------------------------------------------------------
| Add your helper methods here
|-------------------------------------------------------------------------- */

/// helper to find correct color from the [context].
class ThemeColor {
  static ColorStyles get(BuildContext context, {String? themeId}) =>
      nyColorStyle<ColorStyles>(context, themeId: themeId);

  static Color fromHex(String hexColor) => nyHexColor(hexColor);
}

class SystemUIColorHelper {
  static final List<String> _requiresInvertedUIColor = [
    NewsPage.path,
    RadioFreeTankwaPage.path,
    TicketPage.path,
  ];

  static Future<void> invertUIColor(BuildContext context, String path) async {
    if (!_requiresInvertedUIColor.contains(path)) return;
    SystemChrome.setSystemUIOverlayStyle(
      context.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }
}
