import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../../models/model_akademik.dart';
import '../../widgets/cards/widget_card_sidang.dart';
import '../../widgets/detail_sidang/widget_mhs_containers.dart';
import '../../widgets/detail_sidang/widget_nilai_sidang.dart';
import '../widget_basic.dart';

class DetailSidangMahasiswaBase extends StatelessWidget {
  ModelMhsSidang data;

  DetailSidangMahasiswaBase(this.data);

  @override
  Widget build(BuildContext context) {
    Widget judul = Container();
    List<Widget> isiRevisiButton = [Container()];
    TextStyle warnaNilai = TextStyle();

    if (data.judulProposal != null) {
      judul = makeTextTableStyle(context,
          caption: "Judul Proposal", content: data.judulProposal);
    } else if (data.judulMunaqosah != null) {
      judul = makeTextTableStyle(context,
          caption: "Judul Munaqosah", content: data.judulMunaqosah);
    }

    if (data.judulProposal != null || data.judulMunaqosah != null) {
      isiRevisiButton = [Divider(), tombolRevisi(context, data)];
    }

    if (data.nilai.sudahAdaNilai) {
      warnaNilai = TextStyle(color: data.nilai.colorObj);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        makeTextTableStyle(context,
            caption: "Nilai Akhir",
            content: data.nilai.sudahAdaNilai
                ? "${data.nilai.nilai} (${data.nilai.mutu})"
                : "N/A",
            rightTextStyle: TextStyle(
              fontSize: 48,
            ).merge(warnaNilai)),
        judul,
        Divider(),
        makeTextTableStyle(context,
            caption: "Tanggal Sidang",
            content: DateFormat.yMMMMEEEEd("id").format(data.sidangDate)),
        Divider(),
        JadwalSidangMahasiwaContainer(data),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: captionWithIcon(
              caption: "Detail Mahasiswa", icon: LineIcons.user),
        ),
        makeTextTableStyle(context, caption: "NIM", content: data.nim),
        makeTextTableStyle(context, caption: "Nama", content: data.namaMhs),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: captionWithIcon(
              caption: "Detail Dosen Penguji", icon: LineIcons.user),
        ),
        ...listDosenDetail(context, data.penguji),
        Divider(),
        ...listDosenNilaiDetail(context, data.penguji),
        ...isiRevisiButton
      ],
    );
  }
}
