import 'package:flutter/material.dart';
import 'package:afrikaburn/config/design.dart';

class NewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NewsAppBar(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height +
          (viewPadding(context).top / 1.5), // TODO Check this height.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: scale(51, context),
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.arrow_back),
                  color: const Color(0xFF20EDC4),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 26.0),
                child: Container(
                  width: scale(314, context),
                  child: Image.asset(
                    'public/assets/images/news/latest-news-app-bar.png',
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
}
