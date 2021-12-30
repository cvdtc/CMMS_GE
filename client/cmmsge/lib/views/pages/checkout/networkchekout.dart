import 'dart:convert';

import 'package:cmmsge/services/models/checkout/checkoutModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<CheckoutModel> parseSite(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => CheckoutModel.fromJson(e)).toList();
}

Future<List<CheckoutModel>> fetchCheckout(
    String token, String idmasalah) async {
  var url = Uri.parse(_apiService + 'checkout/' + idmasalah);
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
