import 'dart:convert';

class DashboardChartModel {
  var jumlah_activity, tanggal;

  DashboardChartModel({this.jumlah_activity, this.tanggal});
  factory DashboardChartModel.fromJson(Map<dynamic, dynamic> map) {
    return DashboardChartModel(
        jumlah_activity: map["jumlah_activity"], tanggal: map["tanggal"]);
  }

  @override
  String toString() {
    return 'jumlah_activity: $jumlah_activity, tanggal: $tanggal';
  }
}

List<DashboardChartModel> dashboardchartmodelFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<DashboardChartModel>.from(
      data["data"].map((item) => DashboardChartModel.fromJson(item)));
}
