import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';

class SupportAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SupportAppBar(this.height, {super.key});
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  /// The News App Bar
  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: Stack(
        children: [
          Positioned(
            top: viewPadding(context).top,
            left: scale(-144, context),
            child: Image.asset(
              'public/assets/images/app_bars/varient-4-lightdark.png',
              width: scale(471, context),
              fit: BoxFit.fill,
            ),
          ),
          // Positioned(
          //   top: contentTop,
          //   right: scale(110, context),
          //   child: Text("screen-name.support".tr())
          //       .titleLarge(context)
          //       .setColor(context,(color) => context.color.appBarContentLightBackground),
          // ),
          // Positioned(
          //   top: 5,
          //   child: backButton(context),
          // ),

          Container(
            margin: EdgeInsets.only(top: viewPadding(context).top - 35),
            child: AppBar(
              // actions: [backButton(context)],
              // automaticallyImplyLeading: false,
              leading: backButton(context),
              systemOverlayStyle: context.isDarkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              titleSpacing: 30,
              centerTitle: false,
              title: Text("screen-name.support".tr()).setColor(context,
                  (color) => context.color.appBarContentLightBackground),
            ),
          ),
        ],
      ),
    );
  }

  /// Back Navigation Button
  /// It's not needed right now
  Widget backButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 2),
      child: IconButton(
        iconSize: 40,
        icon: Icon(
          AB24Icons.back,
          color: context.color.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
