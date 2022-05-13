import 'dart:convert';

class ChartMesinModel {
  var periode, total;

  ChartMesinModel({this.periode, this.total});

  factory ChartMesinModel.fromJson(Map<dynamic, dynamic> map) {
    return ChartMesinModel(periode: map["periode"], total: map["total"]);
  }

  @override
  String toString() {
    return 'periode: $periode, total: $total';
  }
}

List<ChartMesinModel> chartMesinFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ChartMesinModel>.from(
      data["data"].map((item) => ChartMesinModel.fromJson(item)));
}
