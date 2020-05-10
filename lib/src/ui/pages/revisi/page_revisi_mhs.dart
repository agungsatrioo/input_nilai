import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/model_akademik.dart';
import '../../widgets/revisi/widget_revisi_mhs.dart';
import '../../widgets/widget_boolean_builder.dart';
import '../../widgets/widget_default_view.dart';

class PageRevisiMahasiswa extends StatefulWidget {
  List<Revisi> _listRevisi = List();

  PageRevisiMahasiswa(this._listRevisi);

  @override
  State<StatefulWidget> createState() => _PageRevisiMahasiswa(this._listRevisi);
}

class _PageRevisiMahasiswa extends State<PageRevisiMahasiswa> {
  List<Revisi> _listRevisi = List();

  _PageRevisiMahasiswa(this._listRevisi);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Halaman Revisi'),
          elevation: 0.0,
        ),
        body: SingleChildBooleanWidget(
          boolean: _listRevisi.isNotEmpty, 
          ifTrue: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      WidgetRevisiMahasiswa(_listRevisi),
                    ],
                  ),
                ),
              ), 
          ifFalse: DefaultViewWidget(
                  title: "Belum ada revisi yang harus dikerjakan.",
                )
        ));
  }
}
