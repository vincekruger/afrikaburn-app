import 'package:nylo_framework/nylo_framework.dart';

/// Ticket Type Enum
enum TicketType {
  entry,
  wap,
  etoll,
  identification,
}

final String ticketLocalPath = 'Guides';
final String ticketThumbnailLocalPath = 'Guides';

/// Ticket Model
class Ticket extends Model {
  Ticket();

  // Ticket.fromJson(data) {}

  @override
  toJson() {}
}
