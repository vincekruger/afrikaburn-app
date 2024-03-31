import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/resources/pages/home_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/ticket_page.dart';
import 'package:afrikaburn/resources/widgets/default_world_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RootPage extends NyStatefulWidget {
  /// Route path & page name
  static const path = '/default-world';
  static const name = 'Root Page';
  RootPage() : super(path, child: _DefaultWorldPageState());
}

class _DefaultWorldPageState extends NyState<RootPage> {
  /// List of routes to navigate to
  /// This is used to log screen views & body content
  List<String> _paths = [
    NewsPage.path,
    TicketPage.path,
    HomePage.path,
  ];
  List<Widget> _pages = [
    NewsPage(),
    TicketPage(),
    HomePage(),
  ];

  @override
  stateUpdated(dynamic data) async {
    /// Log screen view
    FirebaseProvider().logScreenView(_paths[data]);

    /// Update the current index
    setState(() {
      _currentIndex = data;
    });
  }

  /// Current index of the navigation bar
  int _currentIndex = 0;

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: DefaultWorldNavigationBar(),
    );
  }
}
