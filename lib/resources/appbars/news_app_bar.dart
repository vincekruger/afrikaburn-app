import 'package:afrikaburn/resources/icons/a_b2024_icons.dart';
import 'package:flutter/material.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewsAppBar(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  /// The News App Bar
  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + (viewPadding(context).top / 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // backButton(context),
              // newsSettingsMenuAnchor(context),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 26.0),
                child: Container(
                  width: scale(314, context),
                  child: Image.asset(
                    context.isDarkMode
                        ? 'public/assets/images/news/latest-news-app-bar-dark.png'
                        : 'public/assets/images/news/latest-news-app-bar-light.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
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
        icon: Icon(Icons.arrow_back),
        color: const Color(0xFF20EDC4),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// News Settings Menu Anchor
  /// Can let the user enable notifications or contribute to the news
  Widget newsSettingsMenuAnchor() {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          iconSize: 20,
          icon: Icon(AB2024.settings),
          color: const Color(0xFF20EDC4),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {},
          leadingIcon: Icon(
            AB2024.close,
            size: 14,
          ),
          child: Text('Enable Notifications'),
        ),
        MenuItemButton(
          onPressed: () {
            // Open link: https://www.afrikaburn.org/news/submit-an-article/
          },
          child: Text('Contribute'),
        ),
      ],
    );
  }
}
