class User {
  var _identity;
  var _lastLogin;
  var _level;

  User(this._identity, this._level, this._lastLogin);

  factory User.fromMap(Map<String, dynamic> obj) =>
      new User(obj['user_identity'], obj['user_level'], obj['last_login']);

  get level => _level;

  get identity => _identity;

  DateTime get lastLogin => DateTime.parse(_lastLogin);

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['user_level'] = this._level;
    map['user_identity'] = this._identity;
    map['last_login'] = this._lastLogin;

    return map;
  }
}
