import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final double bottomPadding = 10;

  const CustomAppBar({
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
        Container(
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundImage.image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Transform(
            alignment: FractionalOffset.bottomCenter,
            transform: Matrix4.identity()..rotateZ(-0.0372),
            child: backgroundImage,
          ),
        ),
        AppBar(
          title: Text(title),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: context.isDarkMode
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
        ),
        SizedBox(height: bottomPadding),
      ],
    );
  }
}
