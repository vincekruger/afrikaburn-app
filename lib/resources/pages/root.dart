import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/app/events/root_app_lifecycle_event.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';

import '/resources/pages/more_stuff_page.dart';
import '/resources/pages/news_page.dart';
import '/resources/pages/radio_free_tankwa_page.dart';
import '/resources/pages/ticket_page.dart';
import '/resources/widgets/default_world_navigation_bar_widget.dart';

class RootPage extends NyStatefulWidget {
  /// Route path & page name
  static const path = '/root';
  static const name = 'Root Page';
  RootPage() : super(path, child: _RootPageState());
}

class _RootPageState extends NyState<RootPage> with WidgetsBindingObserver {
  /// List of routes to navigate to
  /// This is used to log screen views & body content
  List<Map<String, dynamic>> _pageList = [
    {
      'path': NewsPage.path,
      'page': NewsPage(),
    },
    {
      'path': TicketPage.path,
      'page': TicketPage(),
    },
    {
      'path': RadioFreeTankwaPage.path,
      'page': RadioFreeTankwaPage(),
    },
    {
      'path': MoreStuffPage.path,
      'page': MoreStuffPage(),
    },
  ];

  List<String> get _routeNames => _pageList
      .where((element) => element['path'] != null)
      .map<String>((e) => e['path'])
      .toList();

  List<Widget> get _pages => _pageList
      .where((element) => element['page'] != null)
      .map<Widget>((e) => e['page'])
      .toList();

  /// Initialize the page
  @override
  init() async {
    /// Set the UI color
    SystemUIColorHelper.invertUIColor(
        context, _pageList.elementAt(_currentIndex)['path']);

    /// Log screen view
    FirebaseProvider()
        .logScreenView(_pageList.elementAt(_currentIndex)['path']);

    /// Add widget binding observer
    WidgetsBinding.instance.addObserver(this);
  }

  /// Dippose
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    event<RootAppLifecycleEvent>(data: {'state': state});
  }

  @override
  stateUpdated(dynamic data) async {
    /// Set/Find the index
    int setIndex = 0;
    if (data['index'] != null) {
      setIndex = data['index'] as int;
    } else if (data['route'] != null) {
      setIndex = findRouteIndex(data['route'], _routeNames);
    }

    /// Update the current index
    setState(() {
      _currentIndex = setIndex;
    });

    /// Log screen view
    FirebaseProvider().logScreenView(
      _pageList.elementAt(_currentIndex)['path'],
    );
    SystemUIColorHelper.invertUIColor(
      context,
      _pageList.elementAt(_currentIndex)['path'],
    );
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
