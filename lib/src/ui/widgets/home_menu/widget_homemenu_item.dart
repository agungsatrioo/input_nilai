import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../models/menus.dart';

class HomeMenuItemWidget extends StatelessWidget {
  @required
  final HomeMenuItem item;

  const HomeMenuItemWidget(this.item);

  Widget _determineIcon(HomeMenuItem i) {
    if (i.icon is IconData) {
      return Icon(
        i.icon,
        size: 36,
        color: i.iconColor,
      );
    } else if (i.icon is Image) {
      return i.icon;
    } else {
      print(i.icon);
      return Icon(
        LineIcons.question,
        size: 36,
        color: i.iconColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: SizedBox.fromSize(
              size: Size.square(36), child: _determineIcon(item)),
        ),
        Center(
          child: Text(
            item.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        )
      ],
    );
  }
}
