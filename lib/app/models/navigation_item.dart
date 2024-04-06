import 'package:flutter/widgets.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// NavigationItem Model.
class NavigationItem extends Model {
  final IconData icon;
  final String label;
  final String? labelDetail;
  final String? routeName;
  final Function? onTap;

  NavigationItem(
    this.icon,
    this.label, {
    this.labelDetail,
    this.routeName,
    this.onTap,
  }) : assert(routeName == null || onTap == null,
            "Don't set routeName and onTap, choose one or the other");
}
