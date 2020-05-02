import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/src/models/model_akademik.dart';
import 'package:intl/intl.dart';

class MahasiswaCard extends StatelessWidget {
  final ModelMhsSidang _m;

  MahasiswaCard(this._m);

  @override
  Widget build(BuildContext context) => ListTile(
      title: Text(_m.namaMhs),
      subtitle: Text('Tgl. sidang: ${DateFormat.yMMMMd("id").format(_m.sidangDate)} '),
      trailing: Text(_m.nim),          
    );
}