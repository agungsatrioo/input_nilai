import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/model_akademik.dart';
import '../../../utils/util_akademik.dart';
import '../../../utils/util_colors.dart';
import '../../../utils/util_date.dart';
import '../../dialogs.dart';
import '../../widgets/bottom_sheet/widget_bottomsheet_verify.dart';
import '../../widgets/widget_basic.dart';

class PageRevisiForm extends StatefulWidget {
  Revisi source;
  DosenSidang dosen;
  RESTAkademik rest;

  PageRevisiForm({@required this.rest, this.source, this.dosen});

  @override
  State<StatefulWidget> createState() => _PageRevisiFormState();
}

class _PageRevisiFormState extends State<PageRevisiForm> {
  bool _shouldUpdated = false, isInputting = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController deadline = TextEditingController();
  TextEditingController deadlineTime = TextEditingController();

  @override
  initState() {
    super.initState();

    if (widget.source == null) {
      widget.source = Revisi(
        statusRevisi: false,
        tglRevisiInput: DateTime.now(),
        idStatus: widget.dosen.idStatus,
      );
    } else {
      if (widget.source.tglRevisiDeadline != null) {
        deadline.text = formatToTimeStamp(widget.source.tglRevisiDeadline);
        deadlineTime.text = formatTime(widget.source.tglRevisiDeadline);
      }
    }
  }

  _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    ).then((picked) {
      print(picked);
      setState(() {
        widget.source.tglRevisiDeadline = picked;
        deadline.text = formatToTimeStamp(widget.source.tglRevisiDeadline);

        dump();
      });
    });
  }

  _selectTime({TimeOfDay initialDate}) {
    showTimePicker(
            context: context, initialTime: initialDate ?? TimeOfDay.now())
        .then((picked) {
      print(picked);
      setState(() {
        widget.source.tglRevisiDeadline = new DateTime.utc(
            widget.source.tglRevisiDeadline.year,
            widget.source.tglRevisiDeadline.month,
            widget.source.tglRevisiDeadline.day,
            picked.hour,
            picked.minute);

        deadlineTime.text = formatTime(widget.source.tglRevisiDeadline);

        dump();
      });
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(_shouldUpdated);
    return false;
  }

  void dump() {
    print(widget.source.toRawJson());
  }

  togglePost() {
    setState(() {
      isInputting = !isInputting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.source.idRevisi == null
              ? "Tambah Revisi"
              : "Sunting Revisi"),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(LineIcons.arrow_left),
            onPressed: () => Navigator.of(context).pop(_shouldUpdated),
          ),
          actions: <Widget>[
            IconButton(
              icon: isInputting
                  ? SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      height: 24.0,
                      width: 24.0,
                    )
                  : Icon(LineIcons.check),
              onPressed: () {
                showUserVerifyBottomSheet(context,
                    message: Text((widget.source.idRevisi != null
                                ? "Apakah Anda yakin akan menyunting revisi ini?"
                                : "Apakah Anda yakin akan menambahkan revisi ini?") +
                            "\n\nAnda harus memasukkan kata sandi untuk melanjutkan."),
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
                  val ??= false;

                  setState(() {
                    _shouldUpdated = val;
                  });

                  if (val) {
                    togglePost();
                    if (widget.source.idRevisi == null) {
                      addRevisi(context, widget.source);
                    } else {
                      editRevisi(context, widget.source);
                    }
                  }
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _selectDate(); // Call Function that has showDatePicker()
                    },
                    child: IgnorePointer(
                        child: makeTextField(
                            labelText: "Tanggal Deadline",
                            icon: LineIcons.calendar,
                            controller: deadline,
                            value: null,
                            onChange: (val) {})),
                  ),
                  Visibility(
                    visible: deadline.text.isNotEmpty,
                    child: InkWell(
                      onTap: () {
                        _selectTime(
                            initialDate: TimeOfDay(
                          hour: widget.source.tglRevisiDeadline.hour,
                          minute: widget.source.tglRevisiDeadline.minute,
                        ));
                      },
                      child: IgnorePointer(
                          child: makeTextField(
                              labelText: "Waktu Deadline",
                              icon: LineIcons.clock_o,
                              controller: deadlineTime,
                              value: null,
                              onChange: (val) {})),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: makeTextField(
                          labelText: "Deskripsi revisi",
                          icon: LineIcons.sticky_note,
                          value: widget.source.detailRevisi ?? "",
                          textInputType: TextInputType.multiline,
                          maxLines: 15,
                          onChange: (val) {
                            setState(() {
                              widget.source.detailRevisi = val;
                            });
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onRevisiAction(BuildContext context, String value) {
    togglePost();

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

  addRevisi(BuildContext context, Revisi revisi) {
    widget.rest
        .tambahRevisi(revisi)
        .then((String value) => _onRevisiAction(context, value))
        .catchError((e) => _onRevisiError(context, e));
  }

  editRevisi(BuildContext context, Revisi revisi) {
    widget.rest
        .editRevisi(revisi)
        .then((String value) => _onRevisiAction(context, value))
        .catchError((e) => _onRevisiError(context, e));
  }
}
