import 'dart:convert';

import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<MesinModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => MesinModel.fromJson(e)).toList();
}

Future<List<MesinModel>> fetchMesin(String token, String idsite) async {
  var url = Uri.parse(_apiService + 'mesin/' + idsite);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  if (response.statusCode == 200) {
    return compute(parseSite, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}
