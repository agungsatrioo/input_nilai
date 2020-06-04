import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../models/model_akademik.dart';
import '../../../utils/util_akademik.dart';
import '../../widgets/detail_sidang/widget_mhs_sidang_base.dart';
import '../../widgets/widget_default_view.dart';
import '../../widgets/widget_loading.dart';

class MunaqosahHomePageMahasiswa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MunaqosahHomePageMahasiswaState();
}

class _MunaqosahHomePageMahasiswaState
    extends State<MunaqosahHomePageMahasiswa> {
  Future<ModelMhsSidang> _myNilai;
  RESTAkademik _rest;

  @override
  void initState() {
    super.initState();
    _rest = RESTAkademik();

    _myNilai = _rest.getMunaqosahMahasiswa;
  }

  _refresh() {
    setState(() {
      _myNilai = _rest.getMunaqosahMahasiswa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ujian Munaqosah"),
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
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<ModelMhsSidang>(
            future: _myNilai,
            builder:
                (BuildContext ctx, AsyncSnapshot<ModelMhsSidang> snapshot) {
              print(snapshot.data);

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return LoadingWidget();
                default:
                  if (snapshot.hasError) {
                    debugPrint("PAGE DETAIL MUNAQOSAH MAHASISWA ERROR!\n==========\n${snapshot.error.toString()}\n=========");

                    return DefaultViewWidget(
                        title: "Gagal memuat informasi Ujian Munaqosah.",
                        message: "Coba refresh untuk memuat kembali. Pastikan kondisi jaringan Anda dalam keadaan baik.",
                      );
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
        ),
      ),
    );
  }

/*

   */

}
