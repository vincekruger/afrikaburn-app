import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/radio_free_tankwa_controller.dart';

class RadioFreeTankwaPage extends NyStatefulWidget<RadioFreeTankwaController> {
  static const path = '/radio-free-tankwa';

  RadioFreeTankwaPage() : super(path, child: _RadioFreeTankwaPageState());
}

class _RadioFreeTankwaPageState extends NyState<RadioFreeTankwaPage> {

  /// [RadioFreeTankwaController] controller
  RadioFreeTankwaController get controller => widget.controller;

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
        title: Text("Radio Free Tankwa")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
