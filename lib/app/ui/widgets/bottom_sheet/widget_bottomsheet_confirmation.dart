import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget_basic.dart';

Future<bool> showConfirmationBottomSheet(BuildContext context,
        {@required Color yesColor,
        Color yesTextColor,
        @required Color noColor,
        Color noTextColor,
        Widget caption = const Text("Apakah Anda yakin untuk melanjutkan?"),
        bool isDismissible = true}) =>
    showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        builder: (BuildContext bc) {
          return Container(
              padding: EdgeInsets.all(10.0),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: caption,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: makeButton(context, "Ya",
                              buttonColor: yesColor,
                              textColor: yesTextColor,
                              onTap: () => Navigator.of(context).pop(true))),
                      Expanded(
                          child: makeButton(context, "Tidak",
                              buttonColor: noColor,
                              textColor: noTextColor,
                              onTap: () => Navigator.of(context).pop(false))),
                    ],
                  )
                ],
              ));
        });
