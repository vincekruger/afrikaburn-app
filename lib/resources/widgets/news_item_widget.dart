import 'package:afrikaburn/app/models/news.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class NewsItem extends StatefulWidget {
  const NewsItem(this.item, {Key? key, required this.inverted})
      : super(key: key);

  final News item;
  final bool inverted;

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  final double horizontalPadding = 20.0;
  final double verticalPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final boxHeight = 200.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        height: boxHeight,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColor.get(context).primaryContent,
                image: DecorationImage(
                  image: Image.network(widget.item.featuredImageUrl).image,
                  fit: BoxFit.cover,
                ),
                borderRadius: borderRadius,
              ),
            ),
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                color: ThemeColor.get(context).primaryContent,
                borderRadius: borderRadius.copyWith(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    widget.item.imageOverlayColor ??
                        ThemeColor.get(context).primaryContent
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [TitleAction()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Title and Action Row
  ///
  Row TitleAction() {
    /// Create the title
    Widget title = Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: widget.inverted ? horizontalPadding : 0,
          right: widget.inverted ? 0 : horizontalPadding,
        ),
        child: Text(
          widget.item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ).titleLarge(context).setColor(
            context,
            (color) =>
                widget.item.imageOverlayTextColor ??
                ThemeColor.get(context).primaryContent),
      ),
    );

    /// Create the read more button
    Widget readMore = RotatedBox(
      quarterTurns: 3,
      child: OutlineGradientButton(
        child: ElevatedButton(
          onPressed: () {},
          child: Text("news.cta.read-now".tr())
              .bodyMedium(context)
              .fontWeightBold(),
        ),
        backgroundColor: ThemeColor.get(context).surfaceBackground,
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9B1EE9),
            const Color(0xFFFD1D346),
            const Color(0xFF20EDC4),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        strokeWidth: 2,
        padding: EdgeInsets.all(2),
        radius: Radius.circular(3),
      ),
    );

    /// Return the row
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.inverted == false) ...[title, readMore],
        if (widget.inverted == true) ...[readMore, title],
      ],
    );
  }
}
