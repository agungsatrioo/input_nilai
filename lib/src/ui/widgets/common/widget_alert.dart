import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

enum AlertType { info, success, danger }

class AlertWidget extends StatelessWidget {
  final String title, message;
  final Widget trailing;
  final AlertType alertType;

  AlertWidget({
    @required this.alertType,
    @required this.title,
    @required this.message,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(LineIcons.info);
    return Container(
      decoration: new BoxDecoration(color: Colors.red),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTileTheme(
        child: ListTile(
          leading: icon,
          title: Text(title),
          subtitle: Text(message),
        ),
      ),
    );
  }
}
