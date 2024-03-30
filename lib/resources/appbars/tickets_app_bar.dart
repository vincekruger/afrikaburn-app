import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:flutter/material.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class TicketsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const TicketsAppBar(this.height, {super.key});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height + (viewPadding(context).top / 1.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Navigator.canPop(context)
                  ? IconButton(
                      iconSize: 30,
                      icon: Icon(Icons.arrow_back),
                      color: ThemeColor.get(context).primaryAlternate,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : SizedBox(
                      width: scale(57, context),
                    ),
              Container(
                width: scale(336, context),
                child: Image.asset(
                  context.isDarkMode
                      ? 'public/assets/images/tickets/ticket-appbar-dark.png'
                      : 'public/assets/images/tickets/ticket-appbar-light.png',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          AbDivider(width: 198, alignment: Alignment.centerRight),
        ],
      ),
    );
  }
}
