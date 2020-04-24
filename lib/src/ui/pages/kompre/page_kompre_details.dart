import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/models/model_akademik.dart';
import 'package:input_nilai/src/ui/widgets/cards/widget_card_sidang.dart';
import 'package:input_nilai/src/ui/widgets/detail_sidang/widget_penilaian.dart';
import 'package:input_nilai/src/ui/widgets/widget_boolean_builder.dart';
import 'package:input_nilai/src/ui/widgets/widget_buttons.dart';
import 'package:input_nilai/src/utils/util_akademik.dart';
import 'package:input_nilai/src/utils/util_penilaian.dart';
import 'package:line_icons/line_icons.dart';

class PageKompreDetails extends StatefulWidget {
  ModelMhsSidang mhs;

  PageKompreDetails(this.mhs);

  @override
  State<StatefulWidget> createState() {
    return _PageKompreDetailsState(mhs);
  }
}

class _PageKompreDetailsState extends State<PageKompreDetails> {
  ModelMhsSidang mhs;
  RESTAkademik _rest;
  Future _nilai;

  bool _shouldUpdated = false;

  _PageKompreDetailsState(this.mhs);

  @override
  void initState() {
    super.initState();

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
    Future<bool> _onWillPop() async {
      Navigator.of(context).pop(_shouldUpdated);
      return false;
    }

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
                                  SingleChildBooleanWidget(
                                      boolean: snapshot.data.sudahAdaNilai,
                                      ifTrue: MyButton.flatPrimary(
                                          caption: "Ubah penilaian",
                                          buttonWidth: double.infinity,
                                          onTap: () {
                                            tap(
                                                context: context,
                                                message: "Anda akan mengubah penilaian ${mhs
                                                    .namaMhs} (NIM: ${mhs
                                                    .nim})",
                                                onAction: (nilai) =>
                                                    putNilai(myCtx, nilai)
                                            );
                                          }
                                      ),
                                      ifFalse: MyButton.primary(
                                        caption: "Beri penilaian",
                                        buttonWidth: double.infinity,
                                        onTap: () {
                                          tap(
                                              context: context,
                                              message: "Anda akan memberi penilaian kepada ${mhs
                                                  .namaMhs} (NIM: ${mhs.nim})",
                                              onAction: (nilai) =>
                                                  setNilai(myCtx, nilai)
                                          );
                                        },
                                      )
                                  ),
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
