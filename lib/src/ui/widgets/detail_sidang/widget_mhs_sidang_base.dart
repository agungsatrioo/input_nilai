import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../../models/model_akademik.dart';
import '../../widgets/cards/widget_card_sidang.dart';
import '../../widgets/detail_sidang/widget_mhs_containers.dart';
import '../../widgets/detail_sidang/widget_nilai_sidang.dart';
import '../common/widget_alert.dart';
import '../widget_basic.dart';
import 'widget_dosen_detail.dart';

class DetailSidangMahasiswaBase extends StatelessWidget {
  final ModelMhsSidang data;

  const DetailSidangMahasiswaBase(this.data);

  @override
  Widget build(BuildContext context) {
    Widget judul = Container();
    List<Widget> isiRevisiButton = [Container()];
    List<Widget> listPenguji = [Container()];
    List<Widget> listPembimbing = [Container()];

    TextStyle warnaNilai = TextStyle();

    Widget isiNilai = Container();
    Widget alertRevisi = Container();

    List<Revisi> allRevisi = List();

    for (DosenSidang r in data.penguji ?? []) {
      allRevisi.addAll(r.revisi);
    }

    for (DosenSidang r in data.pembimbing ?? []) {
      allRevisi.addAll(r.revisi);
    }

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
      isiNilai = makeTextTableStyle(context,
          caption: "Nilai Akhir",
          content: "${data.nilai.nilai} (${data.nilai.mutu})",
          rightTextStyle: TextStyle(
            fontSize: 48,
          ).merge(warnaNilai));

      if (allRevisi.isNotEmpty) {
        alertRevisi = AlertWidget(
            alertType: AlertType.danger,
            title: "Waduh, ada revisi menanti kamu.",
            message:
                "Rincian revisi dapat kamu akses dengan menekan tombol \"Lihat Revisi\" di layar paling bawah.");
      }
    } else {
      isiNilai = AlertWidget(
          alertType: AlertType.warning,
          title: "Eits, belum ada nilai nih buat kamu.",
          message:
              "Tunggu dulu sampai para dosen memberi nilai untuk kamu, ya!");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        alertRevisi,
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
        ...listDosenNilaiDetail(context, data.penguji),
        ...isiRevisiButton
      ],
    );
  }
}
