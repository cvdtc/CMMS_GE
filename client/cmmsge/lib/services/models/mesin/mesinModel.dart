import 'dart:convert';

class MesinModel {
  var idmesin, nomesin, keterangan, idsite, site, adakomponen;

  MesinModel(
      {this.idmesin,
      this.nomesin,
      this.keterangan,
      this.idsite,
      this.site,
      this.adakomponen});

  factory MesinModel.fromJson(Map<dynamic, dynamic> map) {
    return MesinModel(
        idmesin: map["idmesin"],
        nomesin: map["nomesin"],
        keterangan: map["keterangan"],
        idsite: map["idsite"],
        site: map["site"],
        adakomponen: map["adakomponen"]);
  }

  Map<String, dynamic> toJson() {
    return {"nomesin": nomesin, "keterangan": keterangan, "idsite": idsite};
  }

  @override
  String toString() {
    return 'MesinModel{idmesin: $idmesin, nomesin: $nomesin, keterangan: $keterangan, idsite: $idsite, site: $site }';
  }
}

List<MesinModel> mesinFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<MesinModel>.from(
      data["data"].map((item) => MesinModel.fromJson(item)));
}

String mesinToJson(MesinModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
