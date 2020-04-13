import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/ui/pages/revisi/page_revisi_dosen.dart';
import 'package:input_nilai/app/ui/widgets/widget_buttons.dart';
import 'package:input_nilai/app/utils/util_akademik.dart';
import 'package:theme_provider/theme_provider.dart';

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
