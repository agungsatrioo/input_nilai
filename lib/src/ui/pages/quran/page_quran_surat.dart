import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/src/models/model_surat_quran.dart';
import 'package:input_nilai/src/ui/widgets/widget_basic.dart';
import 'package:input_nilai/src/ui/widgets/widget_indicator.dart';
import 'package:input_nilai/src/utils/util_colors.dart';
import 'package:input_nilai/src/utils/util_quran.dart';
import 'package:theme_provider/theme_provider.dart';

class QuranSuratDetails extends StatefulWidget {
  IndexQuran surat;

  QuranSuratDetails(this.surat);

  @override
  State<StatefulWidget> createState() => _QuranSuratDetailsState(surat);
}

class _QuranSuratDetailsState extends State<QuranSuratDetails> {
  IndexQuran surat;
  Future<SuratQuran> _futureSurat;
  String namaSurat;

  _QuranSuratDetailsState(this.surat);

  @override
  void initState() {
    super.initState();
    _futureSurat = UtilQuran.loadSurat(int.tryParse(surat.nomor));
    namaSurat = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("QS. ${surat.nomor} ${surat.nama}"),
          elevation: 0.0,
        ),
        body: Container(
          child: FutureBuilder<SuratQuran>(
            future: _futureSurat,
            builder: (BuildContext myCtx, AsyncSnapshot<SuratQuran> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return loading();
                default:
                  if (snapshot.hasError) {
                    return center_text("Gagal memuat surat yang diminta.");
                  } else {
                    return ListView(
                        children: snapshot.data.text.entries.map((f) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(f.value,
                                    textDirection: TextDirection.rtl,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .merge(TextStyle(
                                            fontFamily: 'Amiri',
                                            height: 3.0,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                    .data
                                                    .colorScheme
                                                    .onSurface))),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(right:8.0),
                                    child: IndicatorDrawer(
                                      color: colorGreenStd, 
                                      padding: 8.0,
                                      child: Text(
                                      "${f.key}",
                                      style: ThemeProvider.themeOf(context)
                                          .data
                                          .textTheme
                                          .headline.merge(TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${snapshot.data.translations.id.text[f.key]}",
                                      style: ThemeProvider.themeOf(context)
                                          .data
                                          .textTheme
                                          .headline,
                                    ),
                                  ),
                                ],
                              )
                            ),
                            Divider()
                          ],
                        ),
                      );
                    }).toList());
                  }
              }
            },
          ),
        ));
  }
}
