import 'package:flutter/material.dart';

/// TicketActionSheetAction Model.

enum TicketActionSheetActionType {
  TAKE_PHOTO,
  CHOOSE_PHOTO,
  SELECT_FILE,
}

class TicketActionSheetAction {
  final TicketActionSheetActionType action;
  final String title;
  final IconData icon;

  TicketActionSheetAction({
    required this.action,
    required this.title,
    required this.icon,
  });
}
