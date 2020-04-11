import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/utils/util_colors.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

class RevisiDosenItem extends StatelessWidget {
  Revisi _revisi;

  RevisiDosenItem(this._revisi);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _revisi.detailRevisi,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeProvider.themeOf(context).data.textTheme.headline,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Ditambahkan pada ${DateFormat("dd MMMM yyyy hh:mm:ss").format(_revisi.tglRevisiInput)}",
                  style: ThemeProvider.themeOf(context).data.textTheme.title,
                )
              ],
            ),
          ),
          Container(
              decoration: new BoxDecoration(
                color: _revisi.statusRevisi ? colorGreenStd : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: _revisi.statusRevisi
                    ? Icon(LineIcons.check, size: 16.0, color: Colors.white)
                    : Icon(LineIcons.ellipsis_h,
                        size: 16.0, color: Colors.white),
              ))
        ],
      ),
    );
  }
}
