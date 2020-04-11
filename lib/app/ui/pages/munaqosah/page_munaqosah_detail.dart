import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/ui/pages/revisi/page_revisi_dosen.dart';
import 'package:input_nilai/app/ui/widgets/cards/widget_card_sidang.dart';
import 'package:input_nilai/app/ui/widgets/detail_sidang/widget_penilaian.dart';
import 'package:input_nilai/app/ui/widgets/widget_basic.dart';
import 'package:input_nilai/app/utils/util_akademik.dart';
import 'package:input_nilai/app/utils/util_penilaian.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

class PageMunaqosahDetails extends StatefulWidget {
  ModelMhsSidang mhs;

  PageMunaqosahDetails(this.mhs);

  @override
  State<StatefulWidget> createState() {
    return _PageMunaqosahDetailsState(mhs);
  }
}

class _PageMunaqosahDetailsState extends State<PageMunaqosahDetails> {
  ModelMhsSidang mhs;
  TextEditingController _nilaiController;
  RESTAkademik _rest;
  Future _nilai;
  final _myNilaiKey = GlobalKey<FormState>();

  bool _shouldUpdated = false;

  _PageMunaqosahDetailsState(this.mhs);

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_shouldUpdated);
    return false;
  }

  @override
  void initState() {
    super.initState();

    _nilaiController = TextEditingController();
    _rest = RESTAkademik();
    _nilai = _rest.getNilai(mhs.idStatus);
  }

  _refresh() {
    setState(() {
      _nilai = _rest.getNilai(mhs.idStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Detail Mahasiswa"),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(LineIcons.arrow_left),
              onPressed: () => Navigator.of(context).pop(_shouldUpdated),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(LineIcons.refresh),
                onPressed: () => _refresh(),
              )
            ],
          ),
          body: Builder(
            builder: (myCtx) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...widgetDosenSidangDetails(context, mhs),
                    Divider(
                      color: Colors.grey,
                    ),
                    FutureBuilder<DosenSidang>(
                      future: _nilai,
                      builder: (BuildContext context,
                          AsyncSnapshot<DosenSidang> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                    height: 16.0,
                                    width: 16.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text("Memuat nilai...",
                                        style:
                                            Theme.of(context).textTheme.title),
                                  )
                                ],
                              ),
                            );
                          default:
                            if (snapshot.hasError)
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Gagal memuat nilai.",
                                    style: Theme.of(context).textTheme.title),
                              );
                            else {
                              return Column(
                                children: <Widget>[
                                  WidgetPenilaianDosen(
                                    snapshot: snapshot.data,
                                  ),
                                  SizedBox(height: 20),
                                  makeButton(
                                      context,
                                      snapshot.data.sudahAdaNilai
                                          ? "Beri penilaian"
                                          : "Sunting penilaian",
                                      buttonWidth: double.infinity, onTap: () {
                                    if (snapshot.data.sudahAdaNilai) {
                                      tap(
                                        context: context,
                                        message:
                                            "Anda akan menyunting penilaian.",
                                        onAction: (nilai) =>
                                            putNilai(myCtx, nilai),
                                      );
                                    } else {
                                      tap(
                                        context: context,
                                        message:
                                            "Anda akan menyunting penilaian.",
                                        onAction: (nilai) =>
                                            setNilai(myCtx, nilai),
                                      );
                                    }
                                  }),
                                  makeButton(myCtx, "Beri Revisi", onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ThemeConsumer(
                                                    child: PageRevisiDosen(
                                                  rest: _rest,
                                                  dosenSidang: snapshot.data,
                                                )))).then((val) {
                                      if (val) _refresh();
                                    });
                                  },
                                      buttonWidth: double.infinity,
                                      buttonColor:
                                          ThemeProvider.themeOf(context)
                                              .data
                                              .colorScheme
                                              .error)
                                ],
                              );
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  setNilai(BuildContext ctx, int nilai) {
    _rest.setNilai(mhs.idStatus, nilai).then((String value) async {
      await _refresh();

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Sukses menambahkan nilai.'),
        backgroundColor: Colors.green,
      ));

      setState(() {
        _shouldUpdated = true;
      });
    }).catchError((e) async {
      await _refresh();

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  putNilai(BuildContext ctx, int nilai) {
    _rest.putNilai(mhs.idStatus, nilai).then((String value) async {
      await _refresh();

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Sukses menyunting nilai.'),
        backgroundColor: Colors.green,
      ));

      setState(() {
        _shouldUpdated = true;
      });
    }).catchError((e) async {
      await _refresh();

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Gagal menyunting nilai. Silakan coba kembali.'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
