import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/model_akademik.dart';
import '../../pages/revisi/page_revisi_mhs.dart';
import '../detail_sidang/widget_dosen_containers.dart';
import '../widget_basic.dart';
import '../widget_buttons.dart';

Widget cardMahasiswaSidangHeader(BuildContext context,
    {@required String title,
    ModelMhsSidang mahasiswa,
    List<TableRow> tabelRowDosen}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              Theme.of(context).primaryTextTheme.button.color,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    children: [
                      judulSidang(context, mahasiswa),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Nama Mahasiswa",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                                fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            mahasiswa.namaMhs,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "NIM Mahasiswa",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                                fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            mahasiswa.nim,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .button
                                    .color,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                      ...tabelRowDosen
                    ],
                  )
                ],
              )),
        ),
      ],
    ),
  );
}

TableRow judulSidang(BuildContext context, ModelMhsSidang item) {
  String caption, value;

  if (item.judulProposal != null) {
    caption = "Judul Proposal";
    value = item.judulProposal;
  } else if (item.judulMunaqosah != null) {
    caption = "Judul Munaqosah";
    value = item.judulMunaqosah;
  } else {
    return TableRow(children: [Container(), Container()]);
  }

  return TableRow(children: [
    Text(
      caption,
      style: TextStyle(
        color: Theme.of(context).primaryTextTheme.button.color,
        fontSize: 12,
      ),
    ),
    Text(
      value,
      style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryTextTheme.button.color,
          fontWeight: FontWeight.bold),
    )
  ]);
}

List<Widget> widgetDosenSidangDetails(
    BuildContext context, ModelMhsSidang mhs) {
  return <Widget>[
    textWithCaption(context, "NIM", mhs.nim),
    textWithCaption(context, "Nama", mhs.namaMhs),
    _judulSidangDosenDetails(context, mhs),
    textWithCaption(context, "Tanggal Sidang",
        DateFormat.yMMMMEEEEd("id").format(mhs.sidangDate)),
    Divider(),
    JadwalSidangMahasiwaContainer(mhs)
  ];
}

Widget _judulSidangDosenDetails(BuildContext context, ModelMhsSidang item) {
  String caption, value;

  if (item.judulProposal != null) {
    caption = "Judul Proposal";
    value = item.judulProposal;
  } else if (item.judulMunaqosah != null) {
    caption = "Judul Munaqosah";
    value = item.judulMunaqosah;
  } else {
    return Container();
  }

  return textWithCaption(context, caption, value);
}

Widget tombolRevisi(BuildContext context, ModelMhsSidang item) {
  return MyButton.error(
      caption: "Lihat revisi",
      buttonWidth: double.infinity,
      onTap: () {
        List<Revisi> allRevisi = List();

        item.penguji.forEach((f) {
          allRevisi.addAll(f.revisi);
        });

        if (item.pembimbing != null) {
          item.pembimbing.forEach((f) {
            allRevisi.addAll(f.revisi);
          });
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageRevisiMahasiswa(allRevisi)));
      });
}
