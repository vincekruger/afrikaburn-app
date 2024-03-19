import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/map_controller.dart';

class MapPage extends NyStatefulWidget<MapController> {
  static const path = '/map';

  MapPage() : super(path, child: _MapPageState());
}

class _MapPageState extends NyState<MapPage> {

  /// [MapController] controller
  MapController get controller => widget.controller;

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
        title: Text("Map")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
