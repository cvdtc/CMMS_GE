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

import '../models/checklist/checklist.dart';

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
    // ++ fyi : this code below for getting response and message from api response.
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      // ++ fyi : this code below for getting login result if success.
      Map resultLogin = jsonDecode(response.body)['data'];
      var loginresult = LoginResult.fromJson(resultLogin);
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
    print("DASHBOARD?" + response.body);
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return dashboardFromJson(response.body);
    } else {
      // throw Exception([response.body, response.statusCode]);
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
    print('Token Komponen Api Service' + token + idmesin);
    // ++ reminder don't forget to sending idmesin!
    var url = Uri.parse(BaseUrl + 'komponen/' + idmesin);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    print("Data Komponen:" + response.body);
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return komponenFromJson(response.body);
    } else {
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return null;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
    // print("ADD MESIN? " + response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
    print('GET TIMELINE' + response.body);
    // ++ fyi : for getting response message from api
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return timelineFromJson(response.body);
    } else {
      // return null;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  // ! Add Data KOMPONEN
  Future<bool> addKomponen(String token, KomponenModel data) async {
    var url = Uri.parse(BaseUrl + 'komponen');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: KomponenToJson(data));
    print(url.toString() + ' | ' + data.toString());
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  // ! EDIT Data KOMPONEN
  Future<bool> editKomoponen(
      String token, KomponenModel data, String idkomponen) async {
    var url = Uri.parse(BaseUrl + 'komponen/' + idkomponen);
    var response = await client.put(url,
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  // ! DELETE Data KOMPONEN
  Future<bool> deleteKomponen(String token, String idkomponen) async {
    var url = Uri.parse(BaseUrl + 'komponen/' + idkomponen);
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  // ! EDIT Data Checkout TGL REMINDER
  Future<bool> ubahDataCheckout(
      String token, String idcheckout, CheckoutModel data) async {
    var url = Uri.parse(BaseUrl + 'checkouttglreminder/' + idcheckout);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: checkoutToJson(data));
    print('UBAH DATA TGL REMINDER' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  // ! Hapus Data Checkout
  Future<bool> hapusCheckout(String token, String idcheckout) async {
    var url = Uri.parse(BaseUrl + 'checkout/' + idcheckout);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    print('HAPUS CHECKOUT' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  /**
   * ! List Data Get Masalah
   * * note : getting data schedule
   */
  Future<List<MasalahModel>?> getListMasalah(
      String token, String flag_activity, String filter_site) async {
    var url =
        Uri.parse(BaseUrl + 'masalah/' + flag_activity + '/' + filter_site);
    var response = await client.get(url, headers: {
      'content-type': 'application/json',
      // ++ fyi : sending token with BEARER
      'Authorization': 'Bearer ' + token
    });
    print('Masalah?' + response.body + response.statusCode.toString());
    // ++ fyi : for getting response message from api

    if (response.statusCode == 200) {
      Map responsemessage = jsonDecode(response.body);
      responseCode = ResponseCode.fromJson(responsemessage);
      return masalahFromJson(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      // return null;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
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
    if (response.statusCode == 200) {
      // ++ fyi : for getting response message from api
      Map responsemessage = jsonDecode(response.body);
      responseCode = ResponseCode.fromJson(responsemessage);
      return scheduleFromJson(response.body);
    } else {
      // return null;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

/**
   * ! ADD CHECKLIST
   */
  Future<int> addChecklist(String token, ChecklistModel data) async {
    print(token + data.toString());
    var url = Uri.parse(BaseUrl + 'checklist');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: checklistToJson(data));
    print(data.toString() + ' | ' + token);
    print('send to add checklist' + response.body[1].toString());
    // print(responseCode);
    if (response.statusCode == 201) {
      Map responsemessage = jsonDecode(response.body);
      responseCode = ResponseCode.fromJson(responsemessage);
      print(responseCode.data.toString());
      return responseCode.data;
    } else {
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  /**
   * ! EDIT CHECKLIST
   */
  Future<bool> editChecklist(
      String token, ChecklistModel data, String idchecklist) async {
    print(token + data.toString());
    var url = Uri.parse(BaseUrl + 'checklist/' + idchecklist);
    var response = await client.put(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        body: checklistToJson(data));
    print(data);
    print('send to edit checklist' + response.body[1].toString());
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);

    print(responseCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  /**
   * ! DELETE CHECKLIST
   */
  Future<bool> deleteChecklist(String token, String idchecklist) async {
    var url = Uri.parse(BaseUrl + 'checklist/' + idchecklist);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  /**
   * ! ADD DETAIL CHECKLIST
   */
  Future<bool> addDetChecklist(String token, String data) async {
    var url = Uri.parse(BaseUrl + 'detchecklist');
    var response = await client.post(url,
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${token}'
        },
        // body: json.encode({'array': data}));
        body: data);
    print(data);
    print('send to add penyelesaian' + response.body);
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 201) {
      return true;
    } else {
      // return false;
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }

  /**
   * ! DELETE DETAIL CHECKLIST
   */
  Future<bool> deleteDetChecklist(String token, String idchecklist) async {
    var url = Uri.parse(BaseUrl + 'detchecklist/' + idchecklist);
    var response = await client.delete(url, headers: {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${token}'
    });
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error(
          responseCode, StackTrace.fromString(response.statusCode.toString()));
    }
  }
}
