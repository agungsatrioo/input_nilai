import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';

Widget drawIndicator(bool status) {
  return Container(
    decoration: new BoxDecoration(
      color: status ? Colors.green : Colors.grey,
      shape: BoxShape.circle,
    ),
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: status
          ? Icon(LineIcons.check, size: 16.0, color: Colors.white)
          : Icon(LineIcons.ellipsis_h, size: 16.0, color: Colors.white),
    ),
  );
}
