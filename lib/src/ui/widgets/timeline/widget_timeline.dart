import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/ui/widgets/widget_boolean_builder.dart';
import 'package:input_nilai/src/ui/widgets/widget_indicator.dart';
import 'package:line_icons/line_icons.dart';

Widget drawIndicator(bool status) => IndicatorDrawer(
    color: status ? Colors.green : Colors.grey, 
    child: SingleChildBooleanWidget(
      boolean: status, 
      ifTrue: Icon(LineIcons.check, size: 16.0, color: Colors.white), 
      ifFalse: Icon(LineIcons.ellipsis_h, size: 16.0, color: Colors.white)
    )
  );