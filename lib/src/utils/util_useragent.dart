import 'dart:async';
import 'dart:convert';

import 'package:input_nilai/src/models/model_session.dart';
import 'package:input_nilai/src/models/podos.dart';
import 'package:input_nilai/src/utils/util_constants.dart';
import 'package:input_nilai/src/utils/util_database.dart';
import 'package:input_nilai/src/utils/util_network.dart';

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

    Map<String, String> authParams = {
      "content-type": "application/json",
      "Authorization":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IlNpZmxhYkFwcElucHV0Ig.G7Dnvzs6KKvw7JKy529dkey2mYrUVtDGh2ediS3IRIE"
    };

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

  Future<User> get user async {
    var user = await _db.getUser();
    return User.fromMap(user);
  }

  Future<bool> get isLogged async {
    return await _db.isLoggedIn();
  }

  Future<dynamic> get detail_dosen async {
    await Future.delayed(Duration(seconds: 2));

    User u = await user;

    return _netutil
        .get("$APP_REST_URL/dosen/id_dosen/${u.identity}")
        .then((response) async {
      String data = json.encode(response[0]);
      Map s = json.decode(data);

      return s;
    });
  }

  Future<dynamic> get detail_mahasiswa async {
    await Future.delayed(Duration(seconds: 2));
    User u = await user;

    return _netutil
        .get("$APP_REST_URL/mahasiswa/nim/${u.identity}")
        .then((response) async {
      String data = json.encode(response[0]);
      Map s = json.decode(data);

      return s;
    });
  }

  Future<String> get user_id async {
    return user.then((val) => val.identity.toString());
  }

  Future<int> get user_level async {
    return user.then((val) => val.level);
  }

  Future<Dosen> get obj_dosen async {
    return detail_dosen.then((val) => Dosen.fromMap(val));
  }

  Future<MahasiswaProfil> get obj_mahasiswa async {
    return detail_mahasiswa.then((val) => MahasiswaProfil.fromMap(val));
  }
}
