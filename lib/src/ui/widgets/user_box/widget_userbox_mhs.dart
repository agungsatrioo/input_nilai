import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/podos.dart';
import '../../../utils/util_useragent.dart';
import 'widget_userbox_base.dart';
import 'widget_userbox_refresh_btn.dart';

class UserBoxMahasiswa extends StatefulWidget {
  UserAgent _ua;

  UserBoxMahasiswa(this._ua);

  @override
  State<StatefulWidget> createState() => _UserBoxMahasiswaState(this._ua);
}

class _UserBoxMahasiswaState extends State<UserBoxMahasiswa> {
  UserAgent _ua;
  Future<MahasiswaProfil> _future;

  String _nama, _nim, _jurusan;
  Widget _reloadButton;

  _UserBoxMahasiswaState(this._ua);

  @override
  void initState() {
    super.initState();
    _future = _ua.obj_mahasiswa;
  }

  _onRefresh() {
    setState(() {
      _future = _ua.obj_mahasiswa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MahasiswaProfil>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<MahasiswaProfil> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            _nama = "Memuat nama...";
            _nim = "";
            _jurusan = "";
            _reloadButton = _reloadButton = UserBoxCircularProgress(context);
            break;
          default:
            _reloadButton =
                UserBoxRefreshButton(context: context, onTap: _onRefresh);

            if (snapshot.hasError) {
              _nama = "Gagal memuat nama";
            } else if (snapshot.hasData) {
              _nama = snapshot.data.nama;
              _nim = snapshot.data.nim;
              _jurusan = snapshot.data.jurusan;
            }
        }

        return WidgetUserBoxBase(
          nama: _nama,
          reloadButton: _reloadButton,
          details: {"NIM": _nim, "Jurusan": _jurusan},
        );
      },
    );
  }
}
