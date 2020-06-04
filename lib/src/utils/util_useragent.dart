import 'dart:async';
import 'dart:convert';

import '../models/model_session.dart';
import '../models/podos.dart';
import 'util_constants.dart';
import 'util_database.dart';
import 'util_network.dart';

class UserAgent {
  static final UserAgent _singleton = UserAgent._internal();
  static DatabaseHelper _db;
  static NetworkUtil _netutil;

  factory UserAgent() {
    _db = new DatabaseHelper();
    _netutil = new NetworkUtil();

    return _singleton;
  }

  UserAgent._internal();

  Future<dynamic> login(
      String login_url, String username, String password) async {
    await Future.delayed(Duration(seconds: 2));

    return _netutil.post(login_url, body: {
      "identity": username,
      "password": password
    }).timeout(Duration(minutes: 1), onTimeout: () {
      throw new TimeoutException("Waktu tersambung habis.");
    }).catchError((e) {
      print(e.toString());
      throw new Exception("Gagal login.");
    }).then((dynamic res) {
      if (res['status'] == "failed")
        throw new Exception(res['msg']);
      else
        return res;
    });
  }

  Future<dynamic> changePassword(
      String username, String password, String token) async {
    await Future.delayed(Duration(seconds: 2));

    Map<String, String> headers = {"Authorization": "Bearer ${token}"};

    return _netutil.post(APP_REST_URL + "ganti_sandi", headers: headers, body: {
      "identity": username,
      "password": password
    }).timeout(Duration(minutes: 1), onTimeout: () {
      throw new TimeoutException("Waktu tersambung habis.");
    }).catchError((e) {
      print(e.toString());
      throw new Exception("Gagal mengganti password.");
    }).then((dynamic res) {
      if (res['status'] == "failed")
        throw new Exception(res['msg']);
      else
        return res;
    });
  }

  Future<UserModel> get user async {
    var user = await _db.getUser();
    return UserModel.fromJson(user);
  }

  Future<bool> get isLogged async {
    return await _db.isLoggedIn();
  }

  Future<dynamic> get detail_dosen async {
    await Future.delayed(Duration(seconds: 2));

    UserModel u = await user;

    return _netutil
        .get("$APP_REST_URL/dosen/${u.userIdentity}")
        .then((response) async {
      String data = json.encode(response[0]);
      Map s = json.decode(data);

      return s;
    });
  }

  Future<dynamic> get detail_mahasiswa async {
    await Future.delayed(Duration(seconds: 2));
    UserModel u = await user;

    return _netutil
        .get("$APP_REST_URL/mahasiswa/${u.userIdentity}")
        .then((response) async {
      String data = json.encode(response[0]);
      Map s = json.decode(data);

      return s;
    });
  }

  Future<bool> get isFirstTime async {
    UserModel _user = await user;

    return _netutil.get("$APP_REST_URL/is_first_run/${_user.userIdentity}",
        headers: {
          "Authorization": "Bearer ${_user.token}"
        }).then((response) => response["result"]);
  }

  Future<String> get userToken async {
    return user.then((val) => val.token);
  }

  Future<String> get user_id async {
    return user.then((val) => val.userIdentity);
  }

  Future<int> get user_level async {
    return user.then((val) => val.userLevel);
  }

  Future<Dosen> get obj_dosen async {
    return detail_dosen.then((val) => Dosen.fromMap(val));
  }

  Future<MahasiswaProfil> get obj_mahasiswa async {
    return detail_mahasiswa.then((val) => MahasiswaProfil.fromMap(val));
  }
}
