import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/models/model_akademik.dart';

class JadwalSidangMahasiwaContainer extends StatelessWidget {
  final ModelMhsSidang _data;

  JadwalSidangMahasiwaContainer(this._data);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Kelompok Sidang",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _data.namaKelompokSidang,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text("Ruangan Sidang",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _data.kodeRuang,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
