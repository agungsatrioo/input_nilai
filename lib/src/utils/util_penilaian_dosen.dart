import 'package:flutter/material.dart';

import '../models/model_akademik.dart';
import 'util_akademik.dart';

setNilaiDosen({
  @required String table,
  @required BuildContext scaffoldContext, 
  @required RESTAkademik restAkademik,
  @required ModelMhsSidang mahasiswaSidang,
  @required int nilai, 
  @required Function onRefresh, 
  @required Function onSuccess
}) {
  restAkademik.setNilai(table, mahasiswaSidang.nim, nilai).then((String value) async {
    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text('Sukses menambahkan nilai.'),
      backgroundColor: Colors.green,
    ));

    onSuccess();
  }).catchError((e) async {
    debugPrint("POST NILAI ERROR!\n==========\n${e.toString()}\n=========");

    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  });
}

editNilaiDosen({
  @required String table,
  @required BuildContext scaffoldContext, 
  @required RESTAkademik restAkademik,
  @required ModelMhsSidang mahasiswaSidang,
  @required int nilai, 
  @required Function onRefresh, 
  @required Function onSuccess
}) {
  restAkademik.putNilai(table, mahasiswaSidang.nim, nilai).then((String value) async {
    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text('Sukses menambahkan nilai.'),
      backgroundColor: Colors.green,
    ));

    onSuccess();
  }).catchError((e) async {
    debugPrint("PUT NILAI ERROR!\n==========\n${e.toString()}\n=========");

    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  });
}