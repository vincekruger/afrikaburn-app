import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/shared_navigation_bar/navigation_bar_config.dart';
import 'package:afrikaburn/app/events/tankwa_mode_event.dart';

import '/resources/pages/root.dart';

/// Shared Navigation Bar
class SharedNavigationBar extends StatefulWidget {
  SharedNavigationBar({super.key, required this.config});
  final NavigationBarConfig config;

  /// State name
  static String state = "shared_navigation_bar";

  @override
  createState() => _SharedNavigationBarState();
}

class _SharedNavigationBarState extends NyState<SharedNavigationBar> {
  _SharedNavigationBarState() {
    stateName = SharedNavigationBar.state;
  }

  /// Current index of the navigation bar
  int _currentIndex = 0;

  /// Update the state of the widget
  @override
  stateUpdated(dynamic data) async {
    int index = 0;

    /// Set current index by index int
    if (data['index'] != null)
      index = data['index'];

    /// Set current index by the page the route
    else if (data['route'] != null)
      index = widget.config.findIndexByPath(data['route']);

    /// Set the current index
    setState(() {
      /// Update the current index if different
      if (_currentIndex != index) _currentIndex = index;

      /// Toggle the navigation bar visibility
      if (data?['action'] == 'toggle_navigation_bar_visibility')
        _navigationBarVisible = !_navigationBarVisible;
    });
  }

  /// Target updated
  void destinationSelected(int index) {
    var onTappCallback = widget.config.onTap(index);
    if (onTappCallback != null) {
      onTappCallback(context);
    } else {
      updateState(SharedNavigationBar.state, data: {"index": index});
      updateState(RootPage.path,
          data: {"route": widget.config.getPathAtIndex(index)});
    }
  }

  /// Long Press Timer & Duration
  Timer? _longPressTimer;
  final int _longPressMinDuration = 10;

  /// Long Press Started
  /// Start a timer to toggle the app mode
  void _longPressStart(_) {
    _longPressTimer = Timer(Duration(seconds: _longPressMinDuration), () {
      event<TankwaModeEvent>(data: {"toggle": true});
      _longPressTimer?.cancel();
    });
  }

  /// Long Press Ended
  /// Cancel the timer
  void _longPressEnd(_) => _longPressTimer?.cancel();

  /// Navigation Bar Visibility
  bool _navigationBarVisible = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _longPressStart,
      onLongPressEnd: _longPressEnd,
      child: Container(
        padding: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          gradient: GradientStyles.canvasLine,
        ),
        child: material2Bar(),
      ),
    );
  }

  /// Material 2 Navigation Bar
  /// This is working as expected
  Widget material2Bar() {
    return Visibility(
      visible: _navigationBarVisible,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: widget.config.navigationItems
            .map((e) => BottomNavigationBarItem(
                  icon: Icon(e.icon).withGradeint(GradientStyles.appbarIcon),
                  label: e.label,
                ))
            .toList(),
        onTap: destinationSelected,
        showUnselectedLabels: true,
        showSelectedLabels: true,
      ),
    );
  }
}
