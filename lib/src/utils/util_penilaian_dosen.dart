import 'package:flutter/material.dart';

import '../models/model_akademik.dart';
import 'util_akademik.dart';

setNilaiDosen({
  @required BuildContext scaffoldContext, 
  @required RESTAkademik restAkademik,
  @required ModelMhsSidang mahasiswaSidang,
  @required int nilai, 
  @required Function onRefresh, 
  @required Function onSuccess
}) {
  restAkademik.setNilai(mahasiswaSidang.idStatus, nilai).then((String value) async {
    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text('Sukses menambahkan nilai.'),
      backgroundColor: Colors.green,
    ));

    onSuccess();
  }).catchError((e) async {
    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  });
}

editNilaiDosen({
  @required BuildContext scaffoldContext, 
  @required RESTAkademik restAkademik,
  @required ModelMhsSidang mahasiswaSidang,
  @required int nilai, 
  @required Function onRefresh, 
  @required Function onSuccess
}) {
  restAkademik.putNilai(mahasiswaSidang.idStatus, nilai).then((String value) async {
    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text('Sukses menambahkan nilai.'),
      backgroundColor: Colors.green,
    ));

    onSuccess();
  }).catchError((e) async {
    onRefresh();

    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  });
}