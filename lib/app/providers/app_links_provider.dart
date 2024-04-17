import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:quick_actions/quick_actions.dart';
import '/resources/pages/root.dart';
import '/resources/pages/radio_free_tankwa_page.dart';
import '/resources/pages/ticket_page.dart';
import '/resources/shared_navigation_bar/shared_navigation_bar.dart';

class AppLinksProvider implements NyProvider {
  final QuickActions quickActions = const QuickActions();

  final List<ShortcutItem> commonActions = [
    const ShortcutItem(
      type: 'action_tickets',
      localizedTitle: 'My Tickets',
      icon: 'action_tickets',
    ),
    const ShortcutItem(
      type: 'action_rft',
      localizedTitle: 'Radio Free Tankwa',
      icon: 'action_rft',
    ),
  ];
  final List<ShortcutItem> defaultWorldActions = [];
  final List<ShortcutItem> tankwaTownActions = [];

  @override
  boot(Nylo nylo) async {
    /// Setup Quick Actions
    quickActions.setShortcutItems(<ShortcutItem>[
      ...commonActions,
      ...defaultWorldActions,
    ]);
    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    /// Initialize Quick Actions
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_tickets') navigateTickets();
      if (shortcutType == 'action_rft') navigateRFT();
    });
  }

  /// Handle Deep Linking
  /// Deep links are triggered from onUnknownRoute in main.dart
  static Route<dynamic>? handleDeepLink(RouteSettings settings) {
    /// Home Page - basically the share app link
    if (settings.name == '/') navigateNews();

    /// Radio Free Tankwa Link
    if (settings.name == '/rft') navigateRFT();

    return null;
  }

  static void navigateNews() {
    dynamic data = {"index": 0};
    updateState(RootPage.path, data: data);
    updateState(SharedNavigationBar.state, data: data);
    popToRoot();
  }

  static void navigateTickets() {
    dynamic data = {"route": TicketPage.path};
    updateState(RootPage.path, data: data);
    updateState(SharedNavigationBar.state, data: data);
    popToRoot();
  }

  static void navigateRFT() {
    dynamic data = {"route": RadioFreeTankwaPage.path};
    updateState(RootPage.path, data: data);
    updateState(SharedNavigationBar.state, data: data);
    popToRoot();
  }

  /// Pop to root
  static void popToRoot() {
    NyNavigator.instance.router.navigatorKey?.currentState
        ?.popUntil((route) => route.isFirst);
  }
}
