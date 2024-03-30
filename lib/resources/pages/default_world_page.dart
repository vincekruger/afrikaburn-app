import 'package:afrikaburn/resources/pages/home_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
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
    Container(
      child: Text("Tab 1"),
    ),
    Container(
      child: Text("Tab 2"),
    ),
    Container(
      child: Text("Tab 3"),
    ),
    HomePage(),
  ];

  @override
  init() async {}

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tab 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tab 3',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_outlined),
            label: 'More Stuff',
          ),
        ],
      ),
    );
  }
}
