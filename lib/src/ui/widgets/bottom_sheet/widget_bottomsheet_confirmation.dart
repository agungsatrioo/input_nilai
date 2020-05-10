import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widget_buttons.dart';

Future<bool> showConfirmationBottomSheet(BuildContext context,
    {Widget caption = const Text("Apakah Anda yakin untuk melanjutkan?"),
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
                          child: MyButton.flat(caption: "Ya",
                              onTap: () => Navigator.of(context).pop(true))
                      ),
                      Expanded(
                          child: MyButton.secondary(caption: "Tidak",
                              onTap: () => Navigator.of(context).pop(false))
                      ),
                    ],
                  )
                ],
              ));
        });
