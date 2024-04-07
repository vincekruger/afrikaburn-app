import 'package:afrikaburn/app/events/root_app_lifecycle_event.dart';
import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:afrikaburn/resources/pages/more_stuff_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
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

class _DefaultWorldPageState extends NyState<RootPage>
    with WidgetsBindingObserver {
  /// List of routes to navigate to
  /// This is used to log screen views & body content
  List<Map<String, dynamic>> _pageList = [
    {
      'path': NewsPage.path,
      'page': NewsPage(),
    },
    {
      'path': RadioFreeTankwaPage.path,
      'page': RadioFreeTankwaPage(),
    },
    {
      'path': TicketPage.path,
      'page': TicketPage(),
    },
    {
      'path': MoreStuffPage.path,
      'page': MoreStuffPage(),
    },
  ];

  /// Initialize the page
  @override
  init() async {
    FirebaseProvider()
        .logScreenView(_pageList.elementAt(_currentIndex)['path']);
    SystemUIColorHelper.invertUIColor(
        context, _pageList.elementAt(_currentIndex)['path']);
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
    /// Log screen view
    FirebaseProvider().logScreenView(_pageList.elementAt(data)['path']);
    SystemUIColorHelper.invertUIColor(
        context, _pageList.elementAt(data)['path']);

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
        children: _pageList.map<Widget>((e) => e['page']).toList(),
      ),
      bottomNavigationBar: DefaultWorldNavigationBar(),
    );
  }
}
