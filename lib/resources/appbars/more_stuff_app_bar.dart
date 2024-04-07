import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MoreStuffAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final double bottomPadding = 10;

  const MoreStuffAppBar({
    super.key,
    required this.height,
    required this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(height + bottomPadding);

  @override
  Widget build(BuildContext context) {
    var backgroundImage = Image.asset(
      context.isDarkMode
          ? 'public/assets/images/appbar-bg-dark.png'
          : 'public/assets/images/appbar-bg-light.png',
      fit: BoxFit.fill,
    );

    return Stack(
      children: [
        ClipPath(
          clipper: _AppBarClipper(20.0),
          child: Container(
            height: 119,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: backgroundImage.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AppBar(
          title: Text(title),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: context.isDarkMode
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
        ),
      ],
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  final double size;
  _AppBarClipper(this.size);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - this.size);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_AppBarClipper oldClipper) => size != oldClipper.size;
}
