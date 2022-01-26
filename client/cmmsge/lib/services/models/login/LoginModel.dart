import 'dart:convert';

class LoginModel {
  var username, password, device, uuid, appversion;
  LoginModel(
      {this.username, this.password, this.device, this.uuid, this.appversion});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "device": device,
      "uuid": uuid,
      "appversion": appversion
    };
  }

  @override
  String toString() {
    return 'LoginModel{username: $username, password: $password, device: $device, uuid: $uuid, appversion: $appversion}';
  }
}

String loginToJson(LoginModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
