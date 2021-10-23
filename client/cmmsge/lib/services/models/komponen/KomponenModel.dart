import 'dart:convert';

class KomponenModel {
  var idkomponen, idmesin, nama, jumlah;

  KomponenModel({this.idkomponen, this.idmesin, this.nama, this.jumlah});
  factory KomponenModel.fromJson(Map<dynamic, dynamic> map) {
    return KomponenModel(
        idkomponen: map["idkomponen"],
        idmesin: map["idmesin"],
        nama: map["nama"],
        jumlah: map["jumlah"]);
  }

  @override
  String toString() {
    return 'idkomponen: $idkomponen, idmesin: $idmesin, nama: $nama, jumlah: $jumlah';
  }
}

List<KomponenModel> komponenFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<KomponenModel>.from(
      data["data"].map((item) => KomponenModel.fromJson(item)));
}
