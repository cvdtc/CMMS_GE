import 'dart:convert';

class ProgressModel {
  var idprogress, perbaikan, engineer, tanggal, idmasalah, shift;

  ProgressModel(
      {this.idprogress,
      this.perbaikan,
      this.engineer,
      this.tanggal,
      this.idmasalah,
      this.shift});

  Map<String, dynamic> toJson() {
    return {
      "perbaikan": perbaikan,
      "engineer": engineer,
      "tanggal": tanggal,
      "idmasalah": idmasalah,
      "shift": shift
    };
  }

  @override
  String toString() {
    return 'ProgressModel{perbaikan: $perbaikan, engineer: $engineer, tanggal: $tanggal, idmasalah: $idmasalah, shift: $shift}';
  }
}

String progressToJson(ProgressModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
