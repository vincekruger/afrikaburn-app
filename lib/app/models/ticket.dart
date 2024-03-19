import 'package:nylo_framework/nylo_framework.dart';

/// Ticket Model.

enum TicketType { entry, wap, etoll, identification }

class Ticket extends Model {
  Ticket();

  // Ticket.fromJson(data) {}

  @override
  toJson() {}
}
