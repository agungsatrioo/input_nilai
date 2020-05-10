import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/model_akademik.dart';
import '../../../utils/util_common.dart';
import '../widget_basic.dart';

class WidgetPenilaianDosen extends StatelessWidget {
  DosenSidang snapshot;
  Map<String, String> rows;

  WidgetPenilaianDosen({
    @required this.snapshot,
  }) {
    rows = {"Nilai": snapshot.nilai, "Mutu": snapshot.mutu};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ...rows.entries.map((f) {
          return Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                caption_text(context, f.key),
                Text(
                  f.value,
                  style: Theme.of(context).textTheme.title.apply(
                      color: snapshot.sudahAdaNilai
                          ? snapshot.colorObj
                          : ThemeProvider.themeOf(context)
                              .data
                              .textTheme
                              .title
                              .color),
                ),
              ],
            ),
          );
        }).toList(),
        Divider(),
        caption_text(context, "Menilai sebagai"),
        Text(
          snapshot.namaStatus,
          style: Theme.of(context).textTheme.title,
        ),
      ],
    );
  }
}

showNilaiInputDialog({@required BuildContext context}) {
  TextEditingController nilaiController = TextEditingController();
  final myNilaiKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (context) {
      String value = "";
      nilaiController.clear();

      return SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: Form(
                  key: myNilaiKey,
                  child: new TextFormField(
                    autofocus: true,
                    controller: nilaiController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Masukan jangan dikosongkan.";
                      } else if (!isNumeric(val))
                        return "Masukan hanya berupa angka.";
                      else {
                        double numValue = double.tryParse(val);

                        if (numValue >= 1 && numValue <= 100) {
                          return null;
                        } else {
                          return "Angka yang diperbolehkan hanya dari 1-100.";
                        }
                      }
                    },
                    onChanged: (val) => value = val,
                    decoration: new InputDecoration(
                        labelText: 'Masukkan nilai',
                        hintText: 'Masukkan dari 1-100'),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('BATALKAN'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  if (myNilaiKey.currentState.validate())
                    Navigator.pop(context, value);
                })
          ],
        ),
      );
    },
  ).then((val) {
    return val;
  });
}
