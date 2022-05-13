import 'dart:convert';

class DataMasalahByMesinModel {
  var idmasalah,
      jam,
      tanggal,
      masalah,
      shift,
      jenis_masalah,
      flag_activity,
      nomesin,
      ketmesin,
      site,
      idpenyelesaian,
      status;

  DataMasalahByMesinModel(
      {this.idmasalah,
      this.jam,
      this.tanggal,
      this.masalah,
      this.shift,
      this.jenis_masalah,
      this.flag_activity,
      this.nomesin,
      this.ketmesin,
      this.site,
      this.idpenyelesaian,
      this.status});

  factory DataMasalahByMesinModel.fromJson(Map<dynamic, dynamic> map) {
    return DataMasalahByMesinModel(
      idmasalah: map["idmasalah"],
      jam: map["jam"],
      tanggal: map['tanggal'],
      masalah: map['masalah'],
      shift: map['shift'],
      jenis_masalah: map['jenis_masalah'],
      flag_activity: map['flag_activity'],
      nomesin: map['nomesin'],
      ketmesin: map['ketmesin'],
      site: map['site'],
      idpenyelesaian: map['idpenyelesaian'],
      status: map['status'],
    );
  }
}

List<DataMasalahByMesinModel> dashboardFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<DataMasalahByMesinModel>.from(
      data["data"].map((item) => DataMasalahByMesinModel.fromJson(item)));
}
