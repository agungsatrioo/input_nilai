import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/ui/widgets/common/widget_alert.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../../models/model_akademik.dart';
import '../../widgets/cards/widget_card_sidang.dart';
import '../../widgets/detail_sidang/widget_mhs_containers.dart';
import '../../widgets/detail_sidang/widget_nilai_sidang.dart';
import '../widget_basic.dart';
import 'widget_dosen_detail.dart';

class DetailSidangMahasiswaBase extends StatelessWidget {
  ModelMhsSidang data;

  DetailSidangMahasiswaBase(this.data);

  @override
  Widget build(BuildContext context) {
    Widget judul = Container();
    List<Widget> isiRevisiButton = [Container()];
    List<Widget> listPenguji = [Container()];
    List<Widget> listPembimbing = [Container()];
    TextStyle warnaNilai = TextStyle();
    Widget isiNilai = Container();

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

    if (data.pembimbing != null) {
      listPembimbing = [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: captionWithIcon(
              caption: "Detail Dosen Pembimbing", icon: LineIcons.user),
        ),
        SidangDosenDetailsWidget(listDosen: data.pembimbing),
        Divider(),
      ];
    }

    if (data.penguji != null) {
      listPenguji = [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: captionWithIcon(
              caption: "Detail Dosen Penguji", icon: LineIcons.user),
        ),
        SidangDosenDetailsWidget(listDosen: data.penguji),
        Divider(),
      ];
    }

    if (data.nilai.sudahAdaNilai) {
      isiNilai = AlertWidget(
        alertType: AlertType.info, 
        title: "Belum ada nilai", 
        message: "Tunggu dulu sampai para dosen memberi nilai untuk kamu, ya!");
    } else {
      isiNilai = makeTextTableStyle(context,
          caption: "Nilai Akhir",
          content: "${data.nilai.nilai} (${data.nilai.mutu})",
          rightTextStyle: TextStyle(
            fontSize: 48,
          ).merge(warnaNilai));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        isiNilai,
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
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(data.namaMhs[0]),
          ),
          title: Text(data.namaMhs),
          subtitle: Text(data.nim),
        ),
        Divider(),
        ...listPembimbing,
        ...listPenguji,
        Divider(),
        ...listDosenNilaiDetail(context, data.penguji),
        ...isiRevisiButton
      ],
    );
  }
}
