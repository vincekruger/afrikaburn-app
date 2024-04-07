import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/providers/settings_provider.dart';

///
/// Root App Lifecycle Event
///
class RootAppLifecycleEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    // Handle the event
    AppLifecycleState state = event['state'] as AppLifecycleState;
    switch (state) {
      case AppLifecycleState.resumed:
        SettingsProvider().compareAppSettings();
        break;
      default:
        break;
    }
  }
}
