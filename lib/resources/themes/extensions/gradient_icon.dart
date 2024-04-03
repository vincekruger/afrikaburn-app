import 'package:flutter/material.dart';

/// [Text] Extensions
extension GradientIcon on Icon {
  ShaderMask withGradeint(Gradient gradient) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Icon(
        this.icon,
        size: this.size,
        color: Colors.white,
      ),
    );
  }
}
