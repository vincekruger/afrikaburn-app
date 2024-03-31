import 'package:nylo_framework/nylo_framework.dart';
import 'package:nylo_framework/theme/helper/ny_theme.dart';
import 'package:flutter/material.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/widgets/safearea_widget.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/app/controllers/home_controller.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static const path = '/home';
  HomePage() : super(path, child: _HomePageState());
}

class _HomePageState extends NyState<HomePage> {
  /// The [view] method should display your page.
  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getEnv("APP_NAME"),
        ),
        centerTitle: true,
      ),
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Something amazing is happening 🔥",
              ).bodyMedium(context).alignCenter(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: ThemeColor.get(context).surfaceBackground,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 9,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: _buttons,
                          color: ThemeColor.get(context).surfaceContent,
                        ).toList(),
                      ),
                    ),
                  ),
                  Text(
                    "Framework Version: $nyloVersion",
                  )
                      .bodyMedium(context)
                      .setColor(context, (color) => Colors.grey),
                  if (!context.isDarkMode)
                    Switch(
                        value: isThemeDark,
                        onChanged: (_) {
                          NyTheme.set(context,
                              id: getEnv(isThemeDark != true
                                  ? 'DARK_THEME_ID'
                                  : 'LIGHT_THEME_ID'));
                        }),
                  if (!context.isDarkMode)
                    Text("${isThemeDark ? "Dark" : "Light"} Mode"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> get _buttons => [
        button(
          "map".tr(),
          widget.controller.openMap,
        ),
        button(
          "wtf-guide".tr(),
          widget.controller.openWTFGuide,
        ),
        button(
          "my-contact".tr(),
          widget.controller.openMyContact,
        ),
        button(
          "testing.force-crash".tr(),
          () {
            throw Exception("This is a test crash");
          },
        ),
      ];

  Widget button(String text, Function() onPressed) {
    return MaterialButton(
      child: Text(
        text,
      ).bodyLarge(context).setColor(context, (color) => color.surfaceContent),
      onPressed: onPressed,
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}
