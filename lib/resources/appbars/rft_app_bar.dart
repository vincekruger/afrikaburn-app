import 'package:afrikaburn/resources/icons/ab24_icons_icons.dart';
import 'package:afrikaburn/resources/pages/radio_free_tankwa_page.dart';
import 'package:flutter/material.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RFTAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RFTAppBar(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  /// The News App Bar
  @override
  Widget build(BuildContext context) {
    final double contentTop = scale(34, context);

    return Container(
      height: preferredSize.height + (viewPadding(context).top / 1.5),
      child: Stack(
        children: [
          Positioned(
            right: scale(-120, context),
            child: Image.asset(
              'public/assets/images/app_bars/varient-2-lightdark.png',
              width: scale(471, context),
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: contentTop,
            right: scale(110, context),
            child: Text(RadioFreeTankwaPage.name).titleLarge(context).setColor(
                context, (color) => context.color.appBarPrimaryContent),
          ),
          if (Navigator.canPop(context))
            Positioned(
              top: 5,
              child: backButton(context),
            ),
        ],
      ),
    );
  }

  /// Back Navigation Button
  /// It's not needed right now
  Widget backButton(BuildContext context) {
    return Container(
      width: scale(51, context),
      child: IconButton(
        iconSize: 30,
        icon: Icon(AB24Icons.back),
        color: context.color.appBarPrimaryContent,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
