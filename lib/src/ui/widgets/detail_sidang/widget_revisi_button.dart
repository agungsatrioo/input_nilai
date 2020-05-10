import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/model_akademik.dart';
import '../../../utils/util_akademik.dart';
import '../../pages/revisi/page_revisi_dosen.dart';
import '../widget_buttons.dart';

class ButtonRevisi extends StatelessWidget {
  ModelMhsSidang mahasiswa;
  DosenSidang dosen;
  RESTAkademik rest;
  Function(bool) onPageValue;

  ButtonRevisi(
      {@required this.rest,
      @required this.mahasiswa,
      @required this.dosen,
      @required this.onPageValue});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: this.dosen.sudahAdaNilai,
      child: MyButton.flatError(
          caption: "Beri revisi",
          buttonWidth: double.infinity,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ThemeConsumer(
                        child: PageRevisiDosen(
                          rest: rest,
                          dosenSidang: dosen,
                        )))).then((val) => onPageValue(val));
          }),
    );
  }
}
