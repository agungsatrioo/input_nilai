import 'dart:convert';

class UserModel {
    var userIdentity;
    var userLevel;
    String token;
    DateTime lastLogin;

    UserModel({
        this.userIdentity,
        this.userLevel,
        this.token,
        this.lastLogin,
    });

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userIdentity: json["user_identity"],
        userLevel: json["user_level"],
        token: json["token"],
        lastLogin: DateTime.parse(json["last_login"]),
    );

    Map<String, dynamic> toJson() => {
        "user_identity": userIdentity,
        "user_level": userLevel,
        "token": token,
        "last_login": lastLogin.toIso8601String(),
    };
}
