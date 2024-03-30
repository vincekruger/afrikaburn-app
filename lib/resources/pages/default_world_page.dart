import 'package:afrikaburn/resources/pages/home_page.dart';
import 'package:afrikaburn/resources/pages/news_page.dart';
import 'package:afrikaburn/resources/pages/ticket_page.dart';
import 'package:afrikaburn/resources/themes/styles/gradient_styles.dart';
import 'package:afrikaburn/resources/widgets/default_world_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DefaultWorldPage extends NyStatefulWidget {
  static const path = '/default-world';
  DefaultWorldPage() : super(path, child: _DefaultWorldPageState());
}

class _DefaultWorldPageState extends NyState<DefaultWorldPage> {
  int _currentIndex = 0;

  @override
  stateUpdated(dynamic data) async {
    setState(() {
      _currentIndex = data;
    });
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          NewsPage(),
          TicketPage(),
          HomePage(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          gradient: GradientStyles.canvasLine,
        ),
        child: DefaultWorldNavigationBar(),
      ),
    );
  }
}
