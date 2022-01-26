import 'dart:convert';

class BarangModel {
  var idbarang, kode, nama, umur_barang, satuan, lewathari;

  BarangModel(
      {this.idbarang,
      this.nama,
      this.umur_barang,
      this.satuan,
      this.lewathari});

  factory BarangModel.fromJson(Map<String, dynamic> map) {
    return BarangModel(
        idbarang: map['idbarang'],
        nama: map['nama'],
        umur_barang: map['umur_barang'],
        satuan: map['satuan'],
        lewathari: map['lewathari']);
  }

  @override
  String toString() {
    return 'BarangModel{idbarang: $idbarang, nama: $nama, umur_barang: $umur_barang, satuan: $satuan, lewathari: $lewathari}';
  }
}

List<BarangModel> masalahFromJson(String dataJson) {
  final data = json.decode(dataJson);
  return List<BarangModel>.from(
      data["data"].map((item) => BarangModel.fromJson(item)));
}
