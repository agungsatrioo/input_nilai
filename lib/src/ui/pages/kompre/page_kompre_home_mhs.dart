import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/src/models/model_akademik.dart';
import 'package:input_nilai/src/ui/widgets/detail_sidang/widget_mhs_sidang_base.dart';
import 'package:input_nilai/src/ui/widgets/widget_basic.dart';
import 'package:input_nilai/src/utils/util_akademik.dart';
import 'package:line_icons/line_icons.dart';

class KompreHomePageMahasiswa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KompreHomePageMahasiswaState();
}

class _KompreHomePageMahasiswaState extends State<KompreHomePageMahasiswa> {
  Future<ModelMhsSidang> _myNilai;
  RESTAkademik _rest;

  @override
  void initState() {
    super.initState();
    _rest = RESTAkademik();

    _myNilai = _rest.getKompreMahasiswa;
  }

  _refresh() {
    setState(() {
      _myNilai = _rest.getKompreMahasiswa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ujian Komprehensif"),
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
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return loading();
                default:
                  if (snapshot.hasError) {
                    return center_text(
                        "Gagal memuat data Ujian Komprehensif. Reason: ${snapshot.error.toString()}");
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
