import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

CupertinoAlertDialog msgc_ack(String title, String body) {
  return CupertinoAlertDialog(
    title: new Text(title),
    content: new Text(body),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        child: Text("OK"),
      ),
    ],
  );
}

Future showMyDialog(
        {@required BuildContext context,
        @required String title,
        @required String body,
        @required List<Widget> actions}) =>
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title), content: Text(body), actions: actions);
        });

showAlertDialog(
    BuildContext context, String title, String content, List<Widget> actions) {
  // set up the button
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text(title),
    content: Text(content),
    actions: actions,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
