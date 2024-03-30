import 'package:afrikaburn/resources/pages/home_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DefaultWorldPage extends NyStatefulWidget {
  static const path = '/default-world';

  DefaultWorldPage() : super(path, child: _DefaultWorldPageState());
}

class _DefaultWorldPageState extends NyState<DefaultWorldPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    NewsPage(),
    Container(child: Text("Tab 2")),
    Container(child: Text("Tab 3")),
    HomePage(),
  ];

  List<FlashyTabBarItem> _navigationItems = [
    FlashyTabBarItem(icon: Icon(Icons.home), title: Text('News')),
    FlashyTabBarItem(icon: Icon(Icons.home), title: Text('Tab 2')),
    FlashyTabBarItem(icon: Icon(Icons.home), title: Text('Tab 3')),
    FlashyTabBarItem(
        icon: Icon(Icons.more_horiz_outlined), title: Text('More Stuff')),
  ];

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          gradient: GradientStyles().canvasLine,
        ),
        child: FlashyTabBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          selectedIndex: _currentIndex,
          showElevation: true,
          height: 55,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: _navigationItems,
        ),
      ),
    );
  }
}
