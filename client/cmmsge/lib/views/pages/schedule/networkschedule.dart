import 'dart:convert';

import 'package:cmmsge/services/models/schedule/scheduleModel.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;
List<ScheduleModel> parseSchedule(String responseBody) {
  var listSite = json.decode(responseBody)['data'] as List<dynamic>;
  return listSite.map((e) => ScheduleModel.fromJson(e)).toList();
}

Future<List<ScheduleModel>> fetchSchedule(String token) async {
  var url = Uri.parse(_apiService + 'schedule');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  if (response.statusCode == 200) {
    return compute(parseSchedule, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}
