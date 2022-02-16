import 'dart:convert';

class SiteModel {
  var idsite;
  var nama, keterangan;

  SiteModel({this.idsite, this.nama, this.keterangan});

  factory SiteModel.fromJson(Map<String, dynamic> map) {
    return SiteModel(
        idsite: map['idsite'],
        nama: map["nama"],
        keterangan: map["keterangan"]);
  }

  Map<String, dynamic> toJson() {
    return {"nama": nama, "keterangan": keterangan};
  }

  @override
  String toString() {
    return 'idsite: $idsite, nama: $nama, keterangan: $keterangan';
  }
}

List<SiteModel> siteFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<SiteModel>.from(
      data["data"].map((item) => SiteModel.fromJson(item)));
}

String siteToJson(SiteModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
