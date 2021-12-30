import 'dart:convert';

import 'package:cmmsge/services/models/barang/barangModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<BarangModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => BarangModel.fromJson(e)).toList();
}

Future<List<BarangModel>> fetchBarang(String token) async {
  var url = Uri.parse(_apiService + 'barang');
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
