import 'dart:convert';

import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/models/response/responsecode.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<KomponenModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => KomponenModel.fromJson(e)).toList();
}

Future<List<KomponenModel>> fetchKomponen(String token, String idmesin) async {
  var url = Uri.parse(_apiService + 'komponen/' + idmesin);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  // print(response.body);
  if (response.statusCode == 200) {
    return compute(parseSite, response.body);
  } else if (response.statusCode == 204) {
    throw (response.statusCode);
  } else {
    ResponseCode responseCode = ResponseCode();
    Map responsemessage = jsonDecode(response.body);
    responseCode = ResponseCode.fromJson(responsemessage);
    // throw Exception([response.body, response.statusCode]);
    return Future.error(
        responseCode, StackTrace.fromString(response.statusCode.toString()));
  }
}
