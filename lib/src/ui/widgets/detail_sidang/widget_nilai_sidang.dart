import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/ui/widgets/widget_basic.dart';
import 'package:input_nilai/src/utils/util_common.dart';

import '../../../models/model_akademik.dart';

List<TableRow> detailDosenSidang(
        BuildContext context, List<DosenSidang> list) =>
    list.map((item) {
      makeTextTableStyle(context,
          caption: item.namaStatus, content: item.namaDosen);
    }).toList();

List<Widget> listDosenDetail(BuildContext context, List<DosenSidang> list) =>
    list
        .map((item) => makeTextTableStyle(context,
            caption: item.namaStatus, content: item.namaDosen))
        .toList();

List<Widget> listDosenNilaiDetail(
        BuildContext context, List<DosenSidang> list) =>
    list
        .map((item) => makeTextTableStyle(
              context,
              caption: "Nilai ${item.namaStatus}",
              content: item.sudahAdaNilai
                  ? "${item.nilai} (${item.mutu})"
                  : item.nilai,
            ))
        .toList();

List<Widget> detailNilaiDosenSidang(
    BuildContext context, List<DosenSidang> list) {
  return list.map((item) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Nilai ${item.namaStatus}",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(item.sudahAdaNilai ? "${item.nilai} (${item.mutu})" : item.nilai,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: hexToColor(item.color))),
        ],
      ),
    );
  }).toList();
}
