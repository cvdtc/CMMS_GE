import 'dart:convert';

class BarangModel {
  var idbarang, kode, nama, umur_pakai, satuan;

  BarangModel({this.idbarang, this.nama, this.umur_pakai, this.satuan});

  factory BarangModel.fromJson(Map<String, dynamic> map) {
    return BarangModel(
        idbarang: map['idbarang'],
        nama: map['nama'],
        umur_pakai: map['umur_pakai'],
        satuan: map['satuan']);
  }

  @override
  String toString() {
    return 'BarangModel{idbarang: $idbarang, nama: $nama, umur_pakai: $umur_pakai, satuan: $satuan}';
  }
}

List<BarangModel> masalahFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<BarangModel>.from(
      data["data"].map((item) => BarangModel.fromJson(item)));
}
