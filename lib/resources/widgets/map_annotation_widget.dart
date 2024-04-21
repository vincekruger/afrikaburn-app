import 'package:afrikaburn/app/models/map_annotation.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';

class MapAnnotationDetail extends StatefulWidget {
  const MapAnnotationDetail({super.key});

  static String state = "map_annotation_detail";

  @override
  createState() => _MapAnnotationDetailState();
}

class _MapAnnotationDetailState extends NyState<MapAnnotationDetail> {
  _MapAnnotationDetailState() {
    stateName = MapAnnotationDetail.state;
  }

  MapAnnotation? _annotation;
  final _scrollController = ScrollController();
  double _boxMinHeight = 100;
  double _tmpBoxMinHeight = 0;

  @override
  init() async {
    _scrollController.addListener(() {
      dragDownHandler();
      dragUpHandler();
    });
  }

  /// Handle drag down event to close the annotation box
  void dragDownHandler() {
    _tmpBoxMinHeight = _boxMinHeight;
    final newBoxHeight = _boxMinHeight + _scrollController.offset;
    setState(() {
      _boxMinHeight = newBoxHeight < 30 ? 0 : newBoxHeight;
    });
  }

  void dragUpHandler() {
    /// only work for positive offset
    if (_scrollController.offset < 0) return;
    final newBoxHeight = _boxMinHeight + _scrollController.offset;
    setState(() {
      _boxMinHeight = newBoxHeight;
    });
  }

  double getInitialHeightFromAnnotation(MapAnnotation annotation) {
    double height = 70;
    if (annotation.burning == true) height += 20;
    if (annotation.description.isNotEmpty) height += 60;
    return height;
  }

  @override
  stateUpdated(dynamic data) async {
    setState(() {
      if (data?['annotation'] != null) {
        _annotation = data['annotation'];
        _boxMinHeight = getInitialHeightFromAnnotation(_annotation!);
      }

      if (data?['hide'] == true) {
        _boxMinHeight = 0;
      }
    });
  }

  double get boxMinHeight {
    if (_annotation == null) return 0;

    return _boxMinHeight;
  }

  String dayOfWeek(int day) {
    switch (day) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 0:
        return "Sunday";
      default:
        return "Who Knows";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_annotation == null) return SizedBox(height: 0);
    MapAnnotation annotation = _annotation!;

    return SizedBox(
      height: boxMinHeight,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: context.color.surfaceBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: AbDivider(width: 100),
              ),
              SizedBox(height: 10),
              Text(annotation.name)
                  .titleMedium(context)
                  .setColor(context, (color) => context.color.surfaceContent),
              if (annotation.type == AnnotationType.Artwork)
                ...artworkDetail(annotation),
              if (annotation.type == AnnotationType.ThemeCamp)
                ...themeCampDetail(annotation),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> themeCampDetail(MapAnnotation annotation) {
    List<Widget> details = [];

    if (annotation.description.isNotEmpty) {
      details.add(
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(annotation.description)
              .bodyMedium(context)
              .setColor(context, (color) => context.color.surfaceContent),
        ),
      );
    }

    return details;
  }

  List<Widget> artworkDetail(MapAnnotation annotation) {
    List<Widget> details = [];

    /// Burn Scehdule
    if (annotation.burning) {
      details.add(
        Text("Burning on ${dayOfWeek(annotation.burningDay)}")
            .bodyLarge(context)
            .setColor(context, (color) => context.color.surfaceContent),
      );
    }

    if (annotation.description.isNotEmpty) {
      details.add(
        Padding(
          padding: EdgeInsets.only(top: annotation.burning ? 12.0 : 0),
          child: Text(annotation.description)
              .bodyMedium(context)
              .setColor(context, (color) => context.color.surfaceContent),
        ),
      );
    }

    return details;
  }
}
