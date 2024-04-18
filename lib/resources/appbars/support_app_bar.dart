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
            left: -144,
            child: Image.asset(
              'public/assets/images/app_bars/varient-4-lightdark.png',
              width: 471,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            margin: getAppBarTopMargin(context),
            child: AppBar(
              leading: backButton(context),
              backgroundColor: Colors.transparent,
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

  EdgeInsets getAppBarTopMargin(BuildContext context) {
    return EdgeInsets.only(top: 30);
    // double topPadding = viewPadding(context).top;
    // double iOSAdjustment = -25;
    // double androidAdjustment = 10;
    // double adjustment = Platform.isIOS ? iOSAdjustment : androidAdjustment;
    // if (topPadding + adjustment < 0) return EdgeInsets.only(top: topPadding);
    // return EdgeInsets.only(top: topPadding + adjustment);
  }

  /// Back Navigation Button
  /// It's not needed right now
  Widget backButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, left: 2),
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
