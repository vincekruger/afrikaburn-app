import 'package:afrikaburn/config/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/bootstrap/helpers.dart';
import '/app/providers/firebase_provider.dart';
import '/app/events/root_app_lifecycle_event.dart';
import '/resources/shared_navigation_bar/navigation_bar_config.dart';
import '/resources/shared_navigation_bar/shared_navigation_bar.dart';

class RootPage extends NyStatefulWidget {
  /// Route path & page name
  static const path = '/root';
  static const name = 'Root Page';
  RootPage() : super(path, child: _RootPageState());
}

class _RootPageState extends NyState<RootPage> with WidgetsBindingObserver {
  /// Initialize the page
  @override
  init() async {
    /// Set the correct navigation config
    _navigationBarConfig = _navigationConfig;

    /// Trigger the page load handler
    onPageLoad();

    /// Add widget binding observer
    WidgetsBinding.instance.addObserver(this);
  }

  /// On a Page Load
  /// - Set the UI color
  /// - Log screen view
  void onPageLoad() {
    /// Set the UI color
    SystemUIColorHelper.invertUIColor(
        context, _navigationBarConfig.getPathAtIndex(_currentIndex));

    /// Log screen view
    FirebaseProvider()
        .logScreenView(_navigationBarConfig.getPathAtIndex(_currentIndex));
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
      setIndex = _navigationBarConfig.findIndexByPath(data['route']);
    }

    /// Update the current index
    if (_currentIndex != setIndex) {
      setState(() {
        _currentIndex = setIndex;
      });
    }

    /// Set the app mode changed
    if (data?['action'] == 'app_mode_changed') {
      setState(() {
        _navigationBarConfig = _navigationConfig;
      });
    }

    /// trigger page load
    onPageLoad();
  }

  /// Get the correct navigation config
  NavigationBarConfig get _navigationConfig =>
      Backpack.instance.read(StorageKey.tankwaTownMode, defaultValue: false)
          ? TankwaTownNavigationBarConfig()
          : DefaultWorldNavigationBarConfig();

  /// Current index of the navigation bar
  int _currentIndex = 0;

  /// The Current Navigation Bar Config
  late NavigationBarConfig _navigationBarConfig;

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _navigationBarConfig.indexStack,
      ),
      bottomNavigationBar: SharedNavigationBar(config: _navigationBarConfig),
    );
  }
}
