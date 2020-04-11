import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/ui/widgets/revisi/widget_revisi_mhs.dart';
import 'package:input_nilai/app/ui/widgets/widget_basic.dart';

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
        body: _listRevisi.isNotEmpty
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      WidgetRevisiMahasiswa(_listRevisi),
                    ],
                  ),
                ),
              )
            : center_text("Hore, kamu belum dapat revisi apapun dari dosen!"));
  }
}
