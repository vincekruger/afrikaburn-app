import 'package:flutter/material.dart';

/// [Icon] Extensions
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

extension GradientButton on IconButton {
  Widget withGradient(Gradient gradient) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(50.0),
      ),
      padding: EdgeInsets.zero,
      child: IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: this.icon,
        color: this.color,
        onPressed: this.onPressed,
      ),
    );
  }

  Widget withGradientAndIconOverlay(Gradient gradient,
      {required Icon overlayIcon, double? iconTop, double? iconLeft}) {
    return InkWell(
      onTap: this.onPressed,
      borderRadius: BorderRadius.circular(50.0),
      child: Stack(
        children: [
          Container(
            width: overlayIcon.size ?? 40,
            height: overlayIcon.size ?? 40,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: EdgeInsets.zero,
            child: this.icon,
          ),
          Positioned(
            top: iconTop ?? 0,
            left: iconLeft ?? 0,
            child: overlayIcon,
          ),
        ],
      ),
    );
  }
}
