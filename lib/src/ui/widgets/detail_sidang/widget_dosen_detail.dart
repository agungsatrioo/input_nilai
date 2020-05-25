import 'package:flutter/material.dart';
import 'package:input_nilai/src/utils/util_colors.dart';

import '../../../models/model_akademik.dart';

class SidangDosenDetailsWidget extends StatelessWidget {
  final List<DosenSidang> listDosen;

  SidangDosenDetailsWidget({@required this.listDosen});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: listDosen
          .map((item) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorBlueLight,
                  child: Text(item.namaDosen[0]),
                ),
                title: Text(item.namaDosen),
                subtitle: Text(item.namaStatus),
              ))
          .toList(),
    );
  }
}
