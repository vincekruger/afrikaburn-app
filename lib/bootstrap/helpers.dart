import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/themes/styles/color_styles.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
import 'package:afrikaburn/resources/pages/ticket_page.dart';
import 'package:pdfrx/pdfrx.dart';

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

/// Layout Pages Horizontal
PdfPageLayout Function(List<PdfPage>, PdfViewerParams)? pdfHorizonalPageLayout =
    (pages, params) {
  final height = pages.fold(0.0, (prev, page) => max(prev, page.height)) +
      params.margin * 2;
  final pageLayouts = <Rect>[];
  double x = params.margin;
  for (var page in pages) {
    pageLayouts.add(
      Rect.fromLTWH(
        x,
        (height - page.height) / 2, // center vertically
        page.width,
        page.height,
      ),
    );
    x += page.width + params.margin;
  }

  return PdfPageLayout(
    pageLayouts: pageLayouts,
    documentSize: Size(x, height),
  );
};

int findRouteIndex(String path, List<String> _routeList) {
  // Use indexWhere for more concise searching and null handling
  int index = _routeList.indexWhere((route) => route == path);

  // Optional error handling (consider using a custom exception class)
  if (index == -1) {
    throw Exception('Route with path "$path" not found');
  }

  return index;
}
