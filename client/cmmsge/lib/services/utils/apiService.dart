import 'dart:convert';

import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:cmmsge/services/models/dashboard/dashboardModel.dart';
import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/models/login/LoginModel.dart';
import 'package:cmmsge/services/models/login/loginresult.dart';
import 'package:cmmsge/services/models/masalah/masalahModel.dart';
import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/services/models/penyelesaian/penyelesaianModel.dart';
import 'package:cmmsge/services/models/progress/progressModel.dart';
import 'package:cmmsge/services/models/response/responsecode.dart';
import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/services/models/site/siteModel.dart';
import 'package:cmmsge/services/models/timeline/timelineModel.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ? make sure api url true, change variable BaseUrl if api url has changed.
  /// for server
  final String BaseUrl = "http://factory.grand-elephant.co.id:9994/api/v1/";

  /// for development
  // final String BaseUrl = "http://192.168.1.211:9994/api/v1/";

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
    Map resultLogin = jsonDecode(response.body)['data'];
    var loginresult = LoginResult.fromJson(resultLogin);
    // ++ fyi : this code below for getting response and message from api response.
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      // ++ fyi : for set shared preferences from LoginResult model, this shared preferences fot save access token credentials for request to api.
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('access_token', "${loginresult.access_token}");
      sp.setString('username', "${loginresult.username}");
      sp.setString('jabatan', "${loginresult.jabatan}");
      sp.setBool('notifmasalah', true);
      sp.setBool('notifprogress', true);
      sp.setBool('notifselesai', true);
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
    if (response.statusCode == 200) {
      return dashboardFromJson(response.body);
    } else {
      return null;
    }
  }

  List<DashboardModel> parseDashboard(String responseBody) {
    var listSite = json.decode(responseBody)['data'] as List<dynamic>;
    return listSite.map((e) => DashboardModel.fromJson(e)).toList();
  }

  /**
   * ! List Data Komponen
   * * note : getting data komponen by idmesin from json
   * ++      idmesin and token required! 
   */
  Future<List<KomponenModel>?> getListKomponen(
      String token, String idmesin) async {
    // ++ reminder don't forget to sending idmesin!
    var url = Uri.parse(BaseUrl + 'komponen/' + idmesin);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return komponenFromJson(response.body);
    } else {
      return null;
    }
  }

  /**
   * ! List Data Mesin
   * * note : getting data mesin
   * ++      idsite and token required! 
   */
  Future<List<MesinModel>?> getListMesin(String token, String idsite) async {
    // ++ reminder don't forget to sending idsite!
    var url = Uri.parse(BaseUrl + 'mesin/' + idsite);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return mesinFromJson(response.body);
    } else {
      return null;
    }
  }

  // ! Add Data MESIN
  Future<bool> addMesin(String token, MesinModel data) async {
    var url = Uri.parse(BaseUrl + 'mesin');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: mesinToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    print("ADD MESIN? " + response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // ! Edit Data MESIN
  Future<bool> editMesin(String token, MesinModel data, String idmesin) async {
    var url = Uri.parse(BaseUrl + 'mesin/' + idmesin);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: mesinToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * ! TIMELINE
   * ++ LIST SITE
   * * note : getting data site
   */
  Future<List<TimelineModel>?> getListTimeline(
      String token, String idmasalah) async {
    var url = Uri.parse(BaseUrl + 'timeline/' + idmasalah);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    print(response.body);
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return timelineFromJson(response.body);
    } else {
      return null;
    }
  }

  /**
   * ! SITE
  * ++ TAMBAH SITE 
  * * note : add site
  */
  Future<bool> addRumah(String token, SiteModel data) async {
    var url = Uri.parse(BaseUrl + 'site');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: siteToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  /**
  * ++ UPDATE SITE
  * * note : ubah data site
  */
  Future<bool> ubahSite(String token, String idsite, SiteModel data) async {
    var url = Uri.parse(BaseUrl + 'site/' + idsite);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: siteToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /**
  * ++ DELETE SITE
  * * note : ubah data site
  */
  Future<bool> hapusSite(String token, String idsite) async {
    var url = Uri.parse(BaseUrl + 'site/' + idsite);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ! Add Data Site
  Future<bool> addKomponen(String token, KomponenModel data) async {
    var url = Uri.parse(BaseUrl + 'site');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: KomponenToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ! Add Data Masalah
  Future<bool> addMasalah(String token, MasalahModel data) async {
    var url = Uri.parse(BaseUrl + 'masalah');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: masalahToJson(data));
    print('send to api add masalah' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // ! Edit Data Masalah
  Future<bool> editMasalah(
      String token, MasalahModel data, String idmasalah) async {
    var url = Uri.parse(BaseUrl + 'masalah/' + idmasalah);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: masalahToJson(data));
    print('send to api edit masalah' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ! Add Data Progress
  Future<bool> addProgress(String token, ProgressModel data) async {
    var url = Uri.parse(BaseUrl + 'progress');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: progressToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // ! Edit Data Progress (belum dipakai)
  Future<bool> editProgress(
      String token, ProgressModel data, String idprogress) async {
    var url = Uri.parse(BaseUrl + 'progress/' + idprogress);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: progressToJson(data));
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ! Add Data Checkout Barang
  Future<bool> addCheckoutBarang(String token, CheckoutModel data) async {
    var url = Uri.parse(BaseUrl + 'checkout');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: checkoutToJson(data));
    print('send to add checkout' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // ! Hapus Data Checkout
  Future<bool> hapusCheckout(String token, String idcheckout) async {
    var url = Uri.parse(BaseUrl + 'checkout/' + idcheckout);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    print(response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * ! List Data Get Masalah
   * * note : getting data schedule
   */
  Future<List<MasalahModel>?> getListMasalah(
      String token, String flag_activity) async {
    var url = Uri.parse(BaseUrl + 'masalah/' + flag_activity);
    print(token + " | " + url.toString());
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    print(response.body);
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return masalahFromJson(response.body);
    } else {
      return null;
    }
  }

  // ! Add Data Penyelesaian Masalah
  Future<bool> addPenyelesaian(String token, PenyelesaianModel data) async {
    var url = Uri.parse(BaseUrl + 'penyelesaian');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: penyelesaianToJson(data));
    print('send to add penyelesaian' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // ! Delete Data Penyelesaian Masalah
  Future<bool> deletePenyelesaian(String token, String idpenyelesaian) async {
    var url = Uri.parse(BaseUrl + 'penyelesaian/' + idpenyelesaian);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    print('delete data penyelesiaan' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

/**
   * ! List Data Schedule
   * * note : getting data schedule
   */
  Future<List<ScheduleModel>?> getSchedule(String token) async {
    var url = Uri.parse(BaseUrl + 'schedule');
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return scheduleFromJson(response.body);
    } else {
      return null;
    }
  }
}
