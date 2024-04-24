import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:afrikaburn/bootstrap/extensions.dart';
import 'package:afrikaburn/config/design.dart';
import 'package:afrikaburn/app/models/news.dart';
import 'package:afrikaburn/app/controllers/news_controller.dart';
import 'package:afrikaburn/resources/themes/extensions/outlined_button.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/appbars/news_app_bar.dart';
import 'package:afrikaburn/resources/widgets/ab_divider_widget.dart';
import 'package:afrikaburn/resources/widgets/news_item_widget.dart';
import 'package:afrikaburn/resources/widgets/news_subscription_action_widget.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key, required this.controller});

  final NewsController controller;
  static String state = "news_list";

  @override
  createState() => _NewsListState();
}

class _NewsListState extends NyState<NewsList> {
  _NewsListState() {
    stateName = NewsList.state;
  }

  /// [NewsController] controller
  NewsController get controller => widget.controller;

  // @override
  // init() async {}

  // @override
  // void dispose() {}

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(NewsList.state, data: "example payload");

    /// There is some new news to load.
    if (data?['action'] == 'refresh_news') controller.getNewPosts();
  }

  /// ListView Header
  Widget header(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NewsAppBar(
          scale(90 - MediaQuery.of(context).padding.top, context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: AbDivider(width: scale(190, context)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: NewsSubscriptionAction(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: header(context),
        ),
        PagedSliverList<int, News>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<News>(
            itemBuilder: (context, item, index) => NewsItem(item, index: index),
            firstPageErrorIndicatorBuilder: (context) => Container(
              height: scale(200, context),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: context.color.surfaceBackground,
                    border:
                        Border.all(color: context.color.fourthAccent, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('news-content.error-loading.title'.tr())
                          .titleLarge(context)
                          .setColor(
                              context, (color) => context.color.surfaceContent),
                      SizedBox(height: 10),
                      Text('news-content.error-loading.message'.tr())
                          .alignCenter()
                          .bodyMedium(context)
                          .setColor(
                              context, (color) => context.color.surfaceContent),
                      SizedBox(height: 14),
                      OutlinedButton(
                        onPressed:
                            controller.pagingController.retryLastFailedRequest,
                        child: Text('news-content.error-loading.retry'.tr()),
                      ).withGradient(
                        strokeWidth: 2,
                        gradient: GradientStyles.outlinedButtonBorder,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
