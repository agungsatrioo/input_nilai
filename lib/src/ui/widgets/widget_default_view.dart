import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DefaultViewWidget extends StatelessWidget {
  final String title, message;

  DefaultViewWidget({
    @required this.title,
    this.message = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: ListTile(
            title: Center(child: Text(title)),
            subtitle: Center(child: Text(message))
          )
        ),
      );
  }
}