import 'dart:convert';

class StokBarangModel {
  var kode, nama, stok, umur, satuan;

  StokBarangModel({this.kode, this.nama, this.stok, this.umur, this.satuan});

  factory StokBarangModel.fromJson(Map<String, dynamic> map) {
    return StokBarangModel(
        kode: map['kode'],
        nama: map['nama'],
        stok: map['stok'],
        umur: map['umur'],
        satuan: map['satuan']);
  }

  @override
  String toString() {
    return 'StokBarangModel{kode: $kode, nama: $nama, stok: $stok, umur: $umur, satuan: $satuan}';
  }
}

List<StokBarangModel> stokbarangFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<StokBarangModel>.from(
      data["data"].map((item) => StokBarangModel.fromJson(item)));
}
