import 'package:nylo_framework/nylo_framework.dart';

/// Ticket Type Enum
enum TicketType { entry, wap, etoll, identification }

/// Ticket Model
class Ticket extends Model {
  Ticket();

  // Ticket.fromJson(data) {}

  @override
  toJson() {}
}
