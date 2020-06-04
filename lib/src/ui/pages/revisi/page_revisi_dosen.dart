import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/model_akademik.dart';
import '../../../utils/util_akademik.dart';
import '../../widgets/revisi/widget_revisi_dosen_item.dart';
import '../../widgets/widget_default_view.dart';
import '../../widgets/widget_loading.dart';
import 'page_revisi_detail.dart';
import 'page_revisi_form.dart';

class PageRevisiDosen extends StatefulWidget {
  DosenSidang dosenSidang;
  ModelMhsSidang mhs;
  RESTAkademik rest;
  String table;

  PageRevisiDosen(
      {@required this.table,
      @required this.mhs,
      @required this.dosenSidang,
      @required this.rest});

  @override
  State<StatefulWidget> createState() => _PageRevisiDosenState();
}

class _PageRevisiDosenState extends State<PageRevisiDosen> {
  DosenSidang dosenSidang;
  RESTAkademik _rest;
  Future<List<Revisi>> _revisi;

  bool _shouldUpdated = false;

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_shouldUpdated);
    return false;
  }

  @override
  initState() {
    super.initState();
    dosenSidang = widget.dosenSidang;
    _rest = widget.rest;

    _revisi =
        _rest.getNilai(widget.table, widget.mhs.nim).then((val) => val.revisi);
  }

  _refresh() {
    setState(() {
      _revisi = _rest
          .getNilai(widget.table, widget.mhs.nim)
          .then((val) => val.revisi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Halaman Revisi'),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(LineIcons.arrow_left),
              onPressed: () => Navigator.of(context).pop(_shouldUpdated),
            ),
            actions: <Widget>[
              FutureBuilder<List<Revisi>>(
                  future: _revisi,
                  builder: (BuildContext futureContext,
                      AsyncSnapshot<List<Revisi>> snapshot) {
                    return Visibility(
                      visible:
                          snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData
                              || snapshot.hasError ,
                      child: IconButton(
                        icon: Icon(LineIcons.refresh),
                        onPressed: () {
                          _refresh();
                        },
                      ),
                    );
                  }),
              FutureBuilder<List<Revisi>>(
                  future: _revisi,
                  builder: (BuildContext futureContext,
                      AsyncSnapshot<List<Revisi>> snapshot) {
                    return Visibility(
                        visible:
                            snapshot.connectionState == ConnectionState.done &&
                                !snapshot.hasError &&
                                snapshot.hasData,
                        child: IconButton(
                          icon: Icon(LineIcons.plus),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PageRevisiForm(
                                      mhs: widget.mhs,
                                          table: widget.table,
                                          dosen: dosenSidang,
                                          rest: _rest,
                                        ))).then((val) {
                              if (val) _refresh();
                            });
                          },
                        ));
                  }),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              _refresh();
              return Future.value(true);
            },
            child: FutureBuilder<List<Revisi>>(
              future: _revisi,
              builder: (BuildContext futureContext,
                  AsyncSnapshot<List<Revisi>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return LoadingWidget();
                  default:
                    if (snapshot.hasError) {
                       debugPrint(
                        "PAGE DETAIL REVISI DOSEN ERROR!\n==========\n${snapshot.error.toString()}\n=========");

                      return DefaultViewWidget(
                        title: "Gagal memuat informasi revisi.",
                        message:
                            "Coba refresh untuk memuat kembali. Pastikan kondisi jaringan Anda dalam keadaan baik.",
                      );
                    } else if (snapshot.data.isEmpty) {
                      return DefaultViewWidget(
                          title: "Tidak ada data yang tersedia.");
                    } else {
                      return ListView(
                        children: snapshot.data.map((item) {
                          return Material(
                            color: ThemeProvider.themeOf(context)
                                .data
                                .scaffoldBackgroundColor,
                            child: InkWell(
                                child: RevisiDosenItem(item),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RevisiDetailPage(
                                                table: widget.table,
                                                mahasiswa: widget.mhs,
                                                dosen: dosenSidang,
                                                rest: _rest,
                                                revisi: item,
                                              ))).then((val) {
                                    if (val) _refresh();
                                  });
                                }),
                          );
                        }).toList(),
                      );
                    }
                }
              },
            ),
          )),
    );
  }
}
