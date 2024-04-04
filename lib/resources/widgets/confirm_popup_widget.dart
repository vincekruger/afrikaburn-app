import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// Confirm Popup Widget
class ConfirmPopup extends StatelessWidget {
  final String title;
  final String message;
  final AlertAction? action;
  final List<AlertAction>? actions;

  const ConfirmPopup({
    super.key,
    required this.title,
    required this.message,
    this.action,
    this.actions,
  }) : assert(action != null || actions != null);

  Widget actionBuilder(BuildContext context, AlertAction action) {
    final Text label = Text(action.label).fontWeightBold();
    if (action.isDestructive == true)
      label.setColor(
          context, (color) => context.color.dialogDescructiveActionColor);

    return TextButton(
      child: label,
      onPressed: (action.onPressed != null)
          ? action.onPressed
          : () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(title),
      ),
      content: Text(message),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0)
          .copyWith(top: 16, bottom: 8),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.zero.copyWith(bottom: 8),
      actions: (action != null)
          ? [actionBuilder(context, action!)]
          : actions!.map((e) => actionBuilder(context, e)).toList(),
    );
  }
}

/// Alert Action Wrapper
class AlertAction {
  final String label;
  void Function()? onPressed;
  bool? isDestructive = false;

  AlertAction({
    required this.label,
    this.onPressed,
    this.isDestructive,
  });
}
