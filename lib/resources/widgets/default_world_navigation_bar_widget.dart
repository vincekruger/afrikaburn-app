import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/models/navigation_item.dart';
import 'package:afrikaburn/resources/themes/extensions/gradient_icon.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/pages/root.dart';

/// Default World Navigation Bar
class DefaultWorldNavigationBar extends StatefulWidget {
  DefaultWorldNavigationBar({Key? key}) : super(key: key);

  /// State name
  static String state = "default_world_navigation_bar";

  @override
  createState() => _DefaultWorldNavigationBarState();
}

class _DefaultWorldNavigationBarState
    extends NyState<DefaultWorldNavigationBar> {
  _DefaultWorldNavigationBarState() {
    stateName = DefaultWorldNavigationBar.state;
  }

  /// Current index of the navigation bar
  int _currentIndex = 0;

  /// Update the state of the widget
  @override
  stateUpdated(dynamic data) async {
    setState(() {
      _currentIndex = data;
    });
  }

  /// List of navigation items
  List<NavigationItem> _items = [
    NavigationItem(AB24Icons.news, "menu-item.news".tr()),
    NavigationItem(AB24Icons.ticket, "menu-item.tickets".tr()),
    NavigationItem(AB24Icons.more, "menu-item.more-stuff".tr()),
  ];

  /// Target updated
  void destinationSelected(int index) {
    updateState(DefaultWorldNavigationBar.state, data: index);
    updateState(RootPage.path, data: index);
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

    /// I cannot set the padding of the text labels. :(
    // return matrial3Bar();
  }

  /// Material 2 Navigation Bar
  /// This is working as expected
  BottomNavigationBar material2Bar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: _items
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

  /// Material 3 Navigation Bar
  /// This is not working as expected
  /// I cannot setting the top padding on the text labels
  NavigationBar matrial3Bar() {
    final double iconSize = 26;

    return NavigationBar(
      selectedIndex: _currentIndex,
      destinations: _items
          .map((e) => NavigationDestination(
                icon: Icon(e.icon, size: iconSize)
                    .withGradeint(GradientStyles.appbarIcon),
                label: e.label,
                tooltip: '',
              ))
          .toList(),
      onDestinationSelected: destinationSelected,
    );
  }
}
