import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/model_surat_quran.dart';

class SurahItem extends StatelessWidget {
  final IndexQuran surah;

  SurahItem({
    @required this.surah
  }) {
    assert(surah != null);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${surah.nomor}. ${surah.nama}"),
      subtitle: Text(surah.arti),
      trailing: Text(surah.asma,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(
              fontFamily: 'Amiri',
              fontSize: 28,
              height: 2.0,))),
    );
  }
}