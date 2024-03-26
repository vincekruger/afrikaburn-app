import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/map_controller.dart';

class MapPage extends NyStatefulWidget<MapController> {
  static const path = '/map';

  MapPage() : super(path, child: _MapPageState());
}

class AnnotationClickListener extends OnCircleAnnotationClickListener {
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class _MapPageState extends NyState<MapPage> {
  /// [MapController] controller
  MapController get controller => widget.controller;

  /// MapBoxMap Controllers
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;

  Brightness? systemBrightness;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createCircleAnnotationManager().then((manager) {
      circleAnnotationManager = manager;

      // Create OCC
      circleAnnotationManager?.create(CircleAnnotationOptions(
        geometry: widget.controller.occLocation,
        circleColor: Colors.yellow.value,
        circleRadius: 8.0,
      ));

      circleAnnotationManager
          ?.addOnCircleAnnotationClickListener(AnnotationClickListener());
    });
  }

  /// Use boot if you need to load data before the view is rendered.
  @override
  boot() async {
    await widget.controller.setMapboxAccessToken();
    systemBrightness = MediaQuery.of(context).platformBrightness;
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("screen-title.map".tr())),
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(19.9565, -32.5165)).toJson(),
          zoom: 12.0,
        ),
        // TODO Set my own theme eventually
        styleUri: systemBrightness == Brightness.light
            ? MapboxStyles.LIGHT
            : MapboxStyles.DARK,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
