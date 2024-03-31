import 'package:afrikaburn/resources/icons/a_b2024_icons.dart';
import 'package:afrikaburn/resources/pages/root.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// Navigation Item Wrapper Class
class NavigationItem {
  final IconData icon;
  final String label;
  NavigationItem(this.icon, this.label);
}

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

  /// Creates a gradient icon
  GradientIcon gradientIcon(IconData icon, double iconSize) {
    return GradientIcon(
      icon: icon,
      size: iconSize,
      offset: Offset.zero,
      gradient: GradientStyles.appbarIcon,
    );
  }

  /// List of navigation items
  List<NavigationItem> _items = [
    NavigationItem(Icons.newspaper, "News".tr()),
    NavigationItem(AB2024.ticket, "Ticket".tr()),
    NavigationItem(Icons.more_horiz_outlined, "More Stuff".tr()),
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
    final double iconSize = 20;

    return BottomNavigationBar(
      elevation: 0,
      currentIndex: _currentIndex,
      items: _items
          .map((e) => BottomNavigationBarItem(
                icon: gradientIcon(e.icon, iconSize),
                label: e.label,
              ))
          .toList(),
      onTap: destinationSelected,
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
                icon: gradientIcon(e.icon, iconSize),
                label: e.label,
                tooltip: '',
              ))
          .toList(),
      onDestinationSelected: destinationSelected,
    );
  }
}
