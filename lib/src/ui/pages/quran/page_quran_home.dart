import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/models/model_surat_quran.dart';
import 'package:input_nilai/src/ui/pages/quran/page_quran_surat.dart';
import 'package:input_nilai/src/ui/widgets/quran/widget_surah_item.dart';
import 'package:input_nilai/src/ui/widgets/widget_basic.dart';
import 'package:input_nilai/src/utils/util_quran.dart';
import 'package:theme_provider/theme_provider.dart';

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
                  return loading();
                default:
                  if (snapshot.hasError) {
                    return centerText("Gagal memuat Al-Quran.");
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
                                    builder: (context) => ThemeConsumer(
                                        child: QuranSuratDetails(surat)))),
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