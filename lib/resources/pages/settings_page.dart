import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/settings_controller.dart';

class SettingsPage extends NyStatefulWidget<SettingsController> {
  static const path = '/settings';

  SettingsPage({super.key}) : super(path, child: _SettingsPageState());
}

class _SettingsPageState extends NyState<SettingsPage> {

  /// [SettingsController] controller
  SettingsController get controller => widget.controller;

  @override
  init() async {

  }
  
  /// Use boot if you need to load data before the view is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
