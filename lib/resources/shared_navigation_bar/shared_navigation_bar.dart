import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/shared_navigation_bar/navigation_bar_config.dart';

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
    /// Set current index by index int
    if (data['index'] != null) {
      setState(() {
        _currentIndex = data['index'];
      });
    }

    /// Set current index by the page the route
    else if (data['route'] != null) {
      int index = widget.config.findIndexByPath(data['route']);
      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Target updated
  void destinationSelected(int index) {
    updateState(SharedNavigationBar.state, data: {"index": index});
    updateState(RootPage.path,
        data: {"route": widget.config.getPathAtIndex(index)});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        gradient: GradientStyles.canvasLine,
      ),
      child: material2Bar(),
    );
  }

  /// Material 2 Navigation Bar
  /// This is working as expected
  BottomNavigationBar material2Bar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: widget.config.navigationItems
          .map((e) => BottomNavigationBarItem(
                icon: Icon(e.icon).withGradeint(GradientStyles.appbarIcon),
                label: e.label,
              ))
          .toList(),
      onTap: destinationSelected,
      // showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
