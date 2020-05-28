import '../models/model_akademik.dart';
import 'util_constants.dart';
import 'util_exceptions.dart';
import 'util_network.dart';
import 'util_useragent.dart';

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

    String token = await _userAgent.userToken;

    return _networkUtil.get("$APP_REST_URL/cek_nilai?id_status=$status",
        headers: {
          "Authorization": "Bearer $token"
        }).then((val) => DosenSidang.fromJson(val[0]));
  }

  Future<String> setNilai(dynamic status, int nilai) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    return _networkUtil.post("$APP_REST_URL/nilai", headers: head, body: {
      "id_status": "$status",
      "nilai": "$nilai",
    }).then((val) => _setOnAlterValue(val));
  }

  Future<String> putNilai(dynamic status, int nilai) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    return _networkUtil.put("$APP_REST_URL/nilai", headers: head, body: {
      "id_status": "$status",
      "nilai": "$nilai",
    }).then((val) => _setOnAlterValue(val));
  }

  Future<List<ModelMhsSidang>> getSidangDetailsDosen(String type) async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user.then((user) {
      return _networkUtil.get(
        APP_REST_URL + "$type?dosen=${user.userIdentity}",
        headers: {"Authorization": "Bearer ${user.token}"},
      ).then((val) => _dosenModelSidangList(val));
    });
  }

  Future<ModelMhsSidang> getSidangDetailsMhs(String type) async {
    await Future.delayed(Duration(seconds: 2));

    return _userAgent.user.then((user) {
      return _networkUtil.get(
        APP_REST_URL + "$type?mahasiswa=${user.userIdentity}",
        headers: {"Authorization": "Bearer ${user.token}"},
      ).then((val) => ModelMhsSidang.fromJson(val));
    });
  }

  Future<ModelMhsSidang> get getUPMahasiswa => getSidangDetailsMhs("up");
  Future<ModelMhsSidang> get getKompreMahasiswa =>
      getSidangDetailsMhs("kompre");
  Future<ModelMhsSidang> get getMunaqosahMahasiswa =>
      getSidangDetailsMhs("munaqosah");

  Future<List<ModelMhsSidang>> get list_up => getSidangDetailsDosen("up");
  Future<List<ModelMhsSidang>> get list_kompre =>
      getSidangDetailsDosen("kompre");
  Future<List<ModelMhsSidang>> get list_munaqosah =>
      getSidangDetailsDosen("munaqosah");

  Future<List<Revisi>> getRevisiFromDosenID(int id) async {
    await Future.delayed(Duration(seconds: 2));
    String token = await _userAgent.userToken;

    return _networkUtil.get(
      "$APP_REST_URL/revisi/dosen/$id",
      headers: {"Authorization": "Bearer $token"},
    ).then((val) => _dosenModelRevisiList(val));
  }

  Future<List<Revisi>> getRevisiMahasiswa(int id) async {
    await Future.delayed(Duration(seconds: 2));
    String token = await _userAgent.userToken;

    return _networkUtil.get(
      "$APP_REST_URL/revisi/mahasiswa/$id",
      headers: {"Authorization": "Bearer $token"},
    ).then((val) => _dosenModelRevisiList(val));
  }

  Future<Revisi> getRevisiFromID(int id) async {
    await Future.delayed(Duration(seconds: 2));
    String token = await _userAgent.userToken;

    return _networkUtil.get(
      APP_REST_URL + "revisi?id_revisi=$id",
      headers: {"Authorization": "Bearer $token"},
    ).then((val) => Revisi.fromJson(val[0]));
  }

  Future<String> tambahRevisi(Revisi revisi) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    return _networkUtil
        .post("$APP_REST_URL/revisi",
            headers: head, body: revisi.toJsonForExport())
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> editRevisi(Revisi revisi) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    return _networkUtil
        .put("$APP_REST_URL/revisi",
            headers: head, body: revisi.toJsonForExport())
        .then((val) => _setOnAlterValue(val));
  }

   Future<String> deleteRevisi(Revisi revisi) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    return _networkUtil.put("$APP_REST_URL/delrevisi", headers: head, body: {
      "id_revisi": "${revisi.idRevisi}",
      "id_status": "${revisi.idStatus}",
    }).then((val) => _setOnAlterValue(val));
  }

  Future<String> putRevisiMark(Revisi revisi, bool nilai) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    return _networkUtil.put("$APP_REST_URL/mark_revisi", headers: head, body: {
      "id_revisi": "${revisi.idRevisi}",
      "id_status": "${revisi.idStatus}",
      "status": nilai ? "1" : "0",
    }).then((val) => _setOnAlterValue(val));
  }
}
