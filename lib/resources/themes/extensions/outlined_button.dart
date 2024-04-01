import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

extension RoundedOutlinedButton on OutlinedButton {
  Widget withGradient({
    required double strokeWidth,
    required LinearGradient gradient,
    Radius radius = Radius.zero,
  }) {
    return OutlineGradientButton(
      strokeWidth: strokeWidth,
      gradient: gradient,
      padding: EdgeInsets.symmetric(horizontal: 2),
      radius: radius,
      child: OutlinedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        statesController: statesController,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          ),
          side: MaterialStateProperty.all(
              BorderSide(width: 0, color: Colors.transparent)),
        ),
        child: child,
      ),
    );
  }
}
