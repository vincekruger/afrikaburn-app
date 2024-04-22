import 'package:afrikaburn/config/storage_keys.dart';
import 'package:afrikaburn/resources/shared_navigation_bar/shared_navigation_bar.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Hide the Tickets Page event

class HideTicketsEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    // Handle the event
    updateState(SharedNavigationBar.state,
        data: {"index": 0, 'action': 'hide_tickets_page'});

    (await SharedPreferences.getInstance())
        .setBool(StorageKey.ticketsPageHidden, true);
    Backpack.instance.set(StorageKey.ticketsPageHidden, true);
  }
}
