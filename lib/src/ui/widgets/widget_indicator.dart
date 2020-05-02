import 'package:flutter/widgets.dart';

class IndicatorDrawer extends StatelessWidget {
  Color color;
  Widget child;
  final double padding;

  IndicatorDrawer({
    @required this.color,
    @required this.child,
    this.padding = 3.0
  }) {
    assert(color != null);
    assert(child != null);
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: new BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: child
    ),
  );
}