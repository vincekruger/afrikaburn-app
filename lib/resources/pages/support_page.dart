import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/app/controllers/support_controller.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/resources/appbars/support_app_bar.dart';

class SupportPage extends NyStatefulWidget<SupportController> {
  static const path = '/support';
  static const name = 'Support The App';
  SupportPage({super.key}) : super(path, child: _SupportPageState());
}

class _SupportPageState extends NyState<SupportPage> {
  /// [SupportController] controller
  SupportController get controller => widget.controller;
  final contentPadding = const EdgeInsets.symmetric(horizontal: 40);

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SupportAppBar(scale(116, context) + viewPadding(context).top),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 20),
            headline(context, "Why Did I build this?"),
            content(context,
                "Well, because I wanted to gift something amazing to the community and honestly, how many of you really carry around the guides all the time 🤔"),
            divider(context, Alignment.centerRight),
            headline(
              context,
              "So how can you support this fancy Shmansy passion project?",
              alignCenter: true,
            ),
            headline(
              context,
              "With cold hard moola of course 💸",
              subHeadline: true,
              alignCenter: true,
            ),
            content(
                context,
                "This app really does take up a lot of time, and no, Chat-CPT can't build this. 😂\n" +
                    "This year I stopped counting the hours when I hit 200 😭 Then there are the fees that keep this little busta alive on the interwebs. So all the little extra cash dollars really do help to keep the lights on."),
            divider(context, Alignment.centerLeft),
            content(context,
                "In 2019 the app landed on the Apple Store Top 10 List, so I would call this a good  success. So there is a future.  I’m not sure what it is, but this time it will be running all year round with some cool shit coming and going, and then of course, the digital wtf guide will get better with every burn.  Who knows, next year you might get turn by turn bike directions home 😇"),
            divider(context, Alignment.centerLeft),
            SizedBox(
              height: scale(162, context),
              child: Stack(
                children: [
                  content(
                    context,
                    "So, if you’d like to give the app some love, leave a LEKKER review, share it with your pals and ditch that one of fancy hand roasted cup of java mocha what what and gooi that 50 bucks our way.",
                    width:
                        MediaQuery.of(context).size.width - scale(127, context),
                    padding: contentPadding.copyWith(bottom: 20),
                  ),
                  Positioned(
                    top: -10,
                    right: 10,
                    child: Image.asset(
                      context.isDarkMode
                          ? "public/assets/images/pointing-hand-2-dark.png"
                          : "public/assets/images/pointing-hand-2-light.png",
                      height: scale(197, context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  supporterButton(context, SupporterType.GITHUB),
                  supporterButton(context, SupporterType.SNAPSCAN),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  supporterButton(context, SupporterType.KOFI),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Supporter Button
  Widget supporterButton(BuildContext context, SupporterType type) {
    return OutlinedButton(
      onPressed: () => widget.controller.openSponsorUrl(type),
      child: Image.asset(widget.controller.supportButtonImage(context, type),
          height: 16),
    ).withGradient(
      strokeWidth: 2,
      gradient: GradientStyles.appbarIcon,
    );
  }

  Widget divider(BuildContext context, Alignment alignment) {
    return Container(
      alignment: alignment,
      child: AbDivider(
        width: scale(252, context),
        padding: EdgeInsets.only(
          top: 24,
          bottom: 24,
          left: alignment == Alignment.centerLeft ? 20 : 0,
          right: alignment == Alignment.centerRight ? 20 : 0,
        ),
      ),
    );
  }

  Widget content(BuildContext context, String content,
      {double? width, EdgeInsets? padding}) {
    return Container(
      padding: padding == null ? contentPadding : padding,
      width: width == null ? null : scale(width, context),
      child: Text(
        content,
        softWrap: true,
      )
          .bodyMedium(context)
          .setColor(context, (color) => context.color.primaryContent),
    );
  }

  Widget headline(
    BuildContext context,
    String headline, {
    bool? alignCenter = false,
    bool? alignRight = false,
    bool? subHeadline = false,
  }) {
    Text child = Text(headline)
        .headingMedium(context)
        .setColor(context, (color) => context.color.thirdAccent);

    /// Set text alignment
    if (alignCenter == true) child = child.alignCenter();
    if (alignRight == true) child = child.alignRight();

    /// Set Subheadline
    if (subHeadline == true) {
      child = Text(headline.toUpperCase());
      child.setStyle(context.textTheme().labelLarge);
      child.setColor(context, (color) => context.color.primaryAlternate);
    }

    return Container(
      padding: contentPadding.copyWith(bottom: 10),
      child: child,
    );
  }
}
