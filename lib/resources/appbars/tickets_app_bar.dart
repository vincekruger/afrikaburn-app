import 'package:flutter/material.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';

class TicketsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TicketsAppBar(this.height, {Key? key}) : super(key: key);

  final double height;

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
              Container(
                width: scale(57, context),
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.arrow_back),
                  color: const Color(0xFF20EDC4),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                width: scale(336, context),
                child: Image.asset(
                  'public/assets/images/tickets/app-bar-24p-2.png',
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
