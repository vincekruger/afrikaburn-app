import 'package:nylo_framework/nylo_framework.dart';

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
    print('HideTicketsEvent handled');
  }
}
