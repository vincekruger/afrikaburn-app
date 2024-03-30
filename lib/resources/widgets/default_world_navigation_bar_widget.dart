import 'package:afrikaburn/resources/icons/a_b2024_icons.dart';
import 'package:afrikaburn/resources/pages/default_world_page.dart';
import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DefaultWorldNavigationBar extends StatefulWidget {
  DefaultWorldNavigationBar({Key? key}) : super(key: key);

  static String state = "default_world_navigation_bar";

  @override
  createState() => _DefaultWorldNavigationBarState();
}

class _DefaultWorldNavigationBarState
    extends NyState<DefaultWorldNavigationBar> {
  _DefaultWorldNavigationBarState() {
    stateName = DefaultWorldNavigationBar.state;
  }

  int _currentIndex = 0;

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(DefaultWorldNavigationBar.state, data: "example payload");
    setState(() {
      _currentIndex = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: GradientIcon(
            icon: AB2024.ticket,
            size: 20,
            gradient: LinearGradient(
              colors: [
                Color(0xFFE0A414),
                Color(0xFFE0A414),
                Color(0xFFE0A414),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_outlined),
          label: 'More Stuff',
        ),
      ],
      iconSize: 20,
      currentIndex: _currentIndex,
      onTap: (index) {
        updateState(DefaultWorldNavigationBar.state, data: index);
        updateState(DefaultWorldPage.path, data: index);
      },
    );
  }
}
