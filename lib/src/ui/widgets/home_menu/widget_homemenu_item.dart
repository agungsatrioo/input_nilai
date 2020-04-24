import 'package:flutter/material.dart';
import 'package:input_nilai/src/models/menus.dart';

class HomeMenuItem extends StatelessWidget {
  @required
  final HomeMenu item;

  const HomeMenuItem(this.item);

  Widget determineIcon(HomeMenu i) {
    if (i.icon is IconData) {
      return Icon(
        i.icon,
        size: 36,
        color: i.color,
      );
    } else if (i.icon is Image) {
      return i.icon;
    } else {
      print(i.icon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: SizedBox.fromSize(
              size: Size.square(36), child: determineIcon(item)),
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
