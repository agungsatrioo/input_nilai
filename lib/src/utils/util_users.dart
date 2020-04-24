import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/models/model_session.dart';

import 'util_constants.dart';
import 'util_database.dart';
import 'util_useragent.dart';

class UserRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() => _singleton;
  DatabaseHelper _db;
  UserAgent _userAgent;

  UserRepository._internal() {
    _db = DatabaseHelper();
    _userAgent = UserAgent();
  }

  Future<User> authenticate({
    @required String username,
    @required String password,
  }) async {
    return _userAgent
        .login("${APP_REST_URL}auth", username, password)
        .then((response) async {
      String data = json.encode(response["data"]);
      Map dt = jsonDecode(data);

      return User.fromMap(dt);
    });
  }

  Future<void> deleteUser() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    await _db.deleteUsers();
    return;
  }

  Future<void> writeUser(User user) async {
    await _db.saveUser(user);
    await Future.delayed(Duration(seconds: 1));

    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    return (await _db.isLoggedIn());
  }
}
