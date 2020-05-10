import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../models/model_akademik.dart';
import 'widget_boolean_builder.dart';
import 'widget_default_view.dart';

Function(ModelMhsSidang) 
belumSidang   = (item) => !item.nilai.sudahAdaNilai,
revisiSidang  = (item) => item.nilai.sudahAdaNilai && item.nilai.revisi.isNotEmpty,
tuntasSidang  = (item) => item.nilai.sudahAdaNilai && item.nilai.revisi.isEmpty;

List<ModelMhsSidang> _processQuery(List<ModelMhsSidang> data, String query) {
  if (query.isNotEmpty) {
    return data
        .where((item) => item.namaMhs.toString().toLowerCase().contains(query))
        .toList();
  } else
    return data;
}

getStats(List<ModelMhsSidang> data,
    {@required String query,
      @required Function(int) jmlBelumSidang,
      @required Function(int) jmlTuntasSidang,
      @required Function(int) jmlRevisiSidang,
    }) {
  List<ModelMhsSidang> _altered = _processQuery(data, query);

  jmlBelumSidang(_altered.where(belumSidang).length);
  jmlRevisiSidang(_altered.where(revisiSidang).length);
  jmlTuntasSidang(_altered.where(tuntasSidang).length);
}

Widget makeSidangListView(BuildContext context, List<ModelMhsSidang> data,
    {@required String query,
    @required bool isHistory,
      @required bool isRevisi,
    @required Function onRefresh,
      @required Function(ModelMhsSidang) onTap,
    }) {
  List<ModelMhsSidang> _altered = _processQuery(data, query);

  if (isRevisi) {
    _altered = _altered.where(revisiSidang).toList();
  } else if (isHistory) {
    _altered = _altered.where(tuntasSidang).toList();
  } else {
    _altered = _altered.where(belumSidang).toList();
  }

  return SingleChildBooleanWidget(
    boolean: _altered.isNotEmpty, 
    ifTrue: ListView(children: buildChildFromLists(context, _altered, onTap)), 
    ifFalse: DefaultViewWidget(title: "Tidak ada data.")
  );
}

List<Widget> buildChildFromLists(
    BuildContext context, List<ModelMhsSidang> data, Function onTap) {
  List<Widget> _myList = [];

  Map<String, List<ModelMhsSidang>> newMap =
      groupBy(data, (obj) => DateFormat.yMMMM("id").format(obj.sidangDate));

  newMap.forEach((k, value) {
    List<String> dates = [];

    for (ModelMhsSidang item in value) {
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

      _myList.add(ListTile(
        title: Text(item.namaMhs),
        subtitle: Text('Tgl. sidang: ${DateFormat.yMMMMd("id").format(item.sidangDate)} '),
        trailing: Text(item.nim),   
        onTap: () => onTap(item),       
      ));
    }
  });

  return _myList;
}
