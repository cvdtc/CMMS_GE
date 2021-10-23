import 'dart:convert';

class LoginResult {
  var access_token, username, jabatan;

  LoginResult({this.access_token, this.username, this.jabatan});
  factory LoginResult.fromJson(Map<dynamic, dynamic> map) {
    return LoginResult(
        access_token: map["data"]["access_token"],
        username: map["data"]["username"],
        jabatan: map["data"]["jabatan"]);
  }

  @override
  String toString() {
    return 'LoginResult{access_token: $access_token, username: $username, jabatan: $jabatan}';
  }
}

List<LoginResult> resultloginFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<LoginResult>.from(
      data["data"].map((item) => LoginResult.fromJson(item)));
}
