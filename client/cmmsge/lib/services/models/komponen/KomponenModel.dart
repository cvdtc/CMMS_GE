import 'dart:convert';

class KomponenModel {
  var idkomponen,
      nama,
      kategori,
      keterangan,
      flag_reminder,
      jumlah_reminder,
      idmesin;

  KomponenModel(
      {this.idkomponen,
      this.nama,
      this.kategori,
      this.keterangan,
      this.flag_reminder,
      this.jumlah_reminder,
      this.idmesin});
  factory KomponenModel.fromJson(Map<dynamic, dynamic> map) {
    return KomponenModel(
        idkomponen: map["idkomponen"],
        nama: map["nama"],
        kategori: map["kategori"],
        keterangan: map["keterangan"],
        flag_reminder: map["flag_reminder"],
        jumlah_reminder: map["jumlah_reminder"],
        idmesin: map["idmesin"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "kategori": kategori,
      "keterangan": keterangan,
      "flag_reminder": flag_reminder,
      "jumlah_reminder": jumlah_reminder,
      "idmesin": idmesin
    };
  }

  @override
  String toString() {
    return 'idkomponen: $idkomponen, nama: $nama, kategori: $kategori, keterangan: $keterangan, flag_reminder: $flag_reminder, jumlah_reminder: $jumlah_reminder, idmesin: $idmesin';
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
