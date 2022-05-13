import 'dart:convert';

import 'package:cmmsge/services/models/mesin/mesinModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;

Future<List<MesinModel>?> fetchMesinByNoMesin(
    String token, String nomesin) async {
  var url = Uri.parse(_apiService + 'mesinbynomesin/' + nomesin);
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print('ooo' + response.body + response.statusCode.toString());
  if (response.statusCode == 200) {
    return mesinFromJson(response.body);
  } else {
    return Future.error(
        response.body, StackTrace.fromString(response.statusCode.toString()));
  }
}
