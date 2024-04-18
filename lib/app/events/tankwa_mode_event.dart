import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/resources/pages/root.dart';
import 'package:afrikaburn/resources/shared_navigation_bar/shared_navigation_bar.dart';
import 'package:afrikaburn/app/providers/app_mode_provider.dart';

class TankwaModeEvent implements NyEvent {
  @override
  final listeners = {
    DefaultListener: DefaultListener(),
  };
}

class DefaultListener extends NyListener {
  @override
  handle(dynamic event) async {
    /// Get the state from the event
    /// Default will be false if there is no state
    bool state;

    /// Set the state from the event data
    if (event.containsKey('state')) {
      state = event['state'];
    }

    /// If the event is a toggle, set the state
    /// to the opposite of the current state
    else if (event.containsKey('toggle') && event['toggle'] == true) {
      state = !(await AppModeProvider.tankwaTownMode);
      print("Toggle the current app state to $state");
    }

    /// No clear action here
    else {
      throw Exception("AppMode event action is unclear");
    }

    /// Update the storage
    await AppModeProvider.setTankwaTownMode(state);

    /// Update States
    var payload = {"action": "app_mode_changed", "index": 0};
    updateState(SharedNavigationBar.state, data: payload);
    updateState(RootPage.path, data: payload);
  }
}
