import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/model_surat_quran.dart';
import '../../../utils/util_quran.dart';
import '../../widgets/quran/widget_surah_item.dart';
import '../../widgets/widget_default_view.dart';
import '../../widgets/widget_loading.dart';
import 'page_quran_surat.dart';

class QuranHomePage extends StatefulWidget {
  bool juzAmma;

  QuranHomePage({this.juzAmma = false});

  @override
  State<StatefulWidget> createState() =>
      _QuranHomePageState(juzAmma: this.juzAmma);
}

class _QuranHomePageState extends State<QuranHomePage> {
  bool juzAmma;
  Future<List<IndexQuran>> _indexQuran;

  _QuranHomePageState({this.juzAmma});

  @override
  void initState() {
    super.initState();
    _indexQuran = UtilQuran.loadIndexSurat(juzAmma: juzAmma);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(juzAmma ? "Juz Amma" : "Al-Quran"),
          elevation: 0.0,
        ),
        body: Container(
          child: FutureBuilder<List<IndexQuran>>(
            future: _indexQuran,
            builder:
                (BuildContext myCtx, AsyncSnapshot<List<IndexQuran>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return LoadingWidget();
                default:
                  if (snapshot.hasError) {
                    return DefaultViewWidget(
                        title: "Gagal memuat Al-Quran.",
                        message: "Pastikan Anda memperoleh versi asli.",
                      );
                  } else {
                    return ListView(
                      children: snapshot.data.map((surat) {
                        return Material(
                          color: ThemeProvider.themeOf(context)
                              .data
                              .scaffoldBackgroundColor,
                          child: InkWell(
                            child: SurahItem(surah: surat),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuranSuratDetails(surat))),
                          ),
                        );
                      }).toList(),
                    );
                  }
              }
            },
          ),
        ));
  }
}