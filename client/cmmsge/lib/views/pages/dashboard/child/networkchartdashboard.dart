import 'dart:convert';

import 'package:cmmsge/services/models/dashboard/chartsummaryinput.dart';
import 'package:cmmsge/services/utils/apiService.dart';
import 'package:http/http.dart' as http;

final String _apiService = ApiService().BaseUrl;

Future<List<DashboardChartModel>?> fetchchartdashboard(String token) async {
  var url = Uri.parse(_apiService + 'dashboardinputsummary?limit=5');
  var response = await http.get(url, headers: {
    'content-type': 'application/json',
    // ++ fyi : sending token with BEARER
    'Authorization': 'Bearer ' + token
  });
  print(response.body + response.statusCode.toString());
  if (response.statusCode == 200) {
    return dashboardchartmodelFromJson(response.body);
  } else {
    return Future.error(
        response.body, StackTrace.fromString(response.statusCode.toString()));
  }
}
