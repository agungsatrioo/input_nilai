import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:intl/intl.dart';

class MahasiswaCard extends StatelessWidget {
  final ModelMhsSidang _m;

  MahasiswaCard(this._m);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(_m.namaMhs,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subhead),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(_m.nim,
                        style: Theme.of(context).textTheme.subtitle),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_m.keteranganSidang),
                            Text('Tgl. sidang: ' +
                                DateFormat.yMMMMd("id").format(_m.sidangDate))
                          ]))
                ],
              ),
            )
          ],
        ));
  }
}

//,
