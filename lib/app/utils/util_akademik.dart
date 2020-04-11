import 'package:input_nilai/app/models/model_akademik.dart';
import 'package:input_nilai/app/utils/util_constants.dart';
import 'package:input_nilai/app/utils/util_exceptions.dart';
import 'package:input_nilai/app/utils/util_network.dart';
import 'package:input_nilai/app/utils/util_useragent.dart';

class RESTAkademik {
  static final RESTAkademik _singleton = RESTAkademik._internal();
  static UserAgent _userAgent;
  static NetworkUtil _networkUtil;

  factory RESTAkademik() {
    _userAgent = new UserAgent();
    _networkUtil = NetworkUtil();

    return _singleton;
  }

  RESTAkademik._internal();

  _getNilaiErrorReason(dynamic code) {
    switch (code) {
      case 1062:
        throw NilaiSudahAdaException();
      default:
        return "Terjadi kesalahan yang tidak diketahui: $code. Silakan hubungi administrator.";
    }
  }

  _setOnAlterValue(dynamic val) {
    if (val['error'] != null) {
      var e = _getNilaiErrorReason(val['code']);

      if (e is String)
        throw Exception(e);
      else
        throw e;
    } else
      return val['info'];
  }

  _dosenModelSidangList(dynamic val) =>
      (val as Iterable).map((json) => ModelMhsSidang.fromJson(json)).toList();

  _dosenModelRevisiList(dynamic val) =>
      (val as Iterable).map((json) => Revisi.fromJson(json)).toList();

  Future<DosenSidang> getNilai(dynamic status) async {
    await Future.delayed(Duration(seconds: 2));

    return _networkUtil
        .get("$APP_REST_URL/cek_nilai/status/$status")
        .then((val) => DosenSidang.fromJson(val[0]));
  }

  Future<String> setNilai(dynamic status, int nilai) {
    return _networkUtil.post("$APP_REST_URL/input_nilai", body: {
      "id_status": status,
      "nilai": nilai,
    }).then((val) => _setOnAlterValue(val));
  }

  Future<String> putNilai(dynamic status, int nilai) {
    return _networkUtil.put("$APP_REST_URL/input_nilai", body: {
      "id_status": status,
      "nilai": nilai,
    }).then((val) => _setOnAlterValue(val));
  }

  Future<List<ModelMhsSidang>> get list_up async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user_id.then((id) {
      return _networkUtil
          .get("$APP_REST_URL/up/dosen/$id")
          .then((val) => _dosenModelSidangList(val));
    });
  }

  Future<List<ModelMhsSidang>> get list_munaqosah async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user_id.then((id) {
      return _networkUtil
          .get("$APP_REST_URL/munaqosah/dosen/$id")
          .then((val) => _dosenModelSidangList(val));
    });
  }

  Future<List<ModelMhsSidang>> get list_kompre async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user_id.then((id) {
      return _networkUtil
          .get("$APP_REST_URL/kompre/dosen/$id")
          .then((val) => _dosenModelSidangList(val));
    });
  }

  Future<ModelMhsSidang> get getUPMahasiswa async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user_id.then((id) {
      return _networkUtil
          .get(APP_REST_URL + "up/mahasiswa/$id")
          .then((val) => ModelMhsSidang.fromJson(val));
    });
  }

  Future<ModelMhsSidang> get getMunaqosahMahasiswa async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user_id.then((id) {
      return _networkUtil
          .get(APP_REST_URL + "munaqosah/mahasiswa/$id")
          .then((val) => ModelMhsSidang.fromJson(val));
    });
  }

  Future<ModelMhsSidang> get getKompreMahasiswa async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user_id.then((id) {
      return _networkUtil
          .get(APP_REST_URL + "kompre/mahasiswa/$id")
          .then((val) => ModelMhsSidang.fromJson(val));
    });
  }

  Future<List<Revisi>> getRevisiFromDosenID(int id) async {
    await Future.delayed(Duration(seconds: 2));

    return _networkUtil
        .get("$APP_REST_URL/revisi/dosen/$id")
        .then((val) => _dosenModelRevisiList(val));
  }

  Future<List<Revisi>> getRevisiMahasiswa(int id) async {
    await Future.delayed(Duration(seconds: 2));

    return _networkUtil
        .get("$APP_REST_URL/revisi/mahasiswa/$id")
        .then((val) => _dosenModelRevisiList(val));
  }

  Future<Revisi> getRevisiFromID(int id) async {
    await Future.delayed(Duration(seconds: 2));

    return _networkUtil
        .get(APP_REST_URL + "revisi/id_revisi/$id")
        .then((val) => Revisi.fromJson(val[0]));
  }

  Future<String> tambahRevisi(Revisi revisi) {
    return _networkUtil
        .post("$APP_REST_URL/revisi", body: revisi.toJson())
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> editRevisi(Revisi revisi) {
    return _networkUtil
        .put("$APP_REST_URL/revisi", body: revisi.toJson())
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> deleteRevisi(Revisi revisi) {
    Map<String, String> headers = {
      "id_revisi": revisi.idRevisi,
      "id_status": revisi.idStatus,
    };

    return _networkUtil
        .delete("$APP_REST_URL/revisi", headers: headers)
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> putRevisiMark(Revisi revisi, bool nilai) {
    return _networkUtil.put("$APP_REST_URL/revisi_mark", body: {
      "id_revisi": revisi.idRevisi,
      "id_status": revisi.idStatus,
      "status_revisi": nilai ? 1 : 0,
    }).then((val) => _setOnAlterValue(val));
  }
}
