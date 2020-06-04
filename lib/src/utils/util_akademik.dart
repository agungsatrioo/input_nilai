import '../models/model_akademik.dart';
import '../models/model_session.dart';
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

  Future<DosenSidang> getNilai(String table, dynamic nim) async {
    await Future.delayed(Duration(seconds: 2));

    UserModel user = await _userAgent.user;

    return _networkUtil.get(
        "${APP_REST_URL}cek_nilai?table=$table&mahasiswa=$nim&id_dosen=${user.userIdentity}",
        headers: {
          "Authorization": "Bearer ${user.token}"
        }).then((val) => DosenSidang.fromJson(val[0]));
  }

  Future<String> setNilai(String table, String nim, int nilai) async {
    UserModel user = await _userAgent.user;

    Map<String, String> head = {"Authorization": "Bearer ${user.token}"};

    return _networkUtil.post("$APP_REST_URL/nilai", headers: head, body: {
      "table": "$table",
      "nim": "$nim",
      "id_dosen": "${user.userIdentity}",
      "nilai": "$nilai",
    }).then((val) => _setOnAlterValue(val));
  }

  Future<String> putNilai(String table, dynamic nim, dynamic nilai) async {
    UserModel user = await _userAgent.user;

    Map<String, String> head = {"Authorization": "Bearer ${user.token}"};

    return _networkUtil.put("$APP_REST_URL/nilai", headers: head, body: {
      "table": "$table",
      "nim": "$nim",
      "id_dosen": "${user.userIdentity}",
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

  Future<List<Revisi>> getRevisiFromDosenID(
      String table, dynamic idDosen) async {
    await Future.delayed(Duration(seconds: 2));
    String token = await _userAgent.userToken;

    return _networkUtil.get(
      "$APP_REST_URL/revisi?table=$table&dosen=$idDosen",
      headers: {"Authorization": "Bearer $token"},
    ).then((val) => _dosenModelRevisiList(val));
  }

  Future<List<Revisi>> _getRevisiMahasiswa(
      String table, dynamic idDosen) async {
    await Future.delayed(Duration(seconds: 2));
    String token = await _userAgent.userToken;

    return _networkUtil.get(
      "$APP_REST_URL/revisi?table=$table&dosen=$idDosen",
      headers: {"Authorization": "Bearer $token"},
    ).then((val) => _dosenModelRevisiList(val));
  }

  Future<Revisi> getRevisiFromID(
      String table, dynamic idDosen, dynamic nim, dynamic revisiId) async {
    await Future.delayed(Duration(seconds: 2));
    String token = await _userAgent.userToken;

    return _networkUtil.get(
      APP_REST_URL +
          "revisi?table=$table&dosen=$idDosen&mahasiswa=$nim&id_revisi=$revisiId",
      headers: {"Authorization": "Bearer $token"},
    ).then((val) => Revisi.fromJson(val));
  }

  Future<String> tambahRevisi(String table, Revisi revisi) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    Map<String, String> body = {
      "table": table,
      "mahasiswa": revisi.nim,
      "dosen": revisi.idDosen,
      "detail_revisi": revisi.detailRevisi,
      "tgl_revisi_deadline": revisi.tglRevisiDeadline.toIso8601String(),
      "status_revisi": "${revisi.statusRevisi}"
    };

    return _networkUtil
        .post("$APP_REST_URL/revisi", headers: head, body: body)
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> editRevisi(String table, Revisi revisi) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    Map<String, dynamic> body = {
      "table": table,
      "mahasiswa": "${revisi.nim}",
      "dosen": "${revisi.idDosen}",
      "id_revisi": "${revisi.idRevisi}",
      "detail_revisi": revisi.detailRevisi,
      "tgl_revisi_deadline": revisi.tglRevisiDeadline.toIso8601String(),
      
    };

    return _networkUtil
        .put("$APP_REST_URL/revisi", headers: head, body: body)
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> deleteRevisi(String table, Revisi revisi) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

      Map<String, dynamic> body = {
      "table": "$table",
      "mahasiswa": "${revisi.nim}",
      "dosen": "${revisi.idDosen}",
      "id_revisi": "${revisi.idRevisi}"
    };

    return _networkUtil
        .put("$APP_REST_URL/delrevisi", headers: head, body: body)
        .then((val) => _setOnAlterValue(val));
  }

  Future<String> putRevisiMark(String table, Revisi revisi, bool nilai) async {
    String token = await _userAgent.userToken;

    Map<String, String> head = {"Authorization": "Bearer $token"};

    Map<String, dynamic> body = {
      "table": "$table",
      "mahasiswa": "${revisi.nim}",
      "dosen": "${revisi.idDosen}",
      "id_revisi": "${revisi.idRevisi}",
      "status_revisi": "$nilai"
    };

    return _networkUtil
        .put("$APP_REST_URL/mark_revisi", headers: head, body: body)
        .then((val) => _setOnAlterValue(val));
  }
}
