import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/src/models/model_akademik.dart';
import 'package:input_nilai/src/ui/pages/revisi/page_revisi_form.dart';
import 'package:input_nilai/src/ui/widgets/bottom_sheet/widget_bottomsheet_verify.dart';
import 'package:input_nilai/src/ui/widgets/widget_basic.dart';
import 'package:input_nilai/src/ui/widgets/widget_boolean_builder.dart';
import 'package:input_nilai/src/ui/widgets/widget_buttons.dart';
import 'package:input_nilai/src/utils/util_akademik.dart';
import 'package:input_nilai/src/utils/util_colors.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../dialogs.dart';

class RevisiDetailPage extends StatefulWidget {
  Revisi revisi;
  RESTAkademik rest;

  RevisiDetailPage({@required this.revisi, @required this.rest});

  @override
  State<StatefulWidget> createState() => _RevisiDetailPageState();
}

class _RevisiDetailPageState extends State<RevisiDetailPage> {
  Revisi _revisi;
  RESTAkademik _rest;
  bool _shouldUpdated, isDeleting = false;

  Future<Revisi> _future;

  _RevisiDetailPageState();

  initState() {
    super.initState();

    _revisi = widget.revisi;
    _rest = widget.rest;

    _shouldUpdated = false;
    _future = _rest.getRevisiFromID(int.tryParse(_revisi.idRevisi));
  }

  _refresh() {
    setState(() {
      _future = _rest.getRevisiFromID(int.tryParse(_revisi.idRevisi));
    });
  }

  _toggleDel() {
    setState(() {
      isDeleting = !isDeleting;
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_shouldUpdated);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Detail Revisi'),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(LineIcons.arrow_left),
              onPressed: () => Navigator.of(context).pop(_shouldUpdated),
            ),
            actions: !isDeleting
                ? <Widget>[
                    IconButton(
                      icon: Icon(LineIcons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThemeConsumer(
                                        child: PageRevisiForm(
                                      rest: _rest,
                                      source: _revisi,
                                    )))).then((val) {
                          setState(() {
                            _shouldUpdated = val ?? false;
                          });
                          if (val ?? false) _refresh();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(LineIcons.trash),
                      onPressed: () {
                        showUserVerifyBottomSheet(context,
                                message: Text(
                                    "Anda akan menghapus revisi ini. Masukkan kata sandi untuk melanjutkan."),
                                yesColor: colorGreenStd,
                                noColor: ThemeProvider.themeOf(context)
                                    .data
                                    .colorScheme
                                    .surface,
                                noTextColor: ThemeProvider.themeOf(context)
                                    .data
                                    .colorScheme
                                    .onSurface)
                            .then((val) {
                          setState(() {
                            _shouldUpdated = val ?? false;
                          });

                          if (val ?? false) {
                            deleteRevisi(context, _revisi);
                          }
                        });
                      },
                    )
                  ]
                : <Widget>[
                    IconButton(
                      icon: SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                        height: 24.0,
                        width: 24.0,
                      ),
                      onPressed: () {},
                    )
                  ],
          ),
          body: Builder(builder: (scaffoldContext) {
            return FutureBuilder<Revisi>(
              future: _future,
              builder:
                  (BuildContext futureContext, AsyncSnapshot<Revisi> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return loading();
                  default:
                    if (snapshot.hasError) {
                      return center_text("Gagal memuat detail revisi.");
                    } else {
                      return Column(
                        children: <Widget>[
                          textCaptionWithIcon(
                              context: context,
                              icon: LineIcons.calendar,
                              caption: "Tanggal input revisi",
                              content: DateFormat.yMMMMEEEEd("id")
                                  .format(snapshot.data.tglRevisiInput)),
                          textCaptionWithIcon(
                              context: context,
                              icon: LineIcons.hourglass,
                              circleColor: ThemeProvider.themeOf(context)
                                  .data
                                  .colorScheme
                                  .error,
                              caption: "Tenggat waktu revisi",
                              content: snapshot.data.tglRevisiDeadline != null
                                  ? DateFormat.yMMMMEEEEd("id")
                                      .format(snapshot.data.tglRevisiDeadline)
                                  : "Tidak ada tenggat waktu"),
                          textCaptionWithIcon(
                              context: context,
                              icon: LineIcons.file_text,
                              circleColor: ThemeProvider.themeOf(context)
                                  .data
                                  .colorScheme
                                  .primary,
                              caption: "Deskripsi revisi",
                              content: snapshot.data.detailRevisi),
                          SingleChildBooleanWidget(
                            boolean: snapshot.data.statusRevisi, 
                            ifTrue: MyButton.flatError(
                              buttonWidth: double.infinity,
                              caption: "Tandai sebagai belum selesai", 
                              onTap: () => showRevisiOnTap(snapshot, scaffoldContext)
                            ), 
                            ifFalse: MyButton.secondary(
                              buttonWidth: double.infinity,
                              caption: "Tandai sebagai selesai", 
                              onTap: () => showRevisiOnTap(snapshot, scaffoldContext)
                            ), 
                          )
                          
                        ],
                      );
                    }
                }
              },
            );
          }),
        ));
  }

  showRevisiOnTap(AsyncSnapshot snapshot, BuildContext scaffoldContext) {
    showUserVerifyBottomSheet(context,
            message: Text((snapshot.data.statusRevisi
                    ? "Apakah Anda yakin akan membatalkan tanda selesai?"
                    : "Apakah Anda yakin akan menandai revisi ini sebagai selesai? "
                        "Pastikan mahasiswa yang bersangkutan telah menyelesaikan revisi ini "
                        "sebelum Anda menandai.") +
                "\n\nAnda harus memasukkan kata sandi untuk melanjutkan."),
            yesColor: colorGreenStd,
            noColor: ThemeProvider.themeOf(context)
                .data
                .colorScheme
                .surface,
            noTextColor:
                ThemeProvider.themeOf(context)
                    .data
                    .colorScheme
                    .onSurface)
        .then((val) {
      val ??= false;

      setState(() {
        if(!val) _shouldUpdated = val;
      });

      if (val) {
        putMark(scaffoldContext, snapshot.data,
            !snapshot.data.statusRevisi);
      }
    });
  }

  putMark(BuildContext ctx, Revisi revisi, bool nilai) {
    _rest.putRevisiMark(revisi, nilai).then((String value) {
      _refresh();

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Sukses mengubah tanda.'),
        backgroundColor: colorGreenStd,
      ));
    }).catchError((e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Gagal mengubah tanda. Silakan coba kembali.'),
        backgroundColor: Colors.red,
      ));
    });
  }

  _onRevisiAction(BuildContext context, String value) {
    _toggleDel();

    setState(() {
      _shouldUpdated = true;
    });

    showMyDialog(
      title: "Berhasil",
      body: "Operasi yang Anda minta berhasil.",
      actions: <Widget>[
        new FlatButton(
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      context: context,
    ).then((val) => Navigator.of(context).pop(_shouldUpdated));
  }

  _onRevisiError(BuildContext context, dynamic error) {
    _toggleDel();

    print("Error: $error");

    setState(() {
      _shouldUpdated = false;
    });

    showMyDialog(
      title: "Gagal",
      body: "Operasi yang Anda minta gagal.",
      actions: <Widget>[
        new FlatButton(
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      context: context,
    );
  }

  deleteRevisi(BuildContext context, Revisi revisi) {
    _toggleDel();

    widget.rest
        .deleteRevisi(revisi)
        .then((String value) => _onRevisiAction(context, value))
        .catchError((e) => _onRevisiError(context, e));
  }
}
