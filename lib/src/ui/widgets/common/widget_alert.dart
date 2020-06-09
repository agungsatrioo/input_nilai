import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../utils/util_color_extension.dart';
import '../../../utils/util_colors.dart';

enum AlertType { info, success, warning, danger }

class AlertWidget extends StatelessWidget {
  final String title, message;
  final Widget trailing;
  final AlertType alertType;

  const AlertWidget({
    @required this.alertType,
    @required this.title,
    @required this.message,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(LineIcons.info);
    Color bgColor = colorBlueStd;

    switch (alertType) {
      case AlertType.info:
        bgColor = colorBlueStd;
        break;
      case AlertType.success:
        bgColor = colorAlertSuccess;
        break;
      case AlertType.danger:
        bgColor = colorAlertDanger;
        break;
      case AlertType.warning:
        bgColor = colorAlertWarning;
        break;
    }

    Color textColor = bgColor.computeLuminance() > .5 ? bgColor.changeShade(-.3) : bgColor.changeShade(.5);

    return Container(
      decoration: new BoxDecoration(color: bgColor),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      margin: EdgeInsets.only(bottom: 10),
      child: ListTileTheme(
        textColor: textColor,
        iconColor: textColor,
        child: ListTile(
          leading: icon,
          title: Text(title),
          subtitle: Text(message),
        ),
      ),
    );
  }
}
