import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

Widget pointingHand(BuildContext context,
        {EdgeInsets? insets, double? width}) =>
    Container(
      alignment: Alignment.topLeft,
      padding: insets ?? EdgeInsets.only(left: 12, top: 20),
      child: Image.asset(
        context.isDarkMode
            ? "public/assets/images/pointing-hand-dark.png"
            : "public/assets/images/pointing-hand-light.png",
        width: width ?? 58,
      ),
    );
