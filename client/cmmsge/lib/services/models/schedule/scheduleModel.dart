import 'dart:convert';

class ScheduleModel {
  String idmesin, nomesin, keterangan, lewathari;

  ScheduleModel(
      {required this.idmesin,
      required this.nomesin,
      required this.keterangan,
      required this.lewathari});

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
        idmesin: map['idmesin'].toString(),
        nomesin: map['nomesin'].toString(),
        keterangan: map['keterangan'],
        lewathari: map['lewathari'].toString());
  }
}

List<ScheduleModel> scheduleFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<ScheduleModel>.from(
      data["data"].map((item) => ScheduleModel.fromJson(item)));
}
