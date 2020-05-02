import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/models/model_akademik.dart';
import 'package:input_nilai/src/ui/widgets/timeline/widget_timeline.dart';
import 'package:intl/intl.dart';

class RevisiDosenItem extends StatelessWidget {
  Revisi _revisi;

  RevisiDosenItem(this._revisi);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:Text(_revisi.detailRevisi,overflow: TextOverflow.ellipsis),
      subtitle: Text("Ditambahkan pada ${DateFormat("dd MMMM yyyy hh:mm:ss").format(_revisi.tglRevisiInput)}"),
      trailing: drawIndicator(_revisi.statusRevisi),
    );
  }
}
