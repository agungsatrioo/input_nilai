import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../models/model_surat_quran.dart';

class UtilQuran {
  static Future<List<IndexQuran>> loadIndexSurat({bool juzAmma = false}) async {
    await Future.delayed(Duration(seconds: 2));

    return await rootBundle
        .loadString('assets/quran/index_surah.json')
        .then((v) => jsonDecode(v))
        .then((val) {
      Iterable list = val;
      List<IndexQuran> result =
          list.map((json) => IndexQuran.fromJson(json)).toList();

      if (juzAmma) result.removeRange(0, 77); //(78-1) hingga (114-1)

      return result;
    });
  }

  static Future<SuratQuran> loadSurat(int surat) async {
    await Future.delayed(Duration(seconds: 2));

    debugPrint("CARI AYAT $surat.");

    return await rootBundle.loadString("assets/quran/$surat.json").then((v) {
      Map suratDecoded = jsonDecode(v);

      var surat = suratDecoded.values.toList();

      return SuratQuran.fromJson(surat[0]);
    });
  }
}
