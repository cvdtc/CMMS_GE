import 'dart:convert';

import 'package:cmmsge/services/models/response/responsecode.dart';
import 'package:cmmsge/services/models/ringkasan_mesin/ringkasanmesinModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;

Future<List<RingkasanMesinModel>?> fetchRingkasanMesin(
    String token, String idmesin) async {
  var url = Uri.parse(_apiService + 'ringkasanmesin/' + idmesin);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  if (response.statusCode == 200) {
    // var data = jsonDecode(response.body);
    return ringkasanmesinFromJson(response.body);
  } else {
    // throw Exception([response.body, response.statusCode]);
    return Future.error(
        response.body, StackTrace.fromString(response.statusCode.toString()));
  }
  // else if (response.statusCode == 204) {
  //   throw (response.statusCode);
  // } else {
  //   ResponseCode responseCode = ResponseCode();
  //   Map responsemessage = jsonDecode(response.body);
  //   responseCode = ResponseCode.fromJson(responsemessage);
  //   // throw Exception([response.body, response.statusCode]);
  //   return Future.error(
  //       responseCode, StackTrace.fromString(response.statusCode.toString()));
  // }
}
