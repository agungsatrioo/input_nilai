import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WidgetUnivLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Image.asset(
            "assets/images/icon.png",
            scale: 10,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "FISIP",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "UIN SUNAN GUNUNG DJATI",
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
