import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/ui/widgets/detail_sidang/widget_mhs_sidang_base.dart';
import 'package:input_nilai/app/ui/widgets/widget_basic.dart';
import 'package:input_nilai/app/utils/util_akademik.dart';
import 'package:line_icons/line_icons.dart';

class UPHomePageMahasiswa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UPHomePageMahasiswaState();
}

class _UPHomePageMahasiswaState extends State<UPHomePageMahasiswa> {
  Future<ModelMhsSidang> _myNilai;
  RESTAkademik _rest;

  @override
  void initState() {
    super.initState();
    _rest = RESTAkademik();

    _myNilai = _rest.getUPMahasiswa;
  }

  Future<void> _refresh() async {
    setState(() {
      _myNilai = _rest.getUPMahasiswa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ujian Proposal"),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(LineIcons.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(LineIcons.refresh),
            onPressed: () {
              _refresh();
            },
          )
        ],
      ),
      body: FutureBuilder<ModelMhsSidang>(
        future: _myNilai,
        builder: (BuildContext ctx, AsyncSnapshot<ModelMhsSidang> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return loading();
            default:
              if (snapshot.hasError) {
                return center_text(
                    "Gagal memuat data Ujian Proposal. Reason: ${snapshot.error.toString()}");
              } else {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: DetailSidangMahasiswaBase(snapshot.data),
                  ),
                );
              }
          }
        },
      ),
    );
  }

/*

   */

}
