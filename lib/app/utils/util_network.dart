import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton

  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  _processResponse(dynamic response) {
    final String res = response.body;
    final int statusCode = response.statusCode;

    print("Response");
    print(response.headers);
    print(response.body);

    if (json == null)
      throw new Exception("Tidak ada pengolah JSON tersedia.");
    else if (statusCode < 200 || statusCode > 400)
      throw new Exception(() {
        switch (statusCode) {
          case 400:
            return "Permintaan tidak dapat diproses.";
          case 401:
            return "Anda tidak diizinkan mengakses modul ini.";
          case 403:
            return "Anda tidak diizinkan mengakses modul ini.";
          case 404:
            return "Proses tidak dapat dilanjutkan karena koneksi data tidak tersedia.";
          case 408:
            return "Permintaan terlalu lama untuk diproses oleh server.";
          case 410:
            return "Permintaan menghilang dari server dan tidak dapat diproses.";
          case 413:
            return "Permintaan terlalu besar untuk diproses oleh server.";
          case 418:
            return "Mana ada kopi dicampur dengan teh.";
          case 429:
            return "Permintaan dari Anda melebihi batas yang ditentukan oleh server.";
          case 500:
            return "Permintaan tidak dapat diproses karena kesalahan server.";
          case 502:
            return "Permintaan tidak dapat diproses karena gerbang server mendapat jawaban yang tidak benar.";
          case 504:
            return "Permintaan tidak dapat diproses karena gerbang server terlalu lama merespon.";
          default:
            return "Telah terjadi kesalahan pada server. Harap hubungi administrator.";
        }
      });

    return _decoder.convert(res);
  }

  get _onValue {
    return (http.Response response) => _processResponse(response);
  }

  get _onValueDelete {
    return (http.StreamedResponse response) => _processResponse(response);
  }

  _combine(Map map) {
    return {
      "accept": "application/json",
      "content-type": "application/json",
      "Authorization":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IlNpZmxhYkFwcElucHV0Ig.G7Dnvzs6KKvw7JKy529dkey2mYrUVtDGh2ediS3IRIE"
    }..addAll(map ?? {}); //add map if not null
  }

  Future<dynamic> get(String url, {Map headers}) {
    return http.get(url, headers: _combine(headers)).then(_onValue);
  }

  Future<dynamic> post(String url, {Map headers, Map body, encoding}) {
    return http
        .post(url,
            headers: _combine(headers),
            body: json.encode(body),
            encoding: encoding)
        .then(_onValue);
  }

  Future<dynamic> put(String url, {Map headers, Map body, encoding}) async {
    return http
        .put(url,
            headers: _combine(headers),
            body: json.encode(body),
            encoding: encoding)
        .then(_onValue);
  }

  Future<dynamic> delete(String url, {Map headers}) async {
    return http.delete(url, headers: _combine(headers)).then(_onValue);
  }
}
