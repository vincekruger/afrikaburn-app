import 'package:afrikaburn/config/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';

import '/resources/pages/more_stuff_page.dart';
import '/resources/pages/radio_free_tankwa_page.dart';
import '/resources/pages/ticket_page.dart';
import '/resources/pages/news_page.dart';
import '/resources/pages/map_page.dart';
import '/resources/pages/guide_wtf_2024_page.dart';

class BottomNavigationItemConfig {
  final Widget Function() builder;
  final BottomNavigationItem navigationItem;

  BottomNavigationItemConfig({
    required this.builder,
    required this.navigationItem,
  });
}

class BottomNavigationItem extends Model {
  final IconData icon;
  final String label;
  final String routeName;
  final void Function(BuildContext context)? onTap;

  BottomNavigationItem({
    required this.icon,
    required this.label,
    required this.routeName,
    this.onTap,
  });
}

class NavigationBarConfig {
  String get name => throw UnimplementedError();
  List<BottomNavigationItemConfig> get items => throw UnimplementedError();

  /// Generates a list of navigation items to be used
  /// in a a bottom navigation bar widget
  List<BottomNavigationItem> get navigationItems =>
      items.map((e) => e.navigationItem).toList();

  /// Generates a list of builders to be used
  /// in the root IndexStack widget
  List<Widget> get indexStack => items.map((e) => e.builder()).toList();

  /// Generates a list of paths to be used
  /// for the settings of state data
  List<String> get paths =>
      items.map((e) => e.navigationItem.routeName).toList();

  /// Get the path at a specific index
  String getPathAtIndex(int index) {
    try {
      /// Return the path at the index
      return items[index].navigationItem.routeName;
    } on RangeError {
      /// Optional error handling (consider using a custom exception class)
      throw Exception('Index "$index" not found');
    }
  }

  /// Find an index by the path name
  int findIndexByPath(String path) {
    /// Use indexWhere for more concise searching and null handling
    int index = paths.indexWhere((route) => route == path);

    /// Optional error handling (consider using a custom exception class)
    if (index == -1) throw Exception('Route with path "$path" not found');

    return index;
  }

  /// Returns and onTap method if exists
  Function(BuildContext context)? onTap(int index) {
    try {
      /// Return the onTap method at the index
      return items[index].navigationItem.onTap;
    } on RangeError {
      /// Optional error handling (consider using a custom exception class)
      throw Exception('Index "$index" not found');
    }
  }
}

///
/// Tankwa Town Navigation Bar
/// This is the navigation bar used when the burn is happening baby
///
class TankwaTownNavigationBarConfig extends NavigationBarConfig {
  String get name => "Tankwa Town Navigation Bar";
  List<BottomNavigationItemConfig> get items => [
        /// Offline Map
        BottomNavigationItemConfig(
          builder: () => MapPage(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.map,
            label: "menu-item.map".tr(),
            routeName: MapPage.path,
          ),
        ),

        /// 2024 WTF Guide
        BottomNavigationItemConfig(
          builder: () => GuideWtf2024Page(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.wtf_guide,
            label: "menu-item.wtf-guide-pdf-2024".tr(),
            routeName: GuideWtf2024Page.path,
            onTap: (context) {
              routeTo(GuideWtf2024Page.path);
            },
          ),
        ),

        // if (Backpack.instance
        //         .read(StorageKey.ticketsPageHidden, defaultValue: false) ==
        //     false)
        BottomNavigationItemConfig(
          builder: () => TicketPage(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.ticket,
            label: "menu-item.tickets".tr(),
            routeName: TicketPage.path,
          ),
        ),
      ];
}

///
/// Default World Navigation Bar
/// This is the default navigation bar for the world that is
/// when the burn is not happening
///
class DefaultWorldNavigationBarConfig extends NavigationBarConfig {
  String get name => "Default World Navigation Bar";
  List<BottomNavigationItemConfig> get items => [
        /// News
        BottomNavigationItemConfig(
          builder: () => NewsPage(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.news,
            label: "menu-item.news".tr(),
            routeName: NewsPage.path,
          ),
        ),

        /// Tickets
        BottomNavigationItemConfig(
          builder: () => TicketPage(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.ticket,
            label: "menu-item.tickets".tr(),
            routeName: TicketPage.path,
          ),
        ),

        /// Radio Free Tankwa
        BottomNavigationItemConfig(
          builder: () => RadioFreeTankwaPage(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.rft,
            label: "menu-item.radio-free-tankwa".tr(),
            routeName: RadioFreeTankwaPage.path,
          ),
        ),

        /// More Stuff
        BottomNavigationItemConfig(
          builder: () => MoreStuffPage(),
          navigationItem: BottomNavigationItem(
            icon: AB24Icons.more,
            label: "menu-item.more-stuff".tr(),
            routeName: MoreStuffPage.path,
          ),
        ),
      ];
}
