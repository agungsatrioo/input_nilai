import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../models/model_akademik.dart';
import '../timeline/widget_timeline.dart';
import '../timeline/widget_timeline_paint.dart';
import 'package:intl/intl.dart';

class WidgetRevisiMahasiswa extends StatelessWidget {
  List<Revisi> _list = List();

  WidgetRevisiMahasiswa(this._list) {
    _list.sort((a, b) {
      int b1 = a.statusRevisi ? 1 : 0;
      int b2 = b.statusRevisi ? 1 : 0;

      return b2 - b1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<Widget, Widget> myWidget = _list.asMap().map((index, item) {
      return MapEntry(
          drawIndicator(item.statusRevisi),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    DateFormat.yMMMMEEEEd("id").add_Hms().format(
                        item.tglRevisiInput),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Dari",
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${item.namaDosen}",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(
                          "${item.namaStatus}",
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("${item.detailRevisi}",
                    style: Theme.of(context).textTheme.subhead),
                SizedBox(
                  height: 10,
                ),
                _deadlineRevisi(context, item),
                Divider(),
              ],
            ),
          ));
    });

    return Timeline(
        gutterSpacing: 8.0,
        children: myWidget.values.toList(),
        indicators: myWidget.keys.toList());
  }

  Widget _deadlineRevisi(BuildContext context, Revisi item) {
    if (item.statusRevisi) {
      return Container();
    } else {
      return item.tglRevisiDeadline != null
          ? Row(
              children: <Widget>[
                Text("Selesaikan sebelum "),
                Text(
                  DateFormat.yMMMMEEEEd("id").add_Hms().format(
                      item.tglRevisiDeadline),
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            )
          : Text("Tidak ada tenggat waktu.");
    }
  }
}
