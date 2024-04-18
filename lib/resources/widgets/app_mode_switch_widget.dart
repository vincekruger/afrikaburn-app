import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/events/tankwa_mode_event.dart';
import 'package:afrikaburn/app/providers/app_mode_provider.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';

class AppModeSwitch extends StatefulWidget {
  const AppModeSwitch({super.key});
  static String state = "app_mode_switch";

  @override
  createState() => _AppModeSwitchState();
}

class _AppModeSwitchState extends NyState<AppModeSwitch> {
  _AppModeSwitchState() {
    stateName = AppModeSwitch.state;
  }

  @override
  Widget build(BuildContext context) {
    if (!AppModeProvider.isDevelopment) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: OutlinedButton(
        onPressed: () {
          event<TankwaModeEvent>(data: {'state': true});
        },
        child: Text("Enable Tankwa Mode".tr()),
      ).withGradient(
        strokeWidth: 2,
        gradient: GradientStyles.outlinedButtonBorder,
      ),
    );
  }
}
