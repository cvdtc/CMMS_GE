import 'dart:convert';

class KomponenModel {
  var idkomponen, idmesin, nama, jumlah, nomesin, mesin, site;

  KomponenModel(
      {this.idkomponen,
      this.idmesin,
      this.nama,
      this.jumlah,
      this.nomesin,
      this.mesin,
      this.site});
  factory KomponenModel.fromJson(Map<dynamic, dynamic> map) {
    return KomponenModel(
        idkomponen: map["idkomponen"],
        idmesin: map["idmesin"],
        nama: map["nama"],
        jumlah: map["jumlah"],
        nomesin: map["nomesin"],
        mesin: map["mesin"],
        site: map["site"]);
  }

  Map<String, dynamic> toJson() {
    return {"nama": nama, "jumlah": jumlah, "idmesin": idmesin};
  }

  @override
  String toString() {
    return 'idkomponen: $idkomponen, idmesin: $idmesin, nama: $nama, jumlah: $jumlah, nomesin: $nomesin, mesin: $mesin, site: $site';
  }
}

List<KomponenModel> komponenFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<KomponenModel>.from(
      data["data"].map((item) => KomponenModel.fromJson(item)));
}

String KomponenToJson(KomponenModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
