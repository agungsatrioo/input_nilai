import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';

import '../widget_boolean_builder.dart';
import '../widget_indicator.dart';

Widget drawIndicator(bool status) => IndicatorDrawer(
    color: status ? Colors.green : Colors.grey, 
    child: SingleChildBooleanWidget(
      boolean: status, 
      ifTrue: Icon(LineIcons.check, size: 16.0, color: Colors.white), 
      ifFalse: Icon(LineIcons.ellipsis_h, size: 16.0, color: Colors.white)
    )
  );