import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/podos.dart';
import '../../../utils/util_colors.dart';
import '../../../utils/util_useragent.dart';
import 'widget_userbox_base.dart';
import 'widget_userbox_refresh_btn.dart';

class UserBoxDosen extends StatefulWidget {
  UserAgent _ua;

  UserBoxDosen(this._ua);

  @override
  State<StatefulWidget> createState() => _UserBoxDosenState(this._ua);
}

class _UserBoxDosenState extends State<UserBoxDosen> {
  UserAgent _ua;
  Future<Dosen> _future;

  String _nama, _jurusan, _id_dosen, _nip, _nik, _nidn;
  Widget _reloadButton;

  _UserBoxDosenState(this._ua);

  @override
  void initState() {
    super.initState();
    _future = _ua.obj_dosen;
  }

  _onRefresh() {
    setState(() {
      _future = _ua.obj_dosen;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color colorBase = colorBlueStd;

    return FutureBuilder<Dosen>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<Dosen> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            _nama = "Memuat nama...";
            _id_dosen = "";
            _nip = "";
            _nik = "";
            _nidn = "";
            _jurusan = "";
            _reloadButton = UserBoxCircularProgress(context);

            break;
          default:
            _reloadButton =
                UserBoxRefreshButton(colorBase: colorBase, context: context, onTap: _onRefresh);

            if (snapshot.hasError) {
              _nama = "Gagal memuat nama";
            } else if (snapshot.hasData) {
              _nama = snapshot.data.nama;
              _id_dosen = snapshot.data.id;
              _nip = snapshot.data.nip;
              _nik = snapshot.data.nik;
              _nidn = snapshot.data.nidn;
            }
        }

        return WidgetUserBoxBase(
          colorBase: colorBase,
          nama: _nama,
          reloadButton: _reloadButton,
          details: {
            "ID Dosen": _id_dosen,
            "NIP": _nip,
            "NIK": _nik,
            "NIDN": _nidn
          },
        );
      },
    );
  }
}
