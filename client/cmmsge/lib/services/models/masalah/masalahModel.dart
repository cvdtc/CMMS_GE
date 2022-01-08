import 'dart:convert';

class MasalahModel {
  var idmasalah, idmesin, idpenyelesaian, status, shift, flag_activity;
  var jam, tanggal, masalah, nomesin, ketmesin, site, created, jenis_masalah;

  MasalahModel(
      {this.idmasalah,
      this.idmesin,
      this.idpenyelesaian,
      this.status,
      this.shift,
      this.jam,
      this.tanggal,
      this.masalah,
      this.nomesin,
      this.ketmesin,
      this.site,
      this.created,
      this.jenis_masalah,
      this.flag_activity});

  factory MasalahModel.fromJson(Map<String, dynamic> map) {
    return MasalahModel(
        idmasalah: map['idmasalah'],
        idmesin: map['idmesin'],
        idpenyelesaian: map['idpenyelesaian'],
        status: map['status'],
        shift: map['shift'],
        jam: map['jam'],
        tanggal: map['tanggal'],
        masalah: map['masalah'],
        nomesin: map['nomesin'],
        ketmesin: map['ketmesin'],
        site: map['site'],
        created: map['created'],
        jenis_masalah: map['jenis_masalah'],
        flag_activity: map['flag_activity']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idmesin": idmesin,
      "shift": shift,
      "jam": jam,
      "tanggal": tanggal,
      "masalah": masalah,
      "jenis_masalah": jenis_masalah,
      "flag_activity": flag_activity
    };
  }

  @override
  String toString() {
    return 'MasalahModel{idmesin: $idmesin,shift: $shift, jam: $jam, tanggal: $tanggal, masalah: $masalah, jenis_masalah:$jenis_masalah, flag_activity: $flag_activity}';
  }
}

List<MasalahModel> masalahFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<MasalahModel>.from(
      data["data"].map((item) => MasalahModel.fromJson(item)));
}

String masalahToJson(MasalahModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
