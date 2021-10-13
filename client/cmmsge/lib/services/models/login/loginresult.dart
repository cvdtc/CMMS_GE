import 'dart:convert';

class LoginResult {
  var access_token, nama, jabatan;

  LoginResult({this.access_token, this.nama, this.jabatan});
  factory LoginResult.fromJson(Map<dynamic, dynamic> map) {
    return LoginResult(
        access_token: map["access_token"],
        nama: map["nama"],
        jabatan: map["jabatan"]);
  }

  @override
  String toString() {
    return 'LoginResult{access_token: $access_token, nama: $nama, jabatan: $jabatan}';
  }
}

List<LoginResult> resultloginFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<LoginResult>.from(
      data["data"].map((item) => LoginResult.fromJson(item)));
}
