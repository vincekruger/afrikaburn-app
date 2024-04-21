import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MapView extends StatefulWidget {
  
  const MapView({super.key});
  
  static String state = "map_view";

  @override
  createState() => _MapViewState();
}

class _MapViewState extends NyState<MapView> {

  _MapViewState() {
    stateName = MapView.state;
  }

  @override
  init() async {
    
  }
  
  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(MapView.state, data: "example payload");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
