import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final double bottomPadding = 10;

  const SettingsAppBar({
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
        Positioned(
          top: scale(preferredSize.height - 25, context),
          left: scale(-40, context),
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..rotateZ(0.0178 * -1),
            child: Container(
              width: scale(403.86, context),
              height: scale(46, context),
              decoration: BoxDecoration(
                gradient: GradientStyles.canvasLineInverted,
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: _AppBarClipper(20.0),
          child: Container(
            height: preferredSize.height + 20,
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 0, bottom: 10),
            child: IconButton(
              icon: Icon(AB24Icons.close_thick),
              iconSize: 30,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
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
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height - this.size);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_AppBarClipper oldClipper) => size != oldClipper.size;
}
