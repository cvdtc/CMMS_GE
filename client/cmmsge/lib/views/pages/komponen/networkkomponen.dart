import 'dart:convert';

import 'package:cmmsge/services/models/komponen/KomponenModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<KomponenModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  print(listSite);
  return listSite.map((e) => KomponenModel.fromJson(e)).toList();
}

Future<List<KomponenModel>> fetchKomponen(String token, String idmesin) async {
  var url = Uri.parse(_apiService + 'komponen/' + idmesin);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print("NETWORK Komponen? " + token);
  if (response.statusCode == 200) {
    print('Success?');
    return compute(parseSite, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}
