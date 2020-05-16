import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class WidgetUserBoxBase extends StatelessWidget {
  String nama;
  final int _leftSide = 3, _rightSide = 7;
  Widget reloadButton;
  Map<String, String> details;

  WidgetUserBoxBase(
      {@required this.nama,
      @required this.details,
      @required this.reloadButton});

  @override
  Widget build(BuildContext context) => Container(
      decoration: new BoxDecoration(
          color: ThemeProvider.themeOf(context).data.secondaryHeaderColor,
          borderRadius: new BorderRadius.all(new Radius.circular(3.0))),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(12.0),
            decoration: new BoxDecoration(
                color: ThemeProvider.themeOf(context).data.primaryColor),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  nama,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                reloadButton
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Column(
                children: details.entries
                    .where((item) => item.value.isNotEmpty)
                    .map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: _leftSide,
                        child: Text(item.key,
                            style: ThemeProvider.themeOf(context)
                                .data
                                .accentTextTheme
                                .title)),
                    Expanded(
                      flex: _rightSide,
                      child: Text(
                        item.value,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            }).toList()),
          )
        ],
      ));
}
