import 'package:flutter/widgets.dart';
import '../utils/util_colors.dart';

class HomeMenuItem {
  final String name, description;
  final icon;
  final route;
  final Color iconColor;

  HomeMenuItem({
    @required this.name,
    this.description = "",
    @required this.icon,
    @required this.route,
    this.iconColor = iconBlue1,
  });
}