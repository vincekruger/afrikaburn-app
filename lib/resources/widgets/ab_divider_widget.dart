import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:afrikaburn/config/design.dart';

class AbDivider extends StatelessWidget {
  const AbDivider({
    Key? key,
    required this.width,
    this.alignment = Alignment.centerLeft,
    this.padding,
  }) : super(key: key);

  final double width;
  final Alignment alignment;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding ?? EdgeInsets.zero,
      child: Container(
        width: scale(this.width, context),
        height: 2,
        decoration: BoxDecoration(
          gradient: GradientStyles().canvasLine,
        ),
      ),
    );
  }
}
