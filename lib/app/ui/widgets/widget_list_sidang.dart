import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/ui/widgets/widget_basic.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'cards/card_mhs.dart';

Widget makeSidangListView(BuildContext context, List<ModelMhsSidang> data,
    {@required String query,
    @required bool isHistory,
    @required Function onRefresh,
    @required Function(ModelMhsSidang) onTap}) {
  List<ModelMhsSidang> _altered = List();

  if (query.isNotEmpty) {
    _altered = data
        .where((item) => item.namaMhs.toString().toLowerCase().contains(query))
        .toList();
  } else
    _altered = data;

  if (isHistory)
    _altered = _altered.where((item) => item.nilai.sudahAdaNilai).toList();
  else
    _altered = _altered.where((item) => !item.nilai.sudahAdaNilai).toList();

  return (_altered.length < 1)
      ? center_text("Tidak ada data.")
      : ListView(children: buildChildFromLists(context, _altered, onTap));
}

List<Widget> buildChildFromLists(
    BuildContext context, List<ModelMhsSidang> data, Function onTap) {
  List<Widget> _myList = List();

  Map<String, List<ModelMhsSidang>> newMap =
      groupBy(data, (obj) => DateFormat.yMMMM("id").format(obj.sidangDate));

  newMap.forEach((k, v) {
    List<String> dates = List();

    v.forEach((f) {
      if (!dates.contains(k)) {
        dates.add(k);

        _myList.add(Container(
          color: ThemeProvider.themeOf(context).data.colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(k,
                  style: Theme.of(context).textTheme.subtitle.merge(TextStyle(
                      color: ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .onSurface))),
            ],
          ),
          padding: EdgeInsets.all(10.0),
        ));
      }

      _myList.add(Material(
        child: InkWell(
          onTap: () => onTap(f),
          child: MahasiswaCard(f),
        ),
      ));
    });
  });

  return _myList;
}
