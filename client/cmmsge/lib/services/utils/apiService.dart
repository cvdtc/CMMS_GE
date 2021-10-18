import 'dart:convert';

import 'package:cmmsge/services/models/dashboard/dashboardModel.dart';
import 'package:cmmsge/services/models/login/LoginModel.dart';
import 'package:cmmsge/services/models/login/loginresult.dart';
import 'package:cmmsge/services/models/response/responsecode.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ? make sure api url true, change variable BaseUrl if api url has changed.
  final String BaseUrl = "http://192.168.4.125:9994/api/v1/";
  Client client = Client();
  ResponseCode responseCode = ResponseCode();

  /**
   * ! LOGIN
   * * note : login vaidation with api
   * TODO: responstatus api must be set for show to error/message dialog.
  */
  Future<bool> LoginApp(LoginModel data) async {
    var url = Uri.parse(BaseUrl + 'login');
    var response = await client.post(url,
        headers: {'content-type': 'application/json'}, body: loginToJson(data));
    // ++ fyi : this code below for getting login result if success.
    Map resultLogin = jsonDecode(response.body);
    var loginresult = LoginResult.fromJson(resultLogin);
    // ++ fyi : this code below for getting response and message from api response.
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      // ++ fyi : for set shared preferences from LoginResult model, this shared preferences fot save access token credentials for request to api.
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('access_token', "${loginresult.access_token}");
      sp.setString('nama', "${loginresult.nama}");
      sp.setString('jabatan', "${loginresult.jabatan}");
      return true;
    } else {
      return false;
    }
  }

  /**
   * ! DASHBOARD
   * * note : getting dashboard value from api
   */
  Future<List<DashboardModel>?> getDashboard(String token) async {
    var url = Uri.parse(BaseUrl + 'dashboard');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("Data Dashbaord : " + response.body);
    if (response.statusCode == 200) {
      return dashboardFromJson(response.body);
    } else {
      return null;
    }
  }
}
